import React from 'react';
import {
  View,
  StyleSheet,
  ViewStyle,
} from 'react-native';
import { colors, spacing } from '../theme/colors';
import PrimaryButton from './PrimaryButton';

interface ConfirmBarProps {
  title: string;
  onPress: () => void;
  disabled?: boolean;
  loading?: boolean;
  style?: ViewStyle;
}

export default function ConfirmBar({
  title,
  onPress,
  disabled = false,
  loading = false,
  style,
}: ConfirmBarProps) {
  return (
    <View style={[styles.container, style]}>
      <PrimaryButton
        title={title}
        onPress={onPress}
        disabled={disabled}
        loading={loading}
        style={styles.button}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.card,
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.md,
    paddingBottom: spacing.lg,
    borderTopWidth: 1,
    borderTopColor: colors.subtext + '20',
  },
  button: {
    width: '100%',
  },
});
