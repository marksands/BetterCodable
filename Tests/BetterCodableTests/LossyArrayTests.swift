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

	func testDecodingLossyArrayIgnoresLossyElements() throws {
        let jsonData = #"{ "values": [1, null, "3", false, 4], "nonPrimitiveValues": [null] }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.values, [1, 4])
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
    
    func testEncodingDecodedLossyArrayRetainsContents() throws {
        let jsonData = #"{ "values": [1, 2], "nonPrimitiveValues": [{ "one": "one", "two": {"key": ["value"]}}] }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        
        XCTAssertEqual(fixture.values, [1, 2])
        XCTAssertEqual(fixture.nonPrimitiveValues, [Fixture.NestedFixture(one: "one", two: ["key": ["value"]])])
    }
    
    func testEncodingDecodingLossyArrayWorksWithCustomStrategies() throws {
        struct Fixture: Equatable, Codable {
            @LossyArray var theValues: [Date]
        }

        let jsonData = #"{ "the_values": [123, null] }"#.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let fixture = try decoder.decode(Fixture.self, from: jsonData)

        XCTAssertEqual(fixture.theValues, [Date(timeIntervalSince1970: 123)])
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .secondsSince1970
        let data = try encoder.encode(fixture)
        let fixture2 = try decoder.decode(Fixture.self, from: data)

        XCTAssertEqual(fixture2.theValues, [Date(timeIntervalSince1970: 123)])
    }
}
