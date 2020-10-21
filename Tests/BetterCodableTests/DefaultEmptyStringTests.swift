import XCTest
@testable import BetterCodable

class DefaultEmptyStringTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @DefaultEmptyString var name: String
    }
    
    func testDecodingFailableStringDefaultsToEmpty() throws {
        let jsonData = #"{ "name": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.name, "")
    }
    
    func testDecodingKeyNotPresentDefaultsToEmpty() throws {
        let jsonData = #"{}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.name, "")
    }
    
    func testEncodingDecodedFailableStringDefaultsToEmpty() throws {
        let jsonData = #"{ "name": null }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        _fixture.name = "BetterCodable"
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.name, "BetterCodable")
    }
    
    func testEncodingDecodedFulfillableStringRetainsValue() throws {
        let jsonData = #"{ "name": "BetterCodable" }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)

        XCTAssertEqual(fixture.name, "BetterCodable")
    }
}
