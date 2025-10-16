import Foundation

/// Backend configuration loaded from Info.plist or .xcconfig
struct BackendConfig {
    let supabaseURL: String
    let supabaseAnonKey: String
    
    init() {
        // Load from Info.plist or .xcconfig
        self.supabaseURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? ""
        self.supabaseAnonKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String ?? ""
    }
    
    /// Check if backend is properly configured
    var isConfigured: Bool {
        return !supabaseURL.isEmpty && !supabaseAnonKey.isEmpty
    }
}

/// Backend client protocol for API operations
protocol BackendClient {
    /// Sync onboarding answers to backend
    func syncOnboarding(userId: String, answers: [String: CodableValue]) async throws -> SyncResult
}

/// Result of sync operation
struct SyncResult {
    let success: Bool
    let skipped: Bool
    let data: [String: CodableValue]?
    let error: String?
    
    init(success: Bool, skipped: Bool = false, data: [String: CodableValue]? = nil, error: String? = nil) {
        self.success = success
        self.skipped = skipped
        self.data = data
        self.error = error
    }
}

/// No-op client implementation that returns immediately
final class NoopClientImpl: BackendClient {
    func syncOnboarding(userId: String, answers: [String: CodableValue]) async throws -> SyncResult {
        print("📱 NoopClient: syncOnboarding called for user \(userId) with \(answers.count) answers")
        return SyncResult(success: true, skipped: true, data: answers)
    }
}

/// Supabase client implementation (placeholder with TODOs)
final class SupabaseClientImpl: BackendClient {
    private let config: BackendConfig
    
    init(config: BackendConfig) {
        self.config = config
    }
    
    func syncOnboarding(userId: String, answers: [String: CodableValue]) async throws -> SyncResult {
        print("🌐 SupabaseClient: syncOnboarding called for user \(userId)")
        
        // TODO: Implement Supabase client
        // 1. Initialize Supabase client with config.supabaseURL and config.supabaseAnonKey
        // 2. Authenticate with access token from SessionStore
        // 3. Insert/update onboarding answers in database
        // 4. Handle errors and return appropriate SyncResult
        
        // Mock implementation for now
        let mockData = [
            "userId": CodableValue.string(userId),
            "answers": CodableValue.dictionary(answers),
            "syncedAt": CodableValue.string(ISO8601DateFormatter().string(from: Date()))
        ]
        
        return SyncResult(success: true, skipped: false, data: mockData)
    }
    
    // TODO: Add additional Supabase methods
    // - func authenticate(email: String, password: String) async throws -> AuthResult
    // - func signUp(email: String, password: String, name: String) async throws -> AuthResult
    // - func refreshToken() async throws -> AuthResult
    // - func signOut() async throws
    // - func getUserProfile() async throws -> UserProfile
    // - func updateUserProfile(_ profile: UserProfile) async throws
}

/// Backend service manager
@MainActor
final class BackendService: ObservableObject {
    @Published var isConfigured: Bool = false
    @Published var isConnected: Bool = false
    
    private let config: BackendConfig
    private let client: BackendClient
    
    init() {
        self.config = BackendConfig()
        self.isConfigured = config.isConfigured
        
        // Choose client implementation based on configuration
        if config.isConfigured {
            self.client = SupabaseClientImpl(config: config)
            print("🌐 BackendService: Using SupabaseClient")
        } else {
            self.client = NoopClientImpl()
            print("📱 BackendService: Using NoopClient (no backend configured)")
        }
    }
    
    /// Sync onboarding answers for a user
    func syncOnboarding(userId: String, answers: [String: CodableValue]) async {
        do {
            let result = try await client.syncOnboarding(userId: userId, answers: answers)
            
            if result.success {
                if result.skipped {
                    print("✅ Onboarding sync skipped (no backend)")
                } else {
                    print("✅ Onboarding sync successful")
                }
            } else {
                print("❌ Onboarding sync failed: \(result.error ?? "Unknown error")")
            }
            
        } catch {
            print("❌ Onboarding sync error: \(error.localizedDescription)")
        }
    }
    
    /// Check backend connectivity
    func checkConnectivity() async {
        // TODO: Implement actual connectivity check
        // For now, just simulate based on configuration
        isConnected = config.isConfigured
        
        if isConnected {
            print("🌐 Backend connectivity: Connected")
        } else {
            print("📱 Backend connectivity: Not configured")
        }
    }
}

// MARK: - CodableValue Extensions for Backend

extension CodableValue {
    /// Convert CodableValue to dictionary for backend sync
    var backendDictionary: [String: Any] {
        switch self {
        case .string(let value):
            return ["type": "string", "value": value]
        case .int(let value):
            return ["type": "int", "value": value]
        case .double(let value):
            return ["type": "double", "value": value]
        case .bool(let value):
            return ["type": "bool", "value": value]
        case .array(let values):
            return ["type": "array", "value": values.map { $0.backendDictionary }]
        case .dictionary(let dict):
            return ["type": "dictionary", "value": dict.mapValues { $0.backendDictionary }]
        }
    }
    
    /// Create CodableValue from backend dictionary
    static func fromBackendDictionary(_ dict: [String: Any]) -> CodableValue? {
        guard let type = dict["type"] as? String,
              let value = dict["value"] else {
            return nil
        }
        
        switch type {
        case "string":
            return .string(value as? String ?? "")
        case "int":
            return .int(value as? Int ?? 0)
        case "double":
            return .double(value as? Double ?? 0.0)
        case "bool":
            return .bool(value as? Bool ?? false)
        case "array":
            guard let array = value as? [[String: Any]] else { return nil }
            let values = array.compactMap { CodableValue.fromBackendDictionary($0) }
            return .array(values)
        case "dictionary":
            guard let dict = value as? [String: [String: Any]] else { return nil }
            let convertedDict = dict.compactMapValues { CodableValue.fromBackendDictionary($0) }
            return .dictionary(convertedDict)
        default:
            return nil
        }
    }
}
