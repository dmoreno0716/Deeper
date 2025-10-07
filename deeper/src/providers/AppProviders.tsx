import React from 'react';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useOnboardingStore } from '../state/onboardingStore';
import { useSessionStore } from '../state/sessionStore';
import { View, ActivityIndicator } from 'react-native';

const qc = new QueryClient();

export default function AppProviders({ children }: { children: React.ReactNode }) {
  const onbHydrated = useOnboardingStore((s) => s.hasHydrated);
  const sesHydrated = useSessionStore((s) => s.hasHydrated);

  if (!onbHydrated || !sesHydrated) {
    return (
      <View style={{ flex: 1, backgroundColor: '#0e0e0e', alignItems: 'center', justifyContent: 'center' }}>
        <ActivityIndicator />
      </View>
    );
  }

  return <QueryClientProvider client={qc}>{children}</QueryClientProvider>;
}
