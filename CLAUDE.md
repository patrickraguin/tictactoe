# Tic-Tac-Toe — Référence Claude Code

## Stack

Flutter 3.41.7 (FVM), Dart ≥ 3.11.5. Monorepo pub workspaces + Melos.
État : **Riverpod 3** + `riverpod_annotation` (codegen). Modèles : **Freezed v3**. Navigation : **AutoRoute v11**. Persistance : SharedPreferences. I18n : FR/EN (ARB).

## Package map

```
lib/                         ← entry point, ProviderScope.overrides, error handlers
packages/core/               ← Result<T>, UseCase interfaces, AppRouter, logging, theme, l10n
packages/features/
  game/domain/               ← Dart pur : entités, AI strategies, use cases, repo interfaces
  game/data/                 ← ScoreRepositoryImpl + ScoreLocalDatasource (SharedPreferences)
  game/presentation/         ← Pages, Widgets, Controllers/Notifiers (dans logic/)
  settings/domain/           ← AppLocale, LocaleRepository interface
  settings/data/             ← LocaleRepositoryImpl
  settings/presentation/     ← LocaleController, SettingsPage
```

## Règles non-négociables

1. **Domain = Dart pur.** Zéro import Flutter, Riverpod, SharedPreferences dans `domain/`.
2. **Controllers dans `presentation/lib/logic/`.** Jamais dans `application/` ni `domain/`.
3. **Repository providers déclarés dans `presentation/`** avec `throw UnimplementedError` — overridés dans `main.dart`.
4. **DI = `ProviderScope.overrides` en `main.dart`.** Pas de GetIt, pas de service locator.
5. **Mutation optimiste** : `state = AsyncData(next)` immédiatement, persist en arrière-plan, rollback sur `Error`.
6. **Toutes les ops domain retournent `Result<T>`.** Aucune exception lancée ou catchée dans le domain.
7. **Pattern matching exhaustif** sur les sealed unions (`switch` expression, pas `if`). Le compilateur attrape les cas manquants.
8. **`keepAlive: true`** pour les controllers app-wide (ScoreController, LocaleController). AutoDispose pour page-scoped (ConfigNotifier, GameController).

## Abstractions clés (one-liners)

- `Result<T>` sealed : `Success(value) | Error(Failure)` — `.map()`, `.flatMap()`, `.fold()`, `.unwrap()`, `.getOrElse()`
- `Failure` : `StorageFailure | InvalidMoveFailure`
- `UseCase<P,O>` / `AsyncUseCase<P,O>` : `call(params) → Result<O>`
- `GameStateEntity` (sealed) : `InProgressEntity | WonEntity | DrawEntity` — `.isOver`, `.board`, `.humanMark`
- `GameUiState` (Freezed) : `GameStateEntity game + bool cpuThinking` — état UI uniquement, pas domain
- `AiStrategy` : interface → `RandomStrategy | HeuristicStrategy | MinimaxStrategy`

## Controllers Riverpod — inventaire

| Controller | Type Riverpod | État | Durée de vie |
|---|---|---|---|
| `GameController(config)` | Notifier (family) | `GameUiState` | page-scoped (autoDispose) |
| `ScoreController` | AsyncNotifier | `AsyncValue<ScoreEntity>` | app-wide (keepAlive) |
| `ConfigNotifier` | Notifier (manuel) | `GameConfigEntity` | page-scoped (autoDispose) |
| `LocaleController` | AsyncNotifier | `AsyncValue<Locale?>` | app-wide (keepAlive) |
| `GameOutcomeRecorder(config)` | Notifier void | — | observe via `ref.listen` |

`ConfigNotifier` est écrit manuellement (sans `@riverpod`) car le générateur Riverpod 3 ne résout pas encore les types Freezed 3 abstraits.

## DI (main.dart)

```dart
ProviderScope(
  overrides: [
    sharedPreferencesInstanceProvider.overrideWithValue(prefs),
    loggerProvider.overrideWithValue(logger),
    scoreRepositoryProvider.overrideWith((ref) => ScoreRepositoryImpl(...)),
    localeRepositoryProvider.overrideWith((ref) => LocaleRepositoryImpl(...)),
  ],
  child: const TicTacToeApp(),
)
```

## Commandes dev

```bash
fvm use                          # Activer la bonne version Flutter
melos run codegen                # build_runner dans l'ordre des dépendances (core en premier)
melos run codegen:core           # Codegen du package core uniquement
melos run test:all               # Tous les tests (sans goldens)
melos run analyze                # Analyse statique
flutter test --tags golden       # Goldens uniquement
```

Après toute modification d'une classe Freezed, AutoRoute `@RoutePage`, ou `@riverpod` : relancer `melos run codegen`.

## Skills disponibles

- `/architecture` — règles de couches, graphe de dépendances, cycle de vie providers, RouteContributor
- `/patterns` — code annoté : Notifier, AsyncNotifier, mutation optimiste, ref.listen, Result, sealed unions
- `/add-feature` — guide pas-à-pas pour ajouter une feature (domain → data → presentation → wiring)
- `/game-domain` — entités, use cases, AI strategies, flux GameController + GameOutcomeRecorder
- `/testing` — structure des tests par couche, ProviderContainer, fake_async, helpers
