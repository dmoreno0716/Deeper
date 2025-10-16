import SwiftUI

/// Full-screen rating view for current and potential voice ratings
/// Displays overall score, hex radar chart, and metric cards
struct RatingView: View {
    let label: RatingLabel
    let stats: Stats
    let comparisonStats: Stats?
    let onContinue: () -> Void
    
    @State private var showChart: Bool = false
    @State private var showCards: Bool = false
    
    init(
        label: RatingLabel,
        stats: Stats,
        comparisonStats: Stats? = nil,
        onContinue: @escaping () -> Void
    ) {
        self.label = label
        self.stats = stats
        self.comparisonStats = comparisonStats
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
                        
                        // Overall score card
                        overallScoreCard
                        
                        // Hex radar chart
                        if showChart {
                            hexChartView
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        // Metric cards grid
                        if showCards {
                            metricCardsGrid
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
                showCards = true
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var progressValue: Double {
        switch label {
        case .current:
            return 0.8
        case .potential:
            return 0.9
        }
    }
    
    private var titleText: String {
        switch label {
        case .current:
            return "Your Deeper Voice Rating"
        case .potential:
            return "Your VoiceMaxxing Potential"
        }
    }
    
    private var subtitleText: String {
        switch label {
        case .current:
            return "Current VoiceMaxxing assessment"
        case .potential:
            return "Your voice potential after VoiceMaxxing"
        }
    }
    
    private var continueButtonTitle: String {
        switch label {
        case .current:
            return "See potential rating"
        case .potential:
            return "See how I will improve"
        }
    }
    
    private var chartTitle: String {
        switch label {
        case .current:
            return "Voice Analysis"
        case .potential:
            return "Current vs Potential"
        }
    }
    
    private var comparisonColor: Color {
        switch label {
        case .current:
            return Theme.success.opacity(0.7)
        case .potential:
            return Theme.textSecondary.opacity(0.6)
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
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var overallScoreCard: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Overall")
                .font(.deeperSubtitle)
                .fontWeight(.medium)
                .foregroundColor(Theme.textSecondary)
            
            Text("\(stats.overall)")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(Theme.accent)
                .shadow(color: Theme.accent.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.spacingXL)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Theme.accent.opacity(0.2), lineWidth: 2)
                )
        )
        .shadow(color: Theme.accent.opacity(0.1), radius: 12, x: 0, y: 6)
    }
    
    @ViewBuilder
    private var hexChartView: some View {
        VStack(spacing: Theme.spacingMD) {
            Text(chartTitle)
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            HexRadarChart(
                stats: stats,
                comparisonStats: comparisonStats,
                comparisonColor: comparisonColor
            )
            .frame(width: 280, height: 280)
            
            // Legend for potential rating
            if label == .potential && comparisonStats != nil {
                legendView
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.card.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.textSecondary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var metricCardsGrid: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Detailed Metrics")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Theme.spacingMD),
                    GridItem(.flexible(), spacing: Theme.spacingMD)
                ],
                spacing: Theme.spacingMD
            ) {
                ForEach(metricCards, id: \.label) { card in
                    MetricCard(
                        label: card.label,
                        score: card.score,
                        comparisonScore: card.comparisonScore,
                        showDeltaBadge: label == .potential
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    private var continueButton: some View {
        PrimaryButton(title: continueButtonTitle) {
            onContinue()
        }
    }
    
    @ViewBuilder
    private var legendView: some View {
        HStack(spacing: Theme.spacingLG) {
            HStack(spacing: Theme.spacingXS) {
                Circle()
                    .fill(Theme.accent.opacity(0.8))
                    .frame(width: 8, height: 8)
                Text("Potential")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            HStack(spacing: Theme.spacingXS) {
                Circle()
                    .stroke(Theme.textSecondary.opacity(0.6), lineWidth: 2)
                    .frame(width: 8, height: 8)
                Text("Current")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
    
    // MARK: - Data Helpers
    
    private var metricCards: [MetricCardData] {
        let cards = [
            MetricCardData(label: "Overall", score: stats.overall, comparisonScore: comparisonStats?.overall),
            MetricCardData(label: "Resonance", score: stats.resonance, comparisonScore: comparisonStats?.resonance),
            MetricCardData(label: "Breath", score: stats.clarity, comparisonScore: comparisonStats?.clarity),
            MetricCardData(label: "Technique", score: stats.power, comparisonScore: comparisonStats?.power),
            MetricCardData(label: "Consistency", score: stats.consistency, comparisonScore: comparisonStats?.consistency),
            MetricCardData(label: "Confidence", score: stats.control, comparisonScore: comparisonStats?.control)
        ]
        
        return cards
    }
}

// MARK: - Metric Card Data

struct MetricCardData {
    let label: String
    let score: Int
    let comparisonScore: Int?
}

// MARK: - Metric Card Component

struct MetricCard: View {
    let label: String
    let score: Int
    let comparisonScore: Int?
    let showDeltaBadge: Bool
    
    init(label: String, score: Int, comparisonScore: Int?, showDeltaBadge: Bool = false) {
        self.label = label
        self.score = score
        self.comparisonScore = comparisonScore
        self.showDeltaBadge = showDeltaBadge
    }
    
    var body: some View {
        VStack(spacing: Theme.spacingSM) {
            HStack {
                Text(label)
                    .font(.deeperBody)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // Delta badge for potential rating
                if showDeltaBadge, let comparisonScore = comparisonScore {
                    deltaBadge(current: comparisonScore, potential: score)
                }
            }
            
            Text("\(score)")
                .font(.deeperSubtitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
            
            if let comparisonScore = comparisonScore, !showDeltaBadge {
                let change = score - comparisonScore
                let changeText = change > 0 ? "+\(change)" : "\(change)"
                let changeColor = change > 0 ? Theme.success : (change < 0 ? Theme.danger : Theme.textSecondary)
                
                Text(changeText)
                    .font(.deeperCaption)
                    .fontWeight(.medium)
                    .foregroundColor(changeColor)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.textSecondary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private func deltaBadge(current: Int, potential: Int) -> some View {
        let delta = potential - current
        if delta > 0 {
            HStack(spacing: 2) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 8, weight: .bold))
                Text("+\(delta)")
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(
                Capsule()
                    .fill(Theme.success)
            )
        }
    }
}

// MARK: - Rating Calculation Helper

extension RatingView {
    /// Calculate voice stats based on onboarding answers
    static func calculateStats(from answers: [String: CodableValue]) -> Stats {
        // Extract values from answers
        let voiceTrainHours = answers["voiceTrainHours"]?.doubleValue ?? 0
        let breathworkMinutes = answers["breathworkMinutes"]?.doubleValue ?? 0
        let readAloudPages = answers["readAloudPages"]?.doubleValue ?? 0
        let loudEnvironmentsHours = answers["loudEnvironmentsHours"]?.doubleValue ?? 0
        let steamHumidifyFrequency = answers["steamHumidifyFrequency"]?.doubleValue ?? 0
        let downGlidesCount = answers["downGlidesCount"]?.doubleValue ?? 0
        let techniqueStudyDaily = answers["techniqueStudyDaily"]?.doubleValue ?? 0
        
        // Extract aims
        let aims = answers["aims"]?.dictionaryValue ?? [:]
        let reduceVoiceStrain = aims["reduceVoiceStrain"]?.boolValue ?? false
        let trainInMorning = aims["trainInMorning"]?.boolValue ?? false
        
        // Calculate scores (0-100) based on collected data
        let overall = min(100, max(0, 
            (voiceTrainHours * 2) + 
            (breathworkMinutes * 0.5) + 
            (readAloudPages * 1.5) + 
            (techniqueStudyDaily * 0.3) + 
            (reduceVoiceStrain ? 20 : 0) + 
            (trainInMorning ? 10 : 0) - 
            (loudEnvironmentsHours * 3)
        ))
        
        let resonance = min(100, max(0, 
            (voiceTrainHours * 1.5) + 
            (steamHumidifyFrequency * 2) + 
            (downGlidesCount * 1.2) + 
            (reduceVoiceStrain ? 15 : 0)
        ))
        
        let breath = min(100, max(0, 
            (breathworkMinutes * 1.2) + 
            (steamHumidifyFrequency * 1.5) + 
            (techniqueStudyDaily * 0.4) + 
            (trainInMorning ? 8 : 0)
        ))
        
        let technique = min(100, max(0, 
            (techniqueStudyDaily * 1.8) + 
            (voiceTrainHours * 1.2) + 
            (downGlidesCount * 1.0) + 
            (readAloudPages * 0.8)
        ))
        
        let consistency = min(100, max(0, 
            (voiceTrainHours * 1.0) + 
            (breathworkMinutes * 0.8) + 
            (readAloudPages * 1.0) + 
            (trainInMorning ? 12 : 0) + 
            (reduceVoiceStrain ? 10 : 0)
        ))
        
        let confidence = min(100, max(0, 
            (voiceTrainHours * 1.3) + 
            (techniqueStudyDaily * 1.5) + 
            (readAloudPages * 1.2) + 
            (downGlidesCount * 0.9) + 
            (trainInMorning ? 15 : 0)
        ))
        
        return Stats(
            overall: Int(round(overall)),
            depth: Int(round(resonance)), // Using resonance for depth field
            resonance: Int(round(resonance)),
            clarity: Int(round(breath)), // Using breath for clarity field
            power: Int(round(technique)), // Using technique for power field
            control: Int(round(confidence)), // Using confidence for control field
            consistency: Int(round(consistency))
        )
    }
    
    /// Calculate potential stats (enhanced version of current stats)
    static func calculatePotentialStats(from currentStats: Stats) -> Stats {
        return Stats(
            overall: min(100, currentStats.overall + 15),
            depth: min(100, currentStats.depth + 20),
            resonance: min(100, currentStats.resonance + 18),
            clarity: min(100, currentStats.clarity + 12),
            power: min(100, currentStats.power + 25),
            control: min(100, currentStats.control + 22),
            consistency: min(100, currentStats.consistency + 16)
        )
    }
}

// MARK: - CodableValue Extensions

extension CodableValue {
    var doubleValue: Double {
        switch self {
        case .double(let value):
            return value
        case .int(let value):
            return Double(value)
        default:
            return 0
        }
    }
    
    var boolValue: Bool {
        switch self {
        case .bool(let value):
            return value
        default:
            return false
        }
    }
    
    var dictionaryValue: [String: CodableValue] {
        switch self {
        case .dictionary(let value):
            return value
        default:
            return [:]
        }
    }
}

// MARK: - Preview

#Preview {
    RatingView(
        label: .current,
        stats: Stats(
            overall: 72,
            depth: 75,
            resonance: 60,
            clarity: 85,
            power: 70,
            control: 65,
            consistency: 80
        ),
        comparisonStats: Stats(
            overall: 68,
            depth: 60,
            resonance: 70,
            clarity: 75,
            power: 65,
            control: 60,
            consistency: 70
        )
    ) {
        print("Continue tapped")
    }
}
