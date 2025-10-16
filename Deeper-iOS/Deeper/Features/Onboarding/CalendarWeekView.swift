import SwiftUI

/// Calendar week view with task list and plan preview expanders
struct CalendarWeekView: View {
    let onContinue: () -> Void
    
    @State private var showContent: Bool = false
    @State private var expandedWeeks: Set<Int> = []
    
    private let tasks = [
        TaskItem(id: "morning_routine", title: "Morning Voice Training", duration: "15 min", icon: "sun.max.fill"),
        TaskItem(id: "breathwork", title: "Breathwork Session", duration: "10 min", icon: "wind"),
        TaskItem(id: "read_aloud", title: "Read Aloud Practice", duration: "20 min", icon: "book.fill"),
        TaskItem(id: "steam_therapy", title: "Steam Therapy", duration: "5 min", icon: "cloud.fill"),
        TaskItem(id: "down_glides", title: "Down Glides Exercise", duration: "8 min", icon: "arrow.down.circle.fill"),
        TaskItem(id: "technique_study", title: "Technique Study", duration: "12 min", icon: "brain.head.profile"),
        TaskItem(id: "voice_journal", title: "Voice Journal Entry", duration: "5 min", icon: "pencil.circle.fill")
    ]
    
    private let weekPlans = [
        WeekPlan(week: 1, title: "Foundation Week", description: "Establish core habits", tasks: ["Morning Voice Training", "Breathwork Session", "Read Aloud Practice"], intensity: "Low"),
        WeekPlan(week: 2, title: "Building Week", description: "Add steam therapy and technique study", tasks: ["All Week 1 tasks", "Steam Therapy", "Technique Study"], intensity: "Medium"),
        WeekPlan(week: 3, title: "Advanced Week", description: "Complete routine with down glides", tasks: ["All previous tasks", "Down Glides Exercise", "Voice Journal Entry"], intensity: "High")
    ]
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress bar
                ProgressBar(progress: 0.95)
                    .padding(.horizontal, Theme.spacingLG)
                    .padding(.top, Theme.spacingMD)
                
                // Main content
                ScrollView {
                    VStack(spacing: Theme.spacingXL) {
                        // Header
                        headerView
                        
                        // Art block
                        artBlockView
                        
                        // Calendar section
                        if showContent {
                            calendarSection
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        // Task list section
                        if showContent {
                            taskListSection
                                .transition(.opacity.combined(with: .scale))
                                .animation(.easeInOut(duration: 0.6).delay(0.2), value: showContent)
                        }
                        
                        // Plan preview expanders
                        if showContent {
                            planPreviewSection
                                .transition(.opacity.combined(with: .scale))
                                .animation(.easeInOut(duration: 0.6).delay(0.4), value: showContent)
                        }
                        
                        // Continue button
                        continueButton
                            .padding(.bottom, Theme.spacingXXXL)
                    }
                    .padding(.horizontal, Theme.spacingLG)
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
            Text("Your VoiceMaxxing Plan")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Week 1 starts your transformation journey")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Calendar interface with weekly task planning and progress tracking")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var calendarSection: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Week 1 - Foundation")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            // Simple calendar header
            HStack(spacing: 0) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                    Text(day)
                        .font(.deeperCaption)
                        .fontWeight(.medium)
                        .foregroundColor(day == "Mon" ? Theme.accent : Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
                    )
            )
            
            // Week highlight indicator
            HStack {
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 8, height: 8)
                
                Text("Current Week")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
                
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var taskListSection: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Daily Tasks")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingSM) {
                ForEach(tasks, id: \.id) { task in
                    TaskRowView(task: task)
                }
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
    
    @ViewBuilder
    private var planPreviewSection: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Plan Preview")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingSM) {
                ForEach(weekPlans, id: \.week) { weekPlan in
                    WeekPlanExpander(
                        weekPlan: weekPlan,
                        isExpanded: expandedWeeks.contains(weekPlan.week)
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if expandedWeeks.contains(weekPlan.week) {
                                expandedWeeks.remove(weekPlan.week)
                            } else {
                                expandedWeeks.insert(weekPlan.week)
                            }
                        }
                    }
                }
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

// MARK: - Task Row Component

struct TaskRowView: View {
    let task: TaskItem
    
    var body: some View {
        HStack(spacing: Theme.spacingSM) {
            // Task icon
            Image(systemName: task.icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.accent)
                .frame(width: 24, height: 24)
            
            // Task details
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.deeperBody)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textPrimary)
                
                Text(task.duration)
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            Spacer()
            
            // Action buttons (unimplemented)
            HStack(spacing: Theme.spacingXS) {
                Button(action: {
                    // Edit task - unimplemented
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                        .frame(width: 24, height: 24)
                }
                
                Button(action: {
                    // Delete task - unimplemented
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.danger)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding(.vertical, Theme.spacingXS)
    }
}

// MARK: - Week Plan Expander Component

struct WeekPlanExpander: View {
    let weekPlan: WeekPlan
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: onToggle) {
                HStack(spacing: Theme.spacingSM) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Week \(weekPlan.week)")
                            .font(.deeperBody)
                            .fontWeight(.semibold)
                            .foregroundColor(Theme.textPrimary)
                        
                        Text(weekPlan.title)
                            .font(.deeperCaption)
                            .foregroundColor(Theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Intensity indicator
                    intensityIndicator
                    
                    // Expand/collapse icon
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : 0))
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
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
            
            // Expanded content
            if isExpanded {
                VStack(spacing: Theme.spacingSM) {
                    // Description
                    Text(weekPlan.description)
                        .font(.deeperCaption)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.leading)
                    
                    // Task list
                    VStack(alignment: .leading, spacing: Theme.spacingXS) {
                        ForEach(weekPlan.tasks, id: \.self) { task in
                            HStack(spacing: Theme.spacingXS) {
                                Circle()
                                    .fill(Theme.accent)
                                    .frame(width: 4, height: 4)
                                
                                Text(task)
                                    .font(.deeperCaption)
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.accent.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.accent.opacity(0.1), lineWidth: 1)
                        )
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
    
    @ViewBuilder
    private var intensityIndicator: some View {
        HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(intensityColor(for: index))
                    .frame(width: 6, height: 6)
            }
        }
    }
    
    private func intensityColor(for index: Int) -> Color {
        let intensityLevel = weekPlan.intensityLevel
        
        if index < intensityLevel {
            switch weekPlan.intensity {
            case "Low":
                return Theme.success
            case "Medium":
                return Theme.warning
            case "High":
                return Theme.danger
            default:
                return Theme.textSecondary.opacity(0.3)
            }
        } else {
            return Theme.textSecondary.opacity(0.2)
        }
    }
}

// MARK: - Data Models

struct TaskItem {
    let id: String
    let title: String
    let duration: String
    let icon: String
}

struct WeekPlan {
    let week: Int
    let title: String
    let description: String
    let tasks: [String]
    let intensity: String
    
    var intensityLevel: Int {
        switch intensity {
        case "Low": return 1
        case "Medium": return 2
        case "High": return 3
        default: return 1
        }
    }
}

// MARK: - Calendar Week Step View

/// Step view for calendar week screens
struct CalendarWeekStepView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    
    var body: some View {
        CalendarWeekView {
            onboardingStore.next()
        }
    }
}

// MARK: - Preview

#Preview {
    CalendarWeekView {
        print("Continue tapped")
    }
}
