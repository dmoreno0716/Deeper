import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.textPrimary))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.deeperBody)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.textPrimary)
                }
            }
            .frame(minHeight: 48)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Theme.spacingXL)
            .padding(.vertical, Theme.spacingMD)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isDisabled ? Theme.textSecondary : Theme.accent)
                    .shadow(
                        color: isDisabled ? .clear : Theme.accent.opacity(0.3),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint(isDisabled ? "Button is disabled" : "Double tap to activate")
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Primary Button", action: {})
        
        PrimaryButton(title: "Loading Button", action: {}, isLoading: true)
        
        PrimaryButton(title: "Disabled Button", action: {}, isDisabled: true)
    }
    .padding()
    .background(Theme.background)
}