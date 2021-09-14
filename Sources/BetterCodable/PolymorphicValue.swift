/// Discriminator key enum used to retrieve the type of the encodable/decodable value.
public enum Discriminator: String, CodingKey {
    case type = "type"
}

/// To decode/encode a family of types, create an enum that conforms to this protocol and contains the parseable types.
public protocol PolymorphicFamily: Codable {
    associatedtype BaseType : Codable

    /// The discriminator key.
    static var discriminator: Discriminator { get }

    /// Returns the class type of the object coresponding to the value.
    func getType() -> BaseType.Type
}

extension PolymorphicFamily {
    static var discriminator: Discriminator {
        return .type
    }
}

/// Decodes Polymorphic value by attempting to parse the value into it's preferred type.
///
/// This is useful when data may return an array of objects that may be of a different type.
@propertyWrapper
public struct PolymorphicValue<Family: PolymorphicFamily> {
    private let family: Family
    public var wrappedValue: Family.BaseType

    public init(family: Family, wrappedValue: Family.BaseType) {
        self.family = family
        self.wrappedValue = wrappedValue
    }
}

extension PolymorphicValue: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Discriminator.self)
        // Decode the family with the discriminator.
        self.family = try container.decode(Family.self, forKey: Family.discriminator)
        // Decode the object by initialising the corresponding type.
        self.wrappedValue = try family.getType().init(from: decoder)
    }
}

extension PolymorphicValue: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Discriminator.self)
        try container.encode(self.family, forKey: .type)
        try wrappedValue.encode(to: encoder)
    }
}
