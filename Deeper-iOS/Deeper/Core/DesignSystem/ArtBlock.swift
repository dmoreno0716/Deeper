import SwiftUI

struct ArtBlock: View {
    let description: String
    var aspectRatio: CGFloat = 16.0 / 9.0
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = Theme.card
    var borderColor: Color = Theme.textSecondary.opacity(0.2)
    var borderWidth: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: Theme.spacingSM) {
                Image(systemName: "photo.artframe")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(Theme.textSecondary.opacity(0.6))
                
                Text("INSERT ART HERE:")
                    .font(.deeperCaption)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textSecondary.opacity(0.8))
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text(description)
                    .font(.deeperBody)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.spacingMD)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(aspectRatio, contentMode: .fit)
        .background(backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .accessibilityLabel("Art placeholder for \(description)")
        .accessibilityHint("This is a placeholder where art content will be displayed")
    }
}

// Variant for different art block styles
struct ArtBlockVariant: View {
    let description: String
    var style: ArtBlockStyle = .default
    
    var body: some View {
        switch style {
        case .default:
            ArtBlock(description: description)
        case .minimal:
            ArtBlock(
                description: description,
                backgroundColor: Theme.background,
                borderColor: Theme.accent.opacity(0.3),
                borderWidth: 2
            )
        case .highlighted:
            ArtBlock(
                description: description,
                backgroundColor: Theme.accent.opacity(0.1),
                borderColor: Theme.accent,
                borderWidth: 2
            )
        }
    }
}

enum ArtBlockStyle {
    case `default`
    case minimal
    case highlighted
}

#Preview {
    VStack(spacing: 20) {
        ArtBlock(description: "Breathing exercise visualization")
        
        ArtBlockVariant(description: "Meditation guidance art", style: .minimal)
        
        ArtBlockVariant(description: "Progress celebration graphic", style: .highlighted)
        
        // Different aspect ratios
        HStack(spacing: 12) {
            ArtBlock(description: "Square", aspectRatio: 1.0)
            ArtBlock(description: "Portrait", aspectRatio: 3.0 / 4.0)
        }
    }
    .padding()
    .background(Theme.background)
}
