import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { secureJSONStorage } from '../lib/storage';

export type UserProfile = {
  id: string;
  email: string;
  name?: string;
  avatarUrl?: string;
};

type SessionState = {
  user: UserProfile | null;
  accessToken: string | null;
  refreshToken: string | null;
  hasHydrated: boolean;
  setHasHydrated: (v: boolean) => void;
  signIn: (p: { user: UserProfile; accessToken: string; refreshToken?: string }) => void;
  signOut: () => void;
};

export const useSessionStore = create<SessionState>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,
      refreshToken: null,
      hasHydrated: false,
      setHasHydrated: (v) => set({ hasHydrated: v }),
      signIn: ({ user, accessToken, refreshToken }) => set({ user, accessToken, refreshToken: refreshToken ?? null }),
      signOut: () => set({ user: null, accessToken: null, refreshToken: null }),
    }),
    {
      name: 'session-storage',
      storage: createJSONStorage(() => secureJSONStorage as any),
      onRehydrateStorage: () => (state) => {
        state?.setHasHydrated(true);
      },
    }
  )
);
