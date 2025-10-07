import React, { useCallback, useMemo, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  Image,
  TouchableOpacity,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import * as ImagePicker from 'expo-image-picker';
import { useNavigation } from '@react-navigation/native';
import { NavigationProp } from '@react-navigation/native';
import { RootStackParamList } from '../../src/navigation/RootNavigator';
import GradientScreen from '../../src/ui/GradientScreen';
import PrimaryButton from '../../src/ui/PrimaryButton';
import ProgressBar from '../../src/ui/ProgressBar';
import { colors, fontSizes, spacing } from '../../src/theme/colors';
import { useOnboardingStore } from '../../src/state/onboardingStore';

export default function NamePhotoScreen() {
  const navigation = useNavigation<NavigationProp<RootStackParamList>>();
  const storedName = useOnboardingStore((s) => s.name);
  const storedAvatarUri = useOnboardingStore((s) => s.avatarUri);
  const updateName = useOnboardingStore((s) => s.updateName);
  const updateAvatarUri = useOnboardingStore((s) => s.updateAvatarUri);

  const [name, setName] = useState<string>(storedName ?? '');
  const [avatarUri, setAvatarUri] = useState<string | null>(storedAvatarUri ?? null);
  const [requestingPermission, setRequestingPermission] = useState(false);

  const isContinueDisabled = useMemo(() => name.trim().length === 0, [name]);

  const handlePickImage = useCallback(async () => {
    try {
      setRequestingPermission(true);
      const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
      setRequestingPermission(false);
      if (status !== 'granted') {
        return;
      }
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images,
        quality: 0.8,
        allowsEditing: true,
        aspect: [1, 1],
      });
      if (!result.canceled && result.assets && result.assets.length > 0) {
        const uri = result.assets[0].uri;
        setAvatarUri(uri);
      }
    } catch (e) {
      // Intentionally swallow; image picking is optional
    }
  }, []);

  const handleContinue = useCallback(() => {
    updateName(name.trim());
    updateAvatarUri(avatarUri ?? null);
    navigation.navigate('VoiceTrainHours');
  }, [name, avatarUri, navigation, updateName, updateAvatarUri]);

  return (
    <SafeAreaView style={styles.container} edges={['top']}>
      <ProgressBar progress={0.2} />

      <GradientScreen>
        <View style={styles.content}>
          <View style={styles.headerSection}>
            <Text style={styles.title}>What should we call you?</Text>
            <Text style={styles.subtitle}>A strong name for a stronger voice.</Text>
          </View>

          <View style={styles.bodySection}>
            <TouchableOpacity
              activeOpacity={0.8}
              onPress={handlePickImage}
              style={styles.avatarWrapper}
            >
              {avatarUri ? (
                <Image source={{ uri: avatarUri }} style={styles.avatarImage} />
              ) : (
                <View style={styles.avatarPlaceholder}>
                  {/* *INSERT ART HERE: silhouette avatar with subtle glow* */}
                  <Text style={styles.avatarPlaceholderText}>Add photo</Text>
                </View>
              )}
            </TouchableOpacity>

            <TextInput
              value={name}
              onChangeText={setName}
              placeholder="Your name"
              placeholderTextColor={colors.subtext}
              style={styles.input}
              autoCorrect={false}
              autoCapitalize="words"
              returnKeyType="done"
              onSubmitEditing={() => {
                if (!isContinueDisabled) handleContinue();
              }}
              editable={!requestingPermission}
            />
          </View>

          <View style={styles.bottomSection}>
            <PrimaryButton
              title="Continue"
              onPress={handleContinue}
              style={styles.continueButton}
              disabled={isContinueDisabled}
            />
          </View>
        </View>
      </GradientScreen>
    </SafeAreaView>
  );
}

const AVATAR_SIZE = 128;

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
  headerSection: {
    alignItems: 'center',
    paddingTop: spacing.xxl,
  },
  title: {
    fontSize: fontSizes.xxxl,
    fontWeight: '700',
    color: colors.text,
    textAlign: 'center',
    marginBottom: spacing.xs,
  },
  subtitle: {
    fontSize: fontSizes.md,
    color: colors.subtext,
    textAlign: 'center',
  },
  bodySection: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarWrapper: {
    width: AVATAR_SIZE,
    height: AVATAR_SIZE,
    borderRadius: AVATAR_SIZE / 2,
    borderWidth: 2,
    borderColor: colors.accent + '60',
    backgroundColor: colors.card,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: spacing.xl,
    shadowColor: colors.accent,
    shadowOffset: { width: 0, height: 8 },
    shadowOpacity: 0.25,
    shadowRadius: 16,
    elevation: 12,
  },
  avatarPlaceholder: {
    width: AVATAR_SIZE,
    height: AVATAR_SIZE,
    borderRadius: AVATAR_SIZE / 2,
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarPlaceholderText: {
    color: colors.subtext,
    fontSize: fontSizes.sm,
  },
  avatarImage: {
    width: AVATAR_SIZE,
    height: AVATAR_SIZE,
    borderRadius: AVATAR_SIZE / 2,
  },
  input: {
    width: '100%',
    maxWidth: 360,
    borderWidth: 1,
    borderColor: colors.subtext + '20',
    backgroundColor: colors.card,
    borderRadius: 12,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.md,
    color: colors.text,
    fontSize: fontSizes.md,
  },
  bottomSection: {
    paddingBottom: spacing.xxxl,
  },
  continueButton: {
    width: '100%',
  },
});


