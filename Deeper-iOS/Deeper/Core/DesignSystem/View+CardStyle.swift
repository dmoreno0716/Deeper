import SwiftUI

extension View {
    /// Applies the standard card style matching the Expo design system
    func cardStyle() -> some View {
        self
            .background(Theme.card)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    /// Applies card style with custom corner radius
    func cardStyle(cornerRadius: CGFloat) -> some View {
        self
            .background(Theme.card)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
    
    /// Applies card style with custom background color
    func cardStyle(backgroundColor: Color) -> some View {
        self
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    /// Applies card style with custom border
    func cardStyle(borderColor: Color, borderWidth: CGFloat = 1) -> some View {
        self
            .background(Theme.card)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    /// Applies card style with shadow
    func cardStyleWithShadow() -> some View {
        self
            .background(Theme.card)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            )
    }
    
    /// Applies elevated card style with accent glow
    func cardStyleWithGlow() -> some View {
        self
            .background(Theme.card)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: Theme.accent.opacity(0.2),
                radius: 12,
                x: 0,
                y: 6
            )
    }
    
    /// Applies interactive card style with hover/press states
    func interactiveCardStyle() -> some View {
        self
            .background(Theme.card)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: Color.black.opacity(0.05),
                radius: 4,
                x: 0,
                y: 2
            )
    }
}

// Additional card style variants for specific use cases
struct CardStyle {
    static let standard = CardStyleConfig()
    static let elevated = CardStyleConfig(shadowRadius: 8, shadowY: 4)
    static let minimal = CardStyleConfig(borderOpacity: 0.1)
    static let accent = CardStyleConfig(borderColor: Theme.accent, borderOpacity: 0.3)
}

struct CardStyleConfig {
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let borderColor: Color
    let borderWidth: CGFloat
    let borderOpacity: Double
    let shadowRadius: CGFloat
    let shadowY: CGFloat
    let shadowOpacity: Double
    
    init(
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = Theme.card,
        borderColor: Color = Theme.textSecondary,
        borderWidth: CGFloat = 1,
        borderOpacity: Double = 0.2,
        shadowRadius: CGFloat = 0,
        shadowY: CGFloat = 0,
        shadowOpacity: Double = 0
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.borderOpacity = borderOpacity
        self.shadowRadius = shadowRadius
        self.shadowY = shadowY
        self.shadowOpacity = shadowOpacity
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Standard Card")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
            .padding()
            .cardStyle()
        
        Text("Card with Shadow")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
            .padding()
            .cardStyleWithShadow()
        
        Text("Card with Glow")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
            .padding()
            .cardStyleWithGlow()
        
        Text("Interactive Card")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
            .padding()
            .interactiveCardStyle()
    }
    .padding()
    .background(Theme.background)
}
