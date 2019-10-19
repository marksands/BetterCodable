import Foundation

struct YearMonthDayDateStrategy: DateFormattingCodableStrategy {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        return dateFormatter
    }()
    
    static func decode(_ value: String) throws -> Date {
        if let date = YearMonthDayDateStrategy.dateFormatter.date(from: value) {
            return date
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Date Format!"))
        }
    }
    
    static func encode(_ date: Date) -> String {
        return YearMonthDayDateStrategy.dateFormatter.string(from: date)
    }
}

/// Decodes `String` values of format `y-MM-dd` as a `Date`.
///
/// `@YearMonthDayDate` decodes string values of format `y-MM-dd` as a `Date`. Encoding the `Date` will encode the value back into the original string format.
///
/// For example, decoding json data with a `String` representation  of `"2001-01-01"` produces a valid `Date` representing January 1st, 2001.
@propertyWrapper
public struct YearMonthDayDate: Codable {
    private var storage: DateCodableValue<YearMonthDayDateStrategy>
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
