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

export default function DownGlidesCountScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const onboardingStore = useOnboardingStore();

  const options = useMemo(
    () => [
      { label: '<10', value: 5 },
      { label: '10–20', value: 15 },
      { label: '20–30', value: 25 },
      { label: '30–50', value: 40 },
      { label: '>50', value: 60 },
    ],
    []
  );

  const [selected, setSelected] = useState<number>(5);

  const handleConfirm = useCallback(() => {
    onboardingStore.saveAnswer('downGlidesCount', selected);
    navigation.navigate('TechniqueStudyDaily');
  }, [navigation, onboardingStore, selected]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.55} />
      <GradientScreen>
        <View style={styles.content}>
          <Text style={styles.title}>How many downward pitch glides do you do in a week now?</Text>

          {/* *INSERT ART HERE: character with musical staff descending arrow* */}
          <View style={styles.artBox} />

          <View style={styles.optionsRow}>
            {options.map((opt) => {
              const active = selected === opt.value;
              return (
                <TouchableOpacity
                  key={opt.label}
                  style={[styles.optionChip, active && styles.optionChipActive]}
                  onPress={() => setSelected(opt.value)}
                  activeOpacity={0.8}
                >
                  <Text style={[styles.optionText, active && styles.optionTextActive]}>
                    {opt.label}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>

          <View style={styles.confirmRow}>
            <PrimaryButton title="Confirm" onPress={handleConfirm} />
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
  artBox: {
    height: 160,
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    marginBottom: spacing.xl,
  },
  optionsRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm as unknown as number,
  },
  optionChip: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: 999,
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    marginRight: spacing.sm,
    marginBottom: spacing.sm,
  },
  optionChipActive: {
    backgroundColor: colors.accent + '20',
    borderColor: colors.accent,
  },
  optionText: {
    color: colors.subtext,
    fontSize: fontSizes.md,
  },
  optionTextActive: {
    color: colors.text,
    fontWeight: '600',
  },
  confirmRow: {
    marginTop: spacing.xxl,
  },
});


