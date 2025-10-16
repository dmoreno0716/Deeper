import SwiftUI

/// Vows view with four prompts and Yes/No responses
struct VowsView: View {
    let onContinue: () -> Void
    
    @State private var currentVowIndex: Int = 0
    @State private var vowResponses: [Bool] = Array(repeating: false, count: 4)
    @State private var showContent: Bool = false
    @State private var showGlow: Bool = false
    
    private let vows = [
        Vow(
            id: "commitment",
            title: "I commit to my VoiceMaxxing journey",
            description: "I will dedicate myself to improving my voice every day"
        ),
        Vow(
            id: "consistency", 
            title: "I will be consistent with my practice",
            description: "I will follow my daily routine without excuses"
        ),
        Vow(
            id: "patience",
            title: "I will be patient with my progress",
            description: "I understand that voice transformation takes time"
        ),
        Vow(
            id: "belief",
            title: "I believe in my potential",
            description: "I trust that I can achieve the voice I desire"
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 0.98)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                VStack(spacing: Theme.spacingXL) {
                    // Header
                    headerView
                    
                    // Art block
                    artBlockView
                    
                    // Vow content
                    if showContent {
                        vowContentView
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Yes/No buttons
                    if showContent {
                        responseButtons
                            .transition(.opacity.combined(with: .scale))
                            .animation(.easeInOut(duration: 0.6).delay(0.2), value: showContent)
                    }
                    
                    // Progress dots
                    if showContent {
                        progressDots
                            .transition(.opacity.combined(with: .scale))
                            .animation(.easeInOut(duration: 0.6).delay(0.4), value: showContent)
                    }
                }
                .padding(.horizontal, Theme.spacingLG)
                .padding(.bottom, Theme.spacingXXXL)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showContent = true
            }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Your VoiceMaxxing Vows")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Make your commitment to transformation")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Vows ceremony with commitment visualization")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var vowContentView: some View {
        VStack(spacing: Theme.spacingMD) {
            // Vow number indicator
            Text("Vow \(currentVowIndex + 1) of \(vows.count)")
                .font(.deeperCaption)
                .fontWeight(.medium)
                .foregroundColor(Theme.accent)
            
            // Current vow
            let currentVow = vows[currentVowIndex]
            
            VStack(spacing: Theme.spacingSM) {
                Text(currentVow.title)
                    .font(.deeperSubtitle)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                
                Text(currentVow.description)
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.textSecondary.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    @ViewBuilder
    private var responseButtons: some View {
        HStack(spacing: Theme.spacingLG) {
            // No button
            Button(action: {
                handleResponse(false)
            }) {
                Text("No")
                    .font(.deeperBody)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.textSecondary.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Yes button
            Button(action: {
                handleResponse(true)
            }) {
                Text("Yes")
                    .font(.deeperBody)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.accent)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Theme.accent, lineWidth: 1)
                            )
                    )
                    .shadow(
                        color: showGlow ? Theme.accent.opacity(0.5) : Color.clear,
                        radius: showGlow ? 12 : 0,
                        x: 0,
                        y: 0
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(showGlow ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: showGlow)
        }
    }
    
    @ViewBuilder
    private var progressDots: some View {
        HStack(spacing: Theme.spacingSM) {
            ForEach(0..<vows.count, id: \.self) { index in
                Circle()
                    .fill(index <= currentVowIndex ? Theme.accent : Theme.textSecondary.opacity(0.3))
                    .frame(width: index == currentVowIndex ? 12 : 8, height: index == currentVowIndex ? 12 : 8)
                    .animation(.easeInOut(duration: 0.3), value: currentVowIndex)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleResponse(_ response: Bool) {
        // Save response
        vowResponses[currentVowIndex] = response
        
        if response {
            // Show glow effect for Yes
            withAnimation(.easeInOut(duration: 0.2)) {
                showGlow = true
            }
            
            // Hide glow after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showGlow = false
                }
            }
            
            // Move to next vow or complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if currentVowIndex < vows.count - 1 {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        currentVowIndex += 1
                    }
                } else {
                    // All vows completed
                    onContinue()
                }
            }
        }
    }
}

// MARK: - Vow Data Model

struct Vow {
    let id: String
    let title: String
    let description: String
}

// MARK: - Vows Step View

/// Step view for vows screens
struct VowsStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        VowsView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    VowsView {
        print("Continue tapped")
    }
}
