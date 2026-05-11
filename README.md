# Tic-Tac-Toe — Flutter

Application Tic-Tac-Toe Humain vs CPU construite avec une architecture Clean Architecture, un state management Riverpod 3 et une IA minimax imbattable.

## Stack

| Domaine | Choix |
| --- | --- |
| Architecture | Clean Architecture (domain / data / presentation), feature-first |
| État | Riverpod 3 + `riverpod_generator` |
| Modèles | Freezed 3 — sealed unions, immuabilité, `copyWith` |
| Navigation | AutoRoute 11 — routes type-safe avec paramètres compilés |
| Persistance | `shared_preferences` |
| Internationalisation | `flutter_localizations` · Français + Anglais |
| Infos app | `package_info_plus` |
| Tests | `flutter_test`, `fake_async`, `mocktail` |
| Plateformes | Android, iOS, macOS |

## Versions

| Outil | Version |
| --- | --- |
| Flutter | 3.41.7 |
| Dart | ≥ 3.11.5 |

Le projet utilise [FVM](https://fvm.app) pour fixer la version de Flutter. Après installation de FVM : `fvm use`.

## Installation et lancement

```bash
# Récupérer les dépendances
flutter pub get

# Générer le code (Riverpod, Freezed, AutoRoute)
dart run build_runner build --delete-conflicting-outputs

# Lancer sur un device
flutter run -d <device>
```

## Tests

```bash
# Lancer tous les tests
flutter test
```

Ce qui est couvert :

- **Domain** : `BoardEntity`, `playMove`, les 3 stratégies IA, `recordOutcome`, `resolveFirstPlayer`
- **Fuzz** : minimax joue 50 parties contre random — 0 défaite
- **Auto-jeu** : minimax vs minimax → match nul systématique
- **Data** : `ScoreRepositoryImpl` avec `SharedPreferences.setMockInitialValues`
- **Application** : `GameController` (timing CPU via `fakeAsync`), `ScoreController`, `GameOutcomeRecorder`
- **Widgets** : `BoardWidget`, `WinningLineOverlay`, `ConfigPage`, `SettingsPage`

## Architecture

### Vue d'ensemble — Clean Architecture feature-first

Le projet est un **monorepo Dart** (pub workspaces) composé de 7 packages indépendants organisés en couches strictes. Chaque feature est découpée en trois packages : `domain`, `data`, `presentation`.

```
┌─────────────────────────────────────────────────────────────────────┐
│                          lib/main.dart                              │
│              ProviderScope · overrides · error handlers             │
└────────────────────────────┬────────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────────┐
│                         lib/app/app.dart                            │
│          MaterialApp.router · Theme · Localizations · AppRouter     │
└──────────────────┬──────────────────────────────┬───────────────────┘
                   │                              │
   ┌───────────────▼──────────────┐  ┌────────────▼────────────────┐
   │      game_presentation       │  │    settings_presentation    │
   │  ┌─────────────────────────┐ │  │  ┌────────────────────────┐ │
   │  │ Pages                   │ │  │  │ SettingsPage           │ │
   │  │  HomePage               │ │  │  └────────────────────────┘ │
   │  │  ConfigPage             │ │  │  ┌────────────────────────┐ │
   │  │  GamePage               │ │  │  │ LocaleController       │ │
   │  └─────────────────────────┘ │  │  │ (AsyncNotifier,        │ │
   │  ┌─────────────────────────┐ │  │  │  keepAlive)            │ │
   │  │ Logic (Riverpod)        │ │  │  └────────────────────────┘ │
   │  │  GameController         │ │  └─────────────────────────────┘
   │  │  ScoreController        │ │
   │  │  ConfigNotifier         │ │
   │  │  GameOutcomeRecorder    │ │
   │  │  aiStrategyProvider     │ │
   │  └─────────────────────────┘ │
   │  ┌─────────────────────────┐ │
   │  │ Widgets                 │ │
   │  │  BoardWidget            │ │
   │  │  WinningLineOverlay     │ │
   │  │  GameStatusBanner       │ │
   │  │  ScorePanel             │ │
   │  └─────────────────────────┘ │
   └───────────────┬──────────────┘
                   │ dépend de ↓
   ┌───────────────▼──────────────┐  ┌─────────────────────────────┐
   │         game_domain          │  │       settings_domain       │
   │  Dart pur · 0 dép. Flutter   │  │  AppLocale · LocaleRepo     │
   │                              │  │  LoadLocale · SetLocale     │
   │  GameStateEntity (sealed)    │  └──────────────┬──────────────┘
   │    InProgress │ Won │ Draw   │                 │
   │  BoardEntity · CellMark      │  ┌──────────────▼──────────────┐
   │  GameConfigEntity            │  │       settings_data         │
   │  AiStrategy (interface)      │  │  LocaleRepositoryImpl       │
   │    RandomStrategy            │  │  SharedPreferences          │
   │    HeuristicStrategy         │  └─────────────────────────────┘
   │    MinimaxStrategy (α-β)     │
   │  UseCase interfaces          │
   │  ScoreRepository (interface) │
   └───────────────┬──────────────┘
                   │ implémenté par ↓
   ┌───────────────▼──────────────┐
   │          game_data           │
   │  ScoreRepositoryImpl         │
   │  ScoreLocalDatasource        │
   │  SharedPreferences           │
   └───────────────┬──────────────┘
                   │
   ┌───────────────▼──────────────────────────────────────────────┐
   │                            core                              │
   │  Result<T> sealed (Success / Error) · Failure hierarchy      │
   │  UseCase / AsyncUseCase interfaces                           │
   │  AppRouter + RouteContributor (agrège les routes features)   │
   │  AppLogger + ConsoleLogger + loggerProvider                  │
   │  AppProviderObserver (log transitions Riverpod)              │
   │  SharedPreferences provider · PackageInfo provider           │
   │  Material 3 Theme (light + dark)                             │
   │  Localisations générées ARB (FR / EN)                        │
   └──────────────────────────────────────────────────────────────┘
```

### Structure des packages (monorepo pub workspace)

```
packages/
├── core/                           # Partagé par toutes les features
└── features/
    ├── game/
    │   ├── game_domain/            # Dart pur — entities, AI, use cases, repo interfaces
    │   ├── game_data/              # Implémentations (SharedPreferences)
    │   └── game_presentation/      # Flutter + Riverpod — pages, widgets, logic
    └── settings/
        ├── settings_domain/        # AppLocale, LocaleRepository interface
        ├── settings_data/          # LocaleRepositoryImpl
        └── settings_presentation/  # LocaleController, SettingsPage
```

### Flux d'une action utilisateur (jouer un coup)

```
Tap sur une cellule (BoardWidget)
         │
         ▼
GameController.playHumanMove(index)
  ├─ PlayMove use case ──► BoardEntity.place() → Result<GameStateEntity>
  ├─ Mise à jour de GameUiState (état Riverpod)
  └─ Si la partie continue → playComputerMove() après délai
              │
              ▼
       AiStrategy.chooseMove(board)
              │
       MinimaxStrategy (alpha-beta pruning)   ← Hard
       HeuristicStrategy (règles prioritaires) ← Medium
       RandomStrategy (case libre au hasard)   ← Easy
              │
              ▼
       PlayMove use case ──► nouvel état
              │
              ▼
  GameOutcomeRecorder (écoute Won/Draw)
         │
         ▼
  RecordOutcome use case ──► ScoreRepository.save()
         │
         ▼
  ScoreController (recharge le score depuis le repo)
```

### Injection de dépendances

Les dépendances traversent les couches via **Riverpod + surcharge dans `main.dart`** :

```dart
// main.dart — les implémentations concrètes écrasent les placeholders domain
ProviderScope(
  overrides: [
    scoreRepositoryProvider.overrideWithValue(ScoreRepositoryImpl(...)),
    localeRepositoryProvider.overrideWithValue(LocaleRepositoryImpl(...)),
  ],
  child: TicTacToeApp(),
)
```

Dans les tests, les repositories sont remplacés par des mocks ou fakes sans toucher au code de production.

### Règles d'architecture

- **Le domain ne connaît rien de Flutter, Riverpod ni SharedPreferences.** Il est testé avec des assertions pures.
- **L'inversion de dépendance** est portée par les interfaces de repository : abstraites dans `domain`, implémentées dans `data`, injectées depuis `presentation` via Riverpod.
- **`GameState` est une sealed union** (`InProgress | Won | Draw`). Le pattern-matching est exhaustif — le compilateur attrape les cas manquants.
- **`GameOutcomeRecorder` est séparé de `GameController`** : il écoute les transitions `InProgress → Won/Draw` et délègue au `ScoreController`. `GameController` ne connaît pas `ScoreController` (SRP).
- **Les routes sont décentralisées** : chaque package `presentation` expose un `RouteContributor`. L'`AppRouter` du core les agrège sans couplage direct.

## IA — 3 niveaux de difficulté

Interface `AiStrategy` avec trois implémentations pures et déterministes (aucune I/O, pas de `Ref`) :

| Difficulté | Implémentation | Comportement |
| --- | --- | --- |
| Easy | `RandomStrategy` | Case libre au hasard |
| Medium | `HeuristicStrategy` | Gagne si possible → bloque → centre → coin → côté |
| Hard | `MinimaxStrategy` | Minimax avec élagage alpha-beta |

Le minimax utilise un scoring ajusté par la profondeur (`10 - depth` / `depth - 10`) : l'IA préfère gagner le plus vite possible et retarder toute défaite inévitable. Mathématiquement imbattable au morpion.

Ajouter un niveau = ajouter une classe, un cas dans le switch, et un test.

## Flux utilisateur

1. **Home** — score cumulé (persistant), bouton « Jouer », bouton « Réinitialiser le score »
2. **Config** — choix du symbole (X/O), du premier joueur (moi / CPU / aléatoire), de la difficulté
3. **Game** — plateau animé, bandeau de statut, panneau de score, boutons de fin de partie
4. **Paramètres** — choix de la langue, version de l'application
