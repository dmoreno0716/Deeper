import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import RootNavigator from './src/navigation/RootNavigator';
import { colors } from './src/theme/colors';
import AppProviders from './src/providers/AppProviders';

export default function App() {
  return (
    <AppProviders>
      <RootNavigator />
    </AppProviders>
  );
}
