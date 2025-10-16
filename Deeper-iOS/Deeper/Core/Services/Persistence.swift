import Foundation

/// Handles JSON persistence to Application Support directory
/// Equivalent to the storage.ts helpers from the Expo version
class Persistence {
    
    // MARK: - Directory Management
    
    private static let appSupportDirectory: URL = {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let appSupportURL = urls.first!
        let deeperURL = appSupportURL.appendingPathComponent("Deeper")
        
        // Create directory if it doesn't exist
        try? FileManager.default.createDirectory(at: deeperURL, withIntermediateDirectories: true)
        
        return deeperURL
    }()
    
    // MARK: - Generic Save/Load Methods
    
    /// Save any Codable object to JSON file
    static func save<T: Codable>(_ object: T, to filename: String) throws {
        let url = appSupportDirectory.appendingPathComponent("\(filename).json")
        let data = try JSONEncoder().encode(object)
        try data.write(to: url)
    }
    
    /// Load any Codable object from JSON file
    static func load<T: Codable>(_ type: T.Type, from filename: String) throws -> T? {
        let url = appSupportDirectory.appendingPathComponent("\(filename).json")
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
    
    /// Remove a JSON file
    static func remove(filename: String) throws {
        let url = appSupportDirectory.appendingPathComponent("\(filename).json")
        try FileManager.default.removeItem(at: url)
    }
    
    /// Check if a file exists
    static func exists(filename: String) -> Bool {
        let url = appSupportDirectory.appendingPathComponent("\(filename).json")
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    // MARK: - Store-Specific Methods
    
    /// Save onboarding store data
    static func saveOnboardingStore(_ store: OnboardingStoreData) throws {
        try save(store, to: "onboarding-storage")
    }
    
    /// Load onboarding store data
    static func loadOnboardingStore() throws -> OnboardingStoreData? {
        return try load(OnboardingStoreData.self, from: "onboarding-storage")
    }
    
    /// Save session store data
    static func saveSessionStore(_ store: SessionStoreData) throws {
        try save(store, to: "session-storage")
    }
    
    /// Load session store data
    static func loadSessionStore() throws -> SessionStoreData? {
        return try load(SessionStoreData.self, from: "session-storage")
    }
    
    /// Clear all stored data (useful for testing or reset)
    static func clearAllData() throws {
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(at: appSupportDirectory, includingPropertiesForKeys: nil)
        
        for url in contents {
            if url.pathExtension == "json" {
                try fileManager.removeItem(at: url)
            }
        }
    }
    
    /// Get file size for debugging
    static func getFileSize(filename: String) -> Int64? {
        let url = appSupportDirectory.appendingPathComponent("\(filename).json")
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64
        } catch {
            return nil
        }
    }
}

// MARK: - Store Data Structures

/// Persistent data structure for onboarding store
struct OnboardingStoreData: Codable {
    let version: Int
    let stepIndex: Int
    let answers: [String: CodableValue]
    
    init(version: Int = 2, stepIndex: Int = 0, answers: [String: CodableValue] = [:]) {
        self.version = version
        self.stepIndex = stepIndex
        self.answers = answers
    }
}

/// Persistent data structure for session store
struct SessionStoreData: Codable {
    let user: UserProfile?
    let accessToken: String?
    let refreshToken: String?
    
    init(user: UserProfile? = nil, accessToken: String? = nil, refreshToken: String? = nil) {
        self.user = user
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

/// User profile structure matching the TypeScript version
struct UserProfile: Codable, Equatable {
    let id: String
    let email: String
    let name: String?
    let avatarUrl: String?
    
    init(id: String, email: String, name: String? = nil, avatarUrl: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.avatarUrl = avatarUrl
    }
}

// MARK: - Migration Support

/// Migration utilities for handling version upgrades
struct StoreMigration {
    
    /// Migrate onboarding store data from older versions
    static func migrateOnboardingStore(_ data: OnboardingStoreData, fromVersion: Int) -> OnboardingStoreData {
        var migratedData = data
        
        // Version 2 migration: ensure answers is properly structured
        if fromVersion < 2 {
            // Handle any migration logic for version 2
            // For now, just ensure answers is a valid dictionary
            if migratedData.answers.isEmpty {
                migratedData = OnboardingStoreData(
                    version: 2,
                    stepIndex: migratedData.stepIndex,
                    answers: [:]
                )
            }
        }
        
        // Add future migrations here as needed
        // if fromVersion < 3 { ... }
        
        return migratedData
    }
    
    /// Check if migration is needed
    static func needsMigration(currentVersion: Int, storedVersion: Int) -> Bool {
        return storedVersion < currentVersion
    }
}
