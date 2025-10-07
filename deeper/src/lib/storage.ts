import AsyncStorage from '@react-native-async-storage/async-storage';
import * as SecureStore from 'expo-secure-store';
import { Platform } from 'react-native';
import type { StateStorage } from 'zustand/middleware';

// Web localStorage wrapper with async shape
export const webLocalStorage: StateStorage = {
  getItem: async (name) => {
    if (typeof window === 'undefined') return null;
    return window.localStorage.getItem(name);
  },
  setItem: async (name, value) => {
    if (typeof window === 'undefined') return;
    window.localStorage.setItem(name, value);
  },
  removeItem: async (name) => {
    if (typeof window === 'undefined') return;
    window.localStorage.removeItem(name);
  },
};

// Choose AsyncStorage on native, localStorage on web
export const defaultJSONStorage = () =>
  Platform.OS === 'web' ? webLocalStorage : AsyncStorage;

// Secure JSON storage (tokens)
export const secureJSONStorage = {
  getItem: async (key: string) => {
    if (Platform.OS === 'web') return window.localStorage.getItem(key);
    return (await SecureStore.getItemAsync(key)) ?? null;
  },
  setItem: async (key: string, value: string) => {
    if (Platform.OS === 'web') return window.localStorage.setItem(key, value);
    await SecureStore.setItemAsync(key, value);
  },
  removeItem: async (key: string) => {
    if (Platform.OS === 'web') return window.localStorage.removeItem(key);
    await SecureStore.deleteItemAsync(key);
  },
};
