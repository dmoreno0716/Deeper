import SwiftUI

/// Swipeable carousel view showing habit information with impact chips
struct HabitsInfoCarouselView: View {
    let onContinue: () -> Void
    
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    
    private let carouselItems = [
        CarouselItem(
            id: "reduceStrain",
            title: "Reduce Strain",
            subtitle: "Protect Your Voice",
            description: "Learn to recognize and prevent voice strain. Avoid overuse, maintain proper hydration, and use voice-saving techniques throughout your day.",
            impactChips: [
                ImpactChip(text: "Prevents Damage", color: Theme.success),
                ImpactChip(text: "Long-term Health", color: Theme.accent),
                ImpactChip(text: "Sustained Progress", color: Theme.warning)
            ],
            icon: "mic.slash",
            color: Theme.danger
        ),
        CarouselItem(
            id: "wakeEarly",
            title: "Wake & Train Early",
            subtitle: "Morning Routine",
            description: "Start your day with voice training. Morning practice when your voice is fresh leads to better technique and faster improvement.",
            impactChips: [
                ImpactChip(text: "Fresh Voice", color: Theme.success),
                ImpactChip(text: "Better Focus", color: Theme.accent),
                ImpactChip(text: "Consistent Progress", color: Theme.warning)
            ],
            icon: "sunrise",
            color: Theme.warning
        ),
        CarouselItem(
            id: "meditate",
            title: "Meditate/Breath",
            subtitle: "Breathing Foundation",
            description: "Daily breathing exercises strengthen your diaphragm and improve breath control. Essential for powerful, sustained voice projection.",
            impactChips: [
                ImpactChip(text: "Stronger Diaphragm", color: Theme.success),
                ImpactChip(text: "Better Control", color: Theme.accent),
                ImpactChip(text: "Increased Power", color: Theme.warning)
            ],
            icon: "leaf",
            color: Theme.success
        ),
        CarouselItem(
            id: "readAloud",
            title: "Read Aloud",
            subtitle: "Voice Projection",
            description: "Practice reading aloud daily to improve articulation, projection, and vocal confidence. Start with 10-15 minutes and build up.",
            impactChips: [
                ImpactChip(text: "Clear Articulation", color: Theme.success),
                ImpactChip(text: "Better Projection", color: Theme.accent),
                ImpactChip(text: "Increased Confidence", color: Theme.warning)
            ],
            icon: "book",
            color: Theme.accent
        ),
        CarouselItem(
            id: "steamTherapy",
            title: "Steam Therapy",
            subtitle: "Vocal Hydration",
            description: "Regular steam therapy keeps your vocal cords hydrated and healthy. Use a humidifier or steam inhalation for optimal voice care.",
            impactChips: [
                ImpactChip(text: "Hydrated Cords", color: Theme.success),
                ImpactChip(text: "Reduced Strain", color: Theme.accent),
                ImpactChip(text: "Better Resonance", color: Theme.warning)
            ],
            icon: "cloud.fog",
            color: Theme.textSecondary
        ),
        CarouselItem(
            id: "downGlides",
            title: "Down Glides",
            subtitle: "Range Expansion",
            description: "Practice descending vocal glides to expand your lower range and improve vocal flexibility. Essential for deeper voice development.",
            impactChips: [
                ImpactChip(text: "Lower Range", color: Theme.success),
                ImpactChip(text: "Vocal Flexibility", color: Theme.accent),
                ImpactChip(text: "Deeper Voice", color: Theme.warning)
            ],
            icon: "arrow.down.circle",
            color: Theme.accent
        ),
        CarouselItem(
            id: "techniqueStudy",
            title: "Technique Study",
            subtitle: "Voice Fundamentals",
            description: "Study proper voice technique daily. Learn about resonance, placement, and advanced vocal methods to accelerate your progress.",
            impactChips: [
                ImpactChip(text: "Proper Technique", color: Theme.success),
                ImpactChip(text: "Faster Progress", color: Theme.accent),
                ImpactChip(text: "Advanced Methods", color: Theme.warning)
            ],
            icon: "graduationcap",
            color: Theme.warning
        ),
        CarouselItem(
            id: "voiceJournal",
            title: "Voice Journal",
            subtitle: "Progress Tracking",
            description: "Track your daily voice training, note improvements, and identify patterns. Self-awareness accelerates your VoiceMaxxing journey.",
            impactChips: [
                ImpactChip(text: "Track Progress", color: Theme.success),
                ImpactChip(text: "Identify Patterns", color: Theme.accent),
                ImpactChip(text: "Stay Motivated", color: Theme.warning)
            ],
            icon: "book.closed",
            color: Theme.success
        )
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 0.8)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                VStack(spacing: Theme.spacingLG) {
                    // Header
                    headerView
                    
                    // Carousel
                    carouselView
                    
                    // Page indicators
                    pageIndicators
                    
                    // Continue button
                    continueButton
                        .padding(.bottom, Theme.spacingXXXL)
                }
                .padding(.horizontal, Theme.spacingLG)
            }
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("VoiceMaxxing Habits")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Learn about each habit and its impact")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var carouselView: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(carouselItems.indices, id: \.self) { index in
                    CarouselCard(
                        item: carouselItems[index],
                        isActive: index == currentIndex
                    )
                    .frame(width: geometry.size.width)
                }
            }
            .offset(x: -CGFloat(currentIndex) * geometry.size.width + dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.x
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.x > threshold && currentIndex > 0 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentIndex -= 1
                            }
                        } else if value.translation.x < -threshold && currentIndex < carouselItems.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentIndex += 1
                            }
                        }
                        
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dragOffset = 0
                        }
                    }
            )
        }
        .frame(height: 500)
    }
    
    @ViewBuilder
    private var pageIndicators: some View {
        HStack(spacing: Theme.spacingSM) {
            ForEach(carouselItems.indices, id: \.self) { index in
                Circle()
                    .fill(index == currentIndex ? Theme.accent : Theme.textSecondary.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentIndex ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: currentIndex)
            }
        }
    }
    
    @ViewBuilder
    private var continueButton: some View {
        PrimaryButton(title: "Continue") {
            onContinue()
        }
    }
}

// MARK: - Carousel Item Data

struct CarouselItem {
    let id: String
    let title: String
    let subtitle: String
    let description: String
    let impactChips: [ImpactChip]
    let icon: String
    let color: Color
}

struct ImpactChip {
    let text: String
    let color: Color
}

// MARK: - Carousel Card Component

struct CarouselCard: View {
    let item: CarouselItem
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: Theme.spacingLG) {
            // Icon
            Image(systemName: item.icon)
                .font(.system(size: 48, weight: .medium))
                .foregroundColor(item.color)
                .frame(width: 80, height: 80)
                .background(
                    Circle()
                        .fill(item.color.opacity(0.1))
                )
                .scaleEffect(isActive ? 1.0 : 0.9)
                .animation(.easeInOut(duration: 0.3), value: isActive)
            
            // Content
            VStack(spacing: Theme.spacingMD) {
                VStack(spacing: Theme.spacingXS) {
                    Text(item.title)
                        .font(.deeperSubtitle)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(item.subtitle)
                        .font(.deeperBody)
                        .foregroundColor(item.color)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                }
                
                Text(item.description)
                    .font(.deeperBody)
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                // Impact chips
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: Theme.spacingSM
                ) {
                    ForEach(item.impactChips.indices, id: \.self) { index in
                        ImpactChipView(chip: item.impactChips[index])
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(item.color.opacity(0.2), lineWidth: 2)
                )
        )
        .opacity(isActive ? 1.0 : 0.7)
        .scaleEffect(isActive ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.3), value: isActive)
    }
}

// MARK: - Impact Chip Component

struct ImpactChipView: View {
    let chip: ImpactChip
    
    var body: some View {
        Text(chip.text)
            .font(.deeperCaption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, Theme.spacingSM)
            .padding(.vertical, Theme.spacingXS)
            .background(
                Capsule()
                    .fill(chip.color)
            )
    }
}

// MARK: - Habits Info Carousel Step View

/// Step view for habits info carousel screens
struct HabitsInfoCarouselStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        HabitsInfoCarouselView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    HabitsInfoCarouselView {
        print("Continue tapped")
    }
}
