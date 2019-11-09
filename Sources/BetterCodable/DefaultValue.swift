import Foundation

@propertyWrapper
public struct DefaultValue<T: Codable>: Codable {

    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        var value: T?
        let container = try decoder.singleValueContainer()
        value = try? container.decode(T.self)
        switch value {
        case .none:
            switch T.self {
            case is Bool.Type:
                wrappedValue = false as! T
            case is Float.Type:
                wrappedValue = Float(0.0) as! T
            case is Float64.Type:
                wrappedValue = Float64(0) as! T
            case is UInt.Type:
                wrappedValue = UInt(0) as! T
            case is UInt8.Type:
                wrappedValue = UInt8(0) as! T
            case is UInt16.Type:
                wrappedValue = UInt16(0) as! T
            case is UInt32.Type:
                wrappedValue = UInt32(0) as! T
            case is UInt64.Type:
                wrappedValue = UInt64(0) as! T
            case is Int.Type:
                wrappedValue = Int(0) as! T
            case is Int8.Type:
                wrappedValue = Int8(0) as! T
            case is Int16.Type:
                wrappedValue = Int16(0) as! T
            case is Int32.Type:
                wrappedValue = Int32(0) as! T
            case is Int64.Type:
                wrappedValue = Int64(0) as! T
            case is Double.Type:
                wrappedValue = Double(0) as! T
            case is Date.Type:
                wrappedValue = Date() as! T
            case is String.Type:
                wrappedValue = "" as! T
            default:
                fatalError("Haven't handled this type please add it")
            }
        case .some(let unwrappedValue):
            wrappedValue = unwrappedValue
        }
    }
}
