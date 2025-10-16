import Foundation

/// A type-erased container for storing various primitive types and arrays in a Codable format
/// This allows us to store mixed types in a dictionary similar to TypeScript's Record<string, unknown>
enum CodableValue: Codable, Equatable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case stringArray([String])
    case intArray([Int])
    case doubleArray([Double])
    case boolArray([Bool])
    case null
    
    // MARK: - Initializers
    
    init(_ value: String?) {
        self = value.map { .string($0) } ?? .null
    }
    
    init(_ value: Int?) {
        self = value.map { .int($0) } ?? .null
    }
    
    init(_ value: Double?) {
        self = value.map { .double($0) } ?? .null
    }
    
    init(_ value: Bool?) {
        self = value.map { .bool($0) } ?? .null
    }
    
    init(_ value: [String]?) {
        self = value.map { .stringArray($0) } ?? .null
    }
    
    init(_ value: [Int]?) {
        self = value.map { .intArray($0) } ?? .null
    }
    
    init(_ value: [Double]?) {
        self = value.map { .doubleArray($0) } ?? .null
    }
    
    init(_ value: [Bool]?) {
        self = value.map { .boolArray($0) } ?? .null
    }
    
    // MARK: - Codable Implementation
    
    private enum CodingKeys: String, CodingKey {
        case type, value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case "string":
            let value = try container.decode(String.self, forKey: .value)
            self = .string(value)
        case "int":
            let value = try container.decode(Int.self, forKey: .value)
            self = .int(value)
        case "double":
            let value = try container.decode(Double.self, forKey: .value)
            self = .double(value)
        case "bool":
            let value = try container.decode(Bool.self, forKey: .value)
            self = .bool(value)
        case "stringArray":
            let value = try container.decode([String].self, forKey: .value)
            self = .stringArray(value)
        case "intArray":
            let value = try container.decode([Int].self, forKey: .value)
            self = .intArray(value)
        case "doubleArray":
            let value = try container.decode([Double].self, forKey: .value)
            self = .doubleArray(value)
        case "boolArray":
            let value = try container.decode([Bool].self, forKey: .value)
            self = .boolArray(value)
        case "null":
            self = .null
        default:
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Unknown CodableValue type: \(type)"
                )
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .string(let value):
            try container.encode("string", forKey: .type)
            try container.encode(value, forKey: .value)
        case .int(let value):
            try container.encode("int", forKey: .type)
            try container.encode(value, forKey: .value)
        case .double(let value):
            try container.encode("double", forKey: .type)
            try container.encode(value, forKey: .value)
        case .bool(let value):
            try container.encode("bool", forKey: .type)
            try container.encode(value, forKey: .value)
        case .stringArray(let value):
            try container.encode("stringArray", forKey: .type)
            try container.encode(value, forKey: .value)
        case .intArray(let value):
            try container.encode("intArray", forKey: .type)
            try container.encode(value, forKey: .value)
        case .doubleArray(let value):
            try container.encode("doubleArray", forKey: .type)
            try container.encode(value, forKey: .value)
        case .boolArray(let value):
            try container.encode("boolArray", forKey: .type)
            try container.encode(value, forKey: .value)
        case .null:
            try container.encode("null", forKey: .type)
        }
    }
    
    // MARK: - Value Extraction
    
    var stringValue: String? {
        if case .string(let value) = self { return value }
        return nil
    }
    
    var intValue: Int? {
        if case .int(let value) = self { return value }
        return nil
    }
    
    var doubleValue: Double? {
        if case .double(let value) = self { return value }
        return nil
    }
    
    var boolValue: Bool? {
        if case .bool(let value) = self { return value }
        return nil
    }
    
    var stringArrayValue: [String]? {
        if case .stringArray(let value) = self { return value }
        return nil
    }
    
    var intArrayValue: [Int]? {
        if case .intArray(let value) = self { return value }
        return nil
    }
    
    var doubleArrayValue: [Double]? {
        if case .doubleArray(let value) = self { return value }
        return nil
    }
    
    var boolArrayValue: [Bool]? {
        if case .boolArray(let value) = self { return value }
        return nil
    }
    
    var isNull: Bool {
        if case .null = self { return true }
        return false
    }
}

// MARK: - ExpressibleByStringLiteral
extension CodableValue: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = .string(value)
    }
}

// MARK: - ExpressibleByIntegerLiteral
extension CodableValue: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self = .int(value)
    }
}

// MARK: - ExpressibleByBooleanLiteral
extension CodableValue: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

// MARK: - ExpressibleByFloatLiteral
extension CodableValue: ExpressibleByFloatLiteral {
    init(floatLiteral value: Double) {
        self = .double(value)
    }
}
