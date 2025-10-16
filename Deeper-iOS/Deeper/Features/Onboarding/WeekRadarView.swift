import SwiftUI

/// Week radar preview view showing progress over time
/// Displays radar chart with ramped values and week-specific subtitles
struct WeekRadarView: View {
    let week: Int
    let theme: RadarTheme
    let onContinue: () -> Void
    
    @State private var showChart: Bool = false
    @State private var showContent: Bool = false
    
    init(
        week: Int,
        theme: RadarTheme,
        onContinue: @escaping () -> Void
    ) {
        self.week = week
        self.theme = theme
        self.onContinue = onContinue
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: progressValue)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                ScrollView {
                    VStack(spacing: Theme.spacingXL) {
                        // Header
                        headerView
                        
                        // Week radar chart
                        if showChart {
                            weekRadarChart
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Week description
                        if showContent {
                            weekDescription
                                .transition(.move(edge: .bottom).combined(with: .opacity))
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
            // Staggered animations
            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                showChart = true
            }
            
            withAnimation(.easeInOut(duration: 0.6).delay(0.4)) {
                showContent = true
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var progressValue: Double {
        // Progress increases with week number
        return 0.7 + (Double(week) * 0.05)
    }
    
    private var titleText: String {
        return "Week \(week) Preview"
    }
    
    private var subtitleText: String {
        switch (week, theme) {
        case (1, .voice):
            return "Foundation building begins"
        case (1, .habits):
            return "Establishing core routines"
        case (1, .progress):
            return "Initial progress tracking"
        case (1, .mastery):
            return "Mastery fundamentals"
        case (5, .voice):
            return "Voice transformation accelerates"
        case (5, .habits):
            return "Habits become second nature"
        case (5, .progress):
            return "Significant progress visible"
        case (5, .mastery):
            return "Advanced techniques emerge"
        case (10, .voice):
            return "Voice mastery approaches"
        case (10, .habits):
            return "Habits fully integrated"
        case (10, .progress):
            return "Remarkable progress achieved"
        case (10, .mastery):
            return "Mastery level attained"
        default:
            return "VoiceMaxxing progress continues"
        }
    }
    
    private var weekDescription: String {
        switch (week, theme) {
        case (1, .voice):
            return "Your voice foundation is being built. Basic techniques are introduced and daily practice routines are established."
        case (1, .habits):
            return "Core VoiceMaxxing habits are being formed. Consistency is key as you build the foundation for long-term success."
        case (1, .progress):
            return "Initial progress tracking begins. You'll see early improvements in voice quality and technique."
        case (1, .mastery):
            return "Mastery fundamentals are introduced. Advanced techniques are being prepared for your voice transformation journey."
        case (5, .voice):
            return "Your voice transformation is accelerating. Noticeable improvements in depth, resonance, and control are emerging."
        case (5, .habits):
            return "VoiceMaxxing habits are becoming second nature. Your daily routines are now deeply integrated into your lifestyle."
        case (5, .progress):
            return "Significant progress is now visible. Your voice quality has improved substantially across all metrics."
        case (5, .mastery):
            return "Advanced techniques are emerging. You're developing sophisticated voice control and expression capabilities."
        case (10, .voice):
            return "Voice mastery is approaching. Your voice has transformed significantly with professional-level quality and control."
        case (10, .habits):
            return "VoiceMaxxing habits are fully integrated. Your voice training has become a natural part of your daily life."
        case (10, .progress):
            return "Remarkable progress has been achieved. Your voice transformation is nearly complete with exceptional results."
        case (10, .mastery):
            return "Mastery level has been attained. You've achieved professional voice quality with advanced control and expression."
        default:
            return "Your VoiceMaxxing journey continues with steady progress and improvement."
        }
    }
    
    private var radarValues: [Double] {
        // Generate ramped values based on week and theme
        let baseValues = baseStatsForTheme
        let weekMultiplier = Double(week) / 10.0 // 0.1 for week 1, 0.5 for week 5, 1.0 for week 10
        let rampFactor = min(1.0, 0.3 + (weekMultiplier * 0.7)) // Ramp from 30% to 100%
        
        return baseValues.map { value in
            min(100.0, value * rampFactor)
        }
    }
    
    private var baseStatsForTheme: [Double] {
        switch theme {
        case .voice:
            return [75, 70, 80, 65, 70, 75] // Depth, Resonance, Clarity, Power, Control, Consistency
        case .habits:
            return [85, 80, 75, 70, 85, 90] // Higher consistency and depth
        case .progress:
            return [70, 75, 85, 80, 75, 80] // Higher clarity and power
        case .mastery:
            return [90, 85, 90, 85, 90, 85] // High across all metrics
        }
    }
    
    private var themeColor: Color {
        switch theme {
        case .voice:
            return Theme.accent
        case .habits:
            return Theme.success
        case .progress:
            return Theme.warning
        case .mastery:
            return Theme.danger
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text(titleText)
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text(subtitleText)
                .font(.deeperBody)
                .foregroundColor(themeColor)
                .multilineTextAlignment(.center)
                .fontWeight(.medium)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var weekRadarChart: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Progress Overview")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            HexRadarChart(
                values: radarValues,
                labels: ["Depth", "Resonance", "Clarity", "Power", "Control", "Consistency"],
                comparisonValues: nil,
                comparisonColor: themeColor
            )
            .frame(width: 280, height: 280)
            
            // Week indicator
            HStack(spacing: Theme.spacingSM) {
                Circle()
                    .fill(themeColor)
                    .frame(width: 8, height: 8)
                Text("Week \(week) Progress")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.card.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(themeColor.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var weekDescription: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("What to Expect")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            Text(weekDescription)
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.card.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.textSecondary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var continueButton: some View {
        PrimaryButton(title: "Continue") {
            onContinue()
        }
    }
}

// MARK: - Week Radar Step View

/// Step view for week radar screens
struct WeekRadarStepView: View {
    let step: Step
    let payload: WeekRadarPayload
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        WeekRadarView(
            week: payload.week,
            theme: payload.theme,
            onContinue: {
                onboardingStore.next()
            }
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        WeekRadarView(
            week: 1,
            theme: .voice,
            onContinue: { print("Continue tapped") }
        )
        
        WeekRadarView(
            week: 5,
            theme: .habits,
            onContinue: { print("Continue tapped") }
        )
        
        WeekRadarView(
            week: 10,
            theme: .mastery,
            onContinue: { print("Continue tapped") }
        )
    }
    .padding()
    .background(Theme.background)
}
