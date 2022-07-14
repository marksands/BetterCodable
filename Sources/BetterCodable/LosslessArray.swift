/// Decodes Arrays by attempting to decode its elements into their preferred types.
///
/// `@LosslessArray` attempts to decode Arrays and their elements into their preferred types while preserving the data.
///
/// This is useful when data may return unpredictable values when a consumer is expecting a certain type. For instance,
/// if an API sends an array of SKUs as either `Int`s or `String`s, then a `@LosslessArray` can ensure the elements are
/// always decoded as `String`s.
@propertyWrapper
public struct LosslessArray<T: LosslessStringCodable> {
    public var wrappedValue: [T]

    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }
}

extension LosslessArray: Decodable where T: Decodable {
    private struct AnyDecodableValue: Decodable {}

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var elements: [T] = []
        while !container.isAtEnd {
            do {
                let value = try container.decode(LosslessValue<T>.self).wrappedValue
                elements.append(value)
            } catch {
                _ = try? container.decode(AnyDecodableValue.self)
            }
        }

        self.wrappedValue = elements
    }
}

extension LosslessArray: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension LosslessArray: Equatable where T: Equatable {}
extension LosslessArray: Hashable where T: Hashable {}

#if canImport(_Concurrency) && compiler(>=5.5.2)
extension LosslessArray: Sendable where T: Sendable { }
#endif
