import XCTest
import BetterCodable

// MARK: - DefaultCodable

// MARK: -
// MARK: Date Decoding Strategy

private extension Date {
	enum DefaultToNow: DefaultCodableStrategy {
		static var defaultValue: Date { Date() }
	}
}

private let iso8601: DateFormatter = {
	let iso8601 = DateFormatter()
	iso8601.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
	iso8601.timeZone = TimeZone(secondsFromGMT: 0)
	iso8601.locale = Locale(identifier: "en_US_POSIX")
	return iso8601
}()

private extension JSONDecoder {
	static var iso: JSONDecoder {
		let encoder = JSONDecoder()
		encoder.dateDecodingStrategy = .formatted(iso8601)
		return encoder
	}
}

private extension JSONEncoder {
	static var iso: JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(iso8601)
		return encoder
	}
}

class DefaultCodableTest_DateStrategy: XCTestCase {
	struct Fixture: Equatable, Codable {
		@DefaultCodable<Date.DefaultToNow>
		fileprivate var discoverDate: Date
	}
	
	func testDecodingAndEncodingWithDateStrategy() throws {
		let expectedDate = Date(timeIntervalSinceReferenceDate: 222601260)
		let jsonData = #"{ "discoverDate": "2008-01-21T09:41:00.000Z" }"#.data(using: .utf8)!
		let fixture = try JSONDecoder.iso.decode(Fixture.self, from: jsonData)
		XCTAssertEqual(fixture.discoverDate, expectedDate)
		
		let data = try JSONEncoder.iso.encode(fixture)
		let str = String(data: data, encoding: .utf8)
		XCTAssertEqual(str, #"{"discoverDate":"2008-01-21T09:41:00.000Z"}"#)
	}
}

// MARK: -
// MARK: Nested Property Wrapper

class DefaultCodableTest_NestedPropertyWrapper: XCTestCase {
    enum DefaultToNowTimeStampDateValue: DefaultCodableStrategy {
        static var defaultValue: DateValue<TimestampStrategy> {
            .init(wrappedValue: Date(timeIntervalSince1970: 0))
        }
    }
    
    struct Fixture: Codable {
        @DefaultCodable<DefaultToNowTimeStampDateValue>
        @DateValue<TimestampStrategy>
        var returnDate: Date
    }
    
    func testNestedPropertyWrappersCanMergeDefaultCodableWithDateStrategy() throws {
        let _1970 = Date(timeIntervalSince1970: 0)
        let _1971 = Date(timeIntervalSince1970: 31536000)

        let jsonData1 = #"{ "returnDate": null }"#.data(using: .utf8)!
        let jsonData2 = #"{ }"#.data(using: .utf8)!
        let jsonData3 = #"{ "returnDate": 31536000 }"#.data(using: .utf8)!
        
        let fixture1 = try JSONDecoder().decode(Fixture.self, from: jsonData1)
        let fixture2 = try JSONDecoder().decode(Fixture.self, from: jsonData2)
        let fixture3 = try JSONDecoder().decode(Fixture.self, from: jsonData3)
        
        XCTAssertEqual(fixture1.returnDate, _1970)
        XCTAssertEqual(fixture2.returnDate, _1970)
        XCTAssertEqual(fixture3.returnDate, _1971)
    }
}


// MARK: -
// MARK: Types with Containers

class DefaultCodableTests_TypesWithContainers: XCTestCase {
	struct ArrayContainer: Codable {
		var value: [Int]
	}

	enum DefaultArrayContainerType: DefaultCodableStrategy {
		static var defaultValue: ArrayContainer { .init(value: [3, 7]) }
	}

	struct DictionaryContainer: Codable {
		var value: [String: Int]
	}

	enum DefaultDictionaryContainerType: DefaultCodableStrategy {
		static var defaultValue: DictionaryContainer { .init(value: ["a": 1]) }
	}
	
	struct Fixture: Codable {
		@DefaultCodable<DefaultArrayContainerType>
		public var type: ArrayContainer
	}
	
	struct Fixture2: Codable {
		@DefaultCodable<DefaultDictionaryContainerType>
		public var type: DictionaryContainer
	}
	
	func testDecodingAndEncodingWithArrayContainer() throws {
		let jsonData = #"{ "type": { "value": [2, 4, 6] } }"#.data(using: .utf8)!
		let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
		XCTAssertEqual(fixture.type.value, [2, 4, 6])
		
		let data = try JSONEncoder().encode(fixture)
		let str = String(data: data, encoding: .utf8)
		XCTAssertEqual(str, #"{"type":{"value":[2,4,6]}}"#)
	}
	
	func testDecodingAndEncodingWithDictionaryContainer() throws {
		let jsonData = #"{ "type": { "value": {"b": 17 } } }"#.data(using: .utf8)!
		let fixture = try JSONDecoder().decode(Fixture2.self, from: jsonData)
		XCTAssertEqual(fixture.type.value, ["b": 17])
		
		let data = try JSONEncoder().encode(fixture)
		let str = String(data: data, encoding: .utf8)
		XCTAssertEqual(str, #"{"type":{"value":{"b":17}}}"#)
	}
}

// MARK: -
// MARK: Enums with Associated Values

class DefaultCodableTests_EnumWithAssociatedValue: XCTestCase {
	enum Zar: Equatable {
		case ziz(Int)
		case zaz(Int)
	}
	
	struct CustomType: Codable, Equatable {
		enum CodingKeys: String, CodingKey {
			case z = "fish"
			case i = "int"
		}
		
		var z: Zar
		
		init(z: Zar) {
			self.z = z
		}
		
		init(from decoder: Decoder) throws {
			let c = try decoder.container(keyedBy: CodingKeys.self)
			let k = try c.decode(String.self, forKey: .z)
			let i = try c.decode(Int.self, forKey: .i)
			
			if k == "ziz" { z = .ziz(i) }
			else { z = .zaz(i) }
		}
		
		func encode(to encoder: Encoder) throws {
			var c = encoder.container(keyedBy: CodingKeys.self)
			switch z {
			case .ziz(let i):
				try c.encode("ziz", forKey: .z)
				try c.encode(i, forKey: .i)
			case .zaz(let i):
				try c.encode("zaz", forKey: .z)
				try c.encode(i, forKey: .i)
			}
		}
		
		enum Default42: DefaultCodableStrategy {
			static var defaultValue: CustomType { .init(z: .zaz(42)) }
		}
	}
	
	struct Fixture: Equatable, Codable {
		@DefaultCodable<CustomType.Default42>
		public var value: CustomType
	}
	
	func testDecodingAndEncodingCustomEnumWithAssociatedValue() throws {
		let jsonData = #"{ "value": { "fish": "ziz", "int": 4 } }"#.data(using: .utf8)!
		let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
		XCTAssertEqual(fixture.value.z, .ziz(4))
		
		let data = try JSONEncoder().encode(fixture)
		let str = String(data: data, encoding: .utf8)
		XCTAssertEqual(str, #"{"value":{"int":4,"fish":"ziz"}}"#)
	}
}
