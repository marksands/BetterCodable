public struct DefaultNumberZeroStrategy<T: Codable & Numeric>: DefaultCodableStrategy {
    public static var defaultValue: T { return T(exactly: 0)! }
}

/// Decodes Numbers returning zero instead of nil if appicable
///
/// `@DefaultNumberZero` decodes Numbers and returns zero instead of nil if the Decoder is unable to decode the
/// container.
public typealias DefaultNumberZero<T> = DefaultCodable<DefaultNumberZeroStrategy<T>> where T: Codable & Numeric
