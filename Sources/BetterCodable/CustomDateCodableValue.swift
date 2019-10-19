import Foundation

protocol DateFormattingCodableStrategy {
    associatedtype RawValue: Codable

    static func decode(_ value: RawValue) throws -> Date
    static func encode(_ date: Date) -> RawValue
}

struct DateCodableValue<Formatter: DateFormattingCodableStrategy>: Codable {
    let value: Formatter.RawValue
    let date: Date

    init(date: Date) {
        self.date = date
        self.value = Formatter.encode(date)
    }
    
    init(from decoder: Decoder) throws {
        self.value = try Formatter.RawValue(from: decoder)
        self.date = try Formatter.decode(value)
    }
    
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
