import React, { useCallback, useMemo, useState } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Animated } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import GradientScreen from '../../src/ui/GradientScreen';
import PrimaryButton from '../../src/ui/PrimaryButton';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';
import { useOnboardingStore } from '../../src/state/onboardingStore';
import { useNavigation } from '@react-navigation/native';
import { NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../../src/navigation/RootNavigator';

export default function PermissionsScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const onboardingStore = useOnboardingStore();

  const [microphoneAllowed, setMicrophoneAllowed] = useState<boolean>(false);
  const [notificationsAllowed, setNotificationsAllowed] = useState<boolean>(false);

  const permissions = useMemo(
    () => [
      {
        key: 'microphone',
        title: 'Microphone',
        description: 'for optional voice notes/analysis later',
        allowed: microphoneAllowed,
        setAllowed: setMicrophoneAllowed,
      },
      {
        key: 'notifications',
        title: 'Notifications',
        description: 'habit reminders',
        allowed: notificationsAllowed,
        setAllowed: setNotificationsAllowed,
      },
    ],
    [microphoneAllowed, notificationsAllowed]
  );

  const handleNext = useCallback(() => {
    const permissionData: Record<string, boolean> = {};
    permissions.forEach((perm) => {
      permissionData[perm.key] = perm.allowed;
    });
    onboardingStore.saveAnswer('permissions', permissionData);
    navigation.navigate('Aims');
  }, [navigation, onboardingStore, permissions]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.65} />
      <GradientScreen>
        <View style={styles.content}>
          <Text style={styles.title}>Permissions</Text>
          
          <View style={styles.permissionsContainer}>
            {permissions.map((permission) => (
              <View key={permission.key} style={styles.permissionCard}>
                <View style={styles.permissionHeader}>
                  <Text style={styles.permissionTitle}>{permission.title}</Text>
                  <Text style={styles.permissionDescription}>{permission.description}</Text>
                </View>
                <View style={styles.permissionButtons}>
                  <TouchableOpacity
                    style={[
                      styles.permissionButton,
                      !permission.allowed && styles.permissionButtonActive,
                    ]}
                    onPress={() => permission.setAllowed(false)}
                    activeOpacity={0.8}
                  >
                    <Text
                      style={[
                        styles.permissionButtonText,
                        !permission.allowed && styles.permissionButtonTextActive,
                      ]}
                    >
                      Ask App Not to Allow
                    </Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={[
                      styles.permissionButton,
                      permission.allowed && styles.permissionButtonActive,
                    ]}
                    onPress={() => permission.setAllowed(true)}
                    activeOpacity={0.8}
                  >
                    <Text
                      style={[
                        styles.permissionButtonText,
                        permission.allowed && styles.permissionButtonTextActive,
                      ]}
                    >
                      Allow
                    </Text>
                  </TouchableOpacity>
                </View>
              </View>
            ))}
          </View>

          <View style={styles.animatingLine}>
            <Text style={styles.animatingText}>We're gaining a deeper insight into your needs.</Text>
          </View>

          <View style={styles.nextRow}>
            <PrimaryButton title="Next" onPress={handleNext} />
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
  permissionsContainer: {
    marginBottom: spacing.xl,
  },
  permissionCard: {
    backgroundColor: colors.card,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    padding: spacing.lg,
    marginBottom: spacing.md,
  },
  permissionHeader: {
    marginBottom: spacing.md,
  },
  permissionTitle: {
    color: colors.text,
    fontSize: fontSizes.lg,
    fontWeight: '600',
    marginBottom: spacing.xs,
  },
  permissionDescription: {
    color: colors.subtext,
    fontSize: fontSizes.md,
  },
  permissionButtons: {
    flexDirection: 'row',
    gap: spacing.sm,
  },
  permissionButton: {
    flex: 1,
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
    borderRadius: 8,
    backgroundColor: colors.background,
    borderWidth: 1,
    borderColor: colors.subtext + '30',
    alignItems: 'center',
  },
  permissionButtonActive: {
    backgroundColor: colors.accent + '20',
    borderColor: colors.accent,
  },
  permissionButtonText: {
    color: colors.subtext,
    fontSize: fontSizes.sm,
    fontWeight: '500',
  },
  permissionButtonTextActive: {
    color: colors.text,
    fontWeight: '600',
  },
  animatingLine: {
    alignItems: 'center',
    marginBottom: spacing.xl,
  },
  animatingText: {
    color: colors.subtext,
    fontSize: fontSizes.md,
    fontStyle: 'italic',
    textAlign: 'center',
  },
  nextRow: {
    marginTop: spacing.lg,
  },
});
