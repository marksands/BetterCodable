public protocol BoolCodableStrategy: DefaultCodableStrategy where RawValue == Bool {}

public struct DefaultFalseStrategy: BoolCodableStrategy {
    public static var defaultValue: Bool { return false }
}

/// Decodes Bools defaulting to `false` if applicable
///
/// `@DefaultFalse` decodes Bools and defaults the value to false if the Decoder is unable to decode the value.
public typealias DefaultFalse = DefaultCodable<DefaultFalseStrategy>
