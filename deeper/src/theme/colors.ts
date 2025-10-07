export const colors = {
  background: '#0D0A12',
  card: '#15121C',
  text: '#FFFFFF',
  subtext: '#C9C6D0',
  accent: '#FF6A00',
  success: '#22C55E',
  warning: '#F59E0B',
  danger: '#EF4444',
} as const;

export type ColorKey = keyof typeof colors;

// Font sizes
export const fontSizes = {
  xxs: 10,
  xs: 12,
  sm: 14,
  md: 16,
  lg: 18,
  xl: 20,
  xxl: 24,
  xxxl: 32,
} as const;

export type FontSizeKey = keyof typeof fontSizes;

// Spacing
export const spacing = {
  xxs: 2,
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  xxl: 24,
  xxxl: 32,
  xxxxl: 40,
} as const;

export type SpacingKey = keyof typeof spacing;
