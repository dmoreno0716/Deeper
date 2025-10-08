# Deeper iOS App

This is the SwiftUI iOS version of the Deeper voice training app, migrated from the original Expo/React Native implementation.

## Project Overview

**Deeper** is a voice training application that guides users through a comprehensive onboarding process to create a personalized voice improvement plan. The app uses a dark theme with orange accent colors and features an anime-inspired aesthetic.

## Migration from Expo App

This iOS app replicates the structure and functionality of the original Expo app located in `../deeper/`. Key elements migrated include:

### Design System
- **Colors**: Matching color palette from the Expo theme
  - Background: `#0D0A12`
  - Card: `#15121C`
  - Text Primary: `#FFFFFF`
  - Text Secondary: `#C9C6D0`
  - Accent: `#FF6A00`
  - Success: `#22C55E`
  - Warning: `#F59E0B`
  - Danger: `#EF4444`

- **Typography**: Font sizes and spacing matching the original design
- **Components**: SwiftUI equivalents of React Native components
  - `PrimaryButton` → Expo `PrimaryButton`
  - `ProgressBar` → Expo `ProgressBar`
  - `GradientScreen` → Expo `GradientScreen`

### Onboarding Flow
The app implements the same 15-step onboarding process as the original:

1. **Welcome** - Introduction with character art placeholder
2. **ArtStyle** - Artistic style selection
3. **NamePhoto** - User profile setup
4. **VoiceTrainHours** - Voice training frequency
5. **BreathworkMinutes** - Breathwork duration
6. **ReadAloudPages** - Reading aloud practice
7. **LoudEnvironmentsHours** - Time in loud environments
8. **SteamHumidifyFrequency** - Vocal care practices
9. **ExtrasChooser** - Additional features (max 2 selections)
10. **DownGlidesCount** - Vocal exercise frequency
11. **TechniqueStudyDaily** - Daily technique practice
12. **Permissions** - App permissions
13. **Aims** - User goals and preferences
14. **Analyzing** - Processing responses
15. **CurrentRating** - Current voice assessment
16. **PotentialRating** - Potential voice improvement

### Data Models
- `OnboardingAnswers` - Structured data model for user responses
- `OnboardingStore` - State management using SwiftUI's `@StateObject` and `@ObservableObject`
- Persistent storage using `UserDefaults` with version migration support

### Architecture
- **MVVM Pattern**: SwiftUI Views with ObservableObject ViewModels
- **Modular Structure**: Organized by features and core functionality
- **State Management**: Centralized onboarding store with persistence

## Project Structure

```
Deeper-iOS/
├── Deeper.xcodeproj          # Xcode project file
├── Deeper/                   # Main app target
│   ├── App/                  # App entry point
│   │   ├── DeeperApp.swift   # @main app struct
│   │   └── RootView.swift    # Root navigation view
│   ├── Core/                 # Core functionality
│   │   ├── Theme/            # Design system and theming
│   │   ├── DesignSystem/     # Reusable UI components
│   │   ├── Models/           # Data models
│   │   ├── Services/         # Business logic and state management
│   │   └── Navigation/       # Navigation and routing
│   ├── Features/             # Feature modules
│   │   ├── Onboarding/       # Onboarding flow screens
│   │   ├── Paywall/          # Subscription/payment screens
│   │   └── Home/             # Main app screens
│   └── Resources/            # Assets and resources
│       └── Assets.xcassets   # Color sets, images, etc.
└── README.md                 # This file
```

## Key Features

### State Management
- **OnboardingStore**: Centralized state management for the onboarding flow
- **Persistence**: User responses saved to UserDefaults with version migration
- **Progress Tracking**: Visual progress bar showing onboarding completion

### UI Components
- **GradientScreen**: Full-screen gradient background with title/subtitle support
- **PrimaryButton**: Consistent button styling with loading and disabled states
- **ProgressBar**: Visual progress indicator matching the Expo design

### Navigation
- **Step-based Navigation**: Sequential flow through onboarding steps
- **State Persistence**: Resume onboarding from where user left off
- **Progress Visualization**: Real-time progress updates

## Copy and Art Notes

The app maintains the same copy and art notes from the original Expo implementation:

### Art Placeholders
- **Welcome Screen**: "Anime male hero holding a glowing tuning fork/flame, front pose on a runic pedestal"
- **Art Style Screen**: "Art style selection interface - grid of artistic style previews with orange accent highlights"
- **Style Preview Cards**: "Animated previews of different art styles (anime, realistic, abstract, etc.)"

### Copy Elements
- **Welcome**: "Prepare to descend. A deeper voice awaits."
- **Art Style**: "Choose Your Art Style - Select the artistic style that resonates with you"
- **Extras Options**: Voice journal, Jaw & neck release, Posture drill, Tongue posture, Caffeine cap, No smoke, No alcohol, Nasal breathing

## Technical Requirements

- **iOS 17.0+**: Minimum deployment target
- **Swift 5.0+**: Language version
- **SwiftUI**: Primary UI framework
- **Xcode 15.0+**: Development environment

## Bundle Information

- **Bundle ID**: `com.davidmoreno.deeper`
- **App Name**: Deeper
- **Version**: 1.0.0

## Development Status

This is the initial SwiftUI implementation with:
- ✅ Project structure and navigation
- ✅ Theme system and color assets
- ✅ Basic UI components
- ✅ Onboarding flow structure
- ✅ State management and persistence
- 🔄 Individual screen implementations (placeholder views created)
- 🔄 Feature-specific UI components
- 🔄 Advanced animations and interactions

## Next Steps

1. Implement individual onboarding screen logic and UI
2. Add feature-specific components (Home, Paywall screens)
3. Integrate with backend APIs if needed
4. Add animations and micro-interactions
5. Implement accessibility features
6. Add unit and UI tests

## Notes

This iOS app serves as a native companion to the Expo app, allowing for platform-specific optimizations while maintaining feature parity. The modular architecture makes it easy to extend with additional features and maintain consistency across platforms.
