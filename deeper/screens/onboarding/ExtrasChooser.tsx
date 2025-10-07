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

export default function ExtrasChooserScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const onboardingStore = useOnboardingStore();

  const maxExtras = 2;
  const options = useMemo(
    () => [
      'Voice journal (log notes)',
      'Jaw & neck release',
      'Posture drill',
      'Tongue posture (mewing basics)',
      'Caffeine cap',
      'No smoke',
      'No alcohol',
      'Nasal breathing',
    ],
    []
  );

  const [selectedExtras, setSelectedExtras] = useState<string[]>([]);

  const isSelected = useCallback((label: string) => selectedExtras.includes(label), [selectedExtras]);

  const canSelectMore = selectedExtras.length < maxExtras;

  const toggle = useCallback(
    (label: string) => {
      if (isSelected(label)) {
        setSelectedExtras((prev: string[]) => prev.filter((extra: string) => extra !== label));
        return;
      }
      if (canSelectMore) {
        setSelectedExtras((prev: string[]) => [...prev, label]);
      }
    },
    [canSelectMore, isSelected]
  );

  const handleContinue = useCallback(() => {
    onboardingStore.saveAnswer('chosenExtras', selectedExtras);
    navigation.navigate('DownGlidesCount');
  }, [navigation, onboardingStore, selectedExtras]);

  const slots = useMemo(() => {
    const filled = selectedExtras.slice(0, maxExtras);
    const empties = Math.max(0, maxExtras - filled.length);
    return { filled, empties };
  }, [selectedExtras]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.5} />
      <GradientScreen>
        <View style={styles.content}>
          <Text style={styles.title}>Do you want to add any extra tasks to the program? (Max 2)</Text>

          <View style={styles.slotsRow}>
            {slots.filled.map((label: string) => (
              <View key={label} style={[styles.slotBox, styles.slotFilled]}> 
                <Text style={styles.slotText}>{label}</Text>
              </View>
            ))}
            {Array.from({ length: slots.empties }).map((_, i) => (
              <View key={`empty-${i}`} style={styles.slotBox}>
                <Text style={styles.slotPlus}>+</Text>
              </View>
            ))}
          </View>

          <View style={styles.optionsWrap}>
            {options.map((label) => {
              const active = isSelected(label);
              const disabled = !active && !canSelectMore;
              return (
                <TouchableOpacity
                  key={label}
                  style={[
                    styles.chip,
                    active && styles.chipActive,
                    disabled && styles.chipDisabled,
                  ]}
                  onPress={() => toggle(label)}
                  activeOpacity={0.8}
                >
                  <Text style={[styles.chipText, active && styles.chipTextActive]}>
                    {label}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>

          <View style={styles.bottomRow}>
            <PrimaryButton title="Continue" onPress={handleContinue} />
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
  slotsRow: {
    flexDirection: 'row',
    marginBottom: spacing.lg,
  },
  slotBox: {
    flex: 1,
    height: 64,
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: spacing.sm,
  },
  slotFilled: {
    borderColor: colors.accent,
  },
  slotText: {
    color: colors.text,
    fontSize: fontSizes.sm,
    textAlign: 'center',
  },
  slotPlus: {
    color: colors.subtext,
    fontSize: fontSizes.lg,
    fontWeight: '700',
  },
  optionsWrap: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm as unknown as number,
  },
  chip: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: 999,
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    marginRight: spacing.sm,
    marginBottom: spacing.sm,
  },
  chipActive: {
    backgroundColor: colors.accent + '20',
    borderColor: colors.accent,
  },
  chipDisabled: {
    opacity: 0.5,
  },
  chipText: {
    color: colors.subtext,
    fontSize: fontSizes.md,
  },
  chipTextActive: {
    color: colors.text,
    fontWeight: '600',
  },
  bottomRow: {
    marginTop: spacing.xxl,
  },
});


