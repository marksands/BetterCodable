/// Decodes Dictionaries filtering invalid key-value pairs if applicable
///
/// `@LossyDictionary` decodes Dictionaries and filters invalid key-value pairs if the Decoder is unable to decode the value.
///
/// This is useful if the Dictionary is intended to contain non-optional values.
@propertyWrapper
public struct LossyDictionary<Key: Codable & Hashable, Value: Codable>: Codable {
    struct DictionaryCodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }
        
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    
    private struct AnyDecodableValue: Codable {}
    private struct LossyDecodableValue<Value: Codable>: Codable {
        let value: Value
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Value.self)
        }
    }
    
    public var wrappedValue: [Key: Value]
    
    public init(wrappedValue: [Key: Value]) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        var elements: [Key: Value] = [:]
        if Key.self == String.self {
            let container = try decoder.container(keyedBy: DictionaryCodingKey.self)
            
            for key in container.allKeys {
                do {
                    let value = try container.decode(LossyDecodableValue<Value>.self, forKey: key).value
                    elements[key.stringValue as! Key] = value
                } catch {
                    _ = try? container.decode(AnyDecodableValue.self, forKey: key)
                }
            }
        } else if Key.self == Int.self {
            let container = try decoder.container(keyedBy: DictionaryCodingKey.self)
            
            for key in container.allKeys {
                guard key.intValue != nil else {
                    var codingPath = decoder.codingPath
                    codingPath.append(key)
                    throw DecodingError.typeMismatch(
                        Int.self,
                        DecodingError.Context(
                            codingPath: codingPath,
                            debugDescription: "Expected Int key but found String key instead."))
                }
                
                do {
                    let value = try container.decode(LossyDecodableValue<Value>.self, forKey: key).value
                    elements[key.intValue! as! Key] = value
                } catch {
                    _ = try? container.decode(AnyDecodableValue.self, forKey: key)
                }
            }
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unable to decode key type."))
        }
        
        self.wrappedValue = elements
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension LossyDictionary: Equatable where Key: Equatable, Value: Equatable { }
