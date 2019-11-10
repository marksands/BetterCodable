public struct DefaultEmptyDictionaryStrategy<Key: Codable & Hashable, Value: Codable>: DefaultCodableStrategy {
    public static var defaultValue: [Key: Value] { return [:] }
}

/// Decodes Dictionaries returning an empty dictionary instead of nil if appicable
///
/// `@DefaultEmptyDictionary` decodes Dictionaries and returns an empty dictionary instead of nil if the Decoder is unable to decode the container.
public typealias DefaultEmptyDictionary<K, V> = DefaultCodable<DefaultEmptyDictionaryStrategy<K, V>> where K: Codable & Hashable, V: Codable
