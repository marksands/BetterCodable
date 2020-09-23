import XCTest
import BetterCodable

class LosslessValueTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @LosslessValue var bool: Bool
        @LosslessValue var string: String
        @LosslessValue var int: Int
        @LosslessValue var double: Double
    }

    struct BoolFixture: Equatable, Codable {
        @LosslessValue var bool: Bool
    }
    
    func testDecodingMisalignedTypesFromJSONTraversesCorrectType() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "1", "double": "7.1" }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 1)
        XCTAssertEqual(fixture.double, 7.1)
    }
    
    func testDecodingEncodedMisalignedTypesFromJSONDecodesCorrectTypes() throws {
        let jsonData = #"{ "bool": "true", "string": 42, "int": "7", "double": "7.1" }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        _fixture.bool = false
        _fixture.double = 3.14
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, false)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 3.14)
    }
    
    func testEncodingAndDecodedExpectedTypes() throws {
        let jsonData = #"{ "bool": true, "string": "42", "int": 7, "double": 7.1 }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.bool, true)
        XCTAssertEqual(fixture.string, "42")
        XCTAssertEqual(fixture.int, 7)
        XCTAssertEqual(fixture.double, 7.1)
    }

    func testDecodingMisalignedBoolIntValueFromJSONTraversesCorrectType() throws {
        let jsonData = #"{ "bool": 1 }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(BoolFixture.self, from: jsonData)
        XCTAssertEqual(fixture.bool, true)

        let jsonData2 = #"{ "bool": 0 }"#.data(using: .utf8)!
        let fixture2 = try JSONDecoder().decode(BoolFixture.self, from: jsonData2)
        XCTAssertEqual(fixture2.bool, false)
    }
}
