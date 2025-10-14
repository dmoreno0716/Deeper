import Foundation

// MARK: - Onboarding Answer Types
struct OnboardingAnswers: Codable {
    var aims: AimsData?
    var chosenExtras: [String]?
    var voiceTrainHours: Int?
    var breathworkMinutes: Int?
    var readAloudPages: Int?
    var loudEnvironmentsHours: Int?
    var steamHumidifyFrequency: Int?
    var downGlidesCount: Int?
    var techniqueStudyDaily: Int?
    var currentRating: Int?
    var potentialRating: Int?
    var artStyle: String?
    var name: String?
    var photo: Data?
}

struct AimsData: Codable {
    var reduceVoiceStrain: Bool?
    var trainInMorning: Bool?
}

// MARK: - Onboarding Step Enum
enum OnboardingStep: String, CaseIterable {
    case welcome = "Welcome"
    case artStyle = "ArtStyle"
    case namePhoto = "NamePhoto"
    case voiceTrainHours = "VoiceTrainHours"
    case breathworkMinutes = "BreathworkMinutes"
    case readAloudPages = "ReadAloudPages"
    case loudEnvironmentsHours = "LoudEnvironmentsHours"
    case steamHumidifyFrequency = "SteamHumidifyFrequency"
    case extrasChooser = "ExtrasChooser"
    case downGlidesCount = "DownGlidesCount"
    case techniqueStudyDaily = "TechniqueStudyDaily"
    case permissions = "Permissions"
    case aims = "Aims"
    case analyzing = "Analyzing"
    case currentRating = "CurrentRating"
    case potentialRating = "PotentialRating"
    
    var stepIndex: Int {
        return OnboardingStep.allCases.firstIndex(of: self) ?? 0
    }
    
    var progress: Double {
        return Double(stepIndex) / Double(OnboardingStep.allCases.count - 1)
    }
    
    var isLast: Bool {
        return self == OnboardingStep.allCases.last
    }
    
    var next: OnboardingStep? {
        let allCases = OnboardingStep.allCases
        let currentIndex = allCases.firstIndex(of: self) ?? 0
        let nextIndex = currentIndex + 1
        return nextIndex < allCases.count ? allCases[nextIndex] : nil
    }
}

// MARK: - Extras Options
struct ExtrasOptions {
    static let allOptions = [
        "Voice journal (log notes)",
        "Jaw & neck release",
        "Posture drill",
        "Tongue posture (mewing basics)",
        "Caffeine cap",
        "No smoke",
        "No alcohol",
        "Nasal breathing"
    ]
    
    static let maxSelection = 2
}
