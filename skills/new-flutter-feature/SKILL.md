---
name: new-flutter-feature
description: Scaffold a feature in road24-mobile (Flutter) — freezed models, dio-backed repository, flutter_bloc cubit/bloc, and UI — following the app's BLoC + repository conventions.
user-invocable: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: "[feature] [screen/flow] [description]"
---

# Build a Flutter Feature (road24-mobile)

Build a feature for: $ARGUMENTS

Stack: Flutter 3, `flutter_bloc` for state, `dio` client + repository for data, `freezed` for
immutable models/unions, firebase for analytics/messaging.

## Steps

1. **Read first** — an existing feature folder, the shared dio client/interceptors, and how repos +
   BLoCs are wired (DI/provider). Match it.
2. Build: freezed model → repository (dio) → state (freezed union) → bloc/cubit → widgets → route.
3. Run `flutter analyze` and `flutter test` (add `bloc_test` for the BLoC).

## Model (freezed)

```dart
@freezed
class Hold with _$Hold {
  const factory Hold({required int id, required String status}) = _Hold;
  factory Hold.fromJson(Map<String, dynamic> json) => _$HoldFromJson(json);
}
```

## Repository (dio)

```dart
class HoldRepository {
  HoldRepository(this._dio);
  final Dio _dio;

  Future<Hold> fetchHold(int id) async {
    final res = await _dio.get('/v1/holds/$id');
    return Hold.fromJson(res.data as Map<String, dynamic>);
  }
}
```

## State + Cubit (flutter_bloc)

```dart
@freezed
class HoldState with _$HoldState {
  const factory HoldState.initial() = _Initial;
  const factory HoldState.loading() = _Loading;
  const factory HoldState.loaded(Hold hold) = _Loaded;
  const factory HoldState.error(String message) = _Error;
}

class HoldCubit extends Cubit<HoldState> {
  HoldCubit(this._repo) : super(const HoldState.initial());
  final HoldRepository _repo;

  Future<void> load(int id) async {
    emit(const HoldState.loading());
    try {
      emit(HoldState.loaded(await _repo.fetchHold(id)));
    } catch (e) {
      emit(HoldState.error(e.toString()));
    }
  }
}
```

## Rules

- No business logic or network calls in widgets — widgets read BLoC state and dispatch events.
- Models are immutable (`freezed`); parse the wire shape explicitly in `fromJson`.
- Dispose controllers/subscriptions; never block the UI isolate with heavy work.
- Handle every state (initial/loading/loaded/error) in the UI. Localize user-facing strings.
- Cover the BLoC with `bloc_test` and the repository with mocked dio (`mocktail`).
