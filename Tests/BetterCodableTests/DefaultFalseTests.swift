import XCTest
import BetterCodable

class DefaultFalseTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @DefaultFalse var truthy: Bool
    }
    
    func testDecodingFailableArrayDefaultsToFalse() throws {
        let jsonData = #"{ "truthy": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.truthy, false)
    }

    func testDecodingKeyNotPresentDefaultsToFalse() throws {
        let jsonData = #"{}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.truthy, false)
    }
    
    func testEncodingDecodedFailableArrayDefaultsToFalse() throws {
        let jsonData = #"{ "truthy": null }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        _fixture.truthy = true
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.truthy, true)
    }
    
    func testEncodingDecodedFulfillableBoolRetainsValue() throws {
        let jsonData = #"{ "truthy": true }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        
        XCTAssertEqual(fixture.truthy, true)
    }

    func testDecodingMisalignedBoolIntValueDecodesCorrectBoolValue() throws {
        let jsonData = #"{ "truthy": 1 }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.truthy, true)

        let jsonData2 = #"{ "truthy": 0 }"#.data(using: .utf8)!
        let fixture2 = try JSONDecoder().decode(Fixture.self, from: jsonData2)
        XCTAssertEqual(fixture2.truthy, false)
    }

    func testDecodingMisalignedBoolStringValueDecodesCorrectBoolValue() throws {
        let jsonData = #"{ "truthy": "true" }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.truthy, true)

        let jsonData2 = #"{ "truthy": "false" }"#.data(using: .utf8)!
        let fixture2 = try JSONDecoder().decode(Fixture.self, from: jsonData2)
        XCTAssertEqual(fixture2.truthy, false)
    }

    func testDecodingInvalidValueDecodesToDefaultValue() throws {
        let jsonData = #"{ "truthy": "invalidValue" }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(
            fixture.truthy,
            false,
            "Should fall in to the else block and return default value"
        )
    }
}
