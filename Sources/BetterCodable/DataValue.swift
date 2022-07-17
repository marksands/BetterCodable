import Foundation

/// A protocol for providing a custom strategy for encoding and decoding data as strings.
///
/// `DataValueCodableStrategy` provides a generic strategy type that the `DataValue` property wrapper can use to inject
///  custom strategies for encoding and decoding data values.
///
///  TODO: Switch to DataProtocol; consider supporting
public protocol DataValueCodableStrategy {
    static func decode(_ value: String) throws -> Data
    static func encode(_ data: Data) -> String
}

/// Decodes and encodes data using a strategy type.
///
/// `@DataValue` decodes data using a `DataValueCodableStrategy` which provides custom decoding and encoding functionality.
@propertyWrapper
public struct DataValue<Coder: DataValueCodableStrategy> {
    public var wrappedValue: Data

    public init(wrappedValue: Data) {
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

extension DataValue: Equatable {}
extension DataValue: Hashable {}
