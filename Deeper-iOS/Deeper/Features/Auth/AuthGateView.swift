import SwiftUI

/// Authentication gate view for email/name input to populate SessionStore.user
struct AuthGateView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            
            VStack(spacing: Theme.spacingXL) {
                // Header
                headerView
                
                // Art block
                artBlockView
                
                // Form
                formView
                
                // Action buttons
                actionButtonsView
                
                Spacer()
            }
            .padding(.horizontal, Theme.spacingLG)
        }
        .onAppear {
            // Pre-fill with mock data for demo
            email = "user@example.com"
            name = "VoiceMaxxer"
        }
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private var headerView: some View {
        VStack(spacing: Theme.spacingSM) {
            Text("Welcome to VoiceMaxxing")
                .font(.deeperTitle)
                .fontWeight(.bold)
                .foregroundColor(Theme.textPrimary)
                .multilineTextAlignment(.center)
            
            Text("Let's get you set up with your account")
                .font(.deeperBody)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.spacingXXXL)
    }
    
    @ViewBuilder
    private var artBlockView: some View {
        ArtBlock(description: "Authentication interface with user profile setup")
            .aspectRatio(16/9, contentMode: .fit)
    }
    
    @ViewBuilder
    private var formView: some View {
        VStack(spacing: Theme.spacingMD) {
            Text("Your Information")
                .font(.deeperSubtitle)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textPrimary)
            
            VStack(spacing: Theme.spacingMD) {
                // Email field
                VStack(alignment: .leading, spacing: Theme.spacingXS) {
                    Text("Email")
                        .font(.deeperBody)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.textPrimary)
                    
                    TextField("Enter your email", text: $email)
                        .textFieldStyle(AuthTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                // Name field
                VStack(alignment: .leading, spacing: Theme.spacingXS) {
                    Text("Name")
                        .font(.deeperBody)
                        .fontWeight(.medium)
                        .foregroundColor(Theme.textPrimary)
                    
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(AuthTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
            }
            
            // Error message
            if showError {
                errorMessageView
            }
        }
    }
    
    @ViewBuilder
    private var errorMessageView: some View {
        HStack(spacing: Theme.spacingSM) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Theme.danger)
            
            Text(errorMessage)
                .font(.deeperCaption)
                .foregroundColor(Theme.danger)
                .lineSpacing(1)
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.danger.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Theme.danger.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    private var actionButtonsView: some View {
        VStack(spacing: Theme.spacingMD) {
            // Continue button
            Button(action: {
                handleContinue()
            }) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Continue")
                            .font(.deeperBody)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isFormValid ? Theme.accent : Theme.textSecondary.opacity(0.3))
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(!isFormValid || isLoading)
            
            // Skip button
            Button(action: {
                handleSkip()
            }) {
                Text("Skip for now")
                    .font(.deeperBody)
                    .fontWeight(.medium)
                    .foregroundColor(Theme.textSecondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        return !email.isEmpty && !name.isEmpty && isValidEmail(email)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: - Helper Methods
    
    private func handleContinue() {
        guard isFormValid else { return }
        
        isLoading = true
        showError = false
        
        // Mock authentication - in a real app, this would call the backend
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performMockSignIn()
        }
    }
    
    private func performMockSignIn() {
        // Create mock user profile
        let userProfile = UserProfile(
            id: UUID().uuidString,
            email: email,
            name: name,
            avatarUrl: nil
        )
        
        // Mock tokens
        let accessToken = "mock_access_token_\(UUID().uuidString)"
        let refreshToken = "mock_refresh_token_\(UUID().uuidString)"
        
        // Sign in to session store
        sessionStore.signIn(
            user: userProfile,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
        
        print("✅ Mock sign-in successful for \(email)")
        
        isLoading = false
        onComplete()
    }
    
    private func handleSkip() {
        print("📱 User skipped authentication")
        onComplete()
    }
}

// MARK: - Auth Text Field Style

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.textSecondary.opacity(0.2), lineWidth: 1)
                    )
            )
            .font(.deeperBody)
            .foregroundColor(Theme.textPrimary)
    }
}

// MARK: - Auth Gate Step View

/// Step view for authentication gate screens
struct AuthGateStepView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        AuthGateView {
            // Navigate to next step after authentication
            print("Authentication completed, proceeding to next step")
        }
    }
}

// MARK: - Preview

#Preview {
    AuthGateView {
        print("Auth completed")
    }
    .environmentObject(SessionStore())
}
