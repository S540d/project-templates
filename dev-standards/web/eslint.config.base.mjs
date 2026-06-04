// ─────────────────────────────────────────────────────────────────────────
// Kanonische ESLint FlatConfig (ESLint 9) – Web (React / PWA / TS)
// Source of Truth für Issue #7. Abgeleitet aus der React-Native-Basis,
// ohne react-native-Plugin/Globals. Source of Truth für Web-Projekte.
// Konsumierende Projekte binden sie per Spread in ihre lokale eslint.config.mjs ein.
// Erfordert Dev-Deps: @typescript-eslint/parser, @typescript-eslint/eslint-plugin,
//   eslint-plugin-react, eslint-plugin-react-hooks, eslint-plugin-eslint-comments,
//   eslint-plugin-jest, eslint-config-prettier, @eslint/compat, globals
// ─────────────────────────────────────────────────────────────────────────
import typescriptParser from '@typescript-eslint/parser';
import typescriptPlugin from '@typescript-eslint/eslint-plugin';
import reactPlugin from 'eslint-plugin-react';
import reactHooksPlugin from 'eslint-plugin-react-hooks';
import eslintCommentsPlugin from 'eslint-plugin-eslint-comments';
import jestPlugin from 'eslint-plugin-jest';
import prettierConfig from 'eslint-config-prettier';
import { fixupPluginRules } from '@eslint/compat';
import globals from 'globals';

export default [
  // ── Global ignores ────────────────────────────────────────────────────
  {
    ignores: [
      'dist/**',
      'build/**',
      'node_modules/**',
      'coverage/**',
      '.next/**',
      '*.config.js',
      '*.config.mjs',
      'jest.config.js',
      'jest.setup.js',
      '__mocks__/**',
    ],
  },

  // ── Base config for TypeScript files ──────────────────────────────────
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        sourceType: 'module',
        ecmaFeatures: { jsx: true },
      },
      globals: {
        ...globals.browser,
        ...globals.es2021,
      },
    },
    plugins: {
      '@typescript-eslint': typescriptPlugin,
      'react': reactPlugin,
      'react-hooks': reactHooksPlugin,
      'eslint-comments': fixupPluginRules(eslintCommentsPlugin),
    },
    settings: {
      react: { version: 'detect' },
    },
    rules: {
      // ── General ─────────────────────────────────────────────────────
      'no-cond-assign': 'warn',
      'no-const-assign': 'error',
      'no-control-regex': 'warn',
      'no-debugger': 'warn',
      'no-dupe-class-members': 'error',
      'no-dupe-keys': 'error',
      'no-ex-assign': 'warn',
      'no-extra-boolean-cast': 'warn',
      'no-func-assign': 'warn',
      'no-invalid-regexp': 'warn',
      'no-obj-calls': 'warn',
      'no-regex-spaces': 'warn',
      'no-sparse-arrays': 'warn',
      'no-unreachable': 'error',
      'use-isnan': 'warn',
      'valid-typeof': 'warn',

      // ── Best Practices ──────────────────────────────────────────────
      'dot-notation': 'warn',
      'eqeqeq': ['error', 'always'],
      'no-alert': 'warn',
      'no-caller': 'warn',
      'no-eval': 'error',
      'no-extend-native': 'warn',
      'no-extra-bind': 'warn',
      'no-fallthrough': 'warn',
      'no-implied-eval': 'warn',
      'no-labels': 'warn',
      'no-iterator': 'warn',
      'no-lone-blocks': 'warn',
      'no-new': 'warn',
      'no-new-func': 'error',
      'no-new-wrappers': 'warn',
      'no-octal': 'warn',
      'no-octal-escape': 'warn',
      'no-proto': 'warn',
      'no-return-assign': 'warn',
      'no-script-url': 'warn',
      'no-self-compare': 'warn',
      'no-sequences': 'warn',
      'no-useless-escape': 'warn',
      'no-void': 'warn',
      'radix': 'warn',
      'yoda': 'warn',

      // ── Variables ───────────────────────────────────────────────────
      'no-delete-var': 'warn',
      'no-global-assign': 'error',
      'no-label-var': 'warn',
      'no-shadow': 'off', // Handled by @typescript-eslint/no-shadow
      'no-shadow-restricted-names': 'warn',
      'no-undef': 'off', // Handled by TypeScript
      'no-undef-init': 'warn',
      'no-unused-vars': 'off', // Handled by @typescript-eslint/no-unused-vars

      // ── Style ───────────────────────────────────────────────────────
      'consistent-this': 'warn',
      'no-array-constructor': 'warn',
      'no-empty-character-class': 'warn',
      'no-new-object': 'warn',
      'no-bitwise': 'warn',
      'no-var': 'error',
      'prefer-const': 'error',
      'no-console': ['warn', { allow: ['warn', 'error'] }],

      // ── TypeScript ──────────────────────────────────────────────────
      '@typescript-eslint/no-shadow': 'warn',
      '@typescript-eslint/no-unused-vars': ['error', {
        argsIgnorePattern: '^_',
        varsIgnorePattern: '^_',
        destructuredArrayIgnorePattern: '^_',
        caughtErrors: 'none',
      }],
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/consistent-type-imports': ['error', {
        prefer: 'type-imports',
        fixStyle: 'separate-type-imports',
      }],
      '@typescript-eslint/no-non-null-assertion': 'error',

      // ── React ───────────────────────────────────────────────────────
      'react/display-name': 'off',
      'react/jsx-no-comment-textnodes': 'error',
      'react/jsx-no-duplicate-props': 'error',
      'react/jsx-no-undef': 'error',
      'react/jsx-uses-react': 'warn',
      'react/jsx-uses-vars': 'warn',
      'react/no-string-refs': 'error',
      'react/no-unstable-nested-components': 'warn',
      'react/react-in-jsx-scope': 'off',
      'react/self-closing-comp': 'warn',

      // ── React Hooks ─────────────────────────────────────────────────
      'react-hooks/rules-of-hooks': 'error',
      'react-hooks/exhaustive-deps': 'error',

      // ── ESLint Comments ─────────────────────────────────────────────
      'eslint-comments/no-aggregating-enable': 'warn',
      'eslint-comments/no-unlimited-disable': 'warn',
      'eslint-comments/no-unused-disable': 'warn',
      'eslint-comments/no-unused-enable': 'warn',
    },
  },

  // ── Test files (relaxed rules) ────────────────────────────────────────
  {
    files: ['**/__tests__/**', '**/*.test.ts', '**/*.test.tsx'],
    plugins: {
      'jest': jestPlugin,
    },
    rules: {
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/no-non-null-assertion': 'warn',
      'jest/no-disabled-tests': 'warn',
      'jest/no-focused-tests': 'warn',
      'jest/no-identical-title': 'warn',
      'jest/valid-expect': 'warn',
    },
  },

  // ── Scripts and JS config files (relaxed rules) ───────────────────────
  {
    files: ['scripts/**/*.js'],
    languageOptions: {
      globals: {
        ...globals.node,
      },
    },
    rules: {
      '@typescript-eslint/no-explicit-any': 'off',
      'no-console': 'off',
    },
  },

  // ── Prettier (must be last – disables conflicting formatting rules) ───
  prettierConfig,
];
