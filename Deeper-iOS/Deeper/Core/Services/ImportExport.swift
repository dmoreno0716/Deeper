import Foundation

/// Service for importing and exporting onboarding answers and store state
final class ImportExportService {
    
    // MARK: - Export Functions
    
    /// Export onboarding answers to JSON string
    static func exportAnswersToJSON(_ answers: [String: CodableValue]) -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            // Convert CodableValue to JSON-serializable format
            let jsonData = try encoder.encode(answers.mapValues { $0.toJSONValue() })
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("❌ Failed to export answers to JSON: \(error)")
            return nil
        }
    }
    
    /// Export complete store state to JSON string
    static func exportStoreState(
        stepIndex: Int,
        answers: [String: CodableValue],
        user: UserProfile? = nil,
        accessToken: String? = nil
    ) -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            
            let storeState = StoreExportData(
                stepIndex: stepIndex,
                answers: answers.mapValues { $0.toJSONValue() },
                user: user,
                accessToken: accessToken,
                exportedAt: Date(),
                version: "1.0"
            )
            
            let jsonData = try encoder.encode(storeState)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("❌ Failed to export store state to JSON: \(error)")
            return nil
        }
    }
    
    /// Save exported data to Documents directory
    static func saveToDocuments(_ jsonString: String, filename: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ Could not access Documents directory")
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("✅ Exported data saved to: \(fileURL.path)")
            return fileURL
        } catch {
            print("❌ Failed to save exported data: \(error)")
            return nil
        }
    }
    
    // MARK: - Import Functions
    
    /// Import answers from JSON string
    static func importAnswersFromJSON(_ jsonString: String) -> [String: CodableValue]? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("❌ Invalid JSON string")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let jsonDict = try decoder.decode([String: AnyCodable].self, from: jsonData)
            
            // Convert AnyCodable back to CodableValue
            var answers: [String: CodableValue] = [:]
            for (key, value) in jsonDict {
                answers[key] = CodableValue.fromAnyCodable(value)
            }
            
            print("✅ Successfully imported \(answers.count) answers")
            return answers
        } catch {
            print("❌ Failed to import answers from JSON: \(error)")
            return nil
        }
    }
    
    /// Import store state from JSON string
    static func importStoreStateFromJSON(_ jsonString: String) -> StoreImportData? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("❌ Invalid JSON string")
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let storeData = try decoder.decode(StoreExportData.self, from: jsonData)
            
            // Convert to import format
            var answers: [String: CodableValue] = [:]
            for (key, value) in storeData.answers {
                answers[key] = CodableValue.fromAnyCodable(value)
            }
            
            let importData = StoreImportData(
                stepIndex: storeData.stepIndex,
                answers: answers,
                user: storeData.user,
                accessToken: storeData.accessToken
            )
            
            print("✅ Successfully imported store state")
            return importData
        } catch {
            print("❌ Failed to import store state from JSON: \(error)")
            return nil
        }
    }
    
    /// Load data from Documents directory
    static func loadFromDocuments(filename: String) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("❌ Could not access Documents directory")
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            let jsonString = try String(contentsOf: fileURL, encoding: .utf8)
            print("✅ Loaded data from: \(fileURL.path)")
            return jsonString
        } catch {
            print("❌ Failed to load data from Documents: \(error)")
            return nil
        }
    }
    
    // MARK: - File Management
    
    /// List all exported files in Documents directory
    static func listExportedFiles() -> [URL] {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(
                at: documentsDirectory,
                includingPropertiesForKeys: [.creationDateKey],
                options: [.skipsHiddenFiles]
            )
            
            return files.filter { $0.pathExtension == "json" }
                .sorted { url1, url2 in
                    let date1 = try? url1.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                    let date2 = try? url2.resourceValues(forKeys: [.creationDateKey]).creationDate ?? Date.distantPast
                    return date1 ?? Date.distantPast > date2 ?? Date.distantPast
                }
        } catch {
            print("❌ Failed to list exported files: \(error)")
            return []
        }
    }
    
    /// Delete exported file
    static func deleteExportedFile(_ url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            print("✅ Deleted file: \(url.lastPathComponent)")
            return true
        } catch {
            print("❌ Failed to delete file: \(error)")
            return false
        }
    }
}

// MARK: - Data Structures

/// Export data structure for store state
struct StoreExportData: Codable {
    let stepIndex: Int
    let answers: [String: AnyCodable]
    let user: UserProfile?
    let accessToken: String?
    let exportedAt: Date
    let version: String
}

/// Import data structure for store state
struct StoreImportData {
    let stepIndex: Int
    let answers: [String: CodableValue]
    let user: UserProfile?
    let accessToken: String?
}

// MARK: - CodableValue Extensions

extension CodableValue {
    /// Convert CodableValue to AnyCodable for JSON serialization
    func toJSONValue() -> AnyCodable {
        switch self {
        case .string(let value):
            return AnyCodable(value)
        case .int(let value):
            return AnyCodable(value)
        case .double(let value):
            return AnyCodable(value)
        case .bool(let value):
            return AnyCodable(value)
        case .array(let values):
            return AnyCodable(values.map { $0.toJSONValue() })
        case .dictionary(let dict):
            return AnyCodable(dict.mapValues { $0.toJSONValue() })
        }
    }
    
    /// Create CodableValue from AnyCodable
    static func fromAnyCodable(_ anyCodable: AnyCodable) -> CodableValue {
        switch anyCodable.value {
        case let string as String:
            return .string(string)
        case let int as Int:
            return .int(int)
        case let double as Double:
            return .double(double)
        case let bool as Bool:
            return .bool(bool)
        case let array as [AnyCodable]:
            return .array(array.map { fromAnyCodable($0) })
        case let dict as [String: AnyCodable]:
            return .dictionary(dict.mapValues { fromAnyCodable($0) })
        default:
            return .string("\(anyCodable.value)")
        }
    }
}

// MARK: - AnyCodable Helper

/// Helper for encoding/decoding Any type to JSON
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            value = string
        } else if let int = try? container.decode(Int.self) {
            value = int
        } else if let double = try? container.decode(Double.self) {
            value = double
        } else if let bool = try? container.decode(Bool.self) {
            value = bool
        } else if let array = try? container.decode([AnyCodable].self) {
            value = array
        } else if let dict = try? container.decode([String: AnyCodable].self) {
            value = dict
        } else {
            throw DecodingError.typeMismatch(AnyCodable.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch value {
        case let string as String:
            try container.encode(string)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let bool as Bool:
            try container.encode(bool)
        case let array as [AnyCodable]:
            try container.encode(array)
        case let dict as [String: AnyCodable]:
            try container.encode(dict)
        default:
            try container.encode("\(value)")
        }
    }
}
