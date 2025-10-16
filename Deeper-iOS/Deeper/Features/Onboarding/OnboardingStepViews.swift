import SwiftUI

// MARK: - Step 0: Welcome

struct WelcomeStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen(title: "Prepare to descend.", subtitle: "A deeper voice awaits.") {
            VStack {
                Spacer()
                
                ArtBlock(description: "anime male hero holding a glowing tuning fork/flame, front pose on a runic pedestal")
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: 280)
                
                Spacer()
                
                PrimaryButton(title: "Begin") {
                    store.next()
                }
                .frame(maxWidth: 200)
            }
        }
    }
}

// MARK: - Step 1: Art Style

struct ArtStyleStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen(
            title: "Choose Your Art Style",
            subtitle: "Select the artistic style that resonates with you"
        ) {
            VStack(spacing: Theme.spacingLG) {
                Text("Each style has its own unique characteristics and will influence how your AI-generated art looks.")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, Theme.spacingMD)
                
                ArtBlock(description: "Art style selection interface - grid of artistic style previews with orange accent highlights")
                    .aspectRatio(16/9, contentMode: .fit)
                
                ArtBlock(description: "Style preview cards - animated previews of different art styles (anime, realistic, abstract, etc.)")
                    .aspectRatio(16/9, contentMode: .fit)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    // Save default art style for now
                    store.saveAnswer(id: "artStyle", value: "anime")
                    store.next()
                }
            }
        }
    }
}

// MARK: - Step 2: Name & Photo

struct NamePhotoStepView: View {
    @EnvironmentObject var store: OnboardingStore
    @State private var name: String = ""
    
    var body: some View {
        GradientScreen(
            title: "What should we call you?",
            subtitle: "A strong name for a stronger voice."
        ) {
            VStack(spacing: Theme.spacingXL) {
                Spacer()
                
                // Avatar placeholder
                ArtBlock(description: "silhouette avatar with subtle glow")
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Theme.accent.opacity(0.6), lineWidth: 2)
                    )
                
                // Name input
                TextField("Your name", text: $name)
                    .font(.deeperBody)
                    .foregroundColor(Theme.textPrimary)
                    .padding()
                    .background(Theme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: 360)
                    .textInputAutocapitalization(.words)
                    .disableAutocorrection(true)
                
                Spacer()
                
                PrimaryButton(title: "Continue", isDisabled: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                    store.saveAnswer(id: "name", value: name.trimmingCharacters(in: .whitespacesAndNewlines))
                    store.next()
                }
            }
        }
    }
}

// MARK: - Step 3: Voice Training Hours

struct VoiceTrainHoursStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                SliderQuestionView(
                    title: "How many hours do you usually train your voice in a week?",
                    range: 0...10,
                    step: 0.5,
                    unit: "hours/week"
                ) { value in
                    store.saveAnswer(id: "voiceTrainHours", value: value)
                    store.next()
                }
                .padding(.horizontal, Theme.spacingLG)
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 4: Breathwork Minutes

struct BreathworkMinutesStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                Text("How much time do you spend on breathwork in a week?")
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "character seated, calm breath, subtle breath vapor lines")
                    .aspectRatio(16/9, contentMode: .fit)
                
                // Custom slider for breathwork with specific stops
                BreathworkSliderView { value in
                    store.saveAnswer(id: "breathworkMinutes", value: value)
                    store.next()
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Custom Breathwork Slider

struct BreathworkSliderView: View {
    let onConfirm: (Int) -> Void
    
    private let stops = [0, 10, 20, 30, 45, 60, 90]
    @State private var selectedIndex: Int = 0
    
    private var friendlyLabel: String {
        let value = stops[selectedIndex]
        if value == 0 { return "I don't do breathwork" }
        if selectedIndex == stops.count - 1 { return "Around 90+ minutes" }
        
        let prev = stops[selectedIndex - 1]
        let curr = stops[selectedIndex]
        return "Around \(prev)–\(curr) minutes"
    }
    
    var body: some View {
        VStack(spacing: Theme.spacingLG) {
            // Custom slider with stops
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(height: 48)
                    
                    // Fill track
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.accent.opacity(0.3))
                        .frame(width: trackFillWidth(in: geometry), height: 48)
                    
                    // Tick marks
                    HStack(spacing: 0) {
                        ForEach(0..<stops.count, id: \.self) { _ in
                            Rectangle()
                                .fill(Theme.textSecondary.opacity(0.3))
                                .frame(width: 2, height: 14)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, Theme.spacingMD)
                    
                    // Thumb
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 24, height: 24)
                        .shadow(color: Theme.accent.opacity(0.4), radius: 8, x: 0, y: 4)
                        .offset(x: thumbOffset(in: geometry))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    updateValue(from: value.location.x, in: geometry)
                                }
                        )
                }
                .padding(.horizontal, Theme.spacingMD)
            }
            .frame(height: 48)
            
            Text(friendlyLabel)
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
            
            PrimaryButton(title: "Confirm") {
                onConfirm(stops[selectedIndex])
            }
        }
    }
    
    private func trackFillWidth(in geometry: GeometryProxy) -> CGFloat {
        let progress = Double(selectedIndex) / Double(stops.count - 1)
        return geometry.size.width * progress
    }
    
    private func thumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let progress = Double(selectedIndex) / Double(stops.count - 1)
        let availableWidth = geometry.size.width - 24
        return progress * availableWidth - 12
    }
    
    private func updateValue(from x: CGFloat, in geometry: GeometryProxy) {
        let progress = max(0, min(1, x / geometry.size.width))
        let nearestIndex = Int(round(progress * Double(stops.count - 1)))
        selectedIndex = max(0, min(stops.count - 1, nearestIndex))
    }
}

// MARK: - Step 5: Read Aloud Pages

struct ReadAloudPagesStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    private let options = [
        ("0", 0),
        ("5 pages", 5),
        ("10–15 pages", 12),
        ("20–30 pages", 25),
        (">40 pages", 45)
    ]
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                Text("How much time do you spend reading aloud for practice in a week?")
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "character reading from a book near window light")
                    .aspectRatio(16/9, contentMode: .fit)
                
                SingleSelectOptionsGrid(
                    options: options.map { $0.0 }
                ) { selected in
                    if let selected = selected,
                       let selectedIndex = options.firstIndex(where: { $0.0 == selected }) {
                        let value = options[selectedIndex].1
                        store.saveAnswer(id: "readAloudPages", value: value)
                        store.next()
                    }
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 6: Loud Environments Hours

struct LoudEnvironmentsHoursStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                VStack(spacing: Theme.spacingXS) {
                    Text("How much time do you spend in loud places per day?")
                        .font(.deeperSubtitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Clubs, bars, sports events—these strain your voice.")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "character in a noisy crowd with muffled speakers")
                    .aspectRatio(16/9, contentMode: .fit)
                
                SliderQuestionView(
                    title: "",
                    range: 0...4,
                    step: 0.25,
                    unit: "hours"
                ) { value in
                    store.saveAnswer(id: "loudEnvironmentsHours", value: value)
                    store.next()
                }
                .padding(.horizontal, Theme.spacingLG)
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 7: Steam Humidify Frequency

struct SteamHumidifyFrequencyStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                Text("How often do you use steam or humidification?")
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "Steam therapy visualization with throat health indicators")
                    .aspectRatio(16/9, contentMode: .fit)
                
                SliderQuestionView(
                    title: "",
                    range: 0...7,
                    step: 1,
                    unit: "times/week"
                ) { value in
                    store.saveAnswer(id: "steamHumidifyFrequency", value: value)
                    store.next()
                }
                .padding(.horizontal, Theme.spacingLG)
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 8: Extras Chooser

struct ExtrasChooserStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    private let options = [
        "Voice journal (log notes)",
        "Jaw & neck release",
        "Posture drill",
        "Tongue posture (mewing basics)",
        "Caffeine cap",
        "No smoke",
        "No alcohol",
        "Nasal breathing"
    ]
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                Text("Do you want to add any extra tasks to the program? (Max 2)")
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "Feature selection interface with premium options")
                    .aspectRatio(16/9, contentMode: .fit)
                
                OptionsGridView(
                    options: options,
                    maxSelection: 2,
                    allowMultiple: true
                ) { selected in
                    store.saveAnswer(id: "chosenExtras", value: selected)
                    store.next()
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 9: Down Glides Count

struct DownGlidesCountStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                Text("How many down glides do you practice?")
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "Vocal exercise demonstration with pitch visualization")
                    .aspectRatio(16/9, contentMode: .fit)
                
                SliderQuestionView(
                    title: "",
                    range: 0...50,
                    step: 5,
                    unit: "glides/day"
                ) { value in
                    store.saveAnswer(id: "downGlidesCount", value: value)
                    store.next()
                }
                .padding(.horizontal, Theme.spacingLG)
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 10: Technique Study Daily

struct TechniqueStudyDailyStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                Text("Daily technique study time?")
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "Learning interface with technique progression visualization")
                    .aspectRatio(16/9, contentMode: .fit)
                
                SliderQuestionView(
                    title: "",
                    range: 0...120,
                    step: 5,
                    unit: "minutes/day"
                ) { value in
                    store.saveAnswer(id: "techniqueStudyDaily", value: value)
                    store.next()
                }
                .padding(.horizontal, Theme.spacingLG)
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 11: Permissions

struct PermissionsStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    private let permissions = [
        ToggleRowData(
            id: "microphone",
            title: "Microphone",
            description: "for optional voice notes/analysis later",
            initialValue: false,
            isPermission: true
        ),
        ToggleRowData(
            id: "notifications",
            title: "Notifications",
            description: "habit reminders",
            initialValue: false,
            isPermission: true
        )
    ]
    
    var body: some View {
        GradientScreen(
            title: "Permissions",
            subtitle: "Grant necessary permissions for VoiceMaxxing"
        ) {
            VStack(spacing: Theme.spacingLG) {
                ArtBlock(description: "Permission request interface with privacy-focused design")
                    .aspectRatio(16/9, contentMode: .fit)
                
                ToggleRowContainer(
                    title: "",
                    toggles: permissions
                ) { states in
                    store.saveAnswer(id: "permissions", value: states)
                    store.next()
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 12: Aims

struct AimsStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    private let aims = [
        ToggleRowData(
            id: "reduceVoiceStrain",
            title: "Do you aim to reduce voice strain?",
            initialValue: false
        ),
        ToggleRowData(
            id: "trainInMorning",
            title: "Do you like to train in the morning?",
            initialValue: false
        )
    ]
    
    var body: some View {
        GradientScreen {
            VStack(spacing: Theme.spacingLG) {
                VStack(spacing: Theme.spacingSM) {
                    Text("Aims")
                        .font(.deeperSubtitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text("What are your VoiceMaxxing goals?")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, Theme.spacingLG)
                
                ArtBlock(description: "Goal setting interface with voice transformation visualization")
                    .aspectRatio(16/9, contentMode: .fit)
                
                ToggleRowContainer(
                    title: "",
                    toggles: aims
                ) { states in
                    store.saveAnswer(id: "aims", value: states)
                    store.next()
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Step 13: Analyzing

struct AnalyzingStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen(
            title: "Analyzing",
            subtitle: "Processing your responses for personalized VoiceMaxxing"
        ) {
            VStack(spacing: Theme.spacingLG) {
                ArtBlock(description: "AI processing animation with voice analysis visualization")
                    .aspectRatio(16/9, contentMode: .fit)
                
                VStack(spacing: Theme.spacingMD) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.accent))
                        .scaleEffect(1.5)
                    
                    Text("Analyzing your responses...")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
                
                Spacer()
            }
        }
        .onAppear {
            // Auto-advance after analysis delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                store.next()
            }
        }
    }
}

// MARK: - Step 14: Habits Grid (Pre-rating)

struct HabitsGridStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen(
            title: "VoiceMaxxing Habits",
            subtitle: "Your personalized habit tracking grid"
        ) {
            VStack(spacing: Theme.spacingLG) {
                ArtBlock(description: "Habit grid interface with voice training activities")
                    .aspectRatio(16/9, contentMode: .fit)
                
                Text("Your personalized VoiceMaxxing routine is being prepared...")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

// MARK: - Step 15: Week Radar

struct WeekRadarStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen(
            title: "Weekly Progress Radar",
            subtitle: "Track your VoiceMaxxing progress"
        ) {
            VStack(spacing: Theme.spacingLG) {
                // Hex radar chart demonstration
                HexRadarChart(
                    values: [75, 60, 85, 70, 65, 80],
                    labels: ["Depth", "Resonance", "Clarity", "Power", "Control", "Consistency"],
                    comparisonValues: [60, 70, 75, 65, 60, 70],
                    comparisonColor: Theme.success.opacity(0.7)
                )
                .frame(width: 250, height: 250)
                .padding(.horizontal, Theme.spacingLG)
                
                Text("Your progress tracking system is being configured...")
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingLG)
                
                Spacer()
                
                PrimaryButton(title: "Continue") {
                    store.next()
                }
            }
        }
    }
}

// MARK: - Step 16: Pre-Rating (Analyzing Complete)

struct PreRatingStepView: View {
    @EnvironmentObject var store: OnboardingStore
    
    var body: some View {
        GradientScreen(
            title: "Ready for Assessment",
            subtitle: "Your VoiceMaxxing profile is complete"
        ) {
            VStack(spacing: Theme.spacingLG) {
                ArtBlock(description: "Assessment preparation with voice transformation visualization")
                    .aspectRatio(16/9, contentMode: .fit)
                
                VStack(spacing: Theme.spacingMD) {
                    Text("We've analyzed your responses and prepared your personalized VoiceMaxxing assessment.")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Theme.spacingLG)
                    
                    Text("Let's see your current voice rating!")
                        .font(.deeperBody)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.accent)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                PrimaryButton(title: "See My Rating") {
                    store.next()
                }
            }
        }
    }
}

#Preview {
    VStack {
        WelcomeStepView()
            .environmentObject(OnboardingStore())
    }
}
