import SwiftUI

// MARK: - Onboarding Flow Configuration

/// Data-driven onboarding flow configuration
/// Equivalent to the flow logic from the Expo version
struct OnboardingFlow {
    
    /// All onboarding steps in order
    static let steps: [OnboardingStepConfig] = [
        OnboardingStepConfig(
            id: "welcome",
            title: "Prepare to descend.",
            subtitle: "A deeper voice awaits.",
            view: AnyView(WelcomeStepView())
        ),
        OnboardingStepConfig(
            id: "artStyle",
            title: "Choose Your Art Style",
            subtitle: "Select the artistic style that resonates with you",
            view: AnyView(ArtStyleStepView())
        ),
        OnboardingStepConfig(
            id: "namePhoto",
            title: "Name & Photo",
            subtitle: "Tell us about yourself",
            view: AnyView(NamePhotoStepView())
        ),
        OnboardingStepConfig(
            id: "voiceTrainHours",
            title: "Voice Training Hours",
            subtitle: "How many hours do you train?",
            view: AnyView(VoiceTrainHoursStepView())
        ),
        OnboardingStepConfig(
            id: "breathworkMinutes",
            title: "Breathwork Minutes",
            subtitle: "How many minutes of breathwork?",
            view: AnyView(BreathworkMinutesStepView())
        ),
        OnboardingStepConfig(
            id: "readAloudPages",
            title: "Read Aloud Pages",
            subtitle: "How many pages do you read aloud?",
            view: AnyView(ReadAloudPagesStepView())
        ),
        OnboardingStepConfig(
            id: "loudEnvironmentsHours",
            title: "Loud Environments",
            subtitle: "Hours in loud environments?",
            view: AnyView(LoudEnvironmentsHoursStepView())
        ),
        OnboardingStepConfig(
            id: "steamHumidifyFrequency",
            title: "Steam & Humidify",
            subtitle: "How often do you steam or humidify?",
            view: AnyView(SteamHumidifyFrequencyStepView())
        ),
        OnboardingStepConfig(
            id: "extrasChooser",
            title: "Choose Extras",
            subtitle: "Select up to 2 additional features",
            view: AnyView(ExtrasChooserStepView())
        ),
        OnboardingStepConfig(
            id: "downGlidesCount",
            title: "Down Glides Count",
            subtitle: "How many down glides?",
            view: AnyView(DownGlidesCountStepView())
        ),
        OnboardingStepConfig(
            id: "techniqueStudyDaily",
            title: "Technique Study",
            subtitle: "Daily technique study time?",
            view: AnyView(TechniqueStudyDailyStepView())
        ),
        OnboardingStepConfig(
            id: "permissions",
            title: "Permissions",
            subtitle: "Grant necessary permissions",
            view: AnyView(PermissionsStepView())
        ),
        OnboardingStepConfig(
            id: "aims",
            title: "Your Aims",
            subtitle: "What are your goals?",
            view: AnyView(AimsStepView())
        ),
        OnboardingStepConfig(
            id: "analyzing",
            title: "Analyzing",
            subtitle: "Processing your responses",
            view: AnyView(AnalyzingStepView())
        ),
        OnboardingStepConfig(
            id: "currentRating",
            title: "Current Rating",
            subtitle: "Rate your current voice",
            view: AnyView(CurrentRatingStepView())
        ),
        OnboardingStepConfig(
            id: "potentialRating",
            title: "Potential Rating",
            subtitle: "What's your potential?",
            view: AnyView(PotentialRatingStepView())
        )
    ]
    
    /// Get step by index
    static func step(at index: Int) -> OnboardingStepConfig? {
        guard index >= 0 && index < steps.count else { return nil }
        return steps[index]
    }
    
    /// Get step by ID
    static func step(withId id: String) -> OnboardingStepConfig? {
        return steps.first { $0.id == id }
    }
    
    /// Get step index by ID
    static func index(forId id: String) -> Int? {
        return steps.firstIndex { $0.id == id }
    }
    
    /// Total number of steps
    static var count: Int {
        return steps.count
    }
}

// MARK: - Onboarding Step Configuration

/// Configuration for a single onboarding step
struct OnboardingStepConfig {
    let id: String
    let title: String
    let subtitle: String
    let view: AnyView
}

// MARK: - Step Views

/// Base step view with common layout
struct OnboardingStepBaseView<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content
    
    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        GradientScreen(title: title, subtitle: subtitle) {
            content
        }
    }
}

// MARK: - Individual Step Views

struct WelcomeStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Prepare to descend.",
            subtitle: "A deeper voice awaits."
        ) {
            VStack {
                // Character placeholder
                ArtBlock(description: "Anime Hero Character")
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: 280)
                
                Spacer()
                
                PrimaryButton(title: "Begin") {
                    store.next()
                }
                .padding(.bottom, Theme.spacingXXXL)
            }
        }
    }
}

struct ArtStyleStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Choose Your Art Style",
            subtitle: "Select the artistic style that resonates with you"
        ) {
            VStack {
                Text("Art Style Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct NamePhotoStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Name & Photo",
            subtitle: "Tell us about yourself"
        ) {
            VStack {
                Text("Name & Photo Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct VoiceTrainHoursStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Voice Training Hours",
            subtitle: "How many hours do you train?"
        ) {
            VStack {
                Text("Voice Training Hours Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct BreathworkMinutesStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Breathwork Minutes",
            subtitle: "How many minutes of breathwork?"
        ) {
            VStack {
                Text("Breathwork Minutes Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct ReadAloudPagesStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Read Aloud Pages",
            subtitle: "How many pages do you read aloud?"
        ) {
            VStack {
                Text("Read Aloud Pages Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct LoudEnvironmentsHoursStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Loud Environments",
            subtitle: "Hours in loud environments?"
        ) {
            VStack {
                Text("Loud Environments Hours Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct SteamHumidifyFrequencyStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Steam & Humidify",
            subtitle: "How often do you steam or humidify?"
        ) {
            VStack {
                Text("Steam Humidify Frequency Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct ExtrasChooserStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Choose Extras",
            subtitle: "Select up to 2 additional features"
        ) {
            VStack {
                Text("Extras Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct DownGlidesCountStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Down Glides Count",
            subtitle: "How many down glides?"
        ) {
            VStack {
                Text("Down Glides Count Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct TechniqueStudyDailyStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Technique Study",
            subtitle: "Daily technique study time?"
        ) {
            VStack {
                Text("Technique Study Daily Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct PermissionsStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Permissions",
            subtitle: "Grant necessary permissions"
        ) {
            VStack {
                Text("Permissions Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct AimsStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Your Aims",
            subtitle: "What are your goals?"
        ) {
            VStack {
                Text("Aims Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct AnalyzingStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Analyzing",
            subtitle: "Processing your responses"
        ) {
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Theme.accent))
                    .scaleEffect(1.5)
                
                Text("Analyzing your responses...")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                    .padding(.top, Theme.spacingMD)
                
                Spacer()
            }
        }
        .onAppear {
            // Simulate analysis delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                store.next()
            }
        }
    }
}

struct CurrentRatingStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Current Rating",
            subtitle: "Rate your current voice"
        ) {
            VStack {
                Text("Current Rating Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

struct PotentialRatingStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        OnboardingStepBaseView(
            title: "Potential Rating",
            subtitle: "What's your potential?"
        ) {
            VStack {
                Text("Potential Rating Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
                
                PrimaryButton(title: "Finish") {
                    // Complete onboarding
                    store.reset()
                }
            }
        }
    }
}

// MARK: - Gradient Screen Component

/// Replicates the GradientScreen from Expo
struct GradientScreen<Content: View>: View {
    let title: String?
    let subtitle: String?
    let content: Content
    
    init(title: String? = nil, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Theme.background, Color(red: 0.1, green: 0.09, blue: 0.15), Theme.background],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with title and subtitle
                if title != nil || subtitle != nil {
                    VStack(spacing: Theme.spacingSM) {
                        if let title = title {
                            Text(title)
                                .font(.deeperTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Theme.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.deeperSubtitle)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                    }
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingXL)
                    .padding(.bottom, Theme.spacingMD)
                }
                
                // Content
                content
                    .padding(.horizontal, Theme.spacingLG)
            }
        }
    }
}

#Preview {
    WelcomeStepView()
        .environmentObject(OnboardingStore())
}
