import SwiftUI

struct ChipToggle: View {
    let title: String
    @Binding var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            isSelected.toggle()
        }) {
            Text(title)
                .font(.deeperCaption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? Theme.textPrimary : Theme.textSecondary)
                .padding(.horizontal, Theme.spacingMD)
                .padding(.vertical, Theme.spacingSM)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isSelected ? Theme.accent : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    isSelected ? Theme.accent : Theme.textSecondary.opacity(0.3),
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint("Double tap to toggle selection")
    }
}

struct MultiSelectChipToggle: View {
    let title: String
    @Binding var isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
            isSelected.toggle()
        }) {
            HStack(spacing: Theme.spacingXS) {
                Text(title)
                    .font(.deeperCaption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.textPrimary : Theme.textSecondary)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
            .padding(.horizontal, Theme.spacingMD)
            .padding(.vertical, Theme.spacingSM)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Theme.accent : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Theme.accent : Theme.textSecondary.opacity(0.3),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(title)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint("Double tap to toggle selection")
    }
}

// Container view for managing multiple chips
struct ChipToggleGroup: View {
    let options: [String]
    @Binding var selectedOptions: Set<String>
    var multiSelect: Bool = true
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 100, maximum: 150), spacing: Theme.spacingSM)
        ], spacing: Theme.spacingSM) {
            ForEach(options, id: \.self) { option in
                if multiSelect {
                    MultiSelectChipToggle(
                        title: option,
                        isSelected: Binding(
                            get: { selectedOptions.contains(option) },
                            set: { _ in }
                        ),
                        action: {
                            if selectedOptions.contains(option) {
                                selectedOptions.remove(option)
                            } else {
                                selectedOptions.insert(option)
                            }
                        }
                    )
                } else {
                    ChipToggle(
                        title: option,
                        isSelected: Binding(
                            get: { selectedOptions.contains(option) },
                            set: { _ in }
                        ),
                        action: {
                            selectedOptions.removeAll()
                            selectedOptions.insert(option)
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Single select example
        VStack(alignment: .leading, spacing: 8) {
            Text("Single Select")
                .font(.deeperSubtitle)
                .foregroundColor(Theme.textPrimary)
            
            ChipToggleGroup(
                options: ["Option 1", "Option 2", "Option 3"],
                selectedOptions: .constant(["Option 2"]),
                multiSelect: false
            )
        }
        
        // Multi select example
        VStack(alignment: .leading, spacing: 8) {
            Text("Multi Select")
                .font(.deeperSubtitle)
                .foregroundColor(Theme.textPrimary)
            
            ChipToggleGroup(
                options: ["Tag 1", "Tag 2", "Tag 3", "Tag 4"],
                selectedOptions: .constant(["Tag 1", "Tag 3"]),
                multiSelect: true
            )
        }
    }
    .padding()
    .background(Theme.background)
}
