import { defineConfig } from 'tsdown';

export default defineConfig({
  entry: ['src/index.ts'],
  shims: true,
  format: ['esm', 'cjs'],
  dts: true,
  clean: true,
});
