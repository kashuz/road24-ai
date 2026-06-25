---
paths:
  - "**/*.dart"
description: Flutter/Dart conventions for road24-mobile (flutter_bloc, dio, freezed, firebase).
---

# Flutter/Dart conventions (road24-mobile)

Layered: **widget → bloc/cubit → repository**. Data via dio, models via freezed.

## Architecture
- No business logic or network calls in widgets — widgets render BLoC state and dispatch events.
- dio client → repository → bloc/cubit → widget. Inject repositories into blocs.
- Immutable models via `freezed`; parse the wire shape explicitly in `fromJson`; run codegen
  (`dart run build_runner build --delete-conflicting-outputs`) after model changes.

## Style
- Avoid `dynamic` where a type fits; null-safe. Handle every state (initial/loading/loaded/error) in the UI.
- Dispose controllers/subscriptions; never block the UI isolate; prefer `const`; localize strings.

## Security
- Tokens/PII in secure storage; no secrets in source; don't log sensitive data; type dio responses.

## Tests
- `bloc_test` for state sequences (incl. error path), `mocktail` for repositories, widget tests for UI.
- `flutter analyze` + `flutter test` clean before "done".

> Deep rulebook: `skills/road24-conventions/references/{clean-architecture,clean-code,security,testing}.md`.
> Skills: `new-flutter-feature`, `new-flutter-test`.
