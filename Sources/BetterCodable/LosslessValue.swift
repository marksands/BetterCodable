import Foundation

public typealias LosslessStringCodable = LosslessStringConvertible & Codable

/// Decodes Codable values into their respective preferred types.
///
/// `@LosslessValue` attempts to decode Codable types into their respective preferred types while preserving the data.
///
/// This is useful when data may return unpredictable values when a consumer is expecting a certain type. For instace, if an API sends SKUs as either an `Int` or `String`, then a `@LosslessValue` can ensure the types are always decoded as `String`s.
@propertyWrapper
public struct LosslessValue<T: LosslessStringCodable>: Codable {
    private let type: LosslessStringCodable.Type
    
    public var wrappedValue: T
    
    public init(from decoder: Decoder) throws {
        do {
            self.wrappedValue = try T.init(from: decoder)
            self.type = T.self
            
        } catch let error {
            func decode<T: LosslessStringCodable>(_: T.Type) -> (Decoder) -> LosslessStringCodable? {
                return { try? T.init(from: $0) }
            }
            
            let types: [(Decoder) -> LosslessStringCodable?] = [
                decode(String.self),
                decode(Bool.self),
                decode(Int.self),
                decode(Int8.self),
                decode(Int16.self),
                decode(Int64.self),
                decode(UInt.self),
                decode(UInt8.self),
                decode(UInt16.self),
                decode(UInt64.self),
                decode(Double.self),
                decode(Float.self),
                ]
            
            guard
                let rawValue = types.lazy.compactMap({ $0(decoder) }).first,
                let value = T.init("\(rawValue)")
                else { throw error }
            
            self.wrappedValue = value
            self.type = Swift.type(of: rawValue)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        let string = String(describing: wrappedValue)
        
        guard let original = type.init(string) else {
            let description = "Unable to encode '\(wrappedValue)' back to source type '\(type)'"
            throw EncodingError.invalidValue(string, .init(codingPath: [], debugDescription: description))
        }
        
        try original.encode(to: encoder)
    }
}

extension LosslessValue: Equatable where T: Equatable {
    public static func == (lhs: LosslessValue<T>, rhs: LosslessValue<T>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension LosslessValue: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
