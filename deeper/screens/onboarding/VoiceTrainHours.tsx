import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import GradientScreen from '../../src/ui/GradientScreen';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';

export default function VoiceTrainHoursScreen() {
  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.25} />
      <GradientScreen title="Training Plan" subtitle="How many minutes per day?">
        <View style={styles.content}>
          <View style={styles.placeholderBox}>
            <Text style={styles.placeholderText}>VoiceTrainHours coming soon</Text>
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
    justifyContent: 'center',
    paddingHorizontal: spacing.lg,
  },
  placeholderBox: {
    height: 180,
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    justifyContent: 'center',
    alignItems: 'center',
  },
  placeholderText: {
    color: colors.subtext,
    fontSize: fontSizes.md,
  },
});


