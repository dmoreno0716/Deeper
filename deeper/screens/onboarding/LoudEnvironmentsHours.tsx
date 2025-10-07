import React, { useCallback, useMemo, useRef, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import GradientScreen from '../../src/ui/GradientScreen';
import PrimaryButton from '../../src/ui/PrimaryButton';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';
import { useOnboardingStore } from '../../src/state/onboardingStore';
import { useNavigation } from '@react-navigation/native';
import { NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../../src/navigation/RootNavigator';

export default function LoudEnvironmentsHoursScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const onboardingStore = useOnboardingStore();

  const [hours, setHours] = useState<number>(0);
  const trackRef = useRef<View | null>(null);

  const clamp = (v: number, min: number, max: number) => Math.max(min, Math.min(max, v));
  const snapToStep = (v: number, step: number) => Math.round(v / step) * step;

  const handleFromTouch = useCallback((x: number, width: number) => {
    const ratio = clamp(x / width, 0, 1);
    const raw = ratio * 4; // 0..4
    const snapped = snapToStep(raw, 0.25);
    setHours(Number(snapped.toFixed(2)));
  }, []);

  const onGrant = useCallback((evt: any) => {
    if (!trackRef.current) return;
    trackRef.current.measure((_x, _y, width, _h, pageX) => {
      const touchX = evt.nativeEvent.pageX - pageX;
      handleFromTouch(touchX, width);
    });
  }, [handleFromTouch]);

  const onMove = useCallback((evt: any) => {
    if (!trackRef.current) return;
    trackRef.current.measure((_x, _y, width, _h, pageX) => {
      const touchX = evt.nativeEvent.pageX - pageX;
      handleFromTouch(touchX, width);
    });
  }, [handleFromTouch]);

  const label = useMemo(() => {
    if (hours >= 4) return 'Around 4+ hours';
    const lower = Math.floor(hours);
    const upper = lower + 1;
    return `Around ${lower}–${upper} hours`;
  }, [hours]);

  const fillPercent = useMemo(() => Math.min(100, (hours / 4) * 100), [hours]);

  const handleConfirm = useCallback(() => {
    onboardingStore.saveAnswer('loudEnvironmentsHours', hours);
    navigation.navigate('SteamHumidifyFrequency');
  }, [hours, navigation, onboardingStore]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.4} />
      <GradientScreen>
        <View style={styles.content}>
          <Text style={styles.title}>How much time do you spend in loud places per day?</Text>
          <Text style={styles.subtitle}>Clubs, bars, sports events—these strain your voice.</Text>

          {/* *INSERT ART HERE: character in a noisy crowd with muffled speakers* */}
          <View style={styles.artBox} />

          <View
            ref={trackRef}
            style={styles.sliderTrack}
            onStartShouldSetResponder={() => true}
            onMoveShouldSetResponder={() => true}
            onResponderGrant={onGrant}
            onResponderMove={onMove}
          >
            <View style={styles.sliderTicksRow}>
              {Array.from({ length: 5 }).map((_, i) => (
                <View key={i} style={styles.sliderTick} />
              ))}
            </View>
            <View style={[styles.sliderFill, { width: `${fillPercent}%` }]} />
            <View style={[styles.sliderThumb, { left: `${fillPercent}%` }]} />
          </View>

          <Text style={styles.friendly}>{label}</Text>

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
    marginBottom: spacing.xs,
  },
  subtitle: {
    color: colors.subtext,
    fontSize: fontSizes.md,
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
  sliderTrack: {
    position: 'relative',
    height: 48,
    borderRadius: 12,
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    justifyContent: 'center',
    paddingHorizontal: spacing.md,
  },
  sliderTicksRow: {
    position: 'absolute',
    left: spacing.md,
    right: spacing.md,
    top: '50%',
    marginTop: -1,
    height: 2,
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  sliderTick: {
    width: 2,
    height: 14,
    backgroundColor: colors.subtext + '30',
  },
  sliderFill: {
    position: 'absolute',
    left: 0,
    top: 0,
    bottom: 0,
    backgroundColor: colors.accent + '30',
    borderTopLeftRadius: 12,
    borderBottomLeftRadius: 12,
  },
  sliderThumb: {
    position: 'absolute',
    top: '50%',
    width: 24,
    height: 24,
    marginTop: -12,
    marginLeft: -12,
    borderRadius: 12,
    backgroundColor: colors.accent,
    shadowColor: colors.accent,
    shadowOpacity: 0.4,
    shadowRadius: 8,
    shadowOffset: { width: 0, height: 4 },
    elevation: 8,
  },
  friendly: {
    marginTop: spacing.md,
    color: colors.subtext,
    fontSize: fontSizes.md,
  },
  confirmRow: {
    marginTop: spacing.xxl,
  },
});


