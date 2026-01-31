/** @type {import('lint-staged').Config} */
export default {
  '*.{js,jsx,cjs,mjs,ts,tsx,cts,mts}': 'eslint --quiet --fix',
  '*.{ts,tsx,cts,mts}': () => 'tsc --noEmit',
};
