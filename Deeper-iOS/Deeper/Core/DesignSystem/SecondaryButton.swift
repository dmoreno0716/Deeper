import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    var isLoading: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Theme.accent))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.deeperBody)
                        .fontWeight(.semibold)
                        .foregroundColor(isDisabled ? Theme.textSecondary : Theme.accent)
                }
            }
            .frame(minHeight: 48)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Theme.spacingXL)
            .padding(.vertical, Theme.spacingMD)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isDisabled ? Theme.textSecondary : Theme.accent,
                        lineWidth: 2
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
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
        SecondaryButton(title: "Secondary Button", action: {})
        
        SecondaryButton(title: "Loading Button", action: {}, isLoading: true)
        
        SecondaryButton(title: "Disabled Button", action: {}, isDisabled: true)
    }
    .padding()
    .background(Theme.background)
}
