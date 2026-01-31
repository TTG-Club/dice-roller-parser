import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    globals: false, // We use explicit imports
    environment: 'node',
    include: ['test/**/*.test.ts'],
  },
});
