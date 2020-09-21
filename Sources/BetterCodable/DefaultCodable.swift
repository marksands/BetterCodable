import Foundation

/// Provides a default value for missing `Decodable` data.
///
/// `DefaultCodableStrategy` provides a generic strategy type that the `DefaultCodable` property wrapper can use to provide
/// a reasonable default value for missing Decodable data.
public protocol DefaultCodableStrategy {
    associatedtype RawValue: Codable
    
    static var defaultValue: RawValue { get }
}

/// Decodes values with a reasonable default value
///
/// `@Defaultable` attempts to decode a value and falls back to a default type provided by the generic
/// `DefaultCodableStrategy`.
@propertyWrapper
public struct DefaultCodable<Default: DefaultCodableStrategy>: Codable {
    public var wrappedValue: Default.RawValue
    
    public init(wrappedValue: Default.RawValue) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(Default.RawValue.self)) ?? Default.defaultValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DefaultCodable: Equatable where Default.RawValue: Equatable { }
extension DefaultCodable: Hashable where Default.RawValue: Hashable { }

// MARK: - KeyedDecodingContainer
public extension KeyedDecodingContainer {

    /// Default implementation of decoding a DefaultCodable
    ///
    /// Decodes successfully if key is available if not fallsback to the default value provided.
    func decode<P>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        if let value = try decodeIfPresent(DefaultCodable<P>.self, forKey: key) {
            return value
        } else {
            return DefaultCodable(wrappedValue: P.defaultValue)
        }
    }

    func decode<P: BoolCodableStrategy>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        do {
            let value = try decode(Bool.self, forKey: key)
            return DefaultCodable(wrappedValue: value)
        } catch let error {
            guard let decodingError = error as? DecodingError,
                case .typeMismatch = decodingError else {
                    return DefaultCodable(wrappedValue: DefaultFalseStrategy.defaultValue)
            }
            if let intValue = try? decodeIfPresent(Int.self, forKey: key),
                let bool = Bool(exactly: NSNumber(value: intValue)) {
                return DefaultCodable(wrappedValue: bool)
            } else if let stringValue = try? decodeIfPresent(String.self, forKey: key),
                let bool = Bool(stringValue) {
                return DefaultCodable(wrappedValue: bool)
            } else {
                return DefaultCodable(wrappedValue: DefaultFalseStrategy.defaultValue)
            }
        }
    }
}
