# R24NativeInsurance

**Native insurance client** — React Native app for Road24 insurance flows.

- **Stack:** React Native + TypeScript, React Navigation (native-stack), **Redux Toolkit**,
  **React Query**, **react-hook-form**, axios, dayjs, **react-native-mmkv** (fast storage),
  react-native-reanimated, gesture-handler, screens, safe-area-context, svg, nitro-modules.
  Branch: `main`. No git remote set locally. **Has `.claude/`:** no.

## Architecture
Screens (thin) → React Query (server state) + Redux Toolkit (app/session state) → axios client.
Navigation via React Navigation native-stack. Forms via react-hook-form. iOS (`ios/` + Gemfile/pods)
and Android (`android/`). Entry: `App.tsx` / `index.js`; code in `src/`.

## Conventions
- Server state in React Query; don't duplicate into Redux. No `useEffect` fetching — shared axios
  (Bearer). Strict TS — no `any`/`!`/`@ts-ignore`. Model DTOs; map error envelope → RHF fields.
- Persist only token/session in MMKV. Clean up listeners; use reanimated worklets correctly.
- Guard iOS/Android differences; keep native-module usage centralized.

## Commands
```bash
npm install ; cd ios && pod install && cd ..
npm start                 # Metro
npm run ios | android
npm run lint ; npm test   # jest
```

## Notes
- Shares the React data-fetching philosophy with the web clients but is RN — UI primitives and
  navigation differ. Use `react-native-engineer`.
