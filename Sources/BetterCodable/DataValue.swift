import Foundation

/// A protocol for providing a custom strategy for encoding and decoding data as strings.
///
/// `DataValueCodableStrategy` provides a generic strategy type that the `DataValue` property wrapper can use to inject
///  custom strategies for encoding and decoding data values.
///
public protocol DataValueCodableStrategy {
    associatedtype DataType: MutableDataProtocol
    static func decode(_ value: String) throws -> DataType
    static func encode(_ data: DataType) -> String
}

/// Decodes and encodes data using a strategy type.
///
/// `@DataValue` decodes data using a `DataValueCodableStrategy` which provides custom decoding and encoding functionality.
@propertyWrapper
public struct DataValue<Coder: DataValueCodableStrategy> {
    public var wrappedValue: Coder.DataType

    public init(wrappedValue: Coder.DataType) {
        self.wrappedValue = wrappedValue
    }
}

extension DataValue: Decodable {
    public init(from decoder: Decoder) throws {
        self.wrappedValue = try Coder.decode(String(from: decoder))
    }
}

extension DataValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        try Coder.encode(wrappedValue).encode(to: encoder)
    }
}

extension DataValue: Equatable where Coder.DataType: Equatable {}
extension DataValue: Hashable where Coder.DataType: Hashable {}
