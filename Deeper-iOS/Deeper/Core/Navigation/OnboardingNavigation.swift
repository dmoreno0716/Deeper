import SwiftUI

// MARK: - Legacy Onboarding Navigation (Deprecated)

/// This file contains the legacy onboarding navigation implementation.
/// The new data-driven approach is in AppRouter.swift and OnboardingFlow.swift
/// This is kept for reference and can be removed once migration is complete.

// MARK: - Onboarding Steps Enum (Legacy)

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case artStyle = 1
    case namePhoto = 2
    case voiceTrainHours = 3
    case breathworkMinutes = 4
    case readAloudPages = 5
    case loudEnvironmentsHours = 6
    case steamHumidifyFrequency = 7
    case extrasChooser = 8
    case downGlidesCount = 9
    case techniqueStudyDaily = 10
    case permissions = 11
    case aims = 12
    case analyzing = 13
    case currentRating = 14
    case potentialRating = 15
    
    var progress: Double {
        return Double(self.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }
}

/// Legacy onboarding navigation view - now replaced by AppRouter
@available(*, deprecated, message: "Use AppRouter instead")
struct OnboardingNavigationView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            if onboardingStore.hydrated {
                switch OnboardingStep(rawValue: onboardingStore.stepIndex) ?? .welcome {
                case .welcome:
                    WelcomeView()
                case .artStyle:
                    ArtStyleView()
                case .namePhoto:
                    NamePhotoView()
                case .voiceTrainHours:
                    VoiceTrainHoursView()
                case .breathworkMinutes:
                    BreathworkMinutesView()
                case .readAloudPages:
                    ReadAloudPagesView()
                case .loudEnvironmentsHours:
                    LoudEnvironmentsHoursView()
                case .steamHumidifyFrequency:
                    SteamHumidifyFrequencyView()
                case .extrasChooser:
                    ExtrasChooserView()
                case .downGlidesCount:
                    DownGlidesCountView()
                case .techniqueStudyDaily:
                    TechniqueStudyDailyView()
                case .permissions:
                    PermissionsView()
                case .aims:
                    AimsView()
                case .analyzing:
                    AnalyzingView()
                case .currentRating:
                    CurrentRatingView()
                case .potentialRating:
                    PotentialRatingView()
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
                        store.next()
                    }
                    .padding(.bottom, Theme.spacingXXXL)
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
        }
        .onAppear {
            // Simulate analysis delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                store.next()
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
                    store.next()
                }
            }
        }
        .overlay(alignment: .top) {
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
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
            ProgressBar(progress: OnboardingStep(rawValue: store.stepIndex)?.progress ?? 0.0)
        }
    }
}

#Preview {
    OnboardingNavigationView()
}
