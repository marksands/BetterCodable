/// Decodes Arrays filtering invalid values if applicable
///
/// `@LossyArray` decodes Arrays and filters invalid values if the Decoder is unable to decode the value.
///
/// This is useful if the Array is intended to contain non-optional types.
@propertyWrapper
public struct LossyArray<T: Codable>: Codable {
    private struct AnyDecodableValue: Codable {}
    private struct LossyDecodableValue<Value: Codable>: Codable {
        let value: Value
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Value.self)
        }
    }
    
    public var wrappedValue: [T]
    
    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        var elements: [T] = []
        while !container.isAtEnd {
            do {
                let value = try container.decode(LossyDecodableValue<T>.self).value
                elements.append(value)
            } catch {
                _ = try? container.decode(AnyDecodableValue.self)
            }
        }
        
        self.wrappedValue = elements
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension LossyArray: Equatable where T: Equatable { }
extension LossyArray: Hashable where T: Hashable { }
