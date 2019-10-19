import XCTest
import BetterCodable

class LossyDictionaryTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @LossyDictionary var stringToInt: [String: Int]
        @LossyDictionary var intToString: [Int: String]
    }
    
    func testDecodingLossyDictionaryIgnoresFailableElements() throws {
        let jsonData = """
        {
            "stringToInt": {
                "one": 1,
                "two": 2,
                "three": null
            },
            "intToString": {
                "1": "one",
                "2": "two",
                "3": null
            }
        }
        """.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.stringToInt, ["one": 1, "two": 2])
        XCTAssertEqual(fixture.intToString, [1: "one", 2: "two"])
    }
    
    func testEncodingDecodedLossyDictionaryIgnoresFailableElements() throws {
        let jsonData = """
        {
            "stringToInt": {
                "one": 1,
                "two": 2,
                "three": null
            },
            "intToString": {
                "1": "one",
                "2": "two",
                "3": null
            }
        }
        """.data(using: .utf8)!
        
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)

        _fixture.stringToInt["three"] = 3
        _fixture.intToString[3] = "three"
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.stringToInt, ["one": 1, "two": 2, "three": 3])
        XCTAssertEqual(fixture.intToString, [1: "one", 2: "two", 3: "three"])
    }
    
    func testEncodingDecodedLosslessArrayRetainsContents() throws {
        let jsonData = """
        {
            "stringToInt": {
                "one": 1,
                "two": 2,
                "three": 3
            },
            "intToString": {
                "1": "one",
                "2": "two",
                "3": "three"
            }
        }
        """.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.stringToInt, ["one": 1, "two": 2, "three": 3])
        XCTAssertEqual(fixture.intToString, [1: "one", 2: "two", 3: "three"])
    }
}
