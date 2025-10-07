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

export default function VoiceTrainHoursScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const updateSlider = useOnboardingStore((s) => s.updateSlider);
  const markStepCompleted = useOnboardingStore((s) => s.markStepCompleted);
  const name = useOnboardingStore((s) => s.name);
  const artStyle = useOnboardingStore((s) => s.artStyle);

  const [hours, setHours] = useState<number>(0);

  const trackRef = useRef<View | null>(null);

  const sliderLabel = useMemo(() => {
    if (hours <= 0) return "I don’t train";
    return `~${hours.toFixed(hours % 1 === 0 ? 0 : 1)} hours/week`;
  }, [hours]);

  const clamp = (value: number, min: number, max: number) => {
    return Math.max(min, Math.min(max, value));
  };

  const snapToStep = (value: number, step: number) => {
    return Math.round(value / step) * step;
  };

  const handleTrackTouch = useCallback((x: number, width: number) => {
    const ratio = clamp(x / width, 0, 1);
    const raw = ratio * 10; // 0..10 hours
    const snapped = snapToStep(raw, 0.5);
    setHours(Number(snapped.toFixed(2)));
  }, []);

  const onResponderGrant = useCallback((evt) => {
    if (!trackRef.current) return;
    trackRef.current.measure((_x, _y, width, _height, pageX, _pageY) => {
      const touchX = evt.nativeEvent.pageX - pageX;
      handleTrackTouch(touchX, width);
    });
  }, [handleTrackTouch]);

  const onResponderMove = useCallback((evt) => {
    if (!trackRef.current) return;
    trackRef.current.measure((_x, _y, width, _height, pageX, _pageY) => {
      const touchX = evt.nativeEvent.pageX - pageX;
      handleTrackTouch(touchX, width);
    });
  }, [handleTrackTouch]);

  const handleConfirm = useCallback(() => {
    updateSlider('voiceTrainHours', hours);
    markStepCompleted('VoiceTrainHours');
    navigation.navigate('BreathworkMinutes');
  }, [hours, markStepCompleted, navigation, updateSlider]);

  const categories = useMemo(
    () => [
      { key: 'ArtStyle', label: 'Art Style', completed: !!artStyle },
      { key: 'NamePhoto', label: 'Name & Photo', completed: (name ?? '').trim().length > 0 },
      { key: 'VoiceTrainHours', label: 'Voice Hours', completed: false },
      { key: 'BreathworkMinutes', label: 'Breathwork', completed: false },
    ],
    [artStyle, name]
  );

  const thumbLeftPercent = useMemo(() => `${(hours / 10) * 100}%`, [hours]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.25} />
      <GradientScreen>
        <View style={styles.content}>
          <View style={styles.row}>
            <View style={styles.sidebar}>
              {categories.map((c) => (
                <View key={c.key} style={styles.sidebarItem}>
                  <View
                    style={[
                      styles.tick,
                      c.completed ? styles.tickCompleted : styles.tickPending,
                    ]}
                  />
                  <Text style={[styles.sidebarLabel, c.completed && styles.sidebarLabelCompleted]}>
                    {c.label}
                  </Text>
                </View>
              ))}
            </View>

            <View style={styles.main}>
              <Text style={styles.title}>
                How many hours do you usually train your voice in a week?
              </Text>

              <View
                ref={trackRef}
                style={styles.sliderTrack}
                onStartShouldSetResponder={() => true}
                onMoveShouldSetResponder={() => true}
                onResponderGrant={onResponderGrant}
                onResponderMove={onResponderMove}
              >
                <View style={styles.sliderFill} width={`${(hours / 10) * 100}%`} />
                <View style={[styles.sliderThumb, { left: thumbLeftPercent }]} />
                <View style={styles.sliderTicksRow}>
                  {Array.from({ length: 11 }).map((_, i) => (
                    <View key={i} style={styles.sliderTick} />
                  ))}
                </View>
              </View>

              <Text style={styles.sliderLabel}>{sliderLabel}</Text>

              <View style={styles.confirmRow}>
                <PrimaryButton title="Confirm" onPress={handleConfirm} />
              </View>
            </View>
          </View>
        </View>
      </GradientScreen>
    </SafeAreaView>
  );
}

const TICK_SIZE = 10;

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
  row: {
    flex: 1,
    flexDirection: 'row',
  },
  sidebar: {
    width: 120,
    paddingTop: spacing.xl,
    paddingRight: spacing.md,
  },
  sidebarItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.md,
  },
  tick: {
    width: TICK_SIZE,
    height: TICK_SIZE,
    borderRadius: TICK_SIZE / 2,
    marginRight: spacing.sm,
    borderWidth: 1.5,
  },
  tickCompleted: {
    backgroundColor: colors.accent,
    borderColor: colors.accent,
  },
  tickPending: {
    backgroundColor: 'transparent',
    borderColor: colors.subtext + '60',
  },
  sidebarLabel: {
    color: colors.subtext,
    fontSize: fontSizes.sm,
  },
  sidebarLabelCompleted: {
    color: colors.text,
    fontWeight: '600',
  },
  main: {
    flex: 1,
    paddingTop: spacing.xl,
  },
  title: {
    color: colors.text,
    fontSize: fontSizes.xl,
    fontWeight: '700',
    marginBottom: spacing.xl,
  },
  sliderTrack: {
    position: 'relative',
    height: 44,
    borderRadius: 12,
    backgroundColor: colors.card,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    justifyContent: 'center',
    paddingHorizontal: spacing.md,
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
    height: 12,
    backgroundColor: colors.subtext + '30',
  },
  sliderLabel: {
    marginTop: spacing.md,
    color: colors.subtext,
    fontSize: fontSizes.md,
  },
  confirmRow: {
    marginTop: spacing.xxl,
  },
});


