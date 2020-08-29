import XCTest
import BetterCodable

class LosslessArrayTests: XCTestCase {
	struct Fixture: Equatable, Codable {
		@LosslessArray var values: [Int]
	}

	struct Fixture2: Equatable, Codable {
		@LosslessArray var values: [String]
	}

	func testDecodingLosslessArrayActsLikeLossyArray() throws {
		let jsonData = #"{ "values": [1, null, 3, 4] }"#.data(using: .utf8)!
		let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
		XCTAssertEqual(fixture.values, [1, 3, 4])
	}

	func testDecodingIntsConvertsStringsIntoLosslessElements() throws {
		let jsonData = #"{ "values": ["1", 2, null, "4"] }"#.data(using: .utf8)!
		let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
		XCTAssertEqual(fixture.values, [1, 2, 4])
	}

	func testDecodingStringsPreservesLosslessElements() throws {
		let jsonData = #"{ "values": ["1", 2, 3.14, null, false, "4"] }"#.data(using: .utf8)!
		let fixture = try JSONDecoder().decode(Fixture2.self, from: jsonData)
		XCTAssertEqual(fixture.values, ["1", "2", "3.14", "false", "4"])
	}

	func testEncodingDecodedLosslessArrayIgnoresFailableElements() throws {
		let jsonData = #"{ "values": [null, "2", null, 4] }"#.data(using: .utf8)!
		var _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)

		_fixture.values += [5]

		let fixtureData = try JSONEncoder().encode(_fixture)
		let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
		XCTAssertEqual(fixture.values, [2, 4, 5])
	}

	func testEncodingDecodedLosslessArrayRetainsContents() throws {
		let jsonData = #"{ "values": [1, 2, "3"] }"#.data(using: .utf8)!
		let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
		let fixtureData = try JSONEncoder().encode(_fixture)
		let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)

		XCTAssertEqual(fixture.values, [1, 2, 3])
	}
}
