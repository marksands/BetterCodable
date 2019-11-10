import Foundation

/// A protocol for providing a custom strategy for encoding and decoding dates.
///
/// `DateValueCodableStrategy` provides a generic strategy type that the `DateValue` property wrapper can use to inject custom strategies for encoding and decoding date values.
public protocol DateValueCodableStrategy {
    associatedtype RawValue: Codable

    static func decode(_ value: RawValue) throws -> Date
    static func encode(_ date: Date) -> RawValue
}

/// Decodes and encodes dates using a strategy type.
///
/// `@DateValue` decodes dates using a `DateValueCodableStrategy` which provides custom decoding and encoding functionality.
@propertyWrapper
public struct DateValue<Formatter: DateValueCodableStrategy>: Codable {
    private let value: Formatter.RawValue
    public var wrappedValue: Date

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
        self.value = Formatter.encode(wrappedValue)
    }
    
    public init(from decoder: Decoder) throws {
        self.value = try Formatter.RawValue(from: decoder)
        self.wrappedValue = try Formatter.decode(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
