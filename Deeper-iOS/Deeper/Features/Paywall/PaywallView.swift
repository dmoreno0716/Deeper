import SwiftUI

/// Paywall view with yearly/monthly subscription options and trial
struct PaywallView: View {
    let onContinue: () -> Void
    
    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var showContent: Bool = false
    @State private var isLoading: Bool = false
    
    private let features = [
        PaywallFeature(
            icon: "brain.head.profile",
            title: "AI-Powered Training",
            description: "Personalized voice exercises tailored to your goals"
        ),
        PaywallFeature(
            icon: "chart.line.uptrend.xyaxis",
            title: "Progress Tracking",
            description: "Detailed analytics and voice improvement metrics"
        ),
        PaywallFeature(
            icon: "calendar",
            title: "Daily Routines",
            description: "Structured training schedules that adapt to your life"
        ),
        PaywallFeature(
            icon: "person.2.fill",
            title: "Expert Guidance",
            description: "Access to voice coaches and technique tutorials"
        ),
        PaywallFeature(
            icon: "sparkles",
            title: "Advanced Features",
            description: "Premium tools for serious voice transformation"
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main content
                ScrollView {
                    VStack(spacing: Theme.spacingXL) {
                        // Header
                        headerView
                        
                        // Art block
                        artBlockView
                        
                        // Features list
                        if showContent {
                            featuresView
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        // Subscription plans
                        if showContent {
                            subscriptionPlansView
                                .transition(.opacity.combined(with: .scale))
                                .animation(.easeInOut(duration: 0.6).delay(0.2), value: showContent)
                        }
                        
                        // Action buttons
                        if showContent {
                            actionButtonsView
                                .transition(.opacity.combined(with: .scale))
                                .animation(.easeInOut(duration: 0.6).delay(0.4), value: showContent)
                        }
                        
                        // Footer
                        if showContent {
                            footerView
                                .transition(.opacity.combined(with: .scale))
                                .animation(.easeInOut(duration: 0.6).delay(0.6), value: showContent)
                        }
                    }
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.bottom, Theme.spacingXXXL)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                showContent = true
            }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Unlock Your Voice Potential")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Join thousands transforming their voice with VoiceMaxxing")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Paywall interface with subscription options and premium features")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var featuresView: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("What You Get")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingSM) {
                ForEach(features, id: \.title) { feature in
                    PaywallFeatureRow(feature: feature)
                }
            }
        }
    }
    
    @ViewBuilder
    private var subscriptionPlansView: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Choose Your Plan")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingSM) {
                // Yearly plan (default selected)
                SubscriptionPlanCard(
                    plan: .yearly,
                    isSelected: selectedPlan == .yearly,
                    onSelect: { selectedPlan = .yearly }
                )
                
                // Monthly plan
                SubscriptionPlanCard(
                    plan: .monthly,
                    isSelected: selectedPlan == .monthly,
                    onSelect: { selectedPlan = .monthly }
                )
            }
        }
    }
    
    @ViewBuilder
    private var actionButtonsView: some View {
        VStack(spacing: Theme.spacingMD) {
            // Start Free Trial button
            Button(action: {
                handleStartTrial()
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Start Free Trial")
                            .font(.deeperBody)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Theme.accent)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.accent, lineWidth: 1)
                        )
                )
                .shadow(
                    color: Theme.accent.opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isLoading)
            
            // Restore Purchases button
            Button(action: {
                handleRestorePurchases()
            }) {
                Text("Restore Purchases")
                    .font(.deeperBody)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Theme.textSecondary.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    @ViewBuilder
    private var footerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Cancel anytime • No commitment")
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: Theme.spacingMD) {
                Button("Terms of Service") {
                    // Handle terms
                }
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
                
                Text("•")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
                
                Button("Privacy Policy") {
                    // Handle privacy
                }
                .font(.deeperCaption)
                .foregroundColor(Theme.textSecondary)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleStartTrial() {
        isLoading = true
        
        // Simulate loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            print("Starting free trial for \(selectedPlan.rawValue) plan")
            onContinue()
        }
    }
    
    private func handleRestorePurchases() {
        print("Restoring purchases...")
        // In a real app, this would call the paywall service
    }
}

// MARK: - Paywall Feature Row

struct PaywallFeatureRow: View {
    let feature: PaywallFeature
    
    var body: some View {
        HStack(spacing: Theme.spacingMD) {
            // Icon
            ZStack {
                Circle()
                    .fill(Theme.accent.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: feature.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Theme.accent)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(feature.title)
                    .font(.deeperBody)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                
                Text(feature.description)
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
                    .lineSpacing(1)
            }
            
            Spacer()
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
}

// MARK: - Subscription Plan Card

struct SubscriptionPlanCard: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: Theme.spacingMD) {
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(isSelected ? Theme.accent : Theme.textSecondary.opacity(0.3), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Theme.accent)
                            .frame(width: 12, height: 12)
                    }
                }
                
                // Plan details
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(plan.title)
                            .font(.deeperBody)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textPrimary)
                        
                        if plan.isRecommended {
                            Text("RECOMMENDED")
                                .font(.deeperCaption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Theme.accent)
                                )
                        }
                        
                        Spacer()
                    }
                    
                    Text(plan.description)
                        .font(.deeperCaption)
                        .foregroundColor(Theme.textSecondary)
                        .lineSpacing(1)
                }
                
                // Price
                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.price)
                        .font(.deeperBody)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textPrimary)
                    
                    if let savings = plan.savings {
                        Text(savings)
                            .font(.deeperCaption)
                            .foregroundColor(Theme.success)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Theme.accent.opacity(0.1) : Theme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Theme.accent : Theme.textSecondary.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Data Models

struct PaywallFeature {
    let icon: String
    let title: String
    let description: String
}

enum SubscriptionPlan: String, CaseIterable {
    case yearly = "yearly"
    case monthly = "monthly"
    
    var title: String {
        switch self {
        case .yearly: return "Yearly"
        case .monthly: return "Monthly"
        }
    }
    
    var description: String {
        switch self {
        case .yearly: return "Best value • 7-day free trial"
        case .monthly: return "Flexible • 7-day free trial"
        }
    }
    
    var price: String {
        switch self {
        case .yearly: return "$79.99/year"
        case .monthly: return "$9.99/month"
        }
    }
    
    var savings: String? {
        switch self {
        case .yearly: return "Save 33%"
        case .monthly: return nil
        }
    }
    
    var isRecommended: Bool {
        switch self {
        case .yearly: return true
        case .monthly: return false
        }
    }
}

// MARK: - Paywall Step View

/// Step view for paywall screens
struct PaywallStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        PaywallView {
            // Navigate to home after paywall
            // In a real app, this would be handled by the navigation system
            print("Paywall completed, navigating to home")
        }
    }
}

// MARK: - Preview

#Preview {
    PaywallView {
        print("Continue tapped")
    }
}
