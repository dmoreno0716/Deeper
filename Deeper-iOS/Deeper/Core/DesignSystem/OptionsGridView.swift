import SwiftUI

/// Options grid component for single or multi-select choices
/// Equivalent to OptionsGrid.tsx and ChipsPicker.tsx from Expo
struct OptionsGridView: View {
    let options: [String]
    let maxSelection: Int?
    let allowMultiple: Bool
    let onSelectionChanged: ([String]) -> Void
    
    @State private var selectedOptions: Set<String> = []
    
    init(
        options: [String],
        maxSelection: Int? = nil,
        allowMultiple: Bool = true,
        initialSelection: [String] = [],
        onSelectionChanged: @escaping ([String]) -> Void
    ) {
        self.options = options
        self.maxSelection = maxSelection
        self.allowMultiple = allowMultiple
        self.onSelectionChanged = onSelectionChanged
        self._selectedOptions = State(initialValue: Set(initialSelection))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingLG) {
            // Selection slots (for multi-select with max)
            if let maxSelection = maxSelection, allowMultiple {
                selectionSlotsView
            }
            
            // Options grid
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 120, maximum: 200), spacing: Theme.spacingSM)
                ],
                spacing: Theme.spacingSM
            ) {
                ForEach(options, id: \.self) { option in
                    OptionChip(
                        text: option,
                        isSelected: selectedOptions.contains(option),
                        isDisabled: !canSelect(option),
                        onTap: { toggleSelection(option) }
                    )
                }
            }
        }
        .onAppear {
            updateCallback()
        }
        .onChange(of: selectedOptions) { _ in
            updateCallback()
        }
    }
    
    // MARK: - Selection Slots View
    
    @ViewBuilder
    private var selectionSlotsView: some View {
        if let maxSelection = maxSelection {
            HStack(spacing: Theme.spacingSM) {
                ForEach(0..<maxSelection, id: \.self) { index in
                    SelectionSlot(
                        text: selectedArray.count > index ? selectedArray[index] : nil,
                        isEmpty: selectedArray.count <= index
                    )
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var selectedArray: [String] {
        return Array(selectedOptions).sorted()
    }
    
    private func canSelect(_ option: String) -> Bool {
        if selectedOptions.contains(option) {
            return true // Can always deselect
        }
        
        if !allowMultiple {
            return selectedOptions.isEmpty // Single select: only if nothing selected
        }
        
        if let maxSelection = maxSelection {
            return selectedOptions.count < maxSelection
        }
        
        return true // No limit
    }
    
    // MARK: - Actions
    
    private func toggleSelection(_ option: String) {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        
        if selectedOptions.contains(option) {
            // Deselect
            selectedOptions.remove(option)
            impactFeedback.impactOccurred()
        } else if canSelect(option) {
            // Select
            if !allowMultiple {
                selectedOptions.removeAll()
            }
            selectedOptions.insert(option)
            impactFeedback.impactOccurred()
        }
    }
    
    private func updateCallback() {
        onSelectionChanged(selectedArray)
    }
}

// MARK: - Option Chip Component

struct OptionChip: View {
    let text: String
    let isSelected: Bool
    let isDisabled: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(.deeperBody)
                .foregroundColor(chipTextColor)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, Theme.spacingMD)
                .padding(.vertical, Theme.spacingSM)
                .background(chipBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(chipBorderColor, lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
        .accessibilityLabel(text)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint(isDisabled ? "Cannot select more options" : "Double tap to toggle selection")
    }
    
    // MARK: - Computed Properties
    
    private var chipBackground: Color {
        if isSelected {
            return Theme.accent.opacity(0.2)
        }
        return Theme.card
    }
    
    private var chipBorderColor: Color {
        if isSelected {
            return Theme.accent
        }
        return Theme.textSecondary.opacity(0.2)
    }
    
    private var chipTextColor: Color {
        if isSelected {
            return Theme.textPrimary
        }
        return Theme.textSecondary
    }
}

// MARK: - Selection Slot Component

struct SelectionSlot: View {
    let text: String?
    let isEmpty: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.card)
                .frame(height: 64)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isEmpty ? Theme.textSecondary.opacity(0.2) : Theme.accent,
                            lineWidth: 1
                        )
                )
            
            if let text = text {
                Text(text)
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, Theme.spacingSM)
            } else {
                Text("+")
                    .font(.deeperSubtitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.textSecondary)
            }
        }
    }
}

// MARK: - Single Select Variant

struct SingleSelectOptionsGrid: View {
    let options: [String]
    let onSelectionChanged: (String?) -> Void
    
    @State private var selectedOption: String?
    
    init(
        options: [String],
        initialSelection: String? = nil,
        onSelectionChanged: @escaping (String?) -> Void
    ) {
        self.options = options
        self.onSelectionChanged = onSelectionChanged
        self._selectedOption = State(initialValue: initialSelection)
    }
    
    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 120, maximum: 200), spacing: Theme.spacingSM)
            ],
            spacing: Theme.spacingSM
        ) {
            ForEach(options, id: \.self) { option in
                OptionChip(
                    text: option,
                    isSelected: selectedOption == option,
                    isDisabled: false,
                    onTap: { 
                        selectedOption = selectedOption == option ? nil : option
                        onSelectionChanged(selectedOption)
                    }
                )
            }
        }
        .onAppear {
            onSelectionChanged(selectedOption)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        Text("Multi-Select Options Grid")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
        
        OptionsGridView(
            options: [
                "Voice journal (log notes)",
                "Jaw & neck release",
                "Posture drill",
                "Tongue posture (mewing basics)",
                "Caffeine cap",
                "No smoke",
                "No alcohol",
                "Nasal breathing"
            ],
            maxSelection: 2,
            allowMultiple: true
        ) { selected in
            print("Selected: \(selected)")
        }
        
        Text("Single Select Options Grid")
            .font(.deeperSubtitle)
            .foregroundColor(Theme.textPrimary)
        
        SingleSelectOptionsGrid(
            options: ["Option 1", "Option 2", "Option 3", "Option 4"]
        ) { selected in
            print("Selected: \(selected ?? "none")")
        }
    }
    .padding()
    .background(Theme.background)
}
