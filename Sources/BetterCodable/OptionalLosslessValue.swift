/// Like @LosslessValue, but produce nil on parse error/if key not present.
public typealias OptionalLosslessValue<T> = OptionalLosslessValueCodable<LosslessDefaultStrategy<T>> where T: LosslessStringCodable

/// Decodes Codable values into their respective preferred types.
///
/// `@OptionalLosslessValueCodable` attempts to decode Codable types into their preferred order while preserving the data in the most lossless format. If the key is not present or the value cannot be parsed, nil is produced.
///
/// The preferred type order is provided by a generic `LosslessDecodingStrategy` that provides an ordered list of `losslessDecodableTypes`.@propertyWrapper

@propertyWrapper
public struct OptionalLosslessValueCodable<Strategy: LosslessDecodingStrategy>: Codable {
    private let type: LosslessStringCodable.Type

    public var wrappedValue: Strategy.Value?

    public init(wrappedValue: Strategy.Value) {
        self.wrappedValue = wrappedValue
        self.type = Strategy.Value.self
    }

    public init(wrappedValue: Strategy.Value?) {
        self.wrappedValue = wrappedValue
        self.type = Strategy.Value.self
    }

    public init(from decoder: Decoder) {
        do {
            self.wrappedValue = try Strategy.Value.init(from: decoder)
            self.type = Strategy.Value.self
        } catch {
            guard
                let rawValue = Strategy.losslessDecodableTypes.lazy.compactMap({ $0(decoder) }).first,
                let value = Strategy.Value.init("\(rawValue)")
            else {
                self.wrappedValue = nil
                self.type = Strategy.Value.self
                return
            }

            self.wrappedValue = value
            self.type = Swift.type(of: rawValue)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let wrappedValue = wrappedValue {
            let string = String(describing: wrappedValue)

            guard let original = type.init(string) else {
                let description = "Unable to encode '\(String(describing: wrappedValue))' back to source type '\(type)'"
                throw EncodingError.invalidValue(string, .init(codingPath: [], debugDescription: description))
            }

            try original.encode(to: encoder)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}

/// Handles decoding a key that is not present. Instead of throwing an error, a nil value is produced.
extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ type: OptionalLosslessValueCodable<LosslessDefaultStrategy<T>>.Type, forKey key: Key) throws -> OptionalLosslessValueCodable<LosslessDefaultStrategy<T>> {
        (try? decodeIfPresent(type, forKey: key)) ?? OptionalLosslessValueCodable<LosslessDefaultStrategy<T>>(wrappedValue: nil)
    }
}
