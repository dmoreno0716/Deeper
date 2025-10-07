import React, { useCallback, useMemo, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import GradientScreen from '../../src/ui/GradientScreen';
import PrimaryButton from '../../src/ui/PrimaryButton';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';
import { useOnboardingStore } from '../../src/state/onboardingStore';
import { useNavigation } from '@react-navigation/native';
import { NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../../src/navigation/RootNavigator';

export default function AimsScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const onboardingStore = useOnboardingStore();

  const [reduceVoiceStrain, setReduceVoiceStrain] = useState<boolean | null>(null);
  const [trainInMorning, setTrainInMorning] = useState<boolean | null>(null);

  const questions = useMemo(
    () => [
      {
        key: 'reduceVoiceStrain',
        question: 'Do you aim to reduce voice strain?',
        value: reduceVoiceStrain,
        setValue: setReduceVoiceStrain,
      },
      {
        key: 'trainInMorning',
        question: 'Do you like to train in the morning?',
        value: trainInMorning,
        setValue: setTrainInMorning,
      },
    ],
    [reduceVoiceStrain, trainInMorning]
  );

  const handleContinue = useCallback(() => {
    const aimsData: Record<string, boolean> = {};
    questions.forEach((q) => {
      if (q.value !== null) {
        aimsData[q.key] = q.value;
      }
    });
    onboardingStore.saveAnswer('aims', aimsData);
    navigation.navigate('Analyzing');
  }, [navigation, onboardingStore, questions]);

  const isComplete = questions.every((q) => q.value !== null);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.49} />
      <GradientScreen>
        <View style={styles.content}>
          <Text style={styles.title}>Aims</Text>
          
          <View style={styles.questionsContainer}>
            {questions.map((question) => (
              <View key={question.key} style={styles.questionCard}>
                <Text style={styles.questionText}>{question.question}</Text>
                <View style={styles.toggleRow}>
                  <TouchableOpacity
                    style={[
                      styles.toggleButton,
                      question.value === false && styles.toggleButtonActive,
                    ]}
                    onPress={() => question.setValue(false)}
                    activeOpacity={0.8}
                  >
                    <Text
                      style={[
                        styles.toggleButtonText,
                        question.value === false && styles.toggleButtonTextActive,
                      ]}
                    >
                      No
                    </Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={[
                      styles.toggleButton,
                      question.value === true && styles.toggleButtonActive,
                    ]}
                    onPress={() => question.setValue(true)}
                    activeOpacity={0.8}
                  >
                    <Text
                      style={[
                        styles.toggleButtonText,
                        question.value === true && styles.toggleButtonTextActive,
                      ]}
                    >
                      Yes
                    </Text>
                  </TouchableOpacity>
                </View>
              </View>
            ))}
          </View>

          <View style={styles.progressMeter}>
            <Text style={styles.progressText}>Picking content</Text>
            <View style={styles.progressBar}>
              <View style={[styles.progressFill, { width: '49%' }]} />
            </View>
          </View>

          <View style={styles.continueRow}>
            <PrimaryButton 
              title="Continue" 
              onPress={handleContinue}
              disabled={!isComplete}
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
    paddingHorizontal: spacing.lg,
    paddingBottom: spacing.xxl,
  },
  title: {
    color: colors.text,
    fontSize: fontSizes.xl,
    fontWeight: '700',
    marginTop: spacing.xl,
    marginBottom: spacing.lg,
  },
  questionsContainer: {
    marginBottom: spacing.xl,
  },
  questionCard: {
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  questionText: {
    color: colors.text,
    fontSize: fontSizes.lg,
    fontWeight: '600',
    marginBottom: spacing.md,
  },
  toggleRow: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  toggleButton: {
    flex: 1,
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
    borderRadius: 8,
    backgroundColor: colors.background,
    borderWidth: 1,
    borderColor: colors.subtext + '30',
    alignItems: 'center',
  },
  toggleButtonActive: {
    backgroundColor: colors.accent + '20',
    borderColor: colors.accent,
  },
  toggleButtonText: {
    color: colors.subtext,
    fontSize: fontSizes.md,
    fontWeight: '500',
  },
  toggleButtonTextActive: {
    color: colors.text,
    fontWeight: '600',
  },
  progressMeter: {
    marginBottom: spacing.xl,
  },
  progressText: {
    color: colors.subtext,
    fontSize: fontSizes.md,
    marginBottom: spacing.sm,
    textAlign: 'center',
  },
  progressBar: {
    height: 8,
    backgroundColor: colors.card,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: colors.accent,
    borderRadius: 4,
  },
  continueRow: {
    marginTop: spacing.lg,
  },
});
