# Deeper iOS Development Runbook

This runbook provides comprehensive guidance for iOS development, debugging, and configuration of the Deeper VoiceMaxxing app.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Dev Tools Usage](#dev-tools-usage)
3. [Store Management](#store-management)
4. [Step Navigation](#step-navigation)
5. [Backend Configuration](#backend-configuration)
6. [Data Export/Import](#data-exportimport)
7. [Troubleshooting](#troubleshooting)
8. [Testing](#testing)

## Quick Start

### Running the App
1. Open `Deeper-iOS/Deeper.xcodeproj` in Xcode
2. Select your target device or simulator
3. Press `Cmd+R` to build and run
4. The app will start with onboarding flow

### Accessing Dev Tools
1. Run the app in debug mode
2. Look for the "Dev Tools" button in the top-right corner
3. Tap to open the development tools sheet

## Dev Tools Usage

### Reset Onboarding
**Purpose**: Clear all onboarding progress and return to Step 0

**Steps**:
1. Open Dev Tools
2. Tap "Reset Onboarding" button
3. Confirm the action
4. App will return to Welcome screen

**Code Equivalent**:
```swift
onboardingStore.reset()
```

### Export Answers JSON
**Purpose**: Export current onboarding answers for debugging or backup

**Steps**:
1. Open Dev Tools
2. Tap "Export Answers JSON"
3. Choose export type:
   - **Answers Only**: Just the answers dictionary
   - **Full Store State**: Includes step index, user, and tokens
4. Tap "Export to JSON"
5. File saved to Documents directory
6. Tap "Share File" to export via AirDrop, email, etc.

**File Location**: `Documents/deeper_export_YYYYMMDD_HHMMSS.json`

### Import Answers JSON
**Purpose**: Import previously exported data for testing

**Steps**:
1. Open Dev Tools
2. Tap "Import Answers JSON"
3. Choose import type:
   - **Answers Only**: Import just answers
   - **Full Store State**: Import complete state including step index
4. Paste JSON data into text field
5. Tap "Import Data"
6. App will update with imported data

## Store Management

### OnboardingStore
The `OnboardingStore` manages onboarding state and persistence.

**Key Properties**:
- `stepIndex: Int` - Current step (0-based)
- `answers: [String: CodableValue]` - Collected answers
- `hydrated: Bool` - Whether store has loaded from disk

**Key Methods**:
- `saveAnswer(id: String, value: CodableValue)` - Save an answer
- `next()` - Move to next step
- `previous()` - Move to previous step
- `setStepIndex(_ index: Int)` - Jump to specific step
- `reset()` - Clear all data and return to step 0

### SessionStore
The `SessionStore` manages user authentication state.

**Key Properties**:
- `user: UserProfile?` - Current user profile
- `accessToken: String?` - Authentication token
- `isSignedIn: Bool` - Whether user is authenticated

**Key Methods**:
- `signIn(user:accessToken:refreshToken:)` - Sign in user
- `signOut()` - Sign out user
- `updateAccessToken(_ token: String)` - Update token

## Step Navigation

### Jumping to Specific Steps

#### Method 1: Dev Tools UI
1. Open Dev Tools
2. Tap "Jump to Step"
3. Enter step index (0-21)
4. Tap "Jump to Step"

#### Method 2: Quick Step Buttons
1. Open Dev Tools
2. Use quick step buttons:
   - **0**: Welcome screen
   - **16**: Current Rating (Step 17)
   - **17**: Potential Rating (Step 18)

#### Method 3: Code
```swift
// Jump to Step 17 (Current Rating)
onboardingStore.setStepIndex(16)

// Jump to Step 18 (Potential Rating)
onboardingStore.setStepIndex(17)

// Jump to Step 14 (Pre-rating screen)
onboardingStore.setStepIndex(13)
```

### Step Index Reference

| Step | Index | Name | Description |
|------|-------|------|-------------|
| 1 | 0 | Welcome | Story introduction |
| 2 | 1 | Art Style | Art style selection |
| 3 | 2 | Name Photo | User profile setup |
| 4 | 3 | Voice Train Hours | Training time input |
| 5 | 4 | Breathwork Minutes | Breathwork duration |
| 6 | 5 | Read Aloud Pages | Reading practice |
| 7 | 6 | Loud Environments | Environment hours |
| 8 | 7 | Steam Humidify | Steam therapy frequency |
| 9 | 8 | Extras Chooser | Additional options |
| 10 | 9 | Down Glides Count | Exercise repetitions |
| 11 | 10 | Technique Study | Daily study time |
| 12 | 11 | Permissions | App permissions |
| 13 | 12 | Aims | User goals |
| 14 | 13 | Analyzing | Processing screen |
| 15 | 14 | Habits Grid | Core habits overview |
| 16 | 15 | Week Radar | Week 1 preview |
| 17 | 16 | Current Rating | **Voice assessment** |
| 18 | 17 | Potential Rating | **Future potential** |
| 19 | 18 | AI Schedule | Weekly planning |
| 20 | 19 | Progression | Progress visualization |
| 21 | 20 | Calendar Week | Calendar interface |
| 22 | 21 | Vows | Commitment ceremony |
| 23 | 22 | Lock In | Hold gesture |
| 24 | 23 | Personal Message | Final greeting |
| 25 | 24 | Paywall | Subscription screen |

### Testing Specific Steps

#### Test Current Rating (Step 17)
```swift
// Set up test data
onboardingStore.saveAnswer(id: "voiceTrainHours", value: .double(2.0))
onboardingStore.saveAnswer(id: "breathworkMinutes", value: .double(15.0))
onboardingStore.saveAnswer(id: "readAloudPages", value: .double(5.0))
onboardingStore.saveAnswer(id: "aims", value: .dictionary([
    "reduceVoiceStrain": .bool(true),
    "trainInMorning": .bool(false)
]))

// Jump to rating step
onboardingStore.setStepIndex(16)
```

#### Test Potential Rating (Step 18)
```swift
// Ensure you have current rating data first
// Then jump to potential rating
onboardingStore.setStepIndex(17)
```

## Backend Configuration

### Setting Up Supabase

#### Step 1: Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Note your project URL and anon key

#### Step 2: Add Keys to Info.plist
1. Open `Deeper-iOS/Deeper/Info.plist`
2. Add these keys:

```xml
<key>SUPABASE_URL</key>
<string>https://your-project.supabase.co</string>
<key>SUPABASE_ANON_KEY</key>
<string>your-anon-key-here</string>
```

#### Step 3: Verify Configuration
1. Run the app
2. Open Dev Tools
3. Check "Backend Status" section
4. Should show "Configured: Yes" if keys are valid

### Backend Service Usage

The app automatically detects backend configuration:

- **No Keys**: Uses `NoopClientImpl` (offline mode)
- **Valid Keys**: Uses `SupabaseClientImpl` (online mode)

#### Manual Backend Testing
```swift
let backendService = BackendService()
await backendService.syncOnboarding(userId: "test-user", answers: answers)
```

## Data Export/Import

### Export Formats

#### Answers Only
```json
{
  "voiceTrainHours": 2.0,
  "breathworkMinutes": 15.0,
  "readAloudPages": 5.0,
  "aims": {
    "reduceVoiceStrain": true,
    "trainInMorning": false
  }
}
```

#### Full Store State
```json
{
  "stepIndex": 16,
  "answers": {
    "voiceTrainHours": 2.0,
    "breathworkMinutes": 15.0
  },
  "user": {
    "id": "user-123",
    "email": "user@example.com",
    "name": "Test User"
  },
  "accessToken": "token-here",
  "exportedAt": "2024-01-15T10:30:00Z",
  "version": "1.0"
}
```

### Import Process

1. **Prepare JSON**: Ensure valid JSON format
2. **Choose Type**: Answers only or full state
3. **Paste Data**: Copy JSON into import field
4. **Import**: Tap import button
5. **Verify**: Check store state in Dev Tools

### File Management

#### List Exported Files
```swift
let files = ImportExportService.listExportedFiles()
```

#### Delete Exported File
```swift
ImportExportService.deleteExportedFile(fileURL)
```

## Troubleshooting

### Common Issues

#### Store Not Hydrating
**Symptoms**: App shows loading screen indefinitely

**Solutions**:
1. Check console for persistence errors
2. Clear app data: Dev Tools → "Clear All Data"
3. Restart app
4. Check file permissions

#### Step Navigation Not Working
**Symptoms**: Can't jump to specific steps

**Solutions**:
1. Verify step index is within bounds (0-24)
2. Check FlowManifest.flow.count
3. Ensure store is hydrated before navigation

#### Export/Import Fails
**Symptoms**: JSON export/import errors

**Solutions**:
1. Check JSON format validity
2. Verify CodableValue structure
3. Check Documents directory permissions
4. Use smaller data sets for testing

#### Backend Not Connecting
**Symptoms**: Backend status shows "Not Configured"

**Solutions**:
1. Verify Info.plist keys are correct
2. Check Supabase project is active
3. Verify network connectivity
4. Check console for connection errors

### Debug Console Commands

#### Check Store State
```swift
print("Step Index: \(onboardingStore.stepIndex)")
print("Answers Count: \(onboardingStore.answers.count)")
print("Hydrated: \(onboardingStore.hydrated)")
```

#### Check Backend Status
```swift
let config = BackendConfig()
print("Configured: \(config.isConfigured)")
print("URL: \(config.supabaseURL)")
```

#### Force Store Save
```swift
onboardingStore.saveAnswer(id: "test", value: .string("value"))
// Wait for debounced save (0.5s)
```

### Performance Debugging

#### Monitor Store Operations
```swift
// Add breakpoints in:
// - OnboardingStore.saveAnswer()
// - OnboardingStore.setStepIndex()
// - Persistence.saveOnboardingStore()
```

#### Check File Sizes
```swift
let fileSize = Persistence.getFileSize(for: .onboardingStore)
print("Store file size: \(fileSize) bytes")
```

## Testing

### Unit Tests

#### Run Stats Decoding Tests
```bash
# In Xcode, run:
# DeeperTests → StatsDecodingTests
```

#### Run Persistence Tests
```bash
# In Xcode, run:
# DeeperTests → OnboardingStorePersistenceTests
```

### Manual Testing Checklist

#### Onboarding Flow
- [ ] All steps render correctly
- [ ] Navigation works (next/previous)
- [ ] Answers are saved
- [ ] Progress bar updates
- [ ] Step persistence across app relaunch

#### Rating Steps (17-18)
- [ ] Step 17 shows current rating
- [ ] Step 18 shows potential rating
- [ ] Stats calculation matches TypeScript
- [ ] Hex radar chart renders
- [ ] Metric cards display correctly

#### Dev Tools
- [ ] Reset onboarding works
- [ ] Export/import functions work
- [ ] Step jumping works
- [ ] File management works
- [ ] Store state displays correctly

#### Backend Integration
- [ ] NoopClient works offline
- [ ] SupabaseClient connects with valid keys
- [ ] Sync operations complete
- [ ] Error handling works

### Test Data Sets

#### Minimal Test Data
```json
{
  "voiceTrainHours": 1.0,
  "breathworkMinutes": 10.0,
  "aims": {
    "reduceVoiceStrain": true,
    "trainInMorning": false
  }
}
```

#### Complete Test Data
```json
{
  "voiceTrainHours": 2.0,
  "breathworkMinutes": 15.0,
  "readAloudPages": 5.0,
  "loudEnvironmentsHours": 1.0,
  "steamHumidifyFrequency": 3.0,
  "downGlidesCount": 10.0,
  "techniqueStudyDaily": 20.0,
  "aims": {
    "reduceVoiceStrain": true,
    "trainInMorning": true
  }
}
```

## Advanced Usage

### Custom Step Testing
```swift
// Create custom test scenario
let testAnswers: [String: CodableValue] = [
    "voiceTrainHours": .double(5.0),
    "breathworkMinutes": .double(30.0)
]

// Import test data
for (key, value) in testAnswers {
    onboardingStore.saveAnswer(id: key, value: value)
}

// Jump to rating step
onboardingStore.setStepIndex(16)
```

### Backend Development
```swift
// Test backend service
let backendService = BackendService()
await backendService.checkConnectivity()

// Test sync operation
await backendService.syncOnboarding(
    userId: "test-user",
    answers: onboardingStore.answers
)
```

### Performance Testing
```swift
// Measure store operations
let startTime = Date()
onboardingStore.setStepIndex(16)
let endTime = Date()
print("Step navigation took: \(endTime.timeIntervalSince(startTime))s")
```

---

## Quick Reference

### Essential Commands
- **Reset**: `onboardingStore.reset()`
- **Jump to Step 17**: `onboardingStore.setStepIndex(16)`
- **Export Data**: Dev Tools → Export Answers JSON
- **Check Backend**: Dev Tools → Backend Status

### Key Files
- **Store Logic**: `Core/Services/Stores.swift`
- **Dev Tools**: `Features/Dev/DevToolsView.swift`
- **Import/Export**: `Core/Services/ImportExport.swift`
- **Flow Definition**: `Features/Onboarding/FlowManifest.swift`

### Important Notes
- Step indices are 0-based (Step 17 = index 16)
- Store auto-saves with 0.5s debounce
- Backend keys go in Info.plist
- Export files saved to Documents directory
- All operations are async/await compatible

For additional help, check the console logs or refer to the source code comments.
