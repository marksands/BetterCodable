import XCTest
import BetterCodable

class DataValueTests: XCTestCase {
    func testDecodingAndEncodingBase64String() throws {
        struct Fixture: Codable {
            @DataValue<Base64Strategy> var data: Data
        }
        let jsonData = #"{"data":"QmV0dGVyQ29kYWJsZQ=="}"#.data(using: .utf8)!

        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.data, Data("BetterCodable".utf8))

        let outputJSON = try JSONEncoder().encode(fixture)
        XCTAssertEqual(outputJSON, jsonData)
    }

    func testDecodingMalformedBase64Fails() throws {
        struct Fixture: Codable {
            @DataValue<Base64Strategy> var data: Data
        }
        let jsonData = #"{"data":"invalidBase64!"}"#.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Fixture.self, from: jsonData))
    }

    func testDecodingAndEncodingBase64StringToArray() throws {
        struct Fixture: Codable {
            @DataValue<Base64Strategy> var data: [UInt8]
        }
        let jsonData = #"{"data":"QmV0dGVyQ29kYWJsZQ=="}"#.data(using: .utf8)!

        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.data, Array("BetterCodable".utf8))

        let outputJSON = try JSONEncoder().encode(fixture)
        XCTAssertEqual(outputJSON, jsonData)
    }

}
