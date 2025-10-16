import SwiftUI

/// Lock-in view with long-press gesture (2 seconds) and haptic feedback
struct LockInView: View {
    let onContinue: () -> Void
    
    @State private var showContent: Bool = false
    @State private var isPressed: Bool = false
    @State private var progress: Double = 0.0
    @State private var showCompletion: Bool = false
    
    private let holdDuration: Double = 2.0
    private let hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 0.99)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                VStack(spacing: Theme.spacingXL) {
                    // Header
                    headerView
                    
                    // Art block
                    artBlockView
                    
                    // Lock-in instruction
                    if showContent {
                        instructionView
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Hold button
                    if showContent {
                        holdButton
                            .transition(.opacity.combined(with: .scale))
                            .animation(.easeInOut(duration: 0.6).delay(0.2), value: showContent)
                    }
                    
                    // Progress indicator
                    if showContent && isPressed {
                        progressIndicator
                            .transition(.opacity.combined(with: .scale))
                            .animation(.easeInOut(duration: 0.3), value: isPressed)
                    }
                    
                    // Completion message
                    if showCompletion {
                        completionView
                            .transition(.opacity.combined(with: .scale))
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
            Text("Lock In Your Commitment")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Hold to confirm your dedication")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Lock-in gesture with commitment visualization")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var instructionView: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Hold the button below for 2 seconds")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("This gesture symbolizes your commitment to your VoiceMaxxing journey. Feel the weight of your dedication.")
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
    
    @ViewBuilder
    private var holdButton: some View {
        VStack(spacing: Theme.spacingMD) {
            // Hold button
            Button(action: {}) {
                ZStack {
                    // Background circle
                    Circle()
                        .fill(isPressed ? Theme.accent : Theme.accent.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Theme.accent, lineWidth: 3)
                        )
                        .scaleEffect(isPressed ? 1.1 : 1.0)
                        .shadow(
                            color: isPressed ? Theme.accent.opacity(0.4) : Color.clear,
                            radius: isPressed ? 20 : 0,
                            x: 0,
                            y: 0
                        )
                    
                    // Lock icon
                    Image(systemName: isPressed ? "lock.fill" : "lock")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(isPressed ? .white : Theme.accent)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .onLongPressGesture(
                minimumDuration: holdDuration,
                maximumDistance: 50,
                pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = pressing
                    }
                    
                    if pressing {
                        startHoldGesture()
                    } else {
                        cancelHoldGesture()
                    }
                },
                perform: {
                    completeHoldGesture()
                }
            )
            
            // Instruction text
            Text(isPressed ? "Keep holding..." : "Hold to lock in")
                .font(.deeperCaption)
                .fontWeight(.medium)
                .foregroundColor(isPressed ? Theme.accent : Theme.textSecondary)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
        }
    }
    
    @ViewBuilder
    private var progressIndicator: some View {
        VStack(spacing: Theme.spacingSM) {
            // Circular progress
            ZStack {
                Circle()
                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Theme.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: progress)
                
                Text("\(Int(progress * 100))%")
                    .font(.deeperCaption)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.accent)
            }
            
            Text("\(Int((1.0 - progress) * holdDuration))s remaining")
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    @ViewBuilder
    private var completionView: some View {
        VStack(spacing: Theme.spacingMD) {
            // Success icon
            ZStack {
                Circle()
                    .fill(Theme.success)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Circle()
                            .stroke(Theme.success, lineWidth: 3)
                    )
                    .shadow(
                        color: Theme.success.opacity(0.4),
                        radius: 15,
                        x: 0,
                        y: 0
                    )
                
                Image(systemName: "checkmark")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text("Commitment Locked!")
                .font(.deeperSubtitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.success)
            
            Text("Your dedication is sealed. The journey begins now.")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.success.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.success.opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            // Auto-advance after showing completion
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                onContinue()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func startHoldGesture() {
        // Prepare haptic feedback
        hapticGenerator.prepare()
        
        // Start progress animation
        withAnimation(.linear(duration: holdDuration)) {
            progress = 1.0
        }
        
        // Provide haptic feedback on start
        hapticGenerator.impactOccurred()
    }
    
    private func cancelHoldGesture() {
        // Reset progress
        withAnimation(.easeInOut(duration: 0.3)) {
            progress = 0.0
        }
    }
    
    private func completeHoldGesture() {
        // Success haptic feedback
        hapticGenerator.impactOccurred()
        
        // Show completion state
        withAnimation(.easeInOut(duration: 0.5)) {
            showCompletion = true
        }
    }
}

// MARK: - Lock In Step View

/// Step view for lock-in screens
struct LockInStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        LockInView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    LockInView {
        print("Continue tapped")
    }
}
