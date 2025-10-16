import SwiftUI

/// Personal message view with personalized greeting that fades in then advances
struct PersonalMsgView: View {
    let onContinue: () -> Void
    
    @State private var showContent: Bool = false
    @State private var showGreeting: Bool = false
    @State private var showMessage: Bool = false
    @State private var showCompletion: Bool = false
    
    private var userName: String {
        // In a real app, this would come from the onboarding store or user profile
        return "VoiceMaxxer" // Default fallback
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 1.0)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                VStack(spacing: Theme.spacingXL) {
                    // Art block
                    if showContent {
                        artBlockView
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Greeting section
                    if showGreeting {
                        greetingSection
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    
                    // Personal message
                    if showMessage {
                        messageSection
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    
                    // Completion indicator
                    if showCompletion {
                        completionSection
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.horizontal, Theme.spacingLG)
                .padding(.bottom, Theme.spacingXXXL)
            }
        }
        .onAppear {
            startGreetingSequence()
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Personal greeting with motivational message")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var greetingSection: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Hey, \(userName)!")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Welcome to your VoiceMaxxing journey")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.accent)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var messageSection: some View {
        VStack(spacing: Theme.spacingLG) {
            Text("Your transformation begins now")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: Theme.spacingMD) {
                messageCard(
                    icon: "star.fill",
                    title: "You've got this",
                    message: "Every expert was once a beginner. Your commitment to growth is already showing."
                )
                
                messageCard(
                    icon: "heart.fill",
                    title: "We believe in you",
                    message: "Your voice has untapped potential. Together, we'll unlock it step by step."
                )
                
                messageCard(
                    icon: "flame.fill",
                    title: "Ready to transform",
                    message: "The journey ahead will challenge and reward you. Embrace the process."
                )
            }
        }
    }
    
    @ViewBuilder
    private func messageCard(icon: String, title: String, message: String) -> some View {
        HStack(spacing: Theme.spacingMD) {
            // Icon
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.1))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Theme.accent)
            }
            
            // Content
            VStack(alignment: .leading, spacing: Theme.spacingXS) {
                Text(title)
                    .font(.deeperBody)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                
                Text(message)
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.textSecondary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var completionSection: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Let's begin your journey")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.accent)
            
            Text("Your personalized VoiceMaxxing plan is ready. Time to unlock your potential.")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            
            // Continue button
            PrimaryButton(title: "Start My Journey") {
                onContinue()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.accent.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Helper Methods
    
    private func startGreetingSequence() {
        // Show art block first
        withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
            showContent = true
        }
        
        // Show greeting after art block
        withAnimation(.easeInOut(duration: 0.6).delay(1.2)) {
            showGreeting = true
        }
        
        // Show personal message after greeting
        withAnimation(.easeInOut(duration: 0.6).delay(2.0)) {
            showMessage = true
        }
        
        // Show completion section after message
        withAnimation(.easeInOut(duration: 0.6).delay(4.0)) {
            showCompletion = true
        }
    }
}

// MARK: - Personal Message Step View

/// Step view for personal message screens
struct PersonalMsgStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        PersonalMsgView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    PersonalMsgView {
        print("Continue tapped")
    }
}
