import Foundation

struct ISO8601DateStrategy: DateFormattingCodableStrategy {
    static func decode(_ value: String) throws -> Date {
        if let date = ISO8601DateFormatter().date(from: value) {
            return date
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Date Format!"))
        }
    }
    
    static func encode(_ date: Date) -> String {
        return ISO8601DateFormatter().string(from: date)
    }
}

/// Decodes `String` values as an ISO8601 `Date`.
///
/// `@ISO8601Date` relies on an `ISO8601DateFormatter` in order to decode `String` values into `Date`s. Encoding the `Date` will encode the value into the original string value.
///
/// For example, decoding json data with a `String` representation  of `"1996-12-19T16:39:57-08:00"` produces a valid `Date` representing 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time).
@propertyWrapper
public struct ISO8601Date: Codable {
    private var storage: DateCodableValue<ISO8601DateStrategy>
    public var wrappedValue: Date
    
    public init(wrappedValue: Date) {
        self.storage = DateCodableValue(date: wrappedValue)
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        self.storage = try DateCodableValue(from: decoder)
        self.wrappedValue = storage.date
    }
    
    public func encode(to encoder: Encoder) throws {
        try self.storage.encode(to: encoder)
    }
}
