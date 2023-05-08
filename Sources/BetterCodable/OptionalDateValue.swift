import Foundation

/// A protocol for providing a custom strategy for encoding and decoding optional dates.
///
/// `OptionalDateValueCodableStrategy` provides a generic strategy type that the `OptionalDateValue` property wrapper can use to inject
///  custom strategies for encoding and decoding optional date values.
public protocol OptionalDateValueCodableStrategy {
    associatedtype RawValue

    static func decode(_ value: RawValue?) throws -> Date?
    static func encode(_ date: Date?) -> RawValue?
}

/// Decodes and encodes optional dates using a strategy type.
///
/// `@OptionalDateValue` decodes dates using a `OptionalDateValueCodableStrategy` which provides custom decoding and encoding functionality.
@propertyWrapper
public struct OptionalDateValue<Formatter: OptionalDateValueCodableStrategy> {
    public var wrappedValue: Date?

    public init(wrappedValue: Date?) {
        self.wrappedValue = wrappedValue
    }
}

extension OptionalDateValue: Decodable where Formatter.RawValue: Decodable {
    public init(from decoder: Decoder) throws {
        do {
            let value = try Formatter.RawValue(from: decoder)
            self.wrappedValue = try Formatter.decode(value)
        } catch DecodingError.valueNotFound(let rawType, _) where rawType == Formatter.RawValue.self {
            self.wrappedValue = nil
        } catch {
            throw error
        }
    }
}

extension OptionalDateValue: Encodable where Formatter.RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        let value = Formatter.encode(wrappedValue)
        try value.encode(to: encoder)
    }
}

extension OptionalDateValue: Equatable {
    public static func == (lhs: OptionalDateValue<Formatter>, rhs: OptionalDateValue<Formatter>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension OptionalDateValue: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
