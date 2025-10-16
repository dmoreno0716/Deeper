import SwiftUI

/// Demo view showing how to use HexRadarChart with Stats data
/// This can be used in rating steps or progress tracking screens
struct VoiceStatsChartView: View {
    let currentStats: Stats
    let previousStats: Stats?
    let title: String
    let subtitle: String?
    
    init(
        currentStats: Stats,
        previousStats: Stats? = nil,
        title: String = "Voice Analysis",
        subtitle: String? = nil
    ) {
        self.currentStats = currentStats
        self.previousStats = previousStats
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: Theme.spacingLG) {
            // Header
            VStack(spacing: Theme.spacingSM) {
                Text(title)
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            // Hex radar chart
            HexRadarChart(
                stats: currentStats,
                comparisonStats: previousStats,
                comparisonColor: Theme.success.opacity(0.7)
            )
            .frame(width: 280, height: 280)
            
            // Stats summary
            statsSummaryView
            
            // Legend
            if previousStats != nil {
                legendView
            }
        }
        .padding()
        .cardStyle()
    }
    
    // MARK: - Stats Summary
    
    @ViewBuilder
    private var statsSummaryView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Overall Score: \(currentStats.overall)")
                .font(.deeperBody)
                .fontWeight(.semibold)
                .foregroundColor(Theme.accent)
            
            HStack(spacing: Theme.spacingMD) {
                VStack(alignment: .leading, spacing: Theme.spacingXS) {
                    statRow("Depth", currentStats.depth, previousStats?.depth)
                    statRow("Resonance", currentStats.resonance, previousStats?.resonance)
                    statRow("Clarity", currentStats.clarity, previousStats?.clarity)
                }
                
                VStack(alignment: .leading, spacing: Theme.spacingXS) {
                    statRow("Power", currentStats.power, previousStats?.power)
                    statRow("Control", currentStats.control, previousStats?.control)
                    statRow("Consistency", currentStats.consistency, previousStats?.consistency)
                }
            }
        }
    }
    
    @ViewBuilder
    private func statRow(_ label: String, _ current: Int, _ previous: Int?) -> some View {
        HStack {
            Text(label)
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
                .frame(width: 70, alignment: .leading)
            
            Text("\(current)")
                .font(.deeperCaption)
                .fontWeight(.medium)
                .foregroundColor(Theme.textPrimary)
            
            if let previous = previous {
                let change = current - previous
                let changeText = change > 0 ? "+\(change)" : "\(change)"
                let changeColor = change > 0 ? Theme.success : (change < 0 ? Theme.danger : Theme.textSecondary)
                
                Text(changeText)
                    .font(.deeperCaption)
                    .foregroundColor(changeColor)
                    .fontWeight(.medium)
            }
        }
    }
    
    // MARK: - Legend
    
    @ViewBuilder
    private var legendView: some View {
        HStack(spacing: Theme.spacingLG) {
            HStack(spacing: Theme.spacingXS) {
                Circle()
                    .fill(Theme.accent.opacity(0.8))
                    .frame(width: 8, height: 8)
                Text("Current")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            HStack(spacing: Theme.spacingXS) {
                Circle()
                    .fill(Theme.success.opacity(0.7))
                    .frame(width: 8, height: 8)
                Text("Previous")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        VoiceStatsChartView(
            currentStats: Stats(
                overall: 72,
                depth: 75,
                resonance: 60,
                clarity: 85,
                power: 70,
                control: 65,
                consistency: 80
            ),
            previousStats: Stats(
                overall: 68,
                depth: 60,
                resonance: 70,
                clarity: 75,
                power: 65,
                control: 60,
                consistency: 70
            ),
            title: "Current Voice Rating",
            subtitle: "Your voice analysis results"
        )
        
        VoiceStatsChartView(
            currentStats: Stats(
                overall: 85,
                depth: 90,
                resonance: 80,
                clarity: 85,
                power: 90,
                control: 85,
                consistency: 80
            ),
            title: "Potential Voice Rating",
            subtitle: "Your voice potential after VoiceMaxxing"
        )
    }
    .padding()
    .background(Theme.background)
}
