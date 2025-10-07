import React from 'react';
import {
  View,
  Text,
  StyleSheet,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { useNavigation } from '@react-navigation/native';
import { NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../../src/navigation/RootNavigator';
import GradientScreen from '../../src/ui/GradientScreen';
import PrimaryButton from '../../src/ui/PrimaryButton';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';

export default function WelcomeScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();

  const handleBegin = () => {
    navigation.navigate('ArtStyle');
  };

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.1} />
      
      <GradientScreen>
        <View style={styles.content}>
          <View style={styles.titleSection}>
            <Text style={styles.title}>Prepare to descend.</Text>
            <Text style={styles.subtitle}>A deeper voice awaits.</Text>
          </View>

          <View style={styles.characterSection}>
            {/* *INSERT ART HERE: anime male hero holding a glowing tuning fork/flame, front pose on a runic pedestal* */}
            <View style={styles.characterPlaceholder}>
              <Text style={styles.placeholderText}>Anime Hero Character</Text>
            </View>
          </View>

          <View style={styles.bottomSection}>
            <PrimaryButton
              title="Begin"
              onPress={handleBegin}
              style={styles.beginButton}
            />
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
    justifyContent: 'space-between',
    paddingHorizontal: spacing.lg,
  },
  titleSection: {
    alignItems: 'center',
    paddingTop: spacing.xxxl,
  },
  title: {
    fontSize: fontSizes.xxxl,
    fontWeight: '700',
    color: colors.text,
    textAlign: 'center',
    marginBottom: spacing.sm,
    textShadowColor: colors.accent + '40',
    textShadowOffset: { width: 0, height: 2 },
    textShadowRadius: 8,
  },
  subtitle: {
    fontSize: fontSizes.lg,
    color: colors.subtext,
    textAlign: 'center',
    fontStyle: 'italic',
  },
  characterSection: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  characterPlaceholder: {
    width: 280,
    height: 400,
    backgroundColor: colors.card,
    borderRadius: 20,
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 2,
    borderColor: colors.accent + '30',
    shadowColor: colors.accent,
    shadowOffset: {
      width: 0,
      height: 8,
    },
    shadowOpacity: 0.3,
    shadowRadius: 16,
    elevation: 16,
  },
  placeholderText: {
    fontSize: fontSizes.md,
    color: colors.subtext,
    textAlign: 'center',
    fontWeight: '500',
  },
  bottomSection: {
    paddingBottom: spacing.xxxl,
    alignItems: 'center',
  },
  beginButton: {
    width: '100%',
    maxWidth: 200,
    paddingVertical: spacing.lg,
  },
});
