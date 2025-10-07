import React from 'react';
import {
  View,
  StyleSheet,
  ViewStyle,
} from 'react-native';
import { colors, spacing } from '../theme/colors';

interface ProgressDotsProps {
  totalSteps: number;
  currentStep: number;
  style?: ViewStyle;
}

export default function ProgressDots({
  totalSteps,
  currentStep,
  style,
}: ProgressDotsProps) {
  return (
    <View style={[styles.container, style]}>
      {Array.from({ length: totalSteps }, (_, index) => (
        <View
          key={index}
          style={[
            styles.dot,
            index === currentStep && styles.activeDot,
            index < currentStep && styles.completedDot,
          ]}
        />
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: colors.subtext + '40',
    marginHorizontal: spacing.xs,
  },
  activeDot: {
    backgroundColor: colors.accent,
    width: 12,
    height: 12,
    borderRadius: 6,
  },
  completedDot: {
    backgroundColor: colors.accent + '80',
  },
});
