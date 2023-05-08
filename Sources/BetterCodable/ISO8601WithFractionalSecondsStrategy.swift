import Foundation

/// Decodes `String` values as an ISO8601 `Date`.
///
/// `@ISO8601Date` relies on an `ISO8601DateFormatter` in order to decode `String` values into `Date`s. Encoding the `Date`
/// will encode the value into the original string value.
///
/// For example, decoding json data with a `String` representation  of `"1996-12-19T16:39:57-08:00"` produces a valid `Date`
/// representing 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC
/// (Pacific Standard Time).
@available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
public struct ISO8601WithFractionalSecondsStrategy: DateValueCodableStrategy, OptionalDateValueCodableStrategy {
    private static let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    public static func decode(_ value: String) throws -> Date {
        guard let date = Self.formatter.date(from: value) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Date Format!"))
        }
        return date
    }

    public static func encode(_ date: Date) -> String {
        return  Self.formatter.string(from: date)
    }

    public static func decode(_ value: String?) throws -> Date? {
        guard let value else { return nil }
        return try decode(value)
    }

    public static func encode(_ date: Date?) -> String? {
        guard let date else { return nil }
        return encode(date)
    }
}
