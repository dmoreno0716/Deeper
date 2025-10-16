import SwiftUI

@main
struct DeeperApp: App {
    @StateObject private var storeEnvironment = StoreEnvironment()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(storeEnvironment.onboardingStore)
                .environmentObject(storeEnvironment.sessionStore)
                .onAppear {
                    setupDevelopmentStepIndex()
                }
        }
    }
    
    /// Setup development step index from environment variable
    private func setupDevelopmentStepIndex() {
        // Check for DEEPER_START_INDEX environment variable
        if let startIndexString = ProcessInfo.processInfo.environment["DEEPER_START_INDEX"],
           let startIndex = Int(startIndexString) {
            
            let maxStep = FlowManifest.flow.count - 1
            let clampedIndex = max(0, min(startIndex, maxStep))
            
            // Only set if no existing data
            if storeEnvironment.onboardingStore.stepIndex == 0 && storeEnvironment.onboardingStore.answers.isEmpty {
                storeEnvironment.onboardingStore.setIndex(clampedIndex)
                print("🚀 CI/Environment mode: Starting at step \(clampedIndex) (from DEEPER_START_INDEX=\(startIndexString))")
            }
        }
        
        // Development default: Start at Step 17 (Current Rating) for local development
        #if DEBUG
        if storeEnvironment.onboardingStore.stepIndex == 0 && storeEnvironment.onboardingStore.answers.isEmpty {
            storeEnvironment.onboardingStore.setIndex(16) // Step 17 = index 16
            print("🚀 Development mode: Starting at step 16 (Step 17 - Current Rating)")
        }
        #endif
    }
}
