import Foundation

struct TimestampDateStrategy: DateFormattingCodableStrategy {
    static func decode(_ value: TimeInterval) throws -> Date {
        return Date(timeIntervalSince1970: value)
    }
    
    static func encode(_ date: Date) -> TimeInterval {
        return date.timeIntervalSince1970
    }
}

/// Decodes `TimeInterval` values as a `Date`.
///
/// `@TimestampDate` decodes `Double`s of a unix epoch into `Date`s. Encoding the `Date` will encode the value into the original `TimeInterval` value.
///
/// For example, decoding json data with a unix timestamp of `978307200.0` produces a valid `Date` representing January 1, 2001.
@propertyWrapper
public struct TimestampDate: Codable {
    private var storage: DateCodableValue<TimestampDateStrategy>
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
