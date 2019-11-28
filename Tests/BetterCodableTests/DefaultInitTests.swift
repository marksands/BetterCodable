import XCTest
import BetterCodable

class DefaultInitTests: XCTestCase {
    struct Fixture: Codable {
        @DefaultInit var text: String
        @DefaultInit var integer: Int
        @DefaultInit var array: [Int]
        @DefaultInit var dict: [String: Int]
    }
    
    func testDecodingFailableToDefaultInitValue() throws {
        let json = #"{ "text": null, "integer": null, "array": null, "dict": null }"#.data(using: .utf8)!
        let fixture = try! JSONDecoder().decode(Fixture.self, from: json)
        
        XCTAssertEqual(fixture.text, "")
        XCTAssertEqual(fixture.integer, 0)
        XCTAssertEqual(fixture.array, [])
        XCTAssertEqual(fixture.dict, [:])
    }
    
}

extension String: Initable {}
extension Int: Initable {}
extension Array: Initable where Element: Codable {}
extension Dictionary: Initable where Key: Codable, Value: Codable {}

