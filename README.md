# Tic-Tac-Toe — Flutter

Application Tic-Tac-Toe Humain vs CPU construite avec une architecture Clean Architecture, un state management Riverpod 3 et une IA minimax imbattable.

## Stack

| Domaine | Choix |
| --- | --- |
| Architecture | Clean Architecture (domain / data / presentation), feature-first |
| État | Riverpod 3 + `riverpod_generator` |
| Modèles | Freezed 3 — sealed unions, immuabilité, `copyWith` |
| Navigation | AutoRoute 10 — routes type-safe avec paramètres compilés |
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

```
lib/
├── main.dart                    # ProviderScope + AppProviderObserver
│
├── core/                        # Infrastructure transversale
│   ├── app.dart                 # MaterialApp.router (thème, locale, router)
│   ├── router/                  # AutoRoute — 4 routes type-safe
│   ├── theme/                   # Material 3, light + dark
│   ├── logging/                 # Interface AppLogger + ConsoleLogger + provider
│   ├── persistence/             # SharedPreferences + PackageInfo via providers
│   ├── l10n/                    # Traductions ARB (FR/EN) + classes générées
│   ├── error/                   # AppProviderObserver : log toutes les transitions Riverpod
│   └── result/                  # Result<T> sealed (Success / Error / Failure)
│
└── features/
    ├── game/
    │   ├── domain/              # Dart pur — aucune dépendance Flutter ou Riverpod
    │   │   ├── entities/        # Board, CellMark, GameState (sealed), GameConfig, Score
    │   │   ├── ai/              # AiStrategy + 3 implémentations + factory
    │   │   ├── usecases/        # playMove, recordOutcome, resolveFirstPlayer (fonctions pures)
    │   │   └── repositories/    # ScoreRepository (abstrait)
    │   ├── data/
    │   │   ├── datasources/     # SharedPreferences wrapper
    │   │   └── repositories/    # ScoreRepositoryImpl
    │   └── presentation/
    │       ├── logic/
    │       │   ├── controllers/ # GameController, ScoreController
    │       │   ├── providers/   # aiStrategyProvider (family), scoreRepositoryProvider
    │       │   ├── recorders/   # GameOutcomeRecorder
    │       │   ├── game_ui_state.dart     # GameStateEntity + cpuThinking
    │       │   └── config_notifier.dart   # État éphémère de ConfigPage
    │       ├── pages/           # HomePage, ConfigPage, GamePage, SettingsPage
    │       └── widgets/         # BoardWidget, CellWidget, WinningLineOverlay, ScorePanel…
    │
    └── settings/
        ├── domain/              # AppLocale (enum), LocaleRepository (abstrait)
        ├── data/                # LocaleRepositoryImpl
        └── presentation/        # LocaleController, SettingsPage
```

**Règles d'architecture :**

- Le domain ne connaît rien de Flutter, Riverpod ni SharedPreferences. Il est testé avec des assertions pures.
- L'inversion de dépendance est portée par `ScoreRepository` : abstrait dans `domain`, implémenté dans `data`, injecté depuis `presentation` via Riverpod.
- `GameState` est une **sealed union** (`InProgress | Won | Draw`). Le pattern-matching est exhaustif — le compilateur attrape les cas manquants.
- `GameOutcomeRecorder` est séparé de `GameController` : il écoute les transitions `InProgress → Won/Draw` et délègue au `ScoreController`. `GameController` ne connaît pas `ScoreController` (SRP).

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
