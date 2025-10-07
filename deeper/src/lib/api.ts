import Constants from 'expo-constants';
import { useSessionStore } from '../state/sessionStore';

// Mock Supabase client for now
let supabase: any = null;

export function getSupabase() {
  return supabase;
}

// Example API: sync onboarding answers (no-op if no backend configured)
export async function syncOnboardingAnswers(payload: { userId: string; answers: Record<string, unknown> }) {
  if (!supabase) return { ok: true, skipped: true as const };
  // Mock implementation
  return { ok: true, data: payload };
}

// Helper to get auth header if you add custom REST later
export function authHeaders() {
  const token = useSessionStore.getState().accessToken;
  return token ? { Authorization: `Bearer ${token}` } : {};
}
