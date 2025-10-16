import SwiftUI

/// Toggle row component for Yes/No or Allow/Deny choices
/// Equivalent to the toggle patterns in Permissions.tsx and Aims.tsx
struct ToggleRow: View {
    let title: String
    let description: String?
    let onValueChanged: (Bool) -> Void
    
    @State private var isSelected: Bool = false
    
    init(
        title: String,
        description: String? = nil,
        initialValue: Bool = false,
        onValueChanged: @escaping (Bool) -> Void
    ) {
        self.title = title
        self.description = description
        self.onValueChanged = onValueChanged
        self._isSelected = State(initialValue: initialValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMD) {
            // Header
            VStack(alignment: .leading, spacing: Theme.spacingXS) {
                Text(title)
                    .font(.deeperBody)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                
                if let description = description {
                    Text(description)
                        .font(.deeperCaption)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            // Toggle buttons
            HStack(spacing: Theme.spacingSM) {
                ToggleButton(
                    title: "No",
                    isSelected: !isSelected,
                    onTap: { 
                        isSelected = false
                        onValueChanged(false)
                    }
                )
                
                ToggleButton(
                    title: "Yes",
                    isSelected: isSelected,
                    onTap: { 
                        isSelected = true
                        onValueChanged(true)
                    }
                )
            }
        }
        .padding()
        .cardStyle()
        .onAppear {
            onValueChanged(isSelected)
        }
        .onChange(of: isSelected) { newValue in
            onValueChanged(newValue)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(description ?? ""). Currently \(isSelected ? "Yes" : "No")")
        .accessibilityHint("Double tap to toggle between Yes and No")
    }
}

// MARK: - Toggle Button Component

struct ToggleButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.deeperBody)
                .fontWeight(.medium)
                .foregroundColor(buttonTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.spacingSM)
                .padding(.horizontal, Theme.spacingMD)
                .background(buttonBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(buttonBorderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }
    }
    
    // MARK: - Computed Properties
    
    private var buttonBackground: Color {
        if isSelected {
            return Theme.accent.opacity(0.2)
        }
        return Theme.background
    }
    
    private var buttonBorderColor: Color {
        if isSelected {
            return Theme.accent
        }
        return Theme.textSecondary.opacity(0.3)
    }
    
    private var buttonTextColor: Color {
        if isSelected {
            return Theme.textPrimary
        }
        return Theme.textSecondary
    }
}

// MARK: - Permission Toggle Row

/// Specialized toggle row for permissions with Allow/Deny options
struct PermissionToggleRow: View {
    let title: String
    let description: String
    let onValueChanged: (Bool) -> Void
    
    @State private var isAllowed: Bool = false
    
    init(
        title: String,
        description: String,
        initialValue: Bool = false,
        onValueChanged: @escaping (Bool) -> Void
    ) {
        self.title = title
        self.description = description
        self.onValueChanged = onValueChanged
        self._isAllowed = State(initialValue: initialValue)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMD) {
            // Header
            VStack(alignment: .leading, spacing: Theme.spacingXS) {
                Text(title)
                    .font(.deeperBody)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textPrimary)
                
                Text(description)
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
            }
            
            // Permission buttons
            HStack(spacing: Theme.spacingSM) {
                PermissionButton(
                    title: "Ask App Not to Allow",
                    isSelected: !isAllowed,
                    onTap: { 
                        isAllowed = false
                        onValueChanged(false)
                    }
                )
                
                PermissionButton(
                    title: "Allow",
                    isSelected: isAllowed,
                    onTap: { 
                        isAllowed = true
                        onValueChanged(true)
                    }
                )
            }
        }
        .padding()
        .cardStyle()
        .onAppear {
            onValueChanged(isAllowed)
        }
        .onChange(of: isAllowed) { newValue in
            onValueChanged(newValue)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(description). Currently \(isAllowed ? "Allowed" : "Not allowed")")
        .accessibilityHint("Double tap to toggle permission")
    }
}

// MARK: - Permission Button Component

struct PermissionButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.deeperCaption)
                .fontWeight(.medium)
                .foregroundColor(buttonTextColor)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.spacingSM)
                .padding(.horizontal, Theme.spacingMD)
                .background(buttonBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(buttonBorderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            onTap()
        }
    }
    
    // MARK: - Computed Properties
    
    private var buttonBackground: Color {
        if isSelected {
            return Theme.accent.opacity(0.2)
        }
        return Theme.background
    }
    
    private var buttonBorderColor: Color {
        if isSelected {
            return Theme.accent
        }
        return Theme.textSecondary.opacity(0.3)
    }
    
    private var buttonTextColor: Color {
        if isSelected {
            return Theme.textPrimary
        }
        return Theme.textSecondary
    }
}

// MARK: - Toggle Row Container

struct ToggleRowContainer: View {
    let title: String
    let subtitle: String?
    let toggles: [ToggleRowData]
    let onTogglesChanged: ([String: Bool]) -> Void
    
    @State private var toggleStates: [String: Bool] = [:]
    
    init(
        title: String,
        subtitle: String? = nil,
        toggles: [ToggleRowData],
        onTogglesChanged: @escaping ([String: Bool]) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.toggles = toggles
        self.onTogglesChanged = onTogglesChanged
        
        // Initialize toggle states
        let initialState = Dictionary(uniqueKeysWithValues: toggles.map { ($0.id, $0.initialValue) })
        self._toggleStates = State(initialValue: initialState)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingLG) {
            // Header
            VStack(alignment: .leading, spacing: Theme.spacingSM) {
                Text(title)
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.deeperBody)
                        .foregroundColor(Theme.textSecondary)
                }
            }
            
            // Toggle rows
            VStack(spacing: Theme.spacingMD) {
                ForEach(toggles, id: \.id) { toggleData in
                    if toggleData.isPermission {
                        PermissionToggleRow(
                            title: toggleData.title,
                            description: toggleData.description,
                            initialValue: toggleData.initialValue
                        ) { value in
                            toggleStates[toggleData.id] = value
                            onTogglesChanged(toggleStates)
                        }
                    } else {
                        ToggleRow(
                            title: toggleData.title,
                            description: toggleData.description,
                            initialValue: toggleData.initialValue
                        ) { value in
                            toggleStates[toggleData.id] = value
                            onTogglesChanged(toggleStates)
                        }
                    }
                }
            }
        }
        .onAppear {
            onTogglesChanged(toggleStates)
        }
    }
}

// MARK: - Toggle Row Data

struct ToggleRowData {
    let id: String
    let title: String
    let description: String
    let initialValue: Bool
    let isPermission: Bool
    
    init(
        id: String,
        title: String,
        description: String = "",
        initialValue: Bool = false,
        isPermission: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.initialValue = initialValue
        self.isPermission = isPermission
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("Toggle Rows")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
        
        ToggleRowContainer(
            title: "Your Aims",
            subtitle: "What are your VoiceMaxxing goals?",
            toggles: [
                ToggleRowData(
                    id: "reduceVoiceStrain",
                    title: "Do you aim to reduce voice strain?",
                    initialValue: false
                ),
                ToggleRowData(
                    id: "trainInMorning",
                    title: "Do you like to train in the morning?",
                    initialValue: false
                )
            ]
        ) { states in
            print("Toggle states: \(states)")
        }
        
        Text("Permission Toggles")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
        
        ToggleRowContainer(
            title: "Permissions",
            toggles: [
                ToggleRowData(
                    id: "microphone",
                    title: "Microphone",
                    description: "for optional voice notes/analysis later",
                    initialValue: false,
                    isPermission: true
                ),
                ToggleRowData(
                    id: "notifications",
                    title: "Notifications",
                    description: "habit reminders",
                    initialValue: false,
                    isPermission: true
                )
            ]
        ) { states in
            print("Permission states: \(states)")
        }
    }
    .padding()
    .background(Theme.background)
}
