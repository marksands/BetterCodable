/// Decodes Dictionaries returning an empty dictionary instead of nil if appicable
///
/// `@DefaultEmptyDictionary` decodes Dictionaries and returns an empty dictionary instead of nil if the Decoder is unable to decode the container.
@propertyWrapper
public struct DefaultEmptyDictionary<Key: Codable & Hashable, Value: Codable>: Codable {
    public var wrappedValue: [Key: Value]
    
    public init(wrappedValue: [Key: Value]) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode([Key: Value].self)) ?? [:]
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DefaultEmptyDictionary: Equatable where Key: Equatable, Value: Equatable { }
