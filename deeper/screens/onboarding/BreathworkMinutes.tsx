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

export default function BreathworkMinutesScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const onboardingStore = useOnboardingStore();

  const stops = useMemo<number[]>(() => [0, 10, 20, 30, 45, 60, 90], []);
  const [value, setValue] = useState<number>(0);
  const trackRef = useRef<View | null>(null);

  const indexToPercent = useCallback(
    (i: number) => `${(i / (stops.length - 1)) * 100}%`,
    [stops.length]
  );

  const indexToWidthPercent = useCallback(
    (i: number) => (i / (stops.length - 1)) * 100,
    [stops.length]
  );

  const currentIndex = useMemo(() => stops.findIndex((s) => s === value), [stops, value]);

  const friendlyLabel = useMemo(() => {
    if (value === 0) return "I don’t do breathwork";
    const idx = currentIndex;
    if (idx <= 0) return "I don’t do breathwork";
    const prev = stops[idx - 1];
    const curr = stops[idx];
    // For the first non-zero index, range is prev..curr
    if (idx < stops.length - 1) {
      return `Around ${prev}–${curr} minutes`;
    }
    return 'Around 90+ minutes';
  }, [currentIndex, stops, value]);

  const clamp = (v: number, min: number, max: number) => Math.max(min, Math.min(max, v));

  const nearestStop = useCallback(
    (ratio: number) => {
      const scaled = ratio * (stops.length - 1);
      const nearestIndex = Math.round(scaled);
      return clamp(nearestIndex, 0, stops.length - 1);
    },
    [stops.length]
  );

  const setFromTouch = useCallback((x: number, width: number) => {
    const ratio = clamp(x / width, 0, 1);
    const idx = nearestStop(ratio);
    setValue(stops[idx]);
  }, [nearestStop, stops]);

  const onGrant = useCallback((evt: any) => {
    if (!trackRef.current) return;
    trackRef.current.measure((_x, _y, width, _h, pageX) => {
      const touchX = evt.nativeEvent.pageX - pageX;
      setFromTouch(touchX, width);
    });
  }, [setFromTouch]);

  const onMove = useCallback((evt: any) => {
    if (!trackRef.current) return;
    trackRef.current.measure((_x, _y, width, _h, pageX) => {
      const touchX = evt.nativeEvent.pageX - pageX;
      setFromTouch(touchX, width);
    });
  }, [setFromTouch]);

  const handleConfirm = useCallback(() => {
    onboardingStore.saveAnswer('breathworkMinutes', value);
    navigation.navigate('ReadAloudPages');
  }, [navigation, onboardingStore, value]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.3} />
      <GradientScreen>
        <View style={styles.content}>
          <Text style={styles.title}>How much time do you spend on breathwork in a week?</Text>

          {/* *INSERT ART HERE: character seated, calm breath, subtle breath vapor lines* */}
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
              {stops.map((_, i) => (
                <View key={i} style={styles.sliderTick} />
              ))}
            </View>
            <View style={[styles.sliderFill, { width: `${indexToWidthPercent(currentIndex)}%` }]} />
            <View style={[styles.sliderThumb, { left: `${indexToWidthPercent(currentIndex)}%` }]} />
          </View>

          <Text style={styles.friendly}>{friendlyLabel}</Text>

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


