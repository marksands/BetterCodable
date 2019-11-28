public protocol Initable: Codable {
    init()
}

public enum DefaultInitableStrategy<T: Initable>: DefaultCodableStrategy {
    public static var defaultValue: T { T() }
}

/// Decodes values with `T()` value of `Initable` protocol conformed type instead of nil if applicable
///
/// `@DefaultInit` decodes values and returns an `T()` value instead of nil if the Decoder is unable to decode the container.
public typealias DefaultInit<T> = DefaultCodable<DefaultInitableStrategy<T>> where T: Initable
