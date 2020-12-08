public struct DefaultNilStrategy<T: Codable>: DefaultCodableStrategy {
    public static var defaultValue: T? { nil }
}

/// Decodes optional types, defaulting to `nil` instead of throwing an error, if applicable.
///
/// `@DefaultNil` decodes optionals, and defaults to `nil` in cases where the decoder fails (e.g. decoding a non-url string to the `URL` type)
public typealias DefaultNil<T> = DefaultCodable<DefaultNilStrategy<T>> where T: Codable

