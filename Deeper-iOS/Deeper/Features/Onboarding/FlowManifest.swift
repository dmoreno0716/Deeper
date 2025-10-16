import Foundation

// MARK: - Step Kind Enum

/// Defines all possible step types in the onboarding flow
/// Mirrors the TypeScript step types from the original flow.ts
enum StepKind: String, Codable, CaseIterable {
    case story = "story"
    case referral = "referral"
    case toggles = "toggles"
    case question = "question"
    case att = "att"
    case goals = "goals"
    case rating = "rating"
    case rpg = "rpg"
    case hardmode = "hardmode"
    case penalty = "penalty"
    case habitsGrid = "habitsGrid"
    case weekRadar = "weekRadar"
    case aiSchedule = "aiSchedule"
    case progressiveChart = "progressiveChart"
    case calendarWeek1 = "calendarWeek1"
    case commit = "commit"
    case vows = "vows"
    case lockin = "lockin"
    case personalMsg = "personalMsg"
    case paywall = "paywall"
}

// MARK: - Rating Label Enum

/// Labels for rating steps
enum RatingLabel: String, Codable, CaseIterable {
    case current = "current"
    case potential = "potential"
}

// MARK: - Stats Structure

/// VoiceMaxxing statistics structure
struct Stats: Codable, Equatable {
    let overall: Int
    let depth: Int
    let resonance: Int
    let clarity: Int
    let power: Int
    let control: Int
    let consistency: Int
    
    init(overall: Int = 0, depth: Int = 0, resonance: Int = 0, clarity: Int = 0, power: Int = 0, control: Int = 0, consistency: Int = 0) {
        self.overall = overall
        self.depth = depth
        self.resonance = resonance
        self.clarity = clarity
        self.power = power
        self.control = control
        self.consistency = consistency
    }
}

// MARK: - Step Payload Structures

/// Payload for rating steps
struct RatingPayload: Codable {
    let label: RatingLabel
    let stats: Stats?
    
    init(label: RatingLabel, stats: Stats? = nil) {
        self.label = label
        self.stats = stats
    }
}

/// Payload for week radar steps
struct WeekRadarPayload: Codable {
    let week: Int
    let theme: RadarTheme
    
    init(week: Int, theme: RadarTheme) {
        self.week = week
        self.theme = theme
    }
}

/// Payload for progressive chart steps
struct ProgressiveChartPayload: Codable {
    let metric: String
    
    init(metric: String) {
        self.metric = metric
    }
}

/// Radar theme enum
enum RadarTheme: String, Codable, CaseIterable {
    case voice = "voice"
    case habits = "habits"
    case progress = "progress"
    case mastery = "mastery"
}

// MARK: - Step Structure

/// Main step structure with Codable support
struct Step: Codable, Identifiable {
    let id: String
    let kind: StepKind
    let title: String
    let subtitle: String
    let artNote: String
    let payload: StepPayload?
    
    init(id: String, kind: StepKind, title: String, subtitle: String, artNote: String, payload: StepPayload? = nil) {
        self.id = id
        self.kind = kind
        self.title = title
        self.subtitle = subtitle
        self.artNote = artNote
        self.payload = payload
    }
}

// MARK: - Step Payload Union

/// Union type for step payloads
enum StepPayload: Codable {
    case rating(RatingPayload)
    case weekRadar(WeekRadarPayload)
    case progressiveChart(ProgressiveChartPayload)
    case stats(Stats)
    case string(String)
    case int(Int)
    case bool(Bool)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let ratingPayload = try? container.decode(RatingPayload.self) {
            self = .rating(ratingPayload)
        } else if let weekRadarPayload = try? container.decode(WeekRadarPayload.self) {
            self = .weekRadar(weekRadarPayload)
        } else if let progressiveChartPayload = try? container.decode(ProgressiveChartPayload.self) {
            self = .progressiveChart(progressiveChartPayload)
        } else if let stats = try? container.decode(Stats.self) {
            self = .stats(stats)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else {
            throw DecodingError.typeMismatch(StepPayload.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown payload type"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .rating(let payload):
            try container.encode(payload)
        case .weekRadar(let payload):
            try container.encode(payload)
        case .progressiveChart(let payload):
            try container.encode(payload)
        case .stats(let stats):
            try container.encode(stats)
        case .string(let string):
            try container.encode(string)
        case .int(let int):
            try container.encode(int)
        case .bool(let bool):
            try container.encode(bool)
        }
    }
}

// MARK: - Flow Manifest

/// Main flow manifest containing all onboarding steps
struct FlowManifest {
    
    /// Complete onboarding flow with all steps
    static let flow: [Step] = [
        // Step 1: Welcome/Story
        Step(
            id: "welcome",
            kind: .story,
            title: "Prepare to descend.",
            subtitle: "A deeper voice awaits.",
            artNote: "INSERT ART HERE: anime male hero holding a glowing tuning fork/flame, front pose on a runic pedestal"
        ),
        
        // Step 2: Art Style Selection
        Step(
            id: "artStyle",
            kind: .question,
            title: "Choose Your Art Style",
            subtitle: "Select the artistic style that resonates with you",
            artNote: "INSERT ART HERE: Art style selection interface - grid of artistic style previews with orange accent highlights"
        ),
        
        // Step 3: Name & Photo
        Step(
            id: "namePhoto",
            kind: .question,
            title: "Name & Photo",
            subtitle: "Tell us about yourself",
            artNote: "INSERT ART HERE: Profile creation interface with avatar customization options"
        ),
        
        // Step 4: Voice Training Hours
        Step(
            id: "voiceTrainHours",
            kind: .question,
            title: "Voice Training Hours",
            subtitle: "How many hours do you train per day?",
            artNote: "INSERT ART HERE: Time selection interface with voice training visualization"
        ),
        
        // Step 5: Breathwork Minutes
        Step(
            id: "breathworkMinutes",
            kind: .question,
            title: "Breathwork Minutes",
            subtitle: "How many minutes of breathwork do you practice?",
            artNote: "INSERT ART HERE: Breathing exercise visualization with rhythm indicators"
        ),
        
        // Step 6: Read Aloud Pages
        Step(
            id: "readAloudPages",
            kind: .question,
            title: "Read Aloud Pages",
            subtitle: "How many pages do you read aloud daily?",
            artNote: "INSERT ART HERE: Reading interface with voice projection visualization"
        ),
        
        // Step 7: Loud Environments Hours
        Step(
            id: "loudEnvironmentsHours",
            kind: .question,
            title: "Loud Environments",
            subtitle: "How many hours do you spend in loud environments?",
            artNote: "INSERT ART HERE: Environmental noise visualization with voice strain indicators"
        ),
        
        // Step 8: Steam Humidify Frequency
        Step(
            id: "steamHumidifyFrequency",
            kind: .question,
            title: "Steam & Humidify",
            subtitle: "How often do you use steam or humidification?",
            artNote: "INSERT ART HERE: Steam therapy visualization with throat health indicators"
        ),
        
        // Step 9: Extras Chooser
        Step(
            id: "extrasChooser",
            kind: .toggles,
            title: "Choose Extras",
            subtitle: "Select up to 2 additional features",
            artNote: "INSERT ART HERE: Feature selection interface with premium options"
        ),
        
        // Step 10: Down Glides Count
        Step(
            id: "downGlidesCount",
            kind: .question,
            title: "Down Glides Count",
            subtitle: "How many down glides do you practice?",
            artNote: "INSERT ART HERE: Vocal exercise demonstration with pitch visualization"
        ),
        
        // Step 11: Technique Study Daily
        Step(
            id: "techniqueStudyDaily",
            kind: .question,
            title: "Technique Study",
            subtitle: "Daily technique study time?",
            artNote: "INSERT ART HERE: Learning interface with technique progression visualization"
        ),
        
        // Step 12: Permissions
        Step(
            id: "permissions",
            kind: .att,
            title: "Permissions",
            subtitle: "Grant necessary permissions for VoiceMaxxing",
            artNote: "INSERT ART HERE: Permission request interface with privacy-focused design"
        ),
        
        // Step 13: Aims/Goals
        Step(
            id: "aims",
            kind: .goals,
            title: "Your Aims",
            subtitle: "What are your VoiceMaxxing goals?",
            artNote: "INSERT ART HERE: Goal setting interface with voice transformation visualization"
        ),
        
        // Step 14: Analyzing
        Step(
            id: "analyzing",
            kind: .story,
            title: "Analyzing",
            subtitle: "Processing your responses for personalized VoiceMaxxing",
            artNote: "INSERT ART HERE: AI processing animation with voice analysis visualization"
        ),
        
        // Step 15: Habits Grid
        Step(
            id: "habitsGrid",
            kind: .habitsGrid,
            title: "VoiceMaxxing Habits",
            subtitle: "Your personalized habit tracking grid",
            artNote: "INSERT ART HERE: Habit grid interface with voice training activities"
        ),
        
        // Step 16: Week Radar
        Step(
            id: "weekRadar",
            kind: .weekRadar,
            title: "Weekly Progress Radar",
            subtitle: "Track your VoiceMaxxing progress",
            artNote: "INSERT ART HERE: Radar chart visualization with voice metrics",
            payload: .weekRadar(WeekRadarPayload(week: 1, theme: .voice))
        ),
        
        // Step 17: Current Rating (REQUIRED)
        Step(
            id: "currentRating",
            kind: .rating,
            title: "Your Deeper Voice Rating",
            subtitle: "Current VoiceMaxxing assessment",
            artNote: "INSERT ART HERE: Rating dashboard with voice quality metrics",
            payload: .rating(RatingPayload(label: .current))
        ),
        
        // Step 18: Potential Rating (REQUIRED)
        Step(
            id: "potentialRating",
            kind: .rating,
            title: "Potential Rating",
            subtitle: "Your VoiceMaxxing potential",
            artNote: "INSERT ART HERE: Potential visualization with future voice transformation",
            payload: .rating(RatingPayload(label: .potential))
        ),
        
        // Step 19: Progressive Chart
        Step(
            id: "progressiveChart",
            kind: .progressiveChart,
            title: "Progress Tracking",
            subtitle: "Your VoiceMaxxing journey visualization",
            artNote: "INSERT ART HERE: Progress chart with voice improvement metrics",
            payload: .progressiveChart(ProgressiveChartPayload(metric: "voiceDepth"))
        ),
        
        // Step 20: RPG Elements
        Step(
            id: "rpg",
            kind: .rpg,
            title: "VoiceMaxxing Level",
            subtitle: "Your voice training RPG progress",
            artNote: "INSERT ART HERE: RPG interface with voice level progression"
        ),
        
        // Step 21: Hard Mode
        Step(
            id: "hardmode",
            kind: .hardmode,
            title: "Hard Mode Challenge",
            subtitle: "Take your VoiceMaxxing to the next level",
            artNote: "INSERT ART HERE: Challenge interface with advanced training options"
        ),
        
        // Step 22: Penalty System
        Step(
            id: "penalty",
            kind: .penalty,
            title: "VoiceMaxxing Accountability",
            subtitle: "Stay committed to your voice transformation",
            artNote: "INSERT ART HERE: Accountability interface with commitment tracking"
        ),
        
        // Step 23: AI Schedule
        Step(
            id: "aiSchedule",
            kind: .aiSchedule,
            title: "AI Training Schedule",
            subtitle: "Your personalized VoiceMaxxing routine",
            artNote: "INSERT ART HERE: AI-generated schedule interface with voice training timeline"
        ),
        
        // Step 24: Calendar Week 1
        Step(
            id: "calendarWeek1",
            kind: .calendarWeek1,
            title: "Week 1 Calendar",
            subtitle: "Your first week of VoiceMaxxing",
            artNote: "INSERT ART HERE: Calendar interface with voice training appointments"
        ),
        
        // Step 25: Commitment
        Step(
            id: "commit",
            kind: .commit,
            title: "Commit to VoiceMaxxing",
            subtitle: "Make your voice transformation promise",
            artNote: "INSERT ART HERE: Commitment interface with voice transformation visualization"
        ),
        
        // Step 26: Vows
        Step(
            id: "vows",
            kind: .vows,
            title: "VoiceMaxxing Vows",
            subtitle: "Your sacred voice training promises",
            artNote: "INSERT ART HERE: Vow ceremony interface with voice transformation ritual"
        ),
        
        // Step 27: Lock In
        Step(
            id: "lockin",
            kind: .lockin,
            title: "Lock In Your Progress",
            subtitle: "Secure your VoiceMaxxing commitment",
            artNote: "INSERT ART HERE: Lock-in interface with voice transformation security"
        ),
        
        // Step 28: Personal Message
        Step(
            id: "personalMsg",
            kind: .personalMsg,
            title: "Personal Message",
            subtitle: "Your VoiceMaxxing transformation begins now",
            artNote: "INSERT ART HERE: Personal message interface with voice transformation motivation"
        ),
        
        // Step 29: Paywall
        Step(
            id: "paywall",
            kind: .paywall,
            title: "Unlock Premium VoiceMaxxing",
            subtitle: "Access advanced voice transformation features",
            artNote: "INSERT ART HERE: Premium paywall interface with voice transformation benefits"
        )
    ]
    
    /// Get step by index (0-based)
    static func step(at index: Int) -> Step? {
        guard index >= 0 && index < flow.count else { return nil }
        return flow[index]
    }
    
    /// Get step by ID
    static func step(withId id: String) -> Step? {
        return flow.first { $0.id == id }
    }
    
    /// Get step index by ID
    static func index(forId id: String) -> Int? {
        return flow.firstIndex { $0.id == id }
    }
    
    /// Total number of steps
    static var count: Int {
        return flow.count
    }
    
    /// Verify that Step 17 = current rating and Step 18 = potential rating
    static func verifyRatingSteps() -> Bool {
        guard flow.count > 17 else { return false }
        
        let step17 = flow[16] // 0-based index
        let step18 = flow[17] // 0-based index
        
        return step17.id == "currentRating" && step18.id == "potentialRating"
    }
}

// MARK: - Flow Validation

extension FlowManifest {
    /// Validate the flow structure
    static func validateFlow() -> [String] {
        var errors: [String] = []
        
        // Check total steps
        if flow.count < 29 {
            errors.append("Flow should have at least 29 steps, found \(flow.count)")
        }
        
        // Verify rating steps are in correct positions
        if !verifyRatingSteps() {
            errors.append("Steps 17 and 18 must be currentRating and potentialRating respectively")
        }
        
        // Check for duplicate IDs
        let ids = flow.map { $0.id }
        let uniqueIds = Set(ids)
        if ids.count != uniqueIds.count {
            errors.append("Duplicate step IDs found")
        }
        
        // Check for required step kinds
        let requiredKinds: [StepKind] = [.rating, .paywall, .story, .question]
        for kind in requiredKinds {
            if !flow.contains(where: { $0.kind == kind }) {
                errors.append("Missing required step kind: \(kind)")
            }
        }
        
        // Check art notes
        for step in flow {
            if step.artNote.isEmpty {
                errors.append("Step '\(step.id)' missing art note")
            }
        }
        
        return errors
    }
}

#Preview {
    // This is just for SwiftUI preview support - the actual flow is static
    Text("Flow Manifest")
        .onAppear {
            let errors = FlowManifest.validateFlow()
            if !errors.isEmpty {
                print("Flow validation errors: \(errors)")
            } else {
                print("Flow validation passed!")
            }
            
            print("Total steps: \(FlowManifest.count)")
            print("Step 17 is current rating: \(FlowManifest.verifyRatingSteps())")
        }
}
