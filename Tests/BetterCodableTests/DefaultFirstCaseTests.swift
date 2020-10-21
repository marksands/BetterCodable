import XCTest
@testable import BetterCodable

class DefaultFirstCaseTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        enum Language: String, Codable, CaseIterable {
            case unknown, swift, ruby, python, javascript
        }
        
        @DefaultFirstCase var language: Language
    }
    
    func testDecodingFailableEnumDefaultsToFirstCase() throws {
        let jsonData = #"{ "language": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.language, .unknown)
    }
    
    func testDecodingKeyNotPresentDefaultsToFirstCase() throws {
        let jsonData = #"{}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.language, .unknown)
    }
    
    func testEncodingDecodedFailableEnumDefaultsToFirstCase() throws {
        let jsonData = #"{ "language": null }"#.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        _fixture.language = .swift
        
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        XCTAssertEqual(fixture.language, .swift)
    }
    
    func testEncodingDecodedFulfillableEnumRetainsValue() throws {
        let jsonData = #"{ "language": "swift" }"#.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)

        XCTAssertEqual(fixture.language, .swift)
    }
}
