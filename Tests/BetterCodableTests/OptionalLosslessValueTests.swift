import XCTest
import BetterCodable


class OptionalLosslessValueTests: XCTestCase {
    struct Fixture: Codable {
        @OptionalLosslessValue var bool: Bool?
        @OptionalLosslessValue var string: String?
        @OptionalLosslessValue var int: Int?
        @OptionalLosslessValue var double: Double?
        @OptionalLosslessValue var nilValue: Int?
        @OptionalLosslessValue var missingKey: Double?
    }

    func testDecodingMisalignedTypesFromJSONTraversesCorrectType() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "1", "double": "7.1", "nilValue": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 1)
        XCTAssertEqual(fixture.double, 7.1)
        XCTAssertEqual(fixture.nilValue, nil)
        XCTAssertEqual(fixture.missingKey, nil)
    }

    func testDecodingEncodedMisalignedTypesFromJSONDecodesCorrectTypes() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "7", "double": "7.1", "nilValue": null }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)

        _fixture.bool = false
        _fixture.double = 3.14

        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, false)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 3.14)
        XCTAssertEqual(fixture.nilValue, nil)
        XCTAssertEqual(fixture.missingKey, nil)
    }

    func testEncodingAndDecodedExpectedTypes() throws {
        let jsonData = #"{ "bool": true, "string": "42", "int": 7, "double": 7.1, "nilValue": null }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 7.1)
        XCTAssertEqual(fixture.nilValue, nil)
        XCTAssertEqual(fixture.missingKey, nil)
    }
}
