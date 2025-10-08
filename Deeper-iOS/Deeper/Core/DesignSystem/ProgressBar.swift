import SwiftUI

struct ProgressBar: View {
    let progress: Double // 0.0 to 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.accent)
                    .frame(height: 4)
                    .frame(width: max(0, progress * UIScreen.main.bounds.width - Theme.spacingLG * 2))
                    .shadow(color: Theme.accent.opacity(0.8), radius: 4)
                
                Spacer(minLength: 0)
            }
            .frame(height: 4)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Theme.textSecondary.opacity(0.2))
            )
        }
        .padding(.horizontal, Theme.spacingLG)
        .padding(.vertical, Theme.spacingMD)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(progress: 0.0)
        ProgressBar(progress: 0.25)
        ProgressBar(progress: 0.5)
        ProgressBar(progress: 0.75)
        ProgressBar(progress: 1.0)
    }
    .background(Theme.background)
}
