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
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isDisabled ? Theme.textSecondary : Theme.accent)
            )
            .foregroundColor(Theme.textPrimary)
            .shadow(
                color: isDisabled ? .clear : Theme.accent.opacity(0.3),
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continue", action: {})
        PrimaryButton(title: "Loading...", action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
    }
    .padding()
    .background(Theme.background)
}
