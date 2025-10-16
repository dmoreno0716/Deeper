import Foundation
import Combine

// MARK: - OnboardingStore

/// ObservableObject equivalent of the Zustand onboarding store
/// Handles onboarding state, answers persistence, and step navigation
@MainActor
final class OnboardingStore: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var stepIndex: Int = 0
    @Published var answers: [String: CodableValue] = [:]
    @Published var hydrated: Bool = false
    
    // MARK: - Private Properties
    
    private var saveTimer: Timer?
    private let saveDelay: TimeInterval = 0.5 // Debounce delay
    private let currentVersion: Int = 2
    
    // MARK: - Initialization
    
    init() {
        loadFromStorage()
    }
    
    /// Development initializer with default step index
    convenience init(developmentStepIndex: Int) {
        self.init()
        
        // Only set development step if no existing data
        if stepIndex == 0 && answers.isEmpty {
            setStepIndex(developmentStepIndex)
            print("🚀 Development mode: Starting at step \(developmentStepIndex)")
        }
    }
    
    deinit {
        saveTimer?.invalidate()
    }
    
    // MARK: - Public Methods
    
    /// Save an answer for a specific question
    func saveAnswer(id: String, value: CodableValue) {
        answers[id] = value
        debouncedSave()
    }
    
    /// Save an answer with type inference
    func saveAnswer(id: String, value: String?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    func saveAnswer(id: String, value: Int?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    func saveAnswer(id: String, value: Double?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    func saveAnswer(id: String, value: Bool?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    func saveAnswer(id: String, value: [String]?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    func saveAnswer(id: String, value: [Int]?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    func saveAnswer(id: String, value: [Double]?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    func saveAnswer(id: String, value: [Bool]?) {
        saveAnswer(id: id, value: CodableValue(value))
    }
    
    /// Move to next step
    func next() {
        stepIndex += 1
        debouncedSave()
    }
    
    /// Move to previous step
    func previous() {
        stepIndex = max(0, stepIndex - 1)
        debouncedSave()
    }
    
    /// Jump to specific step
    func setStepIndex(_ index: Int) {
        stepIndex = max(0, index)
        debouncedSave()
    }
    
    /// Development helper to set step index (alias for setStepIndex)
    func setIndex(_ index: Int) {
        setStepIndex(index)
    }
    
    /// Reset onboarding state
    func reset() {
        stepIndex = 0
        answers = [:]
        saveToStorage()
    }
    
    /// Get answer for a specific question
    func getAnswer<T>(id: String, as type: T.Type) -> T? {
        guard let value = answers[id] else { return nil }
        
        switch type {
        case is String.Type:
            return value.stringValue as? T
        case is Int.Type:
            return value.intValue as? T
        case is Double.Type:
            return value.doubleValue as? T
        case is Bool.Type:
            return value.boolValue as? T
        case is [String].Type:
            return value.stringArrayValue as? T
        case is [Int].Type:
            return value.intArrayValue as? T
        case is [Double].Type:
            return value.doubleArrayValue as? T
        case is [Bool].Type:
            return value.boolArrayValue as? T
        default:
            return nil
        }
    }
    
    /// Sync onboarding answers to backend if user is signed in
    func maybeSyncOnboarding(userId: String) {
        // Check if we have answers to sync
        guard !answers.isEmpty else {
            print("📱 OnboardingStore: No answers to sync")
            return
        }
        
        // Check if user is signed in
        guard let sessionStore = getSessionStore(), sessionStore.isSignedIn else {
            print("📱 OnboardingStore: User not signed in, skipping sync")
            return
        }
        
        // Sync with backend
        Task {
            let backendService = BackendService()
            await backendService.syncOnboarding(userId: userId, answers: answers)
        }
    }
    
    /// Helper to get SessionStore reference
    private func getSessionStore() -> SessionStore? {
        // In a real app, this would be injected or accessed through a service locator
        // For now, we'll create a temporary instance to check if user is signed in
        // This is not ideal but works for the scaffold
        return SessionStore()
    }
    
    // MARK: - Private Methods
    
    /// Load data from persistent storage
    private func loadFromStorage() {
        Task {
            do {
                if let data = try Persistence.loadOnboardingStore() {
                    // Check if migration is needed
                    if StoreMigration.needsMigration(currentVersion: currentVersion, storedVersion: data.version) {
                        let migratedData = StoreMigration.migrateOnboardingStore(data, fromVersion: data.version)
                        await MainActor.run {
                            self.stepIndex = migratedData.stepIndex
                            self.answers = migratedData.answers
                            self.hydrated = true
                        }
                        // Save migrated data
                        try Persistence.saveOnboardingStore(migratedData)
                    } else {
                        await MainActor.run {
                            self.stepIndex = data.stepIndex
                            self.answers = data.answers
                            self.hydrated = true
                        }
                    }
                } else {
                    // No stored data, use defaults
                    await MainActor.run {
                        self.hydrated = true
                    }
                }
            } catch {
                print("Failed to load onboarding store: \(error)")
                // Use defaults on error
                await MainActor.run {
                    self.hydrated = true
                }
            }
        }
    }
    
    /// Save data to persistent storage with debouncing
    private func debouncedSave() {
        saveTimer?.invalidate()
        saveTimer = Timer.scheduledTimer(withTimeInterval: saveDelay, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.saveToStorage()
            }
        }
    }
    
    /// Save data to persistent storage
    private func saveToStorage() {
        Task {
            do {
                let data = OnboardingStoreData(
                    version: currentVersion,
                    stepIndex: stepIndex,
                    answers: answers
                )
                try Persistence.saveOnboardingStore(data)
            } catch {
                print("Failed to save onboarding store: \(error)")
            }
        }
    }
}

// MARK: - SessionStore

/// ObservableObject equivalent of the Zustand session store
/// Handles user authentication state and tokens
@MainActor
final class SessionStore: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var user: UserProfile?
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var hydrated: Bool = false
    
    // MARK: - Computed Properties
    
    var isSignedIn: Bool {
        return user != nil && accessToken != nil
    }
    
    // MARK: - Initialization
    
    init() {
        loadFromStorage()
    }
    
    // MARK: - Public Methods
    
    /// Sign in user with profile and tokens
    func signIn(user: UserProfile, accessToken: String, refreshToken: String? = nil) {
        self.user = user
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        saveToStorage()
    }
    
    /// Sign out user and clear all session data
    func signOut() {
        user = nil
        accessToken = nil
        refreshToken = nil
        saveToStorage()
    }
    
    /// Update access token (useful for token refresh)
    func updateAccessToken(_ token: String) {
        accessToken = token
        saveToStorage()
    }
    
    /// Update refresh token
    func updateRefreshToken(_ token: String) {
        refreshToken = token
        saveToStorage()
    }
    
    /// Update user profile
    func updateUser(_ user: UserProfile) {
        self.user = user
        saveToStorage()
    }
    
    // MARK: - Private Methods
    
    /// Load data from persistent storage
    private func loadFromStorage() {
        Task {
            do {
                if let data = try Persistence.loadSessionStore() {
                    await MainActor.run {
                        self.user = data.user
                        self.accessToken = data.accessToken
                        self.refreshToken = data.refreshToken
                        self.hydrated = true
                    }
                } else {
                    // No stored data, use defaults
                    await MainActor.run {
                        self.hydrated = true
                    }
                }
            } catch {
                print("Failed to load session store: \(error)")
                // Use defaults on error
                await MainActor.run {
                    self.hydrated = true
                }
            }
        }
    }
    
    /// Save data to persistent storage
    private func saveToStorage() {
        Task {
            do {
                let data = SessionStoreData(
                    user: user,
                    accessToken: accessToken,
                    refreshToken: refreshToken
                )
                try Persistence.saveSessionStore(data)
            } catch {
                print("Failed to save session store: \(error)")
            }
        }
    }
}

// MARK: - Store Environment

/// Environment object for providing stores to SwiftUI views
class StoreEnvironment: ObservableObject {
    let onboardingStore: OnboardingStore
    let sessionStore: SessionStore
    
    init(onboardingStore: OnboardingStore = OnboardingStore(), 
         sessionStore: SessionStore = SessionStore()) {
        self.onboardingStore = onboardingStore
        self.sessionStore = sessionStore
    }
    
    /// Check if all stores are hydrated
    var isFullyHydrated: Bool {
        return onboardingStore.hydrated && sessionStore.hydrated
    }
}
