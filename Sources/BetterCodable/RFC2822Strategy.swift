import Foundation

/// Decodes `String` values as an RFC 2822 `Date`.
///
/// `@RFC2822Date` decodes RFC 2822 date strings into `Date`s. Encoding the `Date` will encode the value back into the original string value.
///
/// For example, decoding json data with a `String` representation  of `"Tue, 24 Dec 2019 16:39:57 -0000"` produces a valid `Date` representing 39 minutes and 57 seconds
/// after the 16th hour of December 24th, 2019 with an offset of -00:00 from UTC (Pacific Standard Time).
public struct RFC2822Strategy: DateValueCodableStrategy {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, d MMM y HH:mm:ss zzz"
        return dateFormatter
    }()
    
    public static func decode(_ value: String) throws -> Date {
        if let date = RFC2822Strategy.dateFormatter.date(from: value) {
            return date
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Date Format!"))
        }
    }
    
    public static func encode(_ date: Date) -> String {
        return RFC2822Strategy.dateFormatter.string(from: date)
    }
}
