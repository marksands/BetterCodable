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
    
    func testDecodingBadUrlAsOptionalWithDefaultNil() throws {
        struct Fixture: Codable {
            @DefaultNil var url: URL?
        }
        let jsonData = #"{"url":""}"#.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertNil(fixture.url)
    }
    
    func testDecodingGoodUrl() throws {
        struct Fixture: Codable {
            @DefaultNil var url: URL?
        }
        let urlString = "https://github.com/marksands/BetterCodable"
        
        let jsonData = #"{"url":"\#(urlString)"}"#
            .data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let url = URL(string: urlString)
        
        XCTAssertNotNil(url)
        XCTAssertNotNil(fixture.url)
        XCTAssertEqual(url, fixture.url)
    }
    
    func testDecodingNullUrl() throws {
        struct Fixture: Codable {
            @DefaultNil var url: URL?
        }
        let jsonData = #"{"url":null}"#.data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertNil(fixture.url)
    }
    
    func testDecodingWithMissingKey() throws {
        struct Fixture: Codable {
            @DefaultNil var url: URL?
        }
        let jsonData = "{}".data(using: .utf8)!
        
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertNil(fixture.url)
    }
}
