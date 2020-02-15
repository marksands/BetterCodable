import XCTest
import BetterCodable

class DefaultEmptyDictionaryTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @DefaultEmptyDictionary var stringToInt: [String: Int]
    }
    
    func testDecodingFailableDictionaryDefaultsToEmptyDictionary() throws {
        let jsonData = #"{ "stringToInt": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.stringToInt, [:])
    }

    func testDecodingKeyNotPresentDefaultsToEmptyDictionary() throws {
        let jsonData = #"{}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.stringToInt, [:])
    }
    
    func testEncodingDecodedFailableDictionaryDefaultsToEmptyDictionary() throws {
        let jsonData = #"{ "stringToInt": null }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)

        _fixture.stringToInt["one"] = 1
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.stringToInt, ["one": 1])
    }
    
    func testEncodingDecodedFulfillableDictionaryRetainsContents() throws {
        let jsonData = #"{ "stringToInt": {"one": 1, "two": 2} }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.stringToInt, ["one": 1, "two": 2])
    }
}
