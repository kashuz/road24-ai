# road24-mobile

**Road24 mobile app** (Flutter). Vehicle management, payments, insurance, notifications on mobile.

- **Repo:** kashuz/road24-mobile · **Stack:** Flutter 3 / Dart (SDK >=3.0.6), `flutter_bloc`, `dio`
  (+ cache interceptor/hive store), `freezed`, firebase (core/analytics/messaging),
  `flutter_local_notifications`, `flutter_inappwebview`, ML Kit text recognition, camera, etc.
  Version 3.4.0+3400540. Branch: `ver/340`. **Has `.claude/`:** yes — CLAUDE.md.

## Architecture
BLoC pattern: `dio` client → repository → `bloc`/`cubit` → widgets. `freezed` for immutable models
and state unions. Code in `lib/`; tests in `test/` + `integration_test/`. Platform dirs:
`android/ ios/ web/ macos/ windows/ linux/`.

## Conventions
- No business logic / network in widgets — widgets render BLoC state and dispatch events.
- `freezed` models; run codegen after model changes:
  `dart run build_runner build --delete-conflicting-outputs`.
- Handle every state (initial/loading/loaded/error); dispose controllers; don't block the UI isolate.
- Type dio responses; honor the `{code,message,details}` envelope; localize strings.
- Uses `flutter_inappwebview` to host some Road24 webviews (see `webviews.md`).

## Commands
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test         # + bloc_test, mocktail
flutter run
```
Icon/splash tooling: `flutter_launcher_icons.yaml`, `flutter_native_splash.yaml`, `change_icon.py`.

## Skill
`new-flutter-feature`.
