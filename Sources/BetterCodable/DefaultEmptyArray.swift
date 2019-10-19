/// Decodes Arrays returning an empty array instead of nil if appicable
///
/// `@DefaultEmptyArray` decodes Arrays and returns an empty array instead of nil if the Decoder is unable to decode the container.
@propertyWrapper
public struct DefaultEmptyArray<T: Codable>: Codable {
    public var wrappedValue: [T]
    
    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode([T].self)) ?? []
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DefaultEmptyArray: Equatable where T: Equatable { }
extension DefaultEmptyArray: Hashable where T: Hashable { }
