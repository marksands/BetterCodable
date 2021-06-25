import XCTest
import BetterCodable

struct MyLosslessStrategy<Value: LosslessStringCodable>: LosslessDecodingStrategy {
    static var losslessDecodableTypes: [(Decoder) -> LosslessStringCodable?] {
        [
            { try? String(from: $0) },
            { try? Bool(from: $0) },
            { try? Int(from: $0) },
            { _ in return 42 },
        ]
    }
}

typealias MyLosslessType<T> = LosslessValueCodable<MyLosslessStrategy<T>> where T: LosslessStringCodable

class LosslessCustomValueTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @MyLosslessType var int: Int
        @MyLosslessType var string: String
        @MyLosslessType var fortytwo: Int
        @MyLosslessType var bool: Bool
    }

    func testDecodingCustomLosslessStrategyDecodesCorrectly() throws {
        let jsonData = #"{ "string": 7, "int": "1", "fortytwo": null, "bool": true }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.string, "7")
        XCTAssertEqual(fixture.int, 1)
        XCTAssertEqual(fixture.fortytwo, 42)
        XCTAssertEqual(fixture.bool, true)
    }

    func testDecodingCustomLosslessStrategyWithBrokenFieldsThrowsError() throws {
        let jsonData = #"{ "string": 7, "int": "1", "fortytwo": null, "bool": 9 }"#.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(Fixture.self, from: jsonData))
    }
}
