# Project Rules & Guidelines

## 1. Core Workflow (Must Follow)

- **DRY Principle:** **STRICTLY FOLLOW THE DRY (DON'T REPEAT YOURSELF) POLICY.** If you find yourself writing the same or very similar logic more than once, abstract it into a shared utility, component, or composable. Code duplication is prohibited.
- **Analyze First:** Before writing any code, ALWAYS analyze the existing project codebase. Look at similar logic, file structure, and coding styles. Strictly follow established patterns and conventions to ensure consistency.
- **Change Summary Requirement:** If you are asked to "check", "review", "fix", or "refactor" a component or file, at the very end of your response, you **MUST** provide a bulleted list explaining your changes. For each change, specify:
  - **Where:** The specific file, function, or block modified.
  - **Why:** The reasoning (referencing a specific rule from this file or a bug).
  - **For What:** The resulting benefit or fix.
- **Single Dictionary:** The code must read fluently without surprises, adhering to a unified project dictionary.
- **Code Style:** Strictly follow the project's ESLint, Prettier configurations.

## 2. Type Safety (Strict TypeScript)

- **Strict Typing:** Strong typing is mandatory.
- **No any:** The use of `any` is strictly prohibited.
- **No Assertions:** Do not use type assertions (`as Type`) or forced casting.
- **No Magic Numbers:** Avoid hardcoded numbers or type assertions in variables/fields.
- **Explicit Return Types:** For utility functions with complex return types (especially when working with `unknown`), always define explicit return types and helper interfaces. This improves code maintainability and IDE support.

## 3. Naming Conventions

- **Language:** Use full English names only for variables, functions, and classes.
- **Clarity over Brevity:** No abbreviations (e.g., `lst`, `ua`), no abstract names (`data`, `item`), and no single-letter names (except in mini-loops).
- **Structure:**
  - One function = one task. One verb per action.
  - Different roots for different meanings (no similar terms like `date`/`data`).
  - No underscores. No prefixes like `super*`, `mega*`.
- **Constants:**
  - Use `const` variables with Uppercase/CamelCase naming conventions.
  - **PROHIBITED:** Do not create functions that simply return a static constant value.
- **Booleans:** Functions starting with `is*` or `check*` must return a boolean and have NO side effects.

## 4. Tech Stack & Best Practices

- **Documentation (JSDoc):**
  - All utility functions (especially in `utils.ts`) MUST have **JSDoc in Russian** explaining parameters, return values, and purpose.
  - **NO HTML:** Do NOT use HTML tags (like `<ul>`, `<li>`, `<br>`) in JSDoc. Use standard Markdown syntax (e.g., `-` for lists) for formatting.
  - _Note:_ Code identifiers (variables, functions) remain in English.
- **Utilities:**
  - **NO REINVENTING THE WHEEL:** Do NOT write custom implementations for common logic if a standard solution exists.
  - **Priority:**
    1. **`es-toolkit`** (for data manipulation/algorithms - replace `lodash`).
    2. Custom implementation (only if previous solutions fail).
