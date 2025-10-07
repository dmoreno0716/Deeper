import React, { useCallback, useMemo } from 'react';
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

export default function CurrentRatingScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const onboardingData = useOnboardingStore();

  const calculateScores = useCallback(() => {
    const { answers } = onboardingData;
    
    // Simple heuristic calculations based on collected data
    const voiceTrainHours = (answers.voiceTrainHours as number) || 0;
    const breathworkMinutes = (answers.breathworkMinutes as number) || 0;
    const readAloudPages = (answers.readAloudPages as number) || 0;
    const loudEnvironmentsHours = (answers.loudEnvironmentsHours as number) || 0;
    const steamHumidifyFrequency = (answers.steamHumidifyFrequency as number) || 0;
    const downGlidesCount = (answers.downGlidesCount as number) || 0;
    const techniqueStudyDaily = (answers.techniqueStudyDaily as number) || 0;
    
    const aims = (answers.aims as Record<string, boolean>) || {};
    const reduceVoiceStrain = aims.reduceVoiceStrain || false;
    const trainInMorning = aims.trainInMorning || false;

    // Calculate scores (0-100) based on collected data
    const overall = Math.min(100, Math.max(0, 
      (voiceTrainHours * 2) + 
      (breathworkMinutes * 0.5) + 
      (readAloudPages * 1.5) + 
      (techniqueStudyDaily * 0.3) + 
      (reduceVoiceStrain ? 20 : 0) + 
      (trainInMorning ? 10 : 0) - 
      (loudEnvironmentsHours * 3)
    ));

    const resonance = Math.min(100, Math.max(0, 
      (voiceTrainHours * 1.5) + 
      (steamHumidifyFrequency * 2) + 
      (downGlidesCount * 1.2) + 
      (reduceVoiceStrain ? 15 : 0)
    ));

    const breath = Math.min(100, Math.max(0, 
      (breathworkMinutes * 1.2) + 
      (steamHumidifyFrequency * 1.5) + 
      (techniqueStudyDaily * 0.4) + 
      (trainInMorning ? 8 : 0)
    ));

    const technique = Math.min(100, Math.max(0, 
      (techniqueStudyDaily * 1.8) + 
      (voiceTrainHours * 1.2) + 
      (downGlidesCount * 1.0) + 
      (readAloudPages * 0.8)
    ));

    const consistency = Math.min(100, Math.max(0, 
      (voiceTrainHours * 1.0) + 
      (breathworkMinutes * 0.8) + 
      (readAloudPages * 1.0) + 
      (trainInMorning ? 12 : 0) + 
      (reduceVoiceStrain ? 10 : 0)
    ));

    const confidence = Math.min(100, Math.max(0, 
      (voiceTrainHours * 1.3) + 
      (techniqueStudyDaily * 1.5) + 
      (readAloudPages * 1.2) + 
      (downGlidesCount * 0.9) + 
      (trainInMorning ? 15 : 0)
    ));

    return {
      overall: Math.round(overall),
      resonance: Math.round(resonance),
      breath: Math.round(breath),
      technique: Math.round(technique),
      consistency: Math.round(consistency),
      confidence: Math.round(confidence),
    };
  }, [onboardingData]);

  const scores = useMemo(() => calculateScores(), [calculateScores]);

  const ratingCards = useMemo(
    () => [
      { label: 'Overall', score: scores.overall },
      { label: 'Resonance', score: scores.resonance },
      { label: 'Breath', score: scores.breath },
      { label: 'Technique', score: scores.technique },
      { label: 'Consistency', score: scores.consistency },
      { label: 'Confidence', score: scores.confidence },
    ],
    [scores]
  );

  const handleSeePotential = useCallback(() => {
    navigation.navigate('PotentialRating');
  }, [navigation]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.8} />
      <GradientScreen>
        <View style={styles.content}>
          <Text style={styles.title}>Your Deeper Voice Rating</Text>
          
          <View style={styles.cardsGrid}>
            {ratingCards.map((card) => (
              <View key={card.label} style={styles.ratingCard}>
                <Text style={styles.cardLabel}>{card.label}</Text>
                <Text style={styles.cardScore}>{card.score}</Text>
              </View>
            ))}
          </View>

          <View style={styles.ctaRow}>
            <PrimaryButton 
              title="See potential rating" 
              onPress={handleSeePotential}
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
    textAlign: 'center',
  },
  cardsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
    marginBottom: spacing.xl,
  },
  ratingCard: {
    width: '48%',
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    padding: spacing.lg,
    marginBottom: spacing.md,
    alignItems: 'center',
  },
  cardLabel: {
    color: colors.subtext,
    fontSize: fontSizes.md,
    marginBottom: spacing.sm,
  },
  cardScore: {
    color: colors.text,
    fontSize: fontSizes.xxl,
    fontWeight: '700',
  },
  ctaRow: {
    marginTop: spacing.lg,
  },
});
