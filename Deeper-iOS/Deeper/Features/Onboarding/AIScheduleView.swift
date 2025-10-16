import SwiftUI

/// AI schedule view showing weekly lanes per habit (Mon-Sun)
struct AIScheduleView: View {
    let onContinue: () -> Void
    
    @State private var showSchedule: Bool = false
    
    private let habits = [
        "Reduce Strain",
        "Wake & Train Early", 
        "Meditate/Breath",
        "Read Aloud",
        "Steam Therapy",
        "Down Glides",
        "Technique Study",
        "Voice Journal"
    ]
    
    private let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 0.85)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                ScrollView {
                    VStack(spacing: Theme.spacingXL) {
                        // Header
                        headerView
                        
                        // Art block
                        artBlockView
                        
                        // AI Schedule
                        if showSchedule {
                            aiScheduleView
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        // Footer note
                        footerNote
                        
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
                showSchedule = true
            }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("AI-Powered Schedule")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Your personalized VoiceMaxxing routine")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "AI schedule interface with weekly habit planning")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var aiScheduleView: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Weekly Habit Schedule")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            // Schedule grid
            VStack(spacing: Theme.spacingSM) {
                // Header row with days
                HStack(spacing: 0) {
                    // Empty corner
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 80, height: 32)
                    
                    // Day headers
                    ForEach(daysOfWeek, id: \.self) { day in
                        Text(day)
                            .font(.deeperCaption)
                            .fontWeight(.medium)
                            .foregroundColor(Theme.textSecondary)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Habit rows
                ForEach(habits, id: \.self) { habit in
                    HStack(spacing: 0) {
                        // Habit name
                        Text(habit)
                            .font(.deeperCaption)
                            .fontWeight(.medium)
                            .foregroundColor(Theme.textPrimary)
                            .frame(width: 80, alignment: .leading)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        // Pillbox lanes for each day
                        ForEach(daysOfWeek.indices, id: \.self) { dayIndex in
                            PillboxLane(
                                habit: habit,
                                dayIndex: dayIndex,
                                isActive: shouldShowPill(habit: habit, dayIndex: dayIndex)
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 32)
                }
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
            
            // Legend
            legendView
        }
    }
    
    @ViewBuilder
    private var legendView: some View {
        HStack(spacing: Theme.spacingLG) {
            HStack(spacing: Theme.spacingXS) {
                Circle()
                    .fill(Theme.success)
                    .frame(width: 12, height: 12)
                Text("Scheduled")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            HStack(spacing: Theme.spacingXS) {
                Circle()
                    .fill(Theme.textSecondary.opacity(0.3))
                    .frame(width: 12, height: 12)
                Text("Rest Day")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
    
    @ViewBuilder
    private var footerNote: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("AI-Generated Schedule")
                .font(.deeperBody)
                .fontWeight(.semibold)
                .foregroundColor(Theme.accent)
            
            Text("Your schedule adapts based on your progress, preferences, and voice development goals. The AI optimizes timing and intensity for maximum results.")
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.accent.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var continueButton: some View {
        PrimaryButton(title: "Continue") {
            onContinue()
        }
    }
    
    // MARK: - Helper Methods
    
    private func shouldShowPill(habit: String, dayIndex: Int) -> Bool {
        // AI-generated schedule logic - some habits are daily, others are 3-4 times per week
        switch habit {
        case "Wake & Train Early", "Meditate/Breath", "Voice Journal":
            return true // Daily habits
        case "Reduce Strain", "Read Aloud", "Technique Study":
            return dayIndex < 5 // Weekdays only
        case "Steam Therapy", "Down Glides":
            return dayIndex % 2 == 0 // Every other day
        default:
            return dayIndex != 0 && dayIndex != 6 // Skip Monday and Sunday
        }
    }
}

// MARK: - Pillbox Lane Component

struct PillboxLane: View {
    let habit: String
    let dayIndex: Int
    let isActive: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { pillIndex in
                Circle()
                    .fill(pillColor(for: pillIndex))
                    .frame(width: 6, height: 6)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func pillColor(for index: Int) -> Color {
        if !isActive {
            return Theme.textSecondary.opacity(0.1)
        }
        
        // Different intensity levels for different habits
        switch habit {
        case "Wake & Train Early", "Meditate/Breath":
            return index == 0 ? Theme.success : Theme.textSecondary.opacity(0.1)
        case "Reduce Strain", "Read Aloud", "Technique Study":
            return index < 2 ? Theme.accent : Theme.textSecondary.opacity(0.1)
        case "Steam Therapy", "Down Glides":
            return index == 2 ? Theme.warning : Theme.textSecondary.opacity(0.1)
        case "Voice Journal":
            return Theme.success.opacity(0.8)
        default:
            return index == 1 ? Theme.accent : Theme.textSecondary.opacity(0.1)
        }
    }
}

// MARK: - AI Schedule Step View

/// Step view for AI schedule screens
struct AIScheduleStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        AIScheduleView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    AIScheduleView {
        print("Continue tapped")
    }
}
