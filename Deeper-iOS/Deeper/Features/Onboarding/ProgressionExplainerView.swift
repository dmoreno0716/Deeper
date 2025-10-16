import SwiftUI
import Charts

/// Progression explainer view with Swift Charts line chart showing "With Deeper vs Without Deeper"
struct ProgressionExplainerView: View {
    let onContinue: () -> Void
    
    @State private var showChart: Bool = false
    
    private let progressionData = [
        ProgressionPoint(week: 0, withDeeper: 50, withoutDeeper: 50),
        ProgressionPoint(week: 1, withDeeper: 55, withoutDeeper: 52),
        ProgressionPoint(week: 2, withDeeper: 62, withoutDeeper: 54),
        ProgressionPoint(week: 3, withDeeper: 68, withoutDeeper: 56),
        ProgressionPoint(week: 4, withDeeper: 75, withoutDeeper: 58),
        ProgressionPoint(week: 5, withDeeper: 82, withoutDeeper: 60),
        ProgressionPoint(week: 6, withDeeper: 88, withoutDeeper: 62),
        ProgressionPoint(week: 7, withDeeper: 92, withoutDeeper: 63),
        ProgressionPoint(week: 8, withDeeper: 95, withoutDeeper: 64),
        ProgressionPoint(week: 9, withDeeper: 97, withoutDeeper: 65),
        ProgressionPoint(week: 10, withDeeper: 98, withoutDeeper: 65)
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 0.9)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                ScrollView {
                    VStack(spacing: Theme.spacingXL) {
                        // Header
                        headerView
                        
                        // Art block
                        artBlockView
                        
                        // Progression chart
                        if showChart {
                            progressionChart
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        // Footer note
                        footerNote
                        
                        // Continue button
                        continueButton
                            .padding(.bottom, Theme.spacingXXXL)
                    }
                    .padding(.horizontal, Theme.spacingLG)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showChart = true
            }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Voice Progression")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("See the difference VoiceMaxxing makes")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Progression chart visualization with voice improvement curves")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var progressionChart: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("10-Week Progression Comparison")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            // Swift Charts line chart
            Chart {
                // With Deeper line
                ForEach(progressionData, id: \.week) { point in
                    LineMark(
                        x: .value("Week", point.week),
                        y: .value("Voice Score", point.withDeeper)
                    )
                    .foregroundStyle(Theme.accent)
                    .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
                    .interpolationMethod(.catmullRom)
                }
                
                // Without Deeper line
                ForEach(progressionData, id: \.week) { point in
                    LineMark(
                        x: .value("Week", point.week),
                        y: .value("Voice Score", point.withoutDeeper)
                    )
                    .foregroundStyle(Theme.textSecondary)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, dash: [5, 3]))
                    .interpolationMethod(.catmullRom)
                }
                
                // Data points for With Deeper
                ForEach(progressionData, id: \.week) { point in
                    PointMark(
                        x: .value("Week", point.week),
                        y: .value("Voice Score", point.withDeeper)
                    )
                    .foregroundStyle(Theme.accent)
                    .symbolSize(40)
                }
                
                // Data points for Without Deeper
                ForEach(progressionData, id: \.week) { point in
                    PointMark(
                        x: .value("Week", point.week),
                        y: .value("Voice Score", point.withoutDeeper)
                    )
                    .foregroundStyle(Theme.textSecondary)
                    .symbolSize(30)
                }
            }
            .frame(height: 250)
            .chartXAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                        .foregroundStyle(Theme.textSecondary.opacity(0.2))
                    AxisTick()
                        .foregroundStyle(Theme.textSecondary)
                    AxisValueLabel()
                        .foregroundStyle(Theme.textSecondary)
                        .font(.deeperCaption)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                        .foregroundStyle(Theme.textSecondary.opacity(0.2))
                    AxisTick()
                        .foregroundStyle(Theme.textSecondary)
                    AxisValueLabel()
                        .foregroundStyle(Theme.textSecondary)
                        .font(.deeperCaption)
                }
            }
            .chartLegend(position: .top, alignment: .center) {
                HStack(spacing: Theme.spacingLG) {
                    HStack(spacing: Theme.spacingXS) {
                        Rectangle()
                            .fill(Theme.accent)
                            .frame(width: 16, height: 3)
                            .cornerRadius(1.5)
                        Text("With VoiceMaxxing")
                            .font(.deeperCaption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    HStack(spacing: Theme.spacingXS) {
                        Rectangle()
                            .fill(Theme.textSecondary)
                            .frame(width: 16, height: 2)
                            .cornerRadius(1)
                            .overlay(
                                Rectangle()
                                    .stroke(Theme.textSecondary, lineWidth: 1)
                            )
                        Text("Without VoiceMaxxing")
                            .font(.deeperCaption)
                            .foregroundColor(Theme.textSecondary)
                    }
                }
            }
            
            // Key insights
            insightsView
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.textSecondary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var insightsView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Key Insights")
                .font(.deeperBody)
                .fontWeight(.semibold)
                .foregroundColor(Theme.accent)
            
            VStack(alignment: .leading, spacing: Theme.spacingXS) {
                insightRow("48% faster improvement", Theme.success)
                insightRow("Reach 90% potential by week 7", Theme.warning)
                insightRow("Sustained long-term growth", Theme.accent)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.accent.opacity(0.05))
        )
    }
    
    @ViewBuilder
    private func insightRow(_ text: String, _ color: Color) -> some View {
        HStack(spacing: Theme.spacingSM) {
            Circle()
                .fill(color)
                .frame(width: 6, height: 6)
            
            Text(text)
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
        }
    }
    
    @ViewBuilder
    private var footerNote: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Week 6 Breakthrough")
                .font(.deeperBody)
                .fontWeight(.semibold)
                .foregroundColor(Theme.accent)
            
            Text("Most users experience a significant breakthrough around week 6, where voice changes become noticeable to others. This is when the compound effects of consistent training truly manifest.")
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.accent.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
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

// MARK: - Progression Point Data

struct ProgressionPoint {
    let week: Int
    let withDeeper: Int
    let withoutDeeper: Int
}

// MARK: - Progression Explainer Step View

/// Step view for progression explainer screens
struct ProgressionExplainerStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        ProgressionExplainerView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    ProgressionExplainerView {
        print("Continue tapped")
    }
}
