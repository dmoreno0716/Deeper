import React, { useEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import GradientScreen from '../../src/ui/GradientScreen';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';
import { useNavigation } from '@react-navigation/native';
import { NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../../src/navigation/RootNavigator';

export default function AnalyzingScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();

  useEffect(() => {
    const timer = setTimeout(() => {
      navigation.navigate('CurrentRating');
    }, 2000);

    return () => clearTimeout(timer);
  }, [navigation]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.75} />
      <GradientScreen>
        <View style={styles.content}>
          <View style={styles.loaderContainer}>
            <ActivityIndicator size="large" color={colors.accent} />
            <Text style={styles.headline}>Analyzing your current voice habits…</Text>
          </View>

          <View style={styles.badgesContainer}>
            <View style={styles.badge}>
              <Text style={styles.badgeText}>800K+ installs</Text>
            </View>
            <View style={styles.badge}>
              <Text style={styles.badgeText}>1M+ programs generated</Text>
            </View>
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
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: spacing.lg,
  },
  loaderContainer: {
    alignItems: 'center',
    marginBottom: spacing.xxl,
  },
  headline: {
    color: colors.text,
    fontSize: fontSizes.xl,
    fontWeight: '700',
    textAlign: 'center',
    marginTop: spacing.lg,
  },
  badgesContainer: {
    flexDirection: 'row',
    gap: spacing.md,
  },
  badge: {
    backgroundColor: colors.card,
    borderRadius: 20,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
  },
  badgeText: {
    color: colors.subtext,
    fontSize: fontSizes.sm,
    fontWeight: '500',
  },
});
