---
name: new-flutter-test
description: Scaffold tests for road24-mobile — bloc_test for BLoCs/Cubits, mocktail for repositories, and widget tests. Use for "write tests for the X bloc", "test the Y repository", "add widget tests".
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash
argument-hint: "[bloc/repository/widget to test]"
---

# Create Flutter Tests (road24-mobile)

Tests for: $ARGUMENTS

Use `bloc_test` for BLoC/Cubit state transitions, `mocktail` for mocking repositories/clients, and
`flutter_test` for widgets. Tests in `test/` mirror `lib/`.

## Steps

1. **Read first** — existing tests in `test/`, the bloc/repository under test, and mock setup. Match style.
2. BLoC: mock the repository, assert the emitted state sequence for each event.
3. Repository: mock dio, assert parsing + error handling.
4. Run `flutter test`.

## BLoC test

```dart
class MockHoldRepository extends Mock implements HoldRepository {}

void main() {
  late MockHoldRepository repo;
  setUp(() => repo = MockHoldRepository());

  blocTest<HoldCubit, HoldState>(
    'emits [loading, loaded] on success',
    build: () {
      when(() => repo.fetchHold(1)).thenAnswer((_) async => const Hold(id: 1, status: 'pending'));
      return HoldCubit(repo);
    },
    act: (cubit) => cubit.load(1),
    expect: () => const [HoldState.loading(), HoldState.loaded(Hold(id: 1, status: 'pending'))],
  );
}
```

## Rules

- Assert the full emitted state sequence (loading → loaded/error). Cover the error path too.
- Mock repositories/dio with mocktail — no real network. Register fallbacks for custom types if needed.
- Widget tests: pump with the needed BlocProviders; find by key/text/semantics; verify rendered states.
- Deterministic, isolated; one behavior per test.
