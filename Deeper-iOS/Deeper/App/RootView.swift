import SwiftUI

struct RootView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        AppRouter()
            .environmentObject(onboardingStore)
            .environmentObject(sessionStore)
    }
}

#Preview {
    RootView()
        .environmentObject(OnboardingStore())
        .environmentObject(SessionStore())
}
