import { create } from 'zustand';
import { persist } from 'zustand/middleware';

export interface OnboardingData {
  name: string;
  avatarUri: string | null;
  artStyle: string;
  sliders: Record<string, number>;
  booleans: Record<string, boolean>;
  permissions: Record<string, boolean>;
  chosenExtras: string[];
  completedSteps: string[];
}

interface OnboardingStore extends OnboardingData {
  updateName: (name: string) => void;
  updateAvatarUri: (uri: string | null) => void;
  updateArtStyle: (style: string) => void;
  updateSlider: (key: string, value: number) => void;
  updateBoolean: (key: string, value: boolean) => void;
  updatePermission: (key: string, value: boolean) => void;
  addChosenExtra: (extra: string) => void;
  removeChosenExtra: (extra: string) => void;
  markStepCompleted: (step: string) => void;
  resetOnboarding: () => void;
}

const initialData: OnboardingData = {
  name: '',
  avatarUri: null,
  artStyle: '',
  sliders: {},
  booleans: {},
  permissions: {},
  chosenExtras: [],
  completedSteps: [],
};

export const useOnboardingStore = create<OnboardingStore>()(
  persist(
    (set, get) => ({
      ...initialData,
      
      updateName: (name: string) => set({ name }),
      
      updateAvatarUri: (avatarUri: string | null) => set({ avatarUri }),
      
      updateArtStyle: (artStyle: string) => set({ artStyle }),
      
      updateSlider: (key: string, value: number) =>
        set((state) => ({
          sliders: { ...state.sliders, [key]: value },
        })),
      
      updateBoolean: (key: string, value: boolean) =>
        set((state) => ({
          booleans: { ...state.booleans, [key]: value },
        })),
      
      updatePermission: (key: string, value: boolean) =>
        set((state) => ({
          permissions: { ...state.permissions, [key]: value },
        })),
      
      addChosenExtra: (extra: string) =>
        set((state) => ({
          chosenExtras: [...state.chosenExtras, extra],
        })),
      
      removeChosenExtra: (extra: string) =>
        set((state) => ({
          chosenExtras: state.chosenExtras.filter((item) => item !== extra),
        })),
      
      markStepCompleted: (step: string) =>
        set((state) => ({
          completedSteps: [...state.completedSteps, step],
        })),
      
      resetOnboarding: () => set(initialData),
    }),
    {
      name: 'onboarding-storage',
    }
  )
);
