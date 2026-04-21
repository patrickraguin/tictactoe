# Tic-Tac-Toe — Flutter

Tic-Tac-Toe Humain vs CPU construit pour un test technique Flutter senior.

L'objectif n'est pas le jeu en lui-même, mais ce qu'il y a autour : architecture claire, IA testable, état prévisible, couverture de tests sérieuse, UX soignée.

## Stack

| Domaine         | Choix                                                     |
| --------------- | --------------------------------------------------------- |
| Architecture    | Clean Architecture (domain / data / presentation)         |
| État            | Riverpod 3 + `riverpod_generator` (code generation)       |
| Modèles         | Freezed 3 (sealed unions pour `GameState`)                |
| Navigation      | AutoRoute 10                                              |
| Persistance     | `shared_preferences`                                      |
| Internationalisation | `flutter_localizations` · Français + Anglais        |
| Infos app       | `package_info_plus` (version affichée dans Paramètres)    |
| Tests           | `flutter_test`, golden tests, `fake_async`, `mocktail`    |
| Plateformes     | Android, iOS, macOS (Linux/Windows/Web conservés par défaut) |

## Lancer le projet

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d <device>
```

Le projet tourne sur Android, iOS et macOS. Les autres plateformes (web/windows/linux) sont conservées mais non testées.

## Architecture

```
lib/
├── main.dart                    # ProviderScope + override SharedPreferences
├── app/                         # shell : MaterialApp, thème, router
│   ├── app.dart
│   ├── router/app_router.dart
│   └── theme/app_theme.dart
└── features/
    └── game/
        ├── domain/              # PURE DART — 100 % testable
        │   ├── entities/        # Board, CellMark, GameState (sealed), GameConfig, Score, Player, Difficulty
        │   ├── ai/              # AiStrategy + 3 implémentations + factory
        │   ├── usecases/        # playMove, initialState
        │   └── repositories/    # ScoreRepository (abstract)
        ├── data/
        │   ├── datasources/     # SharedPreferences wrapper
        │   └── repositories/    # ScoreRepositoryImpl
        └── presentation/
            ├── pages/           # HomePage, ConfigPage, GamePage
            ├── widgets/         # BoardWidget, CellWidget, WinningLineOverlay, ScorePanel
            └── providers/       # GameController, ScoreController, overrides
```

Règles clés :

- **Le domain ne connaît rien de Flutter, de Riverpod, ni de SharedPreferences.** Il est testé uniquement avec des assertions pures.
- L'inversion de dépendance est matérialisée par `ScoreRepository` (abstrait dans `domain`, implémenté dans `data`, injecté depuis `presentation`).
- Le modèle d'état `GameState` est une **sealed union freezed** (`InProgress | Won | Draw`). Les composants consomment cette union via du pattern-matching exhaustif — le compilateur attrape les cas oubliés.

## L'IA en 3 niveaux

Une interface `AiStrategy` avec trois implémentations pures et déterministes (aucune I/O, pas de `Ref`) :

| Difficulté | Implémentation       | Comportement                                      |
| ---------- | -------------------- | ------------------------------------------------- |
| Easy       | `RandomStrategy`     | Case libre au hasard                              |
| Medium     | `HeuristicStrategy`  | Gagne si possible → bloque → centre → coin → côté |
| Hard       | `MinimaxStrategy`    | Minimax avec élagage alpha-beta                   |

Le **minimax** utilise un scoring ajusté par la profondeur (`10 - depth` / `depth - 10`) — l'IA préfère gagner vite et retarder toute défaite inévitable. Prouvé mathématiquement imbattable au morpion.

Le choix de la stratégie se fait via `aiStrategyFor(Difficulty)` — ajouter un niveau = ajouter une classe, un cas dans le switch, et un test.

## Flux utilisateur

1. **Home** — logo, score cumulé (persistant via `SharedPreferences`), bouton « Jouer », bouton « Réinitialiser le score ».
2. **Config** — choix du symbole (X/O), du premier joueur (moi / CPU / aléatoire), de la difficulté.
3. **Game** — plateau animé, bandeau de statut, panneau de score, boutons de fin de partie.

Le `GameController` (Riverpod `Notifier<GameState>` paramétré par `GameConfig`) détient toute la logique de tour. Les victoires/défaites/nulles sont observées par un `GameOutcomeRecorder` qui écrit dans le `ScoreController` — séparation propre entre logique de jeu et bookkeeping du score.

## Tests

```bash
flutter test
```

Ce qui est couvert :

- **Unit domain** : `Board` (égalité, moves, winner), `playMove` (transitions, refus), 3 stratégies IA.
- **Fuzz test** : minimax joue 50 parties contre random → 0 défaite.
- **Tests d'auto-jeu** : minimax vs minimax → match nul systématique.
- **Data** : `ScoreRepositoryImpl` via `SharedPreferences.setMockInitialValues`.
- **Application** : `GameController` (fakeAsync, délai CPU), `ScoreController`, `GameOutcomeRecorder`.
- **Widgets** : `BoardWidget` (taps, cellules désactivées, état fin de partie), `ConfigPage` (sélections, navigation), `SettingsPage` (langue, version).
- **Golden** : plateau en état de victoire, `GamePage` en cours et en état gagné.

Régénérer les goldens si le thème change : `flutter test --update-goldens`.

## Choix techniques assumés

- **Riverpod 3** plutôt que v2 — API `Notifier` unifiée, meilleurs diagnostics, codegen plus léger.
- **Pas de package `json_serializable`** : aucune sérialisation JSON nécessaire (données locales simples → 3 `int` dans `SharedPreferences`).
- **Pas de `get_it` / service locator** : Riverpod remplit ce rôle, pas besoin d'une seconde couche d'injection.
- **Auto-dispose par défaut** : `@riverpod` sans `keepAlive` pour le `GameController` — une nouvelle partie = un nouveau state propre. Le `ScoreController` lui est `keepAlive` (valeur de session).
- **`SharedPreferences` plutôt que Hive/Drift** : le score tient dans trois entiers. Toute sur-ingénierie ici serait du bruit.
- **Animations légères** : `AnimatedSwitcher` sur les cellules, `TweenAnimationBuilder` pour tracer la ligne gagnante. Objectif : du feedback visuel sans framework d'animation lourd.

## Hors scope (à discuter en entretien)

- Mode multijoueur en ligne (backend, WebSocket, conflits de tour).
- Internationalisation (UI actuellement en français).
- CI/CD — un `.github/workflows/ci.yml` minimal (`flutter analyze` + `flutter test`) se branche en 10 lignes si pertinent.
- Accessibilité sémantique (labels, focus ordre) — dimensionné pour l'exercice mais à renforcer en production.

---

Test rédigé dans le cadre d'un recrutement Betclic. Code organisé pour servir de base de discussion technique, pas comme livraison finale de produit.
