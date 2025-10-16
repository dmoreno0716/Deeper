import SwiftUI

/// 8 core habit grid view showing VoiceMaxxing habits with icons and descriptions
struct HabitsGridView: View {
    let onContinue: () -> Void
    
    @State private var showHabits: Bool = false
    
    private let habits = [
        HabitData(
            id: "reduceStrain",
            title: "Reduce Strain",
            description: "Protect your voice from overuse",
            icon: "mic.slash",
            color: Theme.danger
        ),
        HabitData(
            id: "wakeEarly",
            title: "Wake & Train Early",
            description: "Morning voice training routine",
            icon: "sunrise",
            color: Theme.warning
        ),
        HabitData(
            id: "meditate",
            title: "Meditate/Breath",
            description: "Daily breathing exercises",
            icon: "leaf",
            color: Theme.success
        ),
        HabitData(
            id: "readAloud",
            title: "Read Aloud",
            description: "Practice voice projection",
            icon: "book",
            color: Theme.accent
        ),
        HabitData(
            id: "steamTherapy",
            title: "Steam Therapy",
            description: "Hydrate vocal cords",
            icon: "cloud.fog",
            color: Theme.textSecondary
        ),
        HabitData(
            id: "downGlides",
            title: "Down Glides",
            description: "Vocal range exercises",
            icon: "arrow.down.circle",
            color: Theme.accent
        ),
        HabitData(
            id: "techniqueStudy",
            title: "Technique Study",
            description: "Learn voice fundamentals",
            icon: "graduationcap",
            color: Theme.warning
        ),
        HabitData(
            id: "voiceJournal",
            title: "Voice Journal",
            description: "Track your progress",
            icon: "book.closed",
            color: Theme.success
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 0.75)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                ScrollView {
                    VStack(spacing: Theme.spacingXL) {
                        // Header
                        headerView
                        
                        // Art block
                        artBlockView
                        
                        // Habits grid
                        if showHabits {
                            habitsGrid
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        // Continue button
                        continueButton
                            .padding(.bottom, Theme.spacingXXXL)
                    }
                    .padding(.horizontal, Theme.spacingLG)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showHabits = true
            }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("VoiceMaxxing Habits")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Your personalized habit tracking grid")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Habit grid interface with voice training activities")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var habitsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Theme.spacingMD),
                GridItem(.flexible(), spacing: Theme.spacingMD)
            ],
            spacing: Theme.spacingMD
        ) {
            ForEach(habits, id: \.id) { habit in
                HabitCard(habit: habit)
            }
        }
    }
    
    @ViewBuilder
    private var continueButton: some View {
        PrimaryButton(title: "Continue") {
            onContinue()
        }
    }
}

// MARK: - Habit Data

struct HabitData {
    let id: String
    let title: String
    let description: String
    let icon: String
    let color: Color
}

// MARK: - Habit Card Component

struct HabitCard: View {
    let habit: HabitData
    @State private var isPressed: Bool = false
    
    var body: some View {
        VStack(spacing: Theme.spacingMD) {
            // Icon
            Image(systemName: habit.icon)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(habit.color)
                .frame(width: 48, height: 48)
                .background(
                    Circle()
                        .fill(habit.color.opacity(0.1))
                )
            
            // Content
            VStack(spacing: Theme.spacingXS) {
                Text(habit.title)
                    .font(.deeperBody)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(habit.description)
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(habit.color.opacity(0.2), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

// MARK: - Habits Grid Step View

/// Step view for habits grid screens
struct HabitsGridStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        HabitsGridView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    HabitsGridView {
        print("Continue tapped")
    }
}
