import Foundation
import SwiftUI

@MainActor
class OnboardingStore: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var answers: OnboardingAnswers = OnboardingAnswers()
    @Published var hasHydrated: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let storageKey = "onboarding-storage"
    private let versionKey = "onboarding-version"
    private let currentVersion = 2
    
    init() {
        loadFromStorage()
    }
    
    // MARK: - Public Methods
    
    func nextStep() {
        if let next = currentStep.next {
            currentStep = next
            saveToStorage()
        }
    }
    
    func previousStep() {
        let allCases = OnboardingStep.allCases
        if let currentIndex = allCases.firstIndex(of: currentStep),
           currentIndex > 0 {
            currentStep = allCases[currentIndex - 1]
            saveToStorage()
        }
    }
    
    func setStep(_ step: OnboardingStep) {
        currentStep = step
        saveToStorage()
    }
    
    func saveAnswer<T: Codable>(_ keyPath: WritableKeyPath<OnboardingAnswers, T?>, value: T) {
        answers[keyPath: keyPath] = value
        saveToStorage()
    }
    
    func reset() {
        currentStep = .welcome
        answers = OnboardingAnswers()
        saveToStorage()
    }
    
    var progress: Double {
        return currentStep.progress
    }
    
    // MARK: - Private Methods
    
    private func loadFromStorage() {
        guard let data = userDefaults.data(forKey: storageKey),
              let storedData = try? JSONDecoder().decode(StoredOnboardingData.self, from: data) else {
            hasHydrated = true
            return
        }
        
        // Handle version migrations if needed
        let storedVersion = userDefaults.integer(forKey: versionKey)
        if storedVersion < currentVersion {
            migrateFromVersion(storedVersion, to: currentVersion, data: storedData)
        }
        
        currentStep = storedData.currentStep
        answers = storedData.answers
        hasHydrated = true
    }
    
    private func saveToStorage() {
        let storedData = StoredOnboardingData(
            currentStep: currentStep,
            answers: answers,
            version: currentVersion
        )
        
        if let data = try? JSONEncoder().encode(storedData) {
            userDefaults.set(data, forKey: storageKey)
            userDefaults.set(currentVersion, forKey: versionKey)
        }
    }
    
    private func migrateFromVersion(_ fromVersion: Int, to toVersion: Int, data: StoredOnboardingData) {
        // Add migration logic here as needed
        // For now, just update the version
        userDefaults.set(toVersion, forKey: versionKey)
    }
}

// MARK: - Storage Model
private struct StoredOnboardingData: Codable {
    let currentStep: OnboardingStep
    let answers: OnboardingAnswers
    let version: Int
}
