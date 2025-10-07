import React from 'react';
import {
  View,
  Text,
  StyleSheet,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import GradientScreen from '../../src/ui/GradientScreen';
import PrimaryButton from '../../src/ui/PrimaryButton';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';

export default function ArtStyleScreen() {
  const handleContinue = () => {
    // TODO: Navigate to next onboarding step
    console.log('Continue pressed');
  };

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.2} />
      
      <GradientScreen
        title="Choose Your Art Style"
        subtitle="Select the artistic style that resonates with you"
      >
        <View style={styles.content}>
          <View style={styles.artContent}>
            {/* *INSERT ART HERE: Art style selection interface - grid of artistic style previews with orange accent highlights* */}
            
            <Text style={styles.description}>
              Each style has its own unique characteristics and will influence how your AI-generated art looks.
            </Text>
            
            {/* *INSERT ART HERE: Style preview cards - animated previews of different art styles (anime, realistic, abstract, etc.)* */}
            <View style={styles.styleGrid}>
              <Text style={styles.placeholderText}>Art Style Selection Coming Soon</Text>
            </View>
          </View>

          <View style={styles.bottomSection}>
            <PrimaryButton
              title="Continue"
              onPress={handleContinue}
              style={styles.continueButton}
            />
          </View>
        </View>
      </GradientScreen>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  content: {
    flex: 1,
    justifyContent: 'space-between',
  },
  artContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  description: {
    fontSize: fontSizes.lg,
    color: colors.subtext,
    textAlign: 'center',
    lineHeight: 24,
    marginBottom: spacing.xxxl,
    paddingHorizontal: spacing.md,
  },
  styleGrid: {
    width: '100%',
    height: 200,
    backgroundColor: colors.card,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: colors.subtext + '20',
  },
  placeholderText: {
    fontSize: fontSizes.md,
    color: colors.subtext,
    textAlign: 'center',
  },
  bottomSection: {
    paddingBottom: spacing.lg,
  },
  continueButton: {
    width: '100%',
  },
});
