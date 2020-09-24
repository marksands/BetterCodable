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
public protocol BoolCodableStrategy: DefaultCodableStrategy where RawValue == Bool {}

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

    /// Default implementation of decoding a `DefaultCodable` where its strategy is a `BoolCodableStrategy`.
    ///
    /// Tries to initially Decode a `Bool` if available, otherwise tries to decode it as an `Int` or `String`
    /// when there is a `typeMismatch` decoding error. This preserves the actual value of the `Bool` in which
    /// the data provider might be sending the value as different types. If everything fails defaults to
    /// the `defaultValue` provided by the strategy.
    func decode<P: BoolCodableStrategy>(_: DefaultCodable<P>.Type, forKey key: Key) throws -> DefaultCodable<P> {
        do {
            let value = try decode(Bool.self, forKey: key)
            return DefaultCodable(wrappedValue: value)
        } catch let error {
            guard let decodingError = error as? DecodingError,
                case .typeMismatch = decodingError else {
                    return DefaultCodable(wrappedValue: P.defaultValue)
            }
            // Not sure if it is worth adding the Double, Float, and other cases.
            // In reality backend should never return double, or floating point values for bools but hey we are here for a reason 🤷🏻‍♂️
            if let intValue = try? decodeIfPresent(Int.self, forKey: key),
                let bool = Bool(exactly: NSNumber(value: intValue)) {
                return DefaultCodable(wrappedValue: bool)
            } else if let stringValue = try? decodeIfPresent(String.self, forKey: key),
                let bool = Bool(stringValue) {
                return DefaultCodable(wrappedValue: bool)
            } else {
                return DefaultCodable(wrappedValue: P.defaultValue)
            }
        }
    }
}
