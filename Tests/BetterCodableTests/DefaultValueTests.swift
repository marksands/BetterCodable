import XCTest
import Foundation
import BetterCodable

class DefaultValueTests: XCTestCase {


    func testDecodingBooleanDefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var boolean: Bool
        }

        let jsonData = #"{ "boolean": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.boolean, false)
    }

    func testDecodingFloatDefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var float: Float
        }

        let jsonData = #"{ "float": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.float, 0)
    }

    func testDecodingFloat32DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var float32: Float32
        }

        let jsonData = #"{ "float32": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.float32, 0)
    }

    func testDecodingFloat64DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var float64: Float64
        }

        let jsonData = #"{ "float64": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.float64, 0)
    }

    func testDecodingUIntDefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var uInt: UInt
        }

        let jsonData = #"{ "uInt": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.uInt, 0)
    }

    func testDecodingUInt8DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var uInt8: UInt8
        }

        let jsonData = #"{ "uInt8": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.uInt8, 0)
    }

    func testDecodingUInt16DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var uInt16: UInt16
        }

        let jsonData = #"{ "uInt16": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.uInt16, 0)
    }

    func testDecodingUInt32DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var uInt32: UInt32
        }

        let jsonData = #"{ "uInt32": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.uInt32, 0)
    }

    func testDecodingUInt64DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var uInt64: UInt64
        }

        let jsonData = #"{ "uInt64": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.uInt64, 0)
    }

    func testDecodingIntDefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var Int: Int
        }

        let jsonData = #"{ "Int": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.Int, 0)
    }

    func testDecodingInt8DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var Int8: Int8
        }

        let jsonData = #"{ "Int8": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.Int8, 0)
    }

    func testDecodingInt16DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var Int16: Int16
        }

        let jsonData = #"{ "Int16": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.Int16, 0)
    }

    func testDecodingInt32DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var Int32: Int32
        }

        let jsonData = #"{ "Int32": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.Int32, 0)
    }

    func testDecodingInt64DefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var Int64: Int64
        }

        let jsonData = #"{ "Int64": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.Int64, 0)
    }

    func testDecodingDoubleDefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var double: Double
        }

        let jsonData = #"{ "double": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.double, 0)
    }

    func testDecodingDateDefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var date: Date
        }

        let jsonData = #"{ "date": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(
            fixture.date.timeIntervalSince1970.rounded(),
            Date().timeIntervalSince1970.rounded()
        )
    }

    func testDecodingStringDefaultValue() throws {
        struct Fixture: Codable {
            @DefaultValue var string: String
        }

        let jsonData = #"{ "string": null }"#.data(using: .utf8)!
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        XCTAssertEqual(fixture.string, "")
    }

}
