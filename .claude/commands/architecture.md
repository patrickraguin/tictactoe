# Architecture — Référence complète

## Règle de dépendance (stricte, enforced par pub workspace)

```
domain ← data ← presentation ← lib/main.dart
                core ← tout le monde (jamais l'inverse)
```

Chaque couche ne peut importer que les couches à sa gauche et `core`. Le compilateur Dart refuse les imports circulaires.

## Quoi va où

### `domain/`
- **Entities** : classes Freezed `@freezed` (value objects) ou `@immutable` (invariants forts comme `BoardEntity`)
- **Sealed unions** : `@freezed sealed class` (ex: `GameStateEntity`)
- **Repository interfaces** : `abstract interface class ScoreRepository { ... }`
- **Use cases** : `implements UseCase<P,O>` — const constructors, aucune dépendance externe
- **AI strategies** : `implements AiStrategy` — pure Dart, aucune I/O
- **Enums** : `CellMarkEnum`, `DifficultyEnum`, `TypePlayerEnum`, `GameOutcome`
- **INTERDIT** : flutter/, flutter_riverpod, riverpod, shared_preferences, get_it

### `data/`
- **Repository impls** : `class ScoreRepositoryImpl implements ScoreRepository`
- **Datasources** : wrappers SharedPreferences (sérialisation JSON)
- **INTERDIT** : flutter_riverpod, Notifier, Provider

### `presentation/`
- **Pages** : `StatelessWidget` annotées `@RoutePage()`
- **Widgets** : `StatelessWidget` (ConsumerWidget si besoin de ref)
- **Controllers/Notifiers** : dans `lib/logic/` (sous-dossiers : `controllers/`, `recorders/`)
- **Notifiers simples** : à la racine de `lib/logic/` (ex: `config_notifier.dart`)
- **Providers** : dans `lib/logic/providers/` — déclaration avec `throw UnimplementedError`
- **UI state** : Freezed, dans `lib/logic/` (ex: `game_ui_state.dart`)
- **Router** : `implements RouteContributor`, fichier `router.dart` + `router.gr.dart` (généré)

### `core/`
- `Result<T>` sealed, `Failure` hierarchy
- `UseCase / AsyncUseCase` interfaces
- `AppRouter` + `RouteContributor` interface
- `AppLogger` interface + `ConsoleLogger`
- `AppProviderObserver` (log transitions Riverpod)
- `sharedPreferencesInstanceProvider`, `packageInfoProvider`, `loggerProvider`
- Theme (Material 3 light + dark), l10n (ARB générés)

## Pattern : Repository provider avec override

```dart
// Dans presentation/lib/logic/providers/score_providers.dart
@Riverpod(keepAlive: true)
ScoreRepository scoreRepository(Ref ref) => throw UnimplementedError(
  'scoreRepositoryProvider must be overridden in ProviderScope',
);

// Dans lib/main.dart — override avec l'implémentation concrète
scoreRepositoryProvider.overrideWith(
  (ref) => ScoreRepositoryImpl(
    ScoreLocalDatasource(ref.watch(sharedPreferencesInstanceProvider)),
  ),
),
```

L'interface vit dans `domain/`, l'implémentation dans `data/`, la déclaration du provider dans `presentation/`, le wiring dans `lib/main.dart`.

## Pattern : RouteContributor

```dart
// Dans feature/presentation/lib/router.dart
@AutoRouterConfig()
class GamePresentationRouter extends RootStackRouter implements RouteContributor {
  @override
  List<AutoRoute> get routes => [...]; // routes de la feature
}

// Dans lib/app/app.dart — aggrégation sans couplage direct
AppRouter([GamePresentationRouter(), SettingsPresentationRouter()])
```

Chaque package `presentation` s'enregistre lui-même. `app.dart` ne connaît pas les routes individuellement.

## Cycle de vie des providers

| Annotation | Durée de vie | Usage |
|---|---|---|
| `@Riverpod(keepAlive: true)` | App entière (jamais disposé) | ScoreController, LocaleController, repositories |
| `@riverpod` (défaut) | Disposé quand plus de listeners | GameController, GameOutcomeRecorder, ConfigNotifier |
| `NotifierProvider.autoDispose` (manuel) | Disposé quand plus de listeners | ConfigNotifier (cas particulier sans codegen) |

## `ref.watch` vs `ref.read` en controller

- **`ref.watch()`** dans `build()` : crée une dépendance réactive. Si le provider watched change, `build()` est re-exécuté.
- **`ref.read()`** dans les méthodes de mutation : lecture ponctuelle, pas de réactivité. Toujours utiliser `ref.read` dans les callbacks/mutations pour éviter les rebuilds inattendus.

```dart
@override
GameUiState build(GameConfigEntity config) {
  _strategy = ref.watch(aiStrategyProvider(config.difficulty)); // réactif
  ...
}

Future<void> playHumanMove(int index) async {
  final repo = ref.read(scoreRepositoryProvider); // lecture ponctuelle
  ...
}
```
