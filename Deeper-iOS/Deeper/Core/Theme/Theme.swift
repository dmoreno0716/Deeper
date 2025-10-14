import SwiftUI

struct Theme {
    // Colors
    static let background = Color("Background")
    static let card = Color("Card")
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let accent = Color("Accent")
    static let success = Color("Success")
    static let warning = Color("Warning")
    static let danger = Color("Danger")
    
    // Font Sizes
    static let fontSizeXXS: CGFloat = 10
    static let fontSizeXS: CGFloat = 12
    static let fontSizeSM: CGFloat = 14
    static let fontSizeMD: CGFloat = 16
    static let fontSizeLG: CGFloat = 18
    static let fontSizeXL: CGFloat = 20
    static let fontSizeXXL: CGFloat = 24
    static let fontSizeXXXL: CGFloat = 32
    
    // Spacing
    static let spacingXXS: CGFloat = 2
    static let spacingXS: CGFloat = 4
    static let spacingSM: CGFloat = 8
    static let spacingMD: CGFloat = 12
    static let spacingLG: CGFloat = 16
    static let spacingXL: CGFloat = 20
    static let spacingXXL: CGFloat = 24
    static let spacingXXXL: CGFloat = 32
    static let spacingXXXXL: CGFloat = 40
}

// Font extensions for easy access
extension Font {
    static func deeperFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight)
    }
    
    static let deeperTitle = deeperFont(size: Theme.fontSizeXXXL, weight: .bold)
    static let deeperSubtitle = deeperFont(size: Theme.fontSizeLG, weight: .medium)
    static let deeperBody = deeperFont(size: Theme.fontSizeMD)
    static let deeperCaption = deeperFont(size: Theme.fontSizeSM)
}
