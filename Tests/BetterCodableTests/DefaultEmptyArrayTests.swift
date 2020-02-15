import XCTest
import BetterCodable

class DefaultEmptyArrayTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        struct NestedFixture: Equatable, Codable {
            var one: String
            var two: [String: [String]]
        }
        
        @DefaultEmptyArray var values: [Int]
        @DefaultEmptyArray var nonPrimitiveValues: [NestedFixture]
    }
    
    func testDecodingFailableArrayDefaultsToEmptyArray() throws {
        let jsonData = #"{ "values": null, "nonPrimitiveValues": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.values, [])
        XCTAssertEqual(fixture.nonPrimitiveValues, [])
    }

    func testDecodingKeyNotPresentDefaultsToEmptyArray() throws {
        let jsonData = #"{}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.values, [])
        XCTAssertEqual(fixture.nonPrimitiveValues, [])
    }
    
    func testEncodingDecodedFailableArrayDefaultsToEmptyArray() throws {
        let jsonData = #"{ "values": null, "nonPrimitiveValues": null }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        _fixture.values += [1, 2, 3]
        _fixture.nonPrimitiveValues += [Fixture.NestedFixture(one: "a", two: ["b": ["c"]])]
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.values, [1, 2, 3])
        XCTAssertEqual(fixture.nonPrimitiveValues, [Fixture.NestedFixture(one: "a", two: ["b": ["c"]])])
    }
    
    func testEncodingDecodedFulfillableArrayRetainsContents() throws {
        let jsonData = #"{ "values": [1, 2], "nonPrimitiveValues": [{ "one": "one", "two": {"key": ["value"]}}] }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        
        XCTAssertEqual(fixture.values, [1, 2])
        XCTAssertEqual(fixture.nonPrimitiveValues, [Fixture.NestedFixture(one: "one", two: ["key": ["value"]])])
    }
}
