import SwiftUI

/// A reusable 6-axis hex/radar chart component
/// Displays voice statistics in a hexagonal radar chart format
struct HexRadarChart: View {
    let values: [Double] // 6 values for the 6 axes (0-100)
    let labels: [String] // 6 labels for each axis
    let comparisonValues: [Double]? // Optional comparison overlay
    let comparisonColor: Color // Color for comparison overlay
    
    @State private var animationProgress: Double = 0
    
    init(
        values: [Double],
        labels: [String],
        comparisonValues: [Double]? = nil,
        comparisonColor: Color = Theme.textSecondary.opacity(0.6)
    ) {
        assert(values.count == 6, "HexRadarChart requires exactly 6 values")
        assert(labels.count == 6, "HexRadarChart requires exactly 6 labels")
        assert(comparisonValues?.count == 6 || comparisonValues == nil, "Comparison values must be 6 or nil")
        
        self.values = values.map { max(0, min(100, $0)) } // Clamp to 0-100
        self.labels = labels
        self.comparisonValues = comparisonValues?.map { max(0, min(100, $0)) }
        self.comparisonColor = comparisonColor
    }
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = size * 0.35 // Chart radius
            
            ZStack {
                // Background glow effect
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Theme.accent.opacity(0.1),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: radius * 1.2
                        )
                    )
                    .frame(width: radius * 2.4, height: radius * 2.4)
                    .position(center)
                
                // Grid rings
                ForEach(0..<5, id: \.self) { ring in
                    let ringRadius = radius * (Double(ring + 1) / 5.0)
                    HexagonShape()
                        .stroke(
                            Theme.textSecondary.opacity(0.15),
                            lineWidth: 1
                        )
                        .frame(width: ringRadius * 2, height: ringRadius * 2)
                        .position(center)
                }
                
                // Axis lines
                ForEach(0..<6, id: \.self) { axis in
                    let angle = Double(axis) * .pi / 3.0 - .pi / 2.0 // Start from top
                    let endX = center.x + radius * cos(angle)
                    let endY = center.y + radius * sin(angle)
                    
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: CGPoint(x: endX, y: endY))
                    }
                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                }
                
                // Comparison overlay (if provided) - shown as thin stroke
                if let comparisonValues = comparisonValues {
                    HexagonPath(values: comparisonValues, center: center, radius: radius)
                        .stroke(comparisonColor, lineWidth: 1.5)
                        .opacity(0.8)
                }
                
                // Main data polygon - shown as solid fill with stroke
                HexagonPath(values: animatedValues, center: center, radius: radius)
                    .fill(Theme.accent.opacity(0.25))
                    .overlay(
                        HexagonPath(values: animatedValues, center: center, radius: radius)
                            .stroke(Theme.accent.opacity(0.8), lineWidth: 2)
                    )
                
                // Data points
                ForEach(0..<6, id: \.self) { index in
                    let angle = Double(index) * .pi / 3.0 - .pi / 2.0
                    let value = animatedValues[index]
                    let pointRadius = radius * (value / 100.0)
                    let x = center.x + pointRadius * cos(angle)
                    let y = center.y + pointRadius * sin(angle)
                    
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 6, height: 6)
                        .position(x: x, y: y)
                        .shadow(color: Theme.accent.opacity(0.5), radius: 3, x: 0, y: 0)
                }
                
                // Labels
                ForEach(0..<6, id: \.self) { index in
                    let angle = Double(index) * .pi / 3.0 - .pi / 2.0
                    let labelRadius = radius * 1.15
                    let x = center.x + labelRadius * cos(angle)
                    let y = center.y + labelRadius * sin(angle)
                    
                    Text(labels[index])
                        .font(.deeperCaption)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 60)
                        .position(x: x, y: y)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animationProgress = 1.0
            }
        }
        .onChange(of: values) { _ in
            animationProgress = 0
            withAnimation(.easeInOut(duration: 0.8)) {
                animationProgress = 1.0
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var animatedValues: [Double] {
        return values.map { $0 * animationProgress }
    }
}

// MARK: - Hexagon Shape

/// Custom hexagon shape for grid rings
struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        var path = Path()
        
        for i in 0..<6 {
            let angle = Double(i) * .pi / 3.0 - .pi / 2.0
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Hexagon Path Helper

/// Creates a hexagon path based on values and center point
func HexagonPath(values: [Double], center: CGPoint, radius: CGFloat) -> Path {
    var path = Path()
    
    for i in 0..<6 {
        let angle = Double(i) * .pi / 3.0 - .pi / 2.0
        let value = values[i]
        let pointRadius = radius * (value / 100.0)
        let x = center.x + pointRadius * cos(angle)
        let y = center.y + pointRadius * sin(angle)
        
        if i == 0 {
            path.move(to: CGPoint(x: x, y: y))
        } else {
            path.addLine(to: CGPoint(x: x, y: y))
        }
    }
    
    path.closeSubpath()
    return path
}

// MARK: - Stats Convenience Initializer

extension HexRadarChart {
    /// Convenience initializer using Stats structure
    init(
        stats: Stats,
        comparisonStats: Stats? = nil,
        comparisonColor: Color = Theme.textSecondary.opacity(0.6)
    ) {
        let values = [
            Double(stats.depth),
            Double(stats.resonance),
            Double(stats.clarity),
            Double(stats.power),
            Double(stats.control),
            Double(stats.consistency)
        ]
        
        let labels = [
            "Depth",
            "Resonance",
            "Clarity",
            "Power",
            "Control",
            "Consistency"
        ]
        
        let comparisonValues = comparisonStats.map { stats in
            [
                Double(stats.depth),
                Double(stats.resonance),
                Double(stats.clarity),
                Double(stats.power),
                Double(stats.control),
                Double(stats.consistency)
            ]
        }
        
        self.init(
            values: values,
            labels: labels,
            comparisonValues: comparisonValues,
            comparisonColor: comparisonColor
        )
    }
}

// MARK: - Voice Stats Labels

extension HexRadarChart {
    /// VoiceMaxxing-specific labels for the hex chart
    static let voiceLabels = [
        "Depth",
        "Resonance", 
        "Clarity",
        "Power",
        "Control",
        "Consistency"
    ]
    
    /// Create a chart with voice-specific labels
    static func voiceChart(
        values: [Double],
        comparisonValues: [Double]? = nil,
        comparisonColor: Color = Theme.textSecondary.opacity(0.6)
    ) -> HexRadarChart {
        return HexRadarChart(
            values: values,
            labels: voiceLabels,
            comparisonValues: comparisonValues,
            comparisonColor: comparisonColor
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("VoiceMaxxing Stats")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
        
        HexRadarChart(
            values: [75, 60, 85, 70, 65, 80],
            labels: ["Depth", "Resonance", "Clarity", "Power", "Control", "Consistency"]
        )
        .frame(width: 300, height: 300)
        
        Text("With Comparison")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
        
        HexRadarChart(
            values: [75, 60, 85, 70, 65, 80],
            labels: ["Depth", "Resonance", "Clarity", "Power", "Control", "Consistency"],
            comparisonValues: [60, 70, 75, 65, 60, 70],
            comparisonColor: Theme.success.opacity(0.7)
        )
        .frame(width: 300, height: 300)
        
        Text("Using Stats Structure")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
        
        HexRadarChart(
            stats: Stats(
                overall: 0,
                depth: 75,
                resonance: 60,
                clarity: 85,
                power: 70,
                control: 65,
                consistency: 80
            ),
            comparisonStats: Stats(
                overall: 0,
                depth: 60,
                resonance: 70,
                clarity: 75,
                power: 65,
                control: 60,
                consistency: 70
            )
        )
        .frame(width: 300, height: 300)
    }
    .padding()
    .background(Theme.background)
}