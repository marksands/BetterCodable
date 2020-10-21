import XCTest
@testable import BetterCodable

class DefaultNumberZeroTests: XCTestCase {
    struct Fixture: Equatable, Codable {
        @DefaultNumberZero var int: Int
        @DefaultNumberZero var int8: Int8
        @DefaultNumberZero var int16: Int16
        @DefaultNumberZero var int64: Int64
        @DefaultNumberZero var uint: UInt
        @DefaultNumberZero var uint8: UInt8
        @DefaultNumberZero var uint16: UInt16
        @DefaultNumberZero var uint64: UInt64
        @DefaultNumberZero var float: Float
        @DefaultNumberZero var float32: Float32
        @DefaultNumberZero var float64: Float64
        @DefaultNumberZero var cgfloat: CGFloat
        @DefaultNumberZero var double: Double
    }

    func testDecodingFailableNumberDefaultsToZero() throws {
        let jsonData = """
        {
            "int": null,
            "int8": null,
            "int16": null,
            "int64": null,
            "uint": null,
            "uint8": null,
            "uint16": null,
            "uint64": null,
            "float": null,
            "float32": null,
            "float64": null,
            "cgfloat": null,
            "double": null
        }
        """.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        XCTAssertEqual(fixture.int, 0)
        XCTAssertEqual(fixture.int8, 0)
        XCTAssertEqual(fixture.int16, 0)
        XCTAssertEqual(fixture.int64, 0)
        XCTAssertEqual(fixture.uint, 0)
        XCTAssertEqual(fixture.uint8, 0)
        XCTAssertEqual(fixture.uint16, 0)
        XCTAssertEqual(fixture.uint64, 0)
        XCTAssertEqual(fixture.float, 0)
        XCTAssertEqual(fixture.float32, 0)
        XCTAssertEqual(fixture.float64, 0)
        XCTAssertEqual(fixture.cgfloat, 0)
        XCTAssertEqual(fixture.double, 0)
    }

    func testDecodingKeyNotPresentDefaultsToZero() throws {
        let jsonData = #"{}"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        
        XCTAssertEqual(fixture.int, 0)
        XCTAssertEqual(fixture.int8, 0)
        XCTAssertEqual(fixture.int16, 0)
        XCTAssertEqual(fixture.int64, 0)
        XCTAssertEqual(fixture.uint, 0)
        XCTAssertEqual(fixture.uint8, 0)
        XCTAssertEqual(fixture.uint16, 0)
        XCTAssertEqual(fixture.uint64, 0)
        XCTAssertEqual(fixture.float, 0)
        XCTAssertEqual(fixture.float32, 0)
        XCTAssertEqual(fixture.float64, 0)
        XCTAssertEqual(fixture.cgfloat, 0)
        XCTAssertEqual(fixture.double, 0)
    }

    func testEncodingDecodedFailableNumberDefaultsToZero() throws {
        let jsonData = """
        {
            "int": null,
            "int8": null,
            "int16": null,
            "int64": null,
            "uint": null,
            "uint8": null,
            "uint16": null,
            "uint64": null,
            "float": null,
            "float32": null,
            "float64": null,
            "cgfloat": null,
            "double": null
        }
        """.data(using: .utf8)!
        var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)

        _fixture.int = 1
        _fixture.int8 = 2
        _fixture.int16 = 3
        _fixture.int64 = 4
        _fixture.uint = 5
        _fixture.uint8 = 6
        _fixture.uint16 = 7
        _fixture.uint64 = 8
        _fixture.float = 9.9
        _fixture.float32 = 10.10
        _fixture.float64 = 11.11
        _fixture.cgfloat = 12.12
        _fixture.double = 13.13

        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        
        XCTAssertEqual(fixture.int, 1)
        XCTAssertEqual(fixture.int8, 2)
        XCTAssertEqual(fixture.int16, 3)
        XCTAssertEqual(fixture.int64, 4)
        XCTAssertEqual(fixture.uint, 5)
        XCTAssertEqual(fixture.uint8, 6)
        XCTAssertEqual(fixture.uint16, 7)
        XCTAssertEqual(fixture.uint64, 8)
        XCTAssertEqual(fixture.float, 9.9)
        XCTAssertEqual(fixture.float32, 10.10)
        XCTAssertEqual(fixture.float64, 11.11)
        XCTAssertEqual(fixture.cgfloat, 12.12)
        XCTAssertEqual(fixture.double, 13.13)
    }

    func testEncodingDecodedFulfillableNumberRetainsValue() throws {
        let jsonData = """
        {
            "int": 1,
            "int8": 2,
            "int16": 3,
            "int64": 4,
            "uint": 5,
            "uint8": 6,
            "uint16": 7,
            "uint64": 8,
            "float": 9.9,
            "float32": 10.10,
            "float64": 11.11,
            "cgfloat": 12.12,
            "double": 13.13
        }
        """.data(using: .utf8)!
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        
        XCTAssertEqual(fixture.int, 1)
        XCTAssertEqual(fixture.int8, 2)
        XCTAssertEqual(fixture.int16, 3)
        XCTAssertEqual(fixture.int64, 4)
        XCTAssertEqual(fixture.uint, 5)
        XCTAssertEqual(fixture.uint8, 6)
        XCTAssertEqual(fixture.uint16, 7)
        XCTAssertEqual(fixture.uint64, 8)
        XCTAssertEqual(fixture.float, 9.9)
        XCTAssertEqual(fixture.float32, 10.10)
        XCTAssertEqual(fixture.float64, 11.11)
        XCTAssertEqual(fixture.cgfloat, 12.12)
        XCTAssertEqual(fixture.double, 13.13)
    }
}
