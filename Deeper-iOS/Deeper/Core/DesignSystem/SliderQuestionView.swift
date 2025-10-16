import SwiftUI
import UIKit

/// Slider-based question input component
/// Equivalent to SliderQuestion.tsx from Expo
struct SliderQuestionView: View {
    let title: String
    let range: ClosedRange<Double>
    let step: Double
    let unit: String
    let confirmCallback: (Double) -> Void
    
    @State private var currentValue: Double
    @State private var isDragging: Bool = false
    
    init(
        title: String,
        range: ClosedRange<Double>,
        step: Double = 0.5,
        unit: String = "",
        initialValue: Double? = nil,
        confirmCallback: @escaping (Double) -> Void
    ) {
        self.title = title
        self.range = range
        self.step = step
        self.unit = unit
        self.confirmCallback = confirmCallback
        self._currentValue = State(initialValue: initialValue ?? range.lowerBound)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingLG) {
            // Title
            Text(title)
                .font(.deeperSubtitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.leading)
            
            // Slider track
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                        )
                        .frame(height: 44)
                    
                    // Fill track (progress)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.accent.opacity(0.3))
                        .frame(width: trackFillWidth(in: geometry), height: 44)
                        .animation(.easeInOut(duration: 0.1), value: currentValue)
                    
                    // Tick marks
                    HStack(spacing: 0) {
                        ForEach(0..<tickCount, id: \.self) { _ in
                            Rectangle()
                                .fill(Theme.textSecondary.opacity(0.3))
                                .frame(width: 2, height: 12)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, Theme.spacingMD)
                    
                    // Thumb (draggable handle)
                    Circle()
                        .fill(Theme.accent)
                        .frame(width: 24, height: 24)
                        .shadow(
                            color: Theme.accent.opacity(0.4),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                        .offset(x: thumbOffset(in: geometry))
                        .animation(.easeInOut(duration: 0.1), value: currentValue)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !isDragging {
                                        // Haptic feedback on start
                                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                        impactFeedback.impactOccurred()
                                    }
                                    isDragging = true
                                    updateValue(from: value.location.x, in: geometry)
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    // Haptic feedback on end
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                    impactFeedback.impactOccurred()
                                }
                        )
                }
                .padding(.horizontal, Theme.spacingMD)
            }
            .frame(height: 44)
            
            // Current value label
            Text(currentValueLabel)
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .animation(.easeInOut(duration: 0.2), value: currentValue)
            
            // Confirm button
            PrimaryButton(title: "Confirm") {
                confirmCallback(currentValue)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var tickCount: Int {
        return Int((range.upperBound - range.lowerBound) / step) + 1
    }
    
    private var currentValueLabel: String {
        let normalizedValue = (currentValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        
        if normalizedValue <= 0 {
            return "I don't train"
        }
        
        let formattedValue = currentValue.truncatingRemainder(dividingBy: 1) == 0 
            ? String(format: "%.0f", currentValue)
            : String(format: "%.1f", currentValue)
        
        return "~\(formattedValue) \(unit)"
    }
    
    // MARK: - Helper Methods
    
    private func trackFillWidth(in geometry: GeometryProxy) -> CGFloat {
        let progress = (currentValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        return geometry.size.width * progress
    }
    
    private func thumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let progress = (currentValue - range.lowerBound) / (range.upperBound - range.lowerBound)
        let availableWidth = geometry.size.width - 24 // Account for thumb width
        return progress * availableWidth - 12 // Center the thumb
    }
    
    private func updateValue(from x: CGFloat, in geometry: GeometryProxy) {
        let progress = max(0, min(1, x / geometry.size.width))
        let rawValue = range.lowerBound + progress * (range.upperBound - range.lowerBound)
        let snappedValue = snapToStep(rawValue)
        currentValue = max(range.lowerBound, min(range.upperBound, snappedValue))
    }
    
    private func snapToStep(_ value: Double) -> Double {
        return round(value / step) * step
    }
}

// MARK: - Accessibility Support

extension SliderQuestionView {
    /// Accessibility configuration for the slider
    var accessibilityConfig: some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(title)
            .accessibilityValue(currentValueLabel)
            .accessibilityAdjustableAction { direction in
                let increment = direction == .increment ? step : -step
                let newValue = max(range.lowerBound, min(range.upperBound, currentValue + increment))
                currentValue = newValue
                
                // Haptic feedback for accessibility
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
            }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        SliderQuestionView(
            title: "How many hours do you usually train your voice in a week?",
            range: 0...10,
            step: 0.5,
            unit: "hours/week",
            initialValue: 2.0
        ) { value in
            print("Selected value: \(value)")
        }
        .accessibilityConfig
    }
    .padding()
    .background(Theme.background)
}
