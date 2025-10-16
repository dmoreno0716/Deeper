import SwiftUI

/// Placeholder home view for after paywall completion
struct HomeView: View {
    @State private var showWelcome: Bool = false
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: Theme.spacingXL) {
                // Welcome message
                VStack(spacing: Theme.spacingMD) {
                    Text("Welcome to VoiceMaxxing!")
                        .font(.deeperTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Your voice transformation journey begins now")
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, Theme.spacingXXXL)
                
                // Art block
                ArtBlock(description: "Home dashboard with voice training interface")
                    .aspectRatio(16/9, contentMode: .fit)
                
                // Quick actions
                VStack(spacing: Theme.spacingMD) {
                    Text("Quick Actions")
                        .font(.deeperSubtitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.textPrimary)
                    
                    VStack(spacing: Theme.spacingSM) {
                        QuickActionButton(
                            icon: "play.circle.fill",
                            title: "Start Training",
                            description: "Begin your daily voice exercises"
                        )
                        
                        QuickActionButton(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "View Progress",
                            description: "Track your voice improvement"
                        )
                        
                        QuickActionButton(
                            icon: "calendar",
                            title: "Schedule",
                            description: "Manage your training routine"
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, Theme.spacingLG)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showWelcome = true
            }
        }
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        Button(action: {
            print("Tapped: \(title)")
        }) {
            HStack(spacing: Theme.spacingMD) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.1))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Theme.accent)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.deeperBody)
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.textPrimary)
                    
                    Text(description)
                        .font(.deeperCaption)
                        .foregroundColor(Theme.textSecondary)
                        .lineSpacing(1)
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Theme.textSecondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.textSecondary.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
