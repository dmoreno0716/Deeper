import SwiftUI

struct ProgressBar: View {
    let progress: Double // 0.0 to 1.0
    var style: ProgressBarStyle = .default
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track (background)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.textSecondary.opacity(0.12))
                    .frame(height: 4)
                
                // Fill (progress)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.accent)
                    .frame(width: geometry.size.width * max(0, min(1, progress)), height: 4)
                    .shadow(
                        color: Theme.accent.opacity(0.8),
                        radius: 4,
                        x: 0,
                        y: 0
                    )
                    .animation(.easeInOut(duration: 0.2), value: progress)
            }
        }
        .frame(height: 4)
        .padding(.horizontal, Theme.spacingLG)
        .padding(.vertical, Theme.spacingMD)
        .accessibilityLabel("Progress indicator")
        .accessibilityValue("\(Int(progress * 100))% complete")
    }
}

enum ProgressBarStyle {
    case `default`
    case thick // Alternative style for thicker progress bars
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(progress: 0.0)
        ProgressBar(progress: 0.3)
        ProgressBar(progress: 0.7)
        ProgressBar(progress: 1.0)
    }
    .padding()
    .background(Theme.background)
}