# Deeper - Expo TypeScript Foundation

A production-ready Expo TypeScript foundation for the Deeper app with React Navigation, dark theme, and comprehensive UI components.

## 🎨 Design System

### Colors
- **Background**: `#0D0A12` (Deep purple/black)
- **Card**: `#15121C` (Slightly lighter purple)
- **Text**: `#FFFFFF` (White)
- **Subtext**: `#C9C6D0` (Light gray)
- **Accent**: `#FF6A00` (Glowing orange)
- **Success**: `#22C55E` (Green)
- **Warning**: `#F59E0B` (Yellow)
- **Danger**: `#EF4444` (Red)

### Typography
- Font sizes: `xxs` (10px) to `xxxl` (32px)
- Consistent spacing: `xxs` (2px) to `xxxxl` (40px)

## 🏗️ Architecture

### Navigation
- **RootNavigator**: Native Stack Navigator with dark theme
- **Initial Route**: Welcome screen
- **Status Bar**: Light content on dark background

### State Management
- **Zustand Store**: `onboardingStore.ts` with persistence
- **Types**: Comprehensive TypeScript interfaces
- **Storage**: Automatic persistence of onboarding data

### UI Components
- **PrimaryButton**: Orange accent button with glow effect
- **SecondaryButton**: Outlined button with accent border
- **ConfirmBar**: Bottom bar with primary action
- **ProgressDots**: Step indicator with active/completed states
- **GradientScreen**: Wrapper with subtle gradient background

## 📁 Project Structure

```
src/
├── navigation/
│   └── RootNavigator.tsx      # Main navigation setup
├── state/
│   └── onboardingStore.ts     # Zustand store with types
├── theme/
│   └── colors.ts              # Color palette & utilities
└── ui/
    ├── index.ts               # Component exports
    ├── PrimaryButton.tsx      # Primary action button
    ├── SecondaryButton.tsx    # Secondary action button
    ├── ConfirmBar.tsx         # Bottom confirmation bar
    ├── ProgressDots.tsx      # Progress indicator
    └── GradientScreen.tsx    # Gradient wrapper

screens/
└── onboarding/
    └── Welcome.tsx           # Welcome/landing screen
```

## 🚀 Getting Started

1. **Install dependencies**:
   ```bash
   npm install
   ```

2. **Start the development server**:
   ```bash
   npm start
   ```

3. **Run on device/simulator**:
   ```bash
   npm run ios     # iOS
   npm run android # Android
   npm run web     # Web
   ```

## 🎯 Features

- ✅ React Navigation with Native Stack
- ✅ Dark theme with deep purple/black colors
- ✅ Orange accent color (#FF6A00) with glow effects
- ✅ Zustand state management with persistence
- ✅ TypeScript throughout
- ✅ Reusable UI components
- ✅ SafeAreaView integration
- ✅ Status bar configuration
- ✅ Gradient backgrounds
- ✅ Progress indicators
- ✅ Comprehensive type definitions

## 🔧 Usage Examples

### Using the Onboarding Store
```typescript
import { useOnboardingStore } from '../src/state/onboardingStore';

const { name, updateName, markStepCompleted } = useOnboardingStore();
```

### Using UI Components
```typescript
import { PrimaryButton, GradientScreen, ProgressDots } from '../src/ui';

<GradientScreen title="Welcome" subtitle="Get started">
  <PrimaryButton title="Continue" onPress={handlePress} />
  <ProgressDots totalSteps={5} currentStep={2} />
</GradientScreen>
```

### Navigation
```typescript
import { useNavigation } from '@react-navigation/native';
import type { RootStackParamList } from '../src/navigation/RootNavigator';

const navigation = useNavigation<NavigationProp<RootStackParamList>>();
```

## 🎨 Customization

The foundation is designed to be easily customizable:

- **Colors**: Modify `src/theme/colors.ts`
- **Components**: Extend existing components in `src/ui/`
- **Navigation**: Add new screens to `RootNavigator.tsx`
- **State**: Extend the onboarding store or create new stores

## 📱 Platform Support

- ✅ iOS
- ✅ Android  
- ✅ Web
- ✅ Expo Go compatible
