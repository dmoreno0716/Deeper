import React from 'react';
import {
  View,
  StyleSheet,
  ViewStyle,
} from 'react-native';
import { colors, spacing } from '../theme/colors';

interface ProgressBarProps {
  progress: number; // 0-1
  style?: ViewStyle;
}

export default function ProgressBar({
  progress,
  style,
}: ProgressBarProps) {
  return (
    <View style={[styles.container, style]}>
      <View style={styles.track}>
        <View 
          style={[
            styles.fill, 
            { width: `${Math.min(100, Math.max(0, progress * 100))}%` }
          ]} 
        />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
  },
  track: {
    height: 4,
    backgroundColor: colors.subtext + '20',
    borderRadius: 2,
    overflow: 'hidden',
  },
  fill: {
    height: '100%',
    backgroundColor: colors.accent,
    borderRadius: 2,
    shadowColor: colors.accent,
    shadowOffset: {
      width: 0,
      height: 0,
    },
    shadowOpacity: 0.8,
    shadowRadius: 4,
    elevation: 4,
  },
});
