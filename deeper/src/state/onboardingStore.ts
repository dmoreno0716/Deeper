import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { defaultJSONStorage } from '../lib/storage';

export type OnboardingAnswers = Record<string, unknown>;

type OnboardingState = {
  version: number;            // for migrations
  stepIndex: number;
  answers: OnboardingAnswers;
  hasHydrated: boolean;
  setHasHydrated: (v: boolean) => void;
  setStepIndex: (i: number) => void;
  saveAnswer: (id: string, value: unknown) => void;
  reset: () => void;
};

const PERSIST_NAME = 'onboarding-storage';
const PERSIST_VERSION = 2;

export const useOnboardingStore = create<OnboardingState>()(
  persist(
    (set, get) => ({
      version: PERSIST_VERSION,
      stepIndex: 0,
      answers: {},
      hasHydrated: false,
      setHasHydrated: (v) => set({ hasHydrated: v }),
      setStepIndex: (i) => set({ stepIndex: i }),
      saveAnswer: (id, value) => set((s) => ({ answers: { ...s.answers, [id]: value } })),
      reset: () => set({ stepIndex: 0, answers: {} }),
    }),
    {
      name: PERSIST_NAME,
      version: PERSIST_VERSION,
      storage: createJSONStorage(defaultJSONStorage),
      partialize: (s) => ({ version: s.version, stepIndex: s.stepIndex, answers: s.answers }),
      onRehydrateStorage: () => (state) => {
        // called before/after rehydration
        state?.setHasHydrated(true);
      },
      migrate: (persisted: any, fromVersion: number) => {
        // Add migration steps as needed
        if (!persisted) return { version: PERSIST_VERSION, stepIndex: 0, answers: {} };
        if (fromVersion < 2) {
          // example migration: ensure answers is an object
          if (persisted.answers == null || typeof persisted.answers !== 'object') {
            persisted.answers = {};
          }
        }
        persisted.version = PERSIST_VERSION;
        return persisted as OnboardingState;
      },
    }
  )
);
