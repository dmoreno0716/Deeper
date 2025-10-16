import SwiftUI

/// Enhanced development tools view with reset and export functionality
struct DevToolsView: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
    @State private var showingStepJumpSheet = false
    @State private var exportedFiles: [URL] = []
    @State private var stepJumpIndex: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.spacingLG) {
                    // Store State Section
                    storeStateSection
                    
                    // Quick Actions Section
                    quickActionsSection
                    
                    // Export/Import Section
                    exportImportSection
                    
                    // Step Navigation Section
                    stepNavigationSection
                    
                    // File Management Section
                    fileManagementSection
                    
                    Spacer(minLength: Theme.spacingXXXL)
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle("Dev Tools")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
        .onAppear {
            loadExportedFiles()
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportSheet()
        }
        .sheet(isPresented: $showingImportSheet) {
            ImportSheet()
        }
        .sheet(isPresented: $showingStepJumpSheet) {
            StepJumpSheet(stepJumpIndex: $stepJumpIndex)
        }
    }
    
    // MARK: - View Sections
    
    @ViewBuilder
    private var storeStateSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMD) {
            Text("Store State")
                .font(.deeperSubtitle)
                .foregroundColor(Theme.textPrimary)
            
            VStack(alignment: .leading, spacing: Theme.spacingSM) {
                stateRow("Onboarding Step", "\(onboardingStore.stepIndex)")
                stateRow("Answers Count", "\(onboardingStore.answers.count)")
                stateRow("Hydrated", onboardingStore.hydrated ? "Yes" : "No", onboardingStore.hydrated ? Theme.success : Theme.danger)
                stateRow("Signed In", sessionStore.isSignedIn ? "Yes" : "No", sessionStore.isSignedIn ? Theme.success : Theme.danger)
                
                if let user = sessionStore.user {
                    stateRow("User Email", user.email)
                    stateRow("User Name", user.name ?? "N/A")
                }
            }
            .font(.deeperCaption)
            .foregroundColor(Theme.textSecondary)
        }
        .padding()
        .cardStyle()
    }
    
    @ViewBuilder
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMD) {
            Text("Quick Actions")
                .font(.deeperSubtitle)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingSM) {
                SecondaryButton(title: "Reset Onboarding") {
                    resetOnboarding()
                }
                
                SecondaryButton(title: "Clear All Data") {
                    clearAllData()
                }
                
                if sessionStore.isSignedIn {
                    SecondaryButton(title: "Sign Out") {
                        sessionStore.signOut()
                    }
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    @ViewBuilder
    private var exportImportSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMD) {
            Text("Export/Import")
                .font(.deeperSubtitle)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingSM) {
                PrimaryButton(title: "Export Answers JSON") {
                    showingExportSheet = true
                }
                
                SecondaryButton(title: "Import Answers JSON") {
                    showingImportSheet = true
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    @ViewBuilder
    private var stepNavigationSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMD) {
            Text("Step Navigation")
                .font(.deeperSubtitle)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingSM) {
                SecondaryButton(title: "Jump to Step") {
                    showingStepJumpSheet = true
                }
                
                // Quick step buttons
                HStack(spacing: Theme.spacingSM) {
                    quickStepButton("0", "Welcome")
                    quickStepButton("16", "Rating")
                    quickStepButton("17", "Potential")
                }
                
                // Simple step index input
                HStack {
                    TextField("Step Index", text: $stepJumpIndex)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(maxWidth: 100)
                    
                    Button("Go") {
                        jumpToStep(Int(stepJumpIndex) ?? 0)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    @ViewBuilder
    private var fileManagementSection: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMD) {
            Text("Exported Files")
                .font(.deeperSubtitle)
                .foregroundColor(Theme.textPrimary)
            
            if exportedFiles.isEmpty {
                Text("No exported files")
                    .font(.deeperCaption)
                    .foregroundColor(Theme.textSecondary)
                    .italic()
            } else {
                ForEach(exportedFiles, id: \.self) { fileURL in
                    ExportedFileRow(fileURL: fileURL) {
                        loadExportedFiles()
                    }
                }
            }
        }
        .padding()
        .cardStyle()
    }
    
    // MARK: - Helper Views
    
    @ViewBuilder
    private func stateRow(_ label: String, _ value: String, _ color: Color = Theme.accent) -> some View {
        HStack {
            Text(label + ":")
            Spacer()
            Text(value)
                .foregroundColor(color)
        }
    }
    
    @ViewBuilder
    private func quickStepButton(_ step: String, _ name: String) -> some View {
        Button(action: {
            jumpToStep(Int(step) ?? 0)
        }) {
            VStack(spacing: 2) {
                Text(step)
                    .font(.deeperCaption)
                    .fontWeight(.bold)
                Text(name)
                    .font(.system(size: 10))
            }
            .foregroundColor(Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Theme.spacingXS)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Theme.textSecondary.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Actions
    
    private func resetOnboarding() {
        onboardingStore.reset()
        dismiss()
    }
    
    private func clearAllData() {
        onboardingStore.reset()
        sessionStore.signOut()
        dismiss()
    }
    
    private func jumpToStep(_ step: Int) {
        let maxStep = FlowManifest.flow.count - 1
        let clampedStep = max(0, min(step, maxStep))
        onboardingStore.setIndex(clampedStep)
        dismiss()
    }
    
    private func loadExportedFiles() {
        exportedFiles = ImportExportService.listExportedFiles()
    }
}

// MARK: - Export Sheet

struct ExportSheet: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var exportType: ExportType = .answers
    @State private var showingShareSheet = false
    @State private var exportedURL: URL?
    
    enum ExportType: String, CaseIterable {
        case answers = "Answers Only"
        case fullState = "Full Store State"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLG) {
                VStack(alignment: .leading, spacing: Theme.spacingMD) {
                    Text("Export Options")
                        .font(.deeperSubtitle)
                        .foregroundColor(Theme.textPrimary)
                    
                    Picker("Export Type", selection: $exportType) {
                        ForEach(ExportType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .cardStyle()
                
                VStack(spacing: Theme.spacingMD) {
                    PrimaryButton(title: "Export to JSON") {
                        exportData()
                    }
                    
                    if let url = exportedURL {
                        SecondaryButton(title: "Share File") {
                            showingShareSheet = true
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Theme.background)
            .navigationTitle("Export Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            if let url = exportedURL {
                ShareSheet(items: [url])
            }
        }
    }
    
    private func exportData() {
        let jsonString: String?
        
        switch exportType {
        case .answers:
            jsonString = ImportExportService.exportAnswersToJSON(onboardingStore.answers)
        case .fullState:
            jsonString = ImportExportService.exportStoreState(
                stepIndex: onboardingStore.stepIndex,
                answers: onboardingStore.answers,
                user: sessionStore.user,
                accessToken: sessionStore.accessToken
            )
        }
        
        if let jsonString = jsonString {
            let timestamp = DateFormatter.timestamp.string(from: Date())
            let filename = "deeper_export_\(timestamp).json"
            exportedURL = ImportExportService.saveToDocuments(jsonString, filename: filename)
        }
    }
}

// MARK: - Import Sheet

struct ImportSheet: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var jsonInput: String = ""
    @State private var importType: ImportType = .answers
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    enum ImportType: String, CaseIterable {
        case answers = "Answers Only"
        case fullState = "Full Store State"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLG) {
                VStack(alignment: .leading, spacing: Theme.spacingMD) {
                    Text("Import Options")
                        .font(.deeperSubtitle)
                        .foregroundColor(Theme.textPrimary)
                    
                    Picker("Import Type", selection: $importType) {
                        ForEach(ImportType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .padding()
                .cardStyle()
                
                VStack(alignment: .leading, spacing: Theme.spacingMD) {
                    Text("JSON Data")
                        .font(.deeperSubtitle)
                        .foregroundColor(Theme.textPrimary)
                    
                    TextEditor(text: $jsonInput)
                        .font(.deeperCaption)
                        .foregroundColor(Theme.textPrimary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .frame(minHeight: 200)
                }
                .padding()
                .cardStyle()
                
                PrimaryButton(title: "Import Data") {
                    importData()
                }
                
                Spacer()
            }
            .padding()
            .background(Theme.background)
            .navigationTitle("Import Data")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
        .alert("Import Result", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func importData() {
        guard !jsonInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter JSON data to import"
            showingAlert = true
            return
        }
        
        switch importType {
        case .answers:
            if let answers = ImportExportService.importAnswersFromJSON(jsonInput) {
                // Import answers into store
                for (key, value) in answers {
                    onboardingStore.saveAnswer(id: key, value: value)
                }
                alertMessage = "Successfully imported \(answers.count) answers"
            } else {
                alertMessage = "Failed to import answers. Please check JSON format."
            }
            
        case .fullState:
            if let storeData = ImportExportService.importStoreStateFromJSON(jsonInput) {
                // Import full store state
                onboardingStore.setStepIndex(storeData.stepIndex)
                for (key, value) in storeData.answers {
                    onboardingStore.saveAnswer(id: key, value: value)
                }
                
                if let user = storeData.user, let token = storeData.accessToken {
                    sessionStore.signIn(user: user, accessToken: token)
                }
                
                alertMessage = "Successfully imported store state"
            } else {
                alertMessage = "Failed to import store state. Please check JSON format."
            }
        }
        
        showingAlert = true
    }
}

// MARK: - Step Jump Sheet

struct StepJumpSheet: View {
    @EnvironmentObject var onboardingStore: OnboardingStore
    @Environment(\.dismiss) private var dismiss
    
    @Binding var stepJumpIndex: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.spacingLG) {
                VStack(alignment: .leading, spacing: Theme.spacingMD) {
                    Text("Jump to Step")
                        .font(.deeperSubtitle)
                        .foregroundColor(Theme.textPrimary)
                    
                    TextField("Step Index (0-\(FlowManifest.flow.count - 1))", text: $stepJumpIndex)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding()
                .cardStyle()
                
                PrimaryButton(title: "Jump to Step") {
                    jumpToStep()
                }
                
                Spacer()
            }
            .padding()
            .background(Theme.background)
            .navigationTitle("Step Navigation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Theme.accent)
                }
            }
        }
    }
    
    private func jumpToStep() {
        guard let stepIndex = Int(stepJumpIndex) else { return }
        
        let maxStep = FlowManifest.flow.count - 1
        let clampedStep = max(0, min(stepIndex, maxStep))
        onboardingStore.setIndex(clampedStep)
        dismiss()
    }
}

// MARK: - Exported File Row

struct ExportedFileRow: View {
    let fileURL: URL
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(fileURL.lastPathComponent)
                    .font(.deeperCaption)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textPrimary)
                
                Text(fileURL.path)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textSecondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {
                ImportExportService.deleteExportedFile(fileURL)
                onDelete()
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(Theme.danger)
            }
        }
        .padding(.vertical, Theme.spacingXS)
    }
}

// MARK: - Share Sheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let timestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return formatter
    }()
}
