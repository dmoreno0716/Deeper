import SwiftUI

struct OnboardingNavigationView: View {
    @StateObject private var onboardingStore = OnboardingStore()
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if onboardingStore.hasHydrated {
                switch onboardingStore.currentStep {
                case .welcome:
                    WelcomeView()
                        .environmentObject(onboardingStore)
                case .artStyle:
                    ArtStyleView()
                        .environmentObject(onboardingStore)
                case .namePhoto:
                    NamePhotoView()
                        .environmentObject(onboardingStore)
                case .voiceTrainHours:
                    VoiceTrainHoursView()
                        .environmentObject(onboardingStore)
                case .breathworkMinutes:
                    BreathworkMinutesView()
                        .environmentObject(onboardingStore)
                case .readAloudPages:
                    ReadAloudPagesView()
                        .environmentObject(onboardingStore)
                case .loudEnvironmentsHours:
                    LoudEnvironmentsHoursView()
                        .environmentObject(onboardingStore)
                case .steamHumidifyFrequency:
                    SteamHumidifyFrequencyView()
                        .environmentObject(onboardingStore)
                case .extrasChooser:
                    ExtrasChooserView()
                        .environmentObject(onboardingStore)
                case .downGlidesCount:
                    DownGlidesCountView()
                        .environmentObject(onboardingStore)
                case .techniqueStudyDaily:
                    TechniqueStudyDailyView()
                        .environmentObject(onboardingStore)
                case .permissions:
                    PermissionsView()
                        .environmentObject(onboardingStore)
                case .aims:
                    AimsView()
                        .environmentObject(onboardingStore)
                case .analyzing:
                    AnalyzingView()
                        .environmentObject(onboardingStore)
                case .currentRating:
                    CurrentRatingView()
                        .environmentObject(onboardingStore)
                case .potentialRating:
                    PotentialRatingView()
                        .environmentObject(onboardingStore)
                }
            } else {
                // Loading state
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.accent))
                        .scaleEffect(1.5)
                    
                    Text("Loading...")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .padding(.top, Theme.spacingMD)
                }
            }
        }
    }
}

// MARK: - Placeholder Views (to be implemented)
struct WelcomeView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen(
            title: "Prepare to descend.",
            subtitle: "A deeper voice awaits."
        ) {
            VStack {
                // Character placeholder
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.card)
                        .frame(width: 280, height: 400)
                        .overlay(
                            Text("Anime Hero Character")
                                .font(.deeperBody)
                                .foregroundColor(Theme.textSecondary)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Theme.accent.opacity(0.3), lineWidth: 2)
                        )
                        .shadow(color: Theme.accent.opacity(0.3), radius: 16, x: 0, y: 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    PrimaryButton(title: "Begin") {
                        store.nextStep()
                    }
                    .padding(.bottom, Theme.spacingXXXL)
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

// Placeholder views for other onboarding screens
struct ArtStyleView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Choose Your Art Style", subtitle: "Select the artistic style that resonates with you") {
            VStack {
                Text("Art Style Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct NamePhotoView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Name & Photo", subtitle: "Tell us about yourself") {
            VStack {
                Text("Name & Photo Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct VoiceTrainHoursView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Voice Training Hours", subtitle: "How many hours do you train?") {
            VStack {
                Text("Voice Training Hours Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct BreathworkMinutesView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Breathwork Minutes", subtitle: "How many minutes of breathwork?") {
            VStack {
                Text("Breathwork Minutes Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct ReadAloudPagesView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Read Aloud Pages", subtitle: "How many pages do you read aloud?") {
            VStack {
                Text("Read Aloud Pages Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct LoudEnvironmentsHoursView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Loud Environments", subtitle: "Hours in loud environments?") {
            VStack {
                Text("Loud Environments Hours Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct SteamHumidifyFrequencyView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Steam & Humidify", subtitle: "How often do you steam or humidify?") {
            VStack {
                Text("Steam Humidify Frequency Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct ExtrasChooserView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Choose Extras", subtitle: "Select up to 2 additional features") {
            VStack {
                Text("Extras Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct DownGlidesCountView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Down Glides Count", subtitle: "How many down glides?") {
            VStack {
                Text("Down Glides Count Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct TechniqueStudyDailyView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Technique Study", subtitle: "Daily technique study time?") {
            VStack {
                Text("Technique Study Daily Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct PermissionsView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Permissions", subtitle: "Grant necessary permissions") {
            VStack {
                Text("Permissions Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct AimsView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Your Aims", subtitle: "What are your goals?") {
            VStack {
                Text("Aims Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct AnalyzingView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Analyzing", subtitle: "Processing your responses") {
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
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
        .onAppear {
            // Simulate analysis delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                store.nextStep()
            }
        }
    }
}

struct CurrentRatingView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Current Rating", subtitle: "Rate your current voice") {
            VStack {
                Text("Current Rating Selection Coming Soon")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                Spacer()
                PrimaryButton(title: "Continue") {
                    store.nextStep()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

struct PotentialRatingView: View {
    @EnvironmentObject var store: OnboardingStore
    var body: some View {
        GradientScreen(title: "Potential Rating", subtitle: "What's your potential?") {
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
        .overlay(alignment: .top) {
            ProgressBar(progress: store.progress)
        }
    }
}

#Preview {
    OnboardingNavigationView()
}
