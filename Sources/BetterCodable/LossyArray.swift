/// Decodes Arrays filtering invalid values if applicable
///
/// `@LossyArray` decodes Arrays and filters invalid values if the Decoder is unable to decode the value.
///
/// This is useful if the Array is intended to contain non-optional types.
@propertyWrapper
public struct LossyArray<T> {
    public var wrappedValue: [T]
    public var projectedValue: Self { self }

    public init(wrappedValue: [T]) {
        self.wrappedValue = wrappedValue
    }

    public struct FailedDecode {
        var codingPath: [CodingKey]
        var error: Error
    }

    public var failedDecodes: [FailedDecode] = []
}

extension LossyArray: Decodable where T: Decodable {
    private struct AnyDecodableValue: Decodable {}

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        var elements: [T] = []
        var failedDecodes: [FailedDecode] = []
        while !container.isAtEnd {
            do {
                let value = try container.decode(T.self)
                elements.append(value)
            } catch {
                failedDecodes.append(FailedDecode(codingPath: container.codingPath, error: error))
                _ = try? container.decode(AnyDecodableValue.self)
            }
        }

        self.wrappedValue = elements
        self.failedDecodes = failedDecodes
    }
}

extension LossyArray: Encodable where T: Encodable {
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension LossyArray: Equatable where T: Equatable {
    public static func == (lhs: LossyArray<T>, rhs: LossyArray<T>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
extension LossyArray: Hashable where T: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
