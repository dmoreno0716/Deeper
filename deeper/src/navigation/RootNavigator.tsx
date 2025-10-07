import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { colors } from '../theme/colors';
import WelcomeScreen from '../../screens/onboarding/Welcome';
import ArtStyleScreen from '../../screens/onboarding/ArtStyle';
import NamePhotoScreen from '../../screens/onboarding/NamePhoto';
import VoiceTrainHoursScreen from '../../screens/onboarding/VoiceTrainHours';
import BreathworkMinutesScreen from '../../screens/onboarding/BreathworkMinutes';
import ReadAloudPagesScreen from '../../screens/onboarding/ReadAloudPages';
import LoudEnvironmentsHoursScreen from '../../screens/onboarding/LoudEnvironmentsHours';
import SteamHumidifyFrequencyScreen from '../../screens/onboarding/SteamHumidifyFrequency';
import ExtrasChooserScreen from '../../screens/onboarding/ExtrasChooser';
import DownGlidesCountScreen from '../../screens/onboarding/DownGlidesCount';
import TechniqueStudyDailyScreen from '../../screens/onboarding/TechniqueStudyDaily';
import PermissionsScreen from '../../screens/onboarding/Permissions';
import AimsScreen from '../../screens/onboarding/Aims';
import AnalyzingScreen from '../../screens/onboarding/Analyzing';
import CurrentRatingScreen from '../../screens/onboarding/CurrentRating';
import PotentialRatingScreen from '../../screens/onboarding/PotentialRating';

export type RootStackParamList = {
  Welcome: undefined;
  ArtStyle: undefined;
  NamePhoto: undefined;
  VoiceTrainHours: undefined;
  BreathworkMinutes: undefined;
  ReadAloudPages: undefined;
  LoudEnvironmentsHours: undefined;
  SteamHumidifyFrequency: undefined;
  ExtrasChooser: undefined;
  DownGlidesCount: undefined;
  TechniqueStudyDaily: undefined;
  Permissions: undefined;
  Aims: undefined;
  Analyzing: undefined;
  CurrentRating: undefined;
  PotentialRating: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export default function RootNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator
        initialRouteName="Welcome"
        screenOptions={{
          headerStyle: {
            backgroundColor: colors.background,
          },
          headerTintColor: colors.text,
          headerTitleStyle: {
            color: colors.text,
          },
          contentStyle: {
            backgroundColor: colors.background,
          },
        }}
      >
        <Stack.Screen
          name="Welcome"
          component={WelcomeScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="ArtStyle"
          component={ArtStyleScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="NamePhoto"
          component={NamePhotoScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="VoiceTrainHours"
          component={VoiceTrainHoursScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="BreathworkMinutes"
          component={BreathworkMinutesScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="ReadAloudPages"
          component={ReadAloudPagesScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="LoudEnvironmentsHours"
          component={LoudEnvironmentsHoursScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="SteamHumidifyFrequency"
          component={SteamHumidifyFrequencyScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="ExtrasChooser"
          component={ExtrasChooserScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="DownGlidesCount"
          component={DownGlidesCountScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="TechniqueStudyDaily"
          component={TechniqueStudyDailyScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="Permissions"
          component={PermissionsScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="Aims"
          component={AimsScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="Analyzing"
          component={AnalyzingScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="CurrentRating"
          component={CurrentRatingScreen}
          options={{
            headerShown: false,
          }}
        />
        <Stack.Screen
          name="PotentialRating"
          component={PotentialRatingScreen}
          options={{
            headerShown: false,
          }}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
