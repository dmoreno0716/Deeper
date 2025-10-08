import SwiftUI

struct GradientScreen<Content: View>: View {
    let title: String?
    let subtitle: String?
    let content: Content
    
    init(title: String? = nil, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Theme.background,
                    Color(red: 0.102, green: 0.086, blue: 0.145), // #1A1625
                    Theme.background
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header section
                if title != nil || subtitle != nil {
                    VStack(spacing: Theme.spacingSM) {
                        if let title = title {
                            Text(title)
                                .font(.deeperTitle)
                                .foregroundColor(Theme.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .font(.deeperSubtitle)
                                .foregroundColor(Theme.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                        }
                    }
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingXL)
                    .padding(.bottom, Theme.spacingMD)
                }
                
                // Content section
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, Theme.spacingLG)
            }
        }
    }
}

#Preview {
    GradientScreen(
        title: "Welcome to Deeper",
        subtitle: "Your journey to a deeper voice begins here"
    ) {
        VStack {
            Text("Content goes here")
                .foregroundColor(Theme.textPrimary)
            Spacer()
        }
    }
}
