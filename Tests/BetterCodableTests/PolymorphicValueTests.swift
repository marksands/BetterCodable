import XCTest
import BetterCodable

class Drink: Codable {
    let description: String
}

class Soda: Drink {
    var sugar_content: String

    private enum CodingKeys: String, CodingKey {
        case sugar_content
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sugar_content = try container.decode(String.self, forKey: .sugar_content)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sugar_content, forKey: .sugar_content)
        try super.encode(to: encoder)
    }
}

enum DrinkFamily: String, PolymorphicFamily {
    case drink = "drink"
    case soda = "soda"

    static var discriminator: Discriminator = .type

    func getType() -> Drink.Type {
        switch self {
        case .soda:
            return Soda.self
        case .drink:
            return Drink.self
        }
    }
}

class PolymorphicValueTests: XCTestCase {

    struct Fixture: Codable {
        @PolymorphicValue<DrinkFamily> var drink: Drink
    }
    let jsonData = """
    {
        "drink": {
            "type": "soda",
            "description": "Coca-Cola",
            "sugar_content": "5%"
        }
    }
    """.data(using: .utf8)!

    func testDecodingPolymorphicValue() throws {
        let fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        guard let soda = fixture.drink as? Soda else { XCTFail(); return }
        XCTAssertEqual(soda.sugar_content, "5%")
    }

    func testEncodingDecodedPolymorphicValue() throws {
        let _fixture = try JSONDecoder().decode(Fixture.self, from: jsonData)
        guard let soda = _fixture.drink as? Soda else { XCTFail(); return }
        soda.sugar_content = "10%"

        let fixtureData = try JSONEncoder().encode(_fixture)
        let fixture = try JSONDecoder().decode(Fixture.self, from: fixtureData)
        guard let soda = fixture.drink as? Soda else { XCTFail(); return }
        XCTAssertEqual(soda.sugar_content, "10%")
    }
}

