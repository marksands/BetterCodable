import XCTest
import BetterCodable

class DefaultNilTests: XCTestCase {
    /// This test demonstrates the problem that `@DefaultNil` solves. When decoding
    /// optional types, it often the case that we end up with an error instead of
    /// defaulting back to `nil`.
    func testDecodingBadUrlAsOptionalWithoutDefaultNil() {
        struct Fixture: Codable {
            var url: URL?
        }
        let jsonData = #"{"url":""}"#.data(using: .utf8)!
        
        XCTAssertThrowsError(try JSONDecoder().decode(Fixture.self, from: jsonData))
    }
    
    func testDecodingWithUrlConversions() throws {
        struct Fixture: Codable {
            @DefaultNil var a: URL?
            @DefaultNil var b: URL?
        }
        
        let badUrlString = "https://website .test"
        let goodUrlString = "https://website.test"
        
        let jsonData = #"{"a":"\#(badUrlString)", "b":"\#(goodUrlString)"}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        XCTAssertNil(fixture.a)
        XCTAssertEqual(fixture.b, URL(string: goodUrlString))
    }
    
    func testDecodingWithIntegerConversions() throws {
        struct Fixture: Codable {
            @DefaultNil var a: Int?
            @DefaultNil var b: Int?
        }
        
        let jsonData = #"{ "a": 3.14, "b": 3 }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        XCTAssertNil(fixture.a)
        XCTAssertEqual(fixture.b, 3)
    }
    
    func testDecodingWithNullValue() throws {
        struct Fixture: Codable {
            @DefaultNil var a: String?
        }
        
        let jsonData = #"{"a":null}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        XCTAssertNil(fixture.a)
    }
    
    func testDecodingWithMissingKey() throws {
        struct Fixture: Codable {
            @DefaultNil var a: String?
        }
        
        let jsonData = "{}".data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        XCTAssertNil(fixture.a)
    }
}
