import Foundation

/// Decodes `String` values as a Base64-encoded `Data`.
///
/// Decodes strictly valid Base64. This does not handle b64url encoding, invalid padding, or unknown characters.
public struct Base64Strategy<DataType: MutableDataProtocol>: DataValueCodableStrategy {
    public static func decode(_ value: String) throws -> DataType {
        if let data = Data(base64Encoded: value) {
            return DataType(data)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid Base64 Format!"))
        }
    }

    public static func encode(_ data: DataType) -> String {
        Data(data).base64EncodedString()
    }
}
