public struct DefaultEmptyArrayStrategy<T: Codable>: DefaultCodableStrategy {
    public static var defaultValue: [T] { return [] }
}

/// Decodes Arrays returning an empty array instead of nil if appicable
///
/// `@DefaultEmptyArray` decodes Arrays and returns an empty array instead of nil if the Decoder is unable to decode the container.
public typealias DefaultEmptyArray<T> = DefaultCodable<DefaultEmptyArrayStrategy<T>> where T: Codable
