import SwiftUI

// MARK: - Navigation Routes

/// Defines all possible routes in the app
enum AppRoute: Hashable {
    case onboarding(OnboardingStep)
    case paywall
    case home
}

// MARK: - App Router

/// Main navigation coordinator for the app
/// Equivalent to the RootNavigator.tsx from Expo
struct AppRouter: View {
    @EnvironmentObject var storeEnvironment: StoreEnvironment
    
    var body: some View {
        NavigationStack {
            Group {
                if storeEnvironment.isFullyHydrated {
                    MainContentView()
                        .environmentObject(storeEnvironment.onboardingStore)
                        .environmentObject(storeEnvironment.sessionStore)
                } else {
                    HydrationLoadingView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Main Content View

/// Determines which main content to show based on app state
struct MainContentView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var sessionStore: SessionStore
    @State private var showingDevTools = false
    
    var body: some View {
        Group {
            if shouldShowOnboarding {
                OnboardingContainerView()
            } else {
                PaywallView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Dev Tools") {
                    showingDevTools = true
                }
                .foregroundColor(Theme.textSecondary)
            }
        }
        .sheet(isPresented: $showingDevTools) {
            DevToolsView()
                .environmentObject(onboardingStore)
                .environmentObject(sessionStore)
        }
    }
    
    /// Determines if onboarding should be shown
    private var shouldShowOnboarding: Bool {
        // Show onboarding if we haven't completed all steps
        return onboardingStore.stepIndex < OnboardingFlow.steps.count
    }
}

// MARK: - Onboarding Container

/// Container for onboarding flow with progress tracking
struct OnboardingContainerView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator at top
                ProgressBar(progress: onboardingProgress)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Current onboarding step content
                OnboardingStepView()
                    .environmentObject(onboardingStore)
            }
        }
    }
    
    /// Calculate progress based on current step and total steps
    private var onboardingProgress: Double {
        let currentIndex = onboardingStore.stepIndex
        let totalSteps = OnboardingFlow.steps.count
        return Double(currentIndex + 1) / Double(totalSteps)
    }
}

// MARK: - Onboarding Step View

/// Renders the current onboarding step based on stepIndex
struct OnboardingStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        Group {
            if let currentStep = OnboardingFlow.steps[safe: onboardingStore.stepIndex] {
                currentStep.view
            } else {
                // Fallback if step index is out of bounds
                OnboardingCompleteView()
            }
        }
    }
}

// MARK: - Paywall View

/// Placeholder for paywall screen
struct PaywallView: View {
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: Theme.spacingLG) {
                Spacer()
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(Theme.accent)
                
                Text("Unlock Premium")
                    .font(.deeperTitle)
                    .foregroundColor(Theme.textPrimary)
                
                Text("Access all features with premium")
                    .font(.deeperSubtitle)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                PrimaryButton(title: "Get Premium") {
                    // Handle premium purchase
                }
                .padding(.horizontal, Theme.spacingLG)
                .padding(.bottom, Theme.spacingXXXL)
            }
        }
    }
}

// MARK: - Onboarding Complete View

/// Shown when onboarding is complete but we're still in onboarding flow
struct OnboardingCompleteView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: Theme.spacingLG) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(Theme.success)
                
                Text("Onboarding Complete!")
                    .font(.deeperTitle)
                    .foregroundColor(Theme.textPrimary)
                
                Text("You're all set to begin your journey")
                    .font(.deeperSubtitle)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                PrimaryButton(title: "Continue to App") {
                    // Move to next phase (paywall or home)
                    onboardingStore.setStepIndex(OnboardingFlow.steps.count)
                }
                .padding(.horizontal, Theme.spacingLG)
                .padding(.bottom, Theme.spacingXXXL)
            }
        }
    }
}

// MARK: - Dev Tools Sheet

/// Development tools for debugging and testing
struct DevToolsSheet: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLG) {
                VStack(alignment: .leading, spacing: Theme.spacingMD) {
                    Text("Store State")
                        .font(.deeperSubtitle)
                        .foregroundColor(Theme.textPrimary)
                    
                    VStack(alignment: .leading, spacing: Theme.spacingSM) {
                        HStack {
                            Text("Onboarding Step:")
                            Spacer()
                            Text("\(onboardingStore.stepIndex)")
                                .foregroundColor(Theme.accent)
                        }
                        
                        HStack {
                            Text("Answers Count:")
                            Spacer()
                            Text("\(onboardingStore.answers.count)")
                                .foregroundColor(Theme.accent)
                        }
                        
                        HStack {
                            Text("Hydrated:")
                            Spacer()
                            Text(onboardingStore.hydrated ? "Yes" : "No")
                                .foregroundColor(onboardingStore.hydrated ? Theme.success : Theme.danger)
                        }
                        
                        HStack {
                            Text("Signed In:")
                            Spacer()
                            Text(sessionStore.isSignedIn ? "Yes" : "No")
                                .foregroundColor(sessionStore.isSignedIn ? Theme.success : Theme.danger)
                        }
                    }
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
                }
                .padding()
                .cardStyle()
                
                VStack(spacing: Theme.spacingMD) {
                    SecondaryButton(title: "Reset Onboarding") {
                        resetOnboarding()
                    }
                    
                    SecondaryButton(title: "Clear All Data") {
                        clearAllData()
                    }
                    
                    if sessionStore.isSignedIn {
                        SecondaryButton(title: "Sign Out") {
                            sessionStore.signOut()
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Theme.background)
            .navigationTitle("Dev Tools")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
    }
    
    private func resetOnboarding() {
        onboardingStore.reset()
        dismiss()
    }
    
    private func clearAllData() {
        onboardingStore.reset()
        sessionStore.signOut()
        
        // Clear persistent data
        Task {
            try? Persistence.clearAllData()
        }
        
        dismiss()
    }
}

// MARK: - Array Safe Subscript

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    AppRouter()
        .environmentObject(StoreEnvironment())
}
