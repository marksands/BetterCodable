# Better Codable through Property Wrappers

Level up your `Codable` structs through property wrappers. The goal of these property wrappers is to avoid implementing a custom `init(from decoder: Decoder) throws` and suffer through boilerplate.

## @LossyArray

`@LossyArray` decodes Arrays and filters invalid values if the Decoder is unable to decode the value. This is useful when the Array contains non-optional types and your API serves elements that are either null or fail to decode within the container.

### Usage

Easily filter nulls from primitive containers

```Swift
struct Response: Codable {
    @LossyArray var values: [Int]
}

let json = #"{ "values": [1, 2, null, 4, 5, null] }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // [1, 2, 4, 5]
```

Or silently exclude failable entities

```Swift
struct Failable: Codable {
    let value: String
}

struct Response: Codable {
    @LossyArray var values: [Failable]
}

let json = #"{ "values": [{"value": 4}, {"value": "fish"}] }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // [Failable(value: "fish")]
```

## @LossyDictionary

`@LossyDictionary` decodes Dictionaries and filters invalid key-value pairs if the Decoder is unable to decode the value. This is useful if the Dictionary is intended to contain non-optional values and your API serves values that are either null or fail to decode within the container.

### Usage

Easily filter nulls from primitive containers

```Swift
struct Response: Codable {
    @LossyDictionary var values: [String: String]
}

let json = #"{ "values": {"a": "A", "b": "B", "c": null } }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // ["a": "A", "b": "B"]
```

Or silently exclude failable entities

```Swift
struct Failable: Codable {
    let value: String
}

struct Response: Codable {
    @LossyDictionary var values: [String: Failable]
}

let json = #"{ "values": {"a": {"value": "A"}, "b": {"value": 2}} }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // ["a": "A"]
```

## @DefaultCodable

`@DefaultCodable` provides a generic property wrapper that allows for default values using a custom `DefaultCodableStrategy`. This allows one to implement their own default behavior for missing data and get the property wrapper behavior for free. Below are a few common default strategies, but they also serve as a template to implement a custom property wrapper to suit your specific use case.

While not provided in the source code, it's a sinch to create your own default strategy for your custom data flow.

```Swift
struct RefreshDaily: DefaultCodableStrategy {
    static var defaultValue: CacheInterval { return CacheInterval.daily }
}

struct Cache: Codable {
    @DefaultCodable<RefreshDaily> var refreshInterval: CacheInterval
}

let json = #"{ "refreshInterval": null }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Cache.self, from: json)

print(result) // Cache(refreshInterval: .daily)
```

## @DefaultFalse

Optional Bools are weird. A type that once meant true or false, now has three possible states: `.some(true)`, `.some(false)`, or `.none`. And the `.none` condition _could_ indicate truthiness if BadDecisions™ were made.

`@DefaultFalse` mitigates the confusion by defaulting decoded Bools to false if the Decoder is unable to decode the value, either when null is encountered or some unexpected type.

### Usage

```Swift
struct UserPrivilege: Codable {
    @DefaultFalse var isAdmin: Bool
}

let json = #"{ "isAdmin": null }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // UserPrivilege(isAdmin: false)
```

## @DefaultEmptyArray

The weirdness of Optional Booleans extends to other types, such as Arrays. Soroush has a [great blog post](http://khanlou.com/2016/10/emptiness/) explaining why you may want to avoid Optional Arrays. Unfortunately, this idea doesn't come for free in Swift out of the box. Being forced to implement a custom initializer in order to nil coalesce nil arrays to empty arrays is no fun.

`@DefaultEmptyArray` decodes Arrays and returns an empty array instead of nil if the Decoder is unable to decode the container.

### Usage

```Swift
struct Response: Codable {
    @DefaultEmptyArray var favorites: [Favorite]
}

let json = #"{ "favorites": null }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // Response(favorites: [])
```

## @DefaultEmptyDictionary

As mentioned previously, Optional Dictionaries are yet another container where nil and emptiness collide.

 `@DefaultEmptyDictionary` decodes Dictionaries and returns an empty dictionary instead of nil if the Decoder is unable to decode the container.

### Usage

```Swift
struct Response: Codable {
    @DefaultEmptyDictionary var scores: [String: Int]
}

let json = #"{ "scores": null }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // Response(values: [:])
```

## @LosslessValue

All credit for this goes to [Ian Keen](https://twitter.com/iankay).

Somtimes APIs can be unpredictable. They may treat some form of Identifiers or SKUs as `Int`s for one response and `String`s for another. Or you might find yourself encountering `"true"` when you expect a boolean. This is where `@LosslessValue` comes into play.

`@LosslessValue` will attempt to decode a value into the type that you expect, preserving the data that would otherwise throw an exception or be lost altogether. 

### Usage

```Swift
struct Response: Codable {
    @LosslessValue var sku: String
    @LosslessValue var isAvailable: Bool
}

let json = #"{ "sku": 12345, "isAvailable": "true" }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

print(result) // Response(sku: "12355", isAvailable: true)
```

## Date Wrappers

One common frustration with `Codable` is decoding entities that have mixed date formats. `JSONDecoder` comes built in with a handy `dateDecodingStrategy` property, but that uses the same date format for all dates that it will decode. And often, `JSONDecoder` lives elsewhere from the entity forcing tight coupling with the entities if you choose to use its date decoding strategy.

Property wrappers are a nice solution to the aforementioned issues. It allows tight binding of the date formatting strategy directly with the property of the entity, and allows the `JSONDecoder` to remain decoupled from the entities it decodes. The `@DateValue` wrapper is generic across a custom `DateValueCodableStrategy`. This allows anyone to implement their own date decoding strategy and get the property wrapper behavior for free. Below are a few common Date strategies, but they also serve as a template to implement a custom property wrapper to suit your specific date format needs.

The following property wrappers are heavily inspired by [Ian Keen](https://twitter.com/iankay).

## ISO8601Strategy

`ISO8601Strategy` relies on an `ISO8601DateFormatter` in order to decode `String` values into `Date`s. Encoding the date will encode the value into the original string value.

### Usage

```Swift
struct Response: Codable {
    @DateValue<ISO8601Strategy> var date: Date
}

let json = #"{ "date": "1996-12-19T16:39:57-08:00" }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

// This produces a valid `Date` representing 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time).
```

## RFC3339Strategy

`RFC3339Strategy` decodes RFC 3339 date strings into `Date`s. Encoding the date will encode the value back into the original string value.

### Usage

```Swift
struct Response: Codable {
    @DateValue<RFC3339Strategy> var date: Date
}

let json = #"{ "date": "1996-12-19T16:39:57-08:00" }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

// This produces a valid `Date` representing 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time).
```

## TimestampStrategy

`TimestampStrategy` decodes `Double`s of a unix epoch into `Date`s. Encoding the date will encode the value into the original `TimeInterval` value.

### Usage

```Swift
struct Response: Codable {
    @DateValue<TimestampStrategy> var date: Date
}

let json = #"{ "date": 978307200.0 }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

// This produces a valid `Date` representing January 1st, 2001.
```

## YearMonthDayStrategy

 `@DateValue<YearMonthDayStrategy>` decodes string values into `Date`s using the date format `y-MM-dd`. Encoding the date will encode the value back into the original string format.

### Usage

```Swift
struct Response: Codable {
    @DateValue<YearMonthDayStrategy> var date: Date
}

let json = #"{ "date": "2001-01-01" }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

// This produces a valid `Date` representing January 1st, 2001.
```

Or lastly, you can mix and match date wrappers as needed where the benefits truly shine

```Swift
struct Response: Codable {
    @DateValue<ISO8601Strategy> var updatedAt: Date
    @DateValue<YearMonthDayStrategy> var birthday: Date
}

let json = #"{ "updatedAt": "2019-10-19T16:14:32-05:00", "birthday": "1984-01-22" }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(Response.self, from: json)

// This produces two valid `Date` values, `updatedAt` representing October 19, 2019 and `birthday` January 22nd, 1984.
```

## Installation

Swift Package Manager

### Attribution

This project is licensed under MIT. If you find these useful, please tell your boss where you found them.
