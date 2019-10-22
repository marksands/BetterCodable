import XCTest
import BetterCodable

class CustomDateCodableValueTests: XCTestCase {
    func testDecodingAndEncodingISO8601DateString() throws {
        struct Fixture: Codable {
            @DateValue<ISO8601Strategy> var iso8601: Date
        }
        let jsonData = #"{"iso8601": "1996-12-19T16:39:57-08:00"}"#.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.iso8601, Date(timeIntervalSince1970: 851042397))
    }
    
    func testDecodingAndEncodingRFC3339DateString() throws {
         struct Fixture: Codable {
            @DateValue<RFC3339Strategy> var rfc3339Date: Date
        }
        let jsonData = #"{"rfc3339Date": "1996-12-19T16:39:57-08:00"}"#.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.rfc3339Date, Date(timeIntervalSince1970: 851042397))
    }

    func testDecodingAndEncodingUTCTimestamp() throws {
        struct Fixture: Codable {
            @DateValue<TimestampStrategy> var timestamp: Date
        }
        let jsonData = #"{"timestamp": 851042397.0}"#.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.timestamp, Date(timeIntervalSince1970: 851042397))
    }
    
    func testDecodingAndEncodingYearMonthDateString() throws {
        struct Fixture: Codable {
            @DateValue<YearMonthDayStrategy> var ymd: Date
        }
        let jsonData = #"{"ymd": "1996-12-19"}"#.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.ymd, Date(timeIntervalSince1970: 850975200))
    }
}
