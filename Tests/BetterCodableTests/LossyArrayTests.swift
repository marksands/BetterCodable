import XCTest
import BetterCodable

class LossyArrayTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        struct NestedFixture: Equatable, Codable {
            var one: String
            var two: [String: [String]]
        }
        
        @LossyArray var values: [Int]
        @LossyArray var nonPrimitiveValues: [NestedFixture]
    }
    
    func testDecodingLossyArrayIgnoresFailableElements() throws {
        let jsonData = #"{ "values": [1, null, 3, 4], "nonPrimitiveValues": [null] }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.values, [1, 3, 4])
        XCTAssertEqual(fixture.nonPrimitiveValues, [])
    }
    
    func testEncodingDecodedLossyArrayIgnoresFailableElements() throws {
        let jsonData = #"{ "values": [null, 2, null, 4], "nonPrimitiveValues": [null] }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        _fixture.values += [5]
        _fixture.nonPrimitiveValues += [Fixture.NestedFixture(one: "1", two: ["x": ["y"]])]
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.values, [2, 4, 5])
        XCTAssertEqual(fixture.nonPrimitiveValues, [Fixture.NestedFixture(one: "1", two: ["x": ["y"]])])
    }
    
    func testEncodingDecodedLosslessArrayRetainsContents() throws {
        let jsonData = #"{ "values": [1, 2], "nonPrimitiveValues": [{ "one": "one", "two": {"key": ["value"]}}] }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        
        XCTAssertEqual(fixture.values, [1, 2])
        XCTAssertEqual(fixture.nonPrimitiveValues, [Fixture.NestedFixture(one: "one", two: ["key": ["value"]])])
    }
}
