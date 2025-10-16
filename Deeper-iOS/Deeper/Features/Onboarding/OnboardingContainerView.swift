import SwiftUI

/// Main onboarding container that renders steps based on FlowManifest
/// Equivalent to OnboardingRenderer.tsx functionality
struct OnboardingContainerView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Progress Bar
                ProgressBar(progress: onboardingProgress)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Current step content
                currentStepView
            }
        }
    }
    
    /// Calculate progress based on current step and total steps
    private var onboardingProgress: Double {
        let currentIndex = onboardingStore.stepIndex
        let totalSteps = FlowManifest.count
        return Double(currentIndex + 1) / Double(totalSteps)
    }
    
    /// Get current step from flow manifest
    private var currentStep: Step? {
        return FlowManifest.step(at: onboardingStore.stepIndex)
    }
    
    /// Render the current step based on its kind
    @ViewBuilder
    private var currentStepView: some View {
            if let step = currentStep {
                switch onboardingStore.stepIndex {
                case 0:
                    WelcomeStepView()
                        .environmentObject(onboardingStore)
                case 1:
                    ArtStyleStepView()
                        .environmentObject(onboardingStore)
                case 2:
                    NamePhotoStepView()
                        .environmentObject(onboardingStore)
                case 3:
                    VoiceTrainHoursStepView()
                        .environmentObject(onboardingStore)
                case 4:
                    BreathworkMinutesStepView()
                        .environmentObject(onboardingStore)
                case 5:
                    ReadAloudPagesStepView()
                        .environmentObject(onboardingStore)
                case 6:
                    LoudEnvironmentsHoursStepView()
                        .environmentObject(onboardingStore)
                case 7:
                    SteamHumidifyFrequencyStepView()
                        .environmentObject(onboardingStore)
                case 8:
                    ExtrasChooserStepView()
                        .environmentObject(onboardingStore)
                case 9:
                    DownGlidesCountStepView()
                        .environmentObject(onboardingStore)
                case 10:
                    TechniqueStudyDailyStepView()
                        .environmentObject(onboardingStore)
                case 11:
                    PermissionsStepView()
                        .environmentObject(onboardingStore)
                case 12:
                    AimsStepView()
                        .environmentObject(onboardingStore)
                case 13:
                    AnalyzingStepView()
                        .environmentObject(onboardingStore)
                case 14:
                    HabitsGridStepView()
                        .environmentObject(onboardingStore)
                case 15:
                    if let step = currentStep,
                       case .weekRadar(let payload) = step.kind {
                        WeekRadarStepView(step: step, payload: payload)
                            .environmentObject(onboardingStore)
                    } else {
                        UnknownStepView()
                            .environmentObject(onboardingStore)
                    }
                case 16:
                    PreRatingStepView()
                        .environmentObject(onboardingStore)
                default:
                    // Fallback to step.kind routing for steps 17+
                    switch step.kind {
                    case .rating(let payload):
                        RatingStepView(step: step, payload: payload)
                            .environmentObject(onboardingStore)
                    case .rpg:
                        RpgStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .hardmode:
                        HardmodeStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .penalty:
                        PenaltyStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .aiSchedule:
                        AiScheduleStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .progressiveChart:
                        ProgressiveChartStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .calendarWeek1:
                        CalendarWeek1StepView(step: step)
                            .environmentObject(onboardingStore)
                    case .commit:
                        CommitStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .vows:
                        VowsStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .lockin:
                        LockinStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .personalMsg:
                        PersonalMsgStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .paywall:
                        PaywallStepView(step: step)
                            .environmentObject(onboardingStore)
                    case .weekRadar(let payload):
                        WeekRadarStepView(step: step, payload: payload)
                            .environmentObject(onboardingStore)
                    case .referral:
                        ReferralStepView(step: step)
                            .environmentObject(onboardingStore)
                    default:
                        UnknownStepView()
                            .environmentObject(onboardingStore)
                    }
                }
        } else {
            // Fallback for invalid step index
            UnknownStepView()
                .environmentObject(onboardingStore)
        }
    }
}

// MARK: - Step View Components

/// Base step view with common layout and continue button
struct BaseStepView<Content: View>: View {
    let step: Step
    let content: Content
    @EnvironmentObject var onboardingStore: OnboardingStore
    @State private var showContinueButton: Bool = true
    
    init(step: Step, @ViewBuilder content: () -> Content) {
        self.step = step
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Content area
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Shared Continue button (when enabled)
                if showContinueButton {
                    continueButton
                        .padding(.horizontal, Theme.spacingLG)
                        .padding(.bottom, Theme.spacingXXXL)
                }
            }
        }
        .onAppear {
            // Hide continue button for steps that handle their own navigation
            hideContinueButtonForSpecificSteps()
        }
    }
    
    private var continueButton: some View {
        PrimaryButton(title: "Continue") {
            onboardingStore.next()
        }
    }
    
    /// Hide continue button for steps that handle their own navigation
    private func hideContinueButtonForSpecificSteps() {
        switch step.kind {
        case .rating, .paywall, .personalMsg, .lockin:
            showContinueButton = false
        default:
            showContinueButton = true
        }
    }
}

// MARK: - Individual Step Views

/// Story step view for narrative content
struct StoryStepView: View {
    let step: Step
    
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: 280)
                    
                    Spacer()
                }
            }
        }
    }
}

/// Question step view for data collection
struct QuestionStepView: View {
    let step: Step
    
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: 280)
                    
                    Spacer()
                    
                    Text("Question implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.spacingLG)
                }
            }
        }
    }
}

/// Toggles step view for multiple choice selections
struct TogglesStepView: View {
    let step: Step
    
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: 280)
                    
                    Spacer()
                    
                    Text("Toggles implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.spacingLG)
                }
            }
        }
    }
}

/// ATT (Attention) step view
struct AttStepView: View {
    let step: Step
    
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: 280)
                    
                    Spacer()
                    
                    Text("ATT implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.spacingLG)
                }
            }
        }
    }
}

/// Goals step view
struct GoalsStepView: View {
    let step: Step
    
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                        .aspectRatio(16/9, contentMode: .fit)
                        .frame(maxWidth: 280)
                    
                    Spacer()
                    
                    Text("Goals implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.spacingLG)
                }
            }
        }
    }
}

/// Rating step view for assessments
struct RatingStepView: View {
    let step: Step
    let payload: RatingPayload
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        RatingView(
            label: payload.label,
            stats: calculatedStats,
            comparisonStats: payload.label == .potential ? previousStats : nil,
            onContinue: {
                onboardingStore.next()
            }
        )
    }
    
    // MARK: - Computed Properties
    
    private var calculatedStats: Stats {
        if let stats = payload.stats {
            return stats
        }
        
        // Calculate stats from onboarding answers
        let currentStats = RatingView.calculateStats(from: onboardingStore.answers)
        
        // For potential rating, enhance the current stats
        if payload.label == .potential {
            return RatingView.calculatePotentialStats(from: currentStats)
        }
        
        return currentStats
    }
    
    private var previousStats: Stats? {
        // For potential rating, use current stats as comparison
        if payload.label == .potential {
            return RatingView.calculateStats(from: onboardingStore.answers)
        }
        return nil
    }
}

// MARK: - Placeholder Step Views (to be implemented in later prompts)

struct RpgStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("RPG implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct HardmodeStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Hardmode implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct PenaltyStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Penalty implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct HabitsGridStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Habits Grid implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}


struct AiScheduleStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("AI Schedule implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct ProgressiveChartStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Progressive Chart implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct CalendarWeek1StepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Calendar Week 1 implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct CommitStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Commit implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct VowsStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Vows implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct LockinStepView: View {
    let step: Step
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Lockin implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct PersonalMsgStepView: View {
    let step: Step
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Personal Message implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct PaywallStepView: View {
    let step: Step
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Paywall implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

struct ReferralStepView: View {
    let step: Step
    var body: some View {
        BaseStepView(step: step) {
            GradientScreen(title: step.title, subtitle: step.subtitle) {
                VStack {
                    ArtBlock(description: step.artNote)
                    Spacer()
                    Text("Referral implementation coming soon")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
        }
    }
}

/// Unknown step view for invalid or missing steps
struct UnknownStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: Theme.spacingLG) {
                Spacer()
                
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(Theme.warning)
                
                Text("Unknown Step")
                    .font(.deeperTitle)
                    .foregroundColor(Theme.textPrimary)
                
                Text("Step index out of bounds or invalid")
                    .font(.deeperSubtitle)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                
                PrimaryButton(title: "Continue") {
                    onboardingStore.next()
                }
                
                Spacer()
            }
            .padding(.horizontal, Theme.spacingLG)
        }
        .onAppear {
            // Log warning for unknown step
            print("⚠️ Warning: Unknown step at index \(onboardingStore.stepIndex)")
            print("⚠️ Total flow steps: \(FlowManifest.count)")
        }
    }
}

#Preview {
    OnboardingContainerView()
        .environmentObject(OnboardingStore())
}
