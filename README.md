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
├── main.dart                    # ProviderScope + AppProviderObserver (logging global)
│
├── core/                        # Infrastructure transversale
│   ├── app.dart                 # MaterialApp.router (thème, locale, router)
│   ├── l10n_ext.dart            # Extension BuildContext.l10n
│   ├── router/                  # AutoRoute — 4 routes type-safe
│   ├── theme/                   # Material 3, light + dark
│   ├── logging/                 # Interface AppLogger + ConsoleLogger + provider
│   ├── persistence/             # SharedPreferences + PackageInfo via providers
│   ├── l10n/                    # Traductions ARB (FR/EN) + classes générées
│   ├── error/                   # AppProviderObserver : log toutes transitions Riverpod
│   └── result/                  # Result<T> sealed (Success / Error / Failure / Unit)
│
└── features/
    ├── game/                    # Feature principale
    │   ├── domain/              # PURE DART — 100 % testable
    │   │   ├── entities/        # Board, CellMark, GameState (sealed), GameConfig, Score, Player, Difficulty
    │   │   ├── ai/              # AiStrategy + 3 implémentations (Random / Heuristic / Minimax) + factory
    │   │   ├── usecases/        # playMove, recordOutcome, resolveFirstPlayer (fonctions pures)
    │   │   └── repositories/    # ScoreRepository (abstrait)
    │   ├── data/
    │   │   ├── datasources/     # SharedPreferences wrapper (lecture sync / écriture async)
    │   │   └── repositories/    # ScoreRepositoryImpl (wraps datasource, Result<T>)
    │   └── presentation/
    │       ├── logic/
    │       │   ├── config_notifier.dart      # État éphémère de ConfigPage (auto-dispose)
    │       │   ├── game_ui_state.dart        # GameStateEntity + cpuThinking (séparation domaine / UI)
    │       │   ├── controllers/              # GameController, ScoreController (AsyncNotifier)
    │       │   ├── providers/               # aiStrategyProvider (family), scoreRepositoryProvider
    │       │   └── recorders/               # GameOutcomeRecorder : écoute GameController → ScoreController
    │       ├── pages/                       # HomePage, ConfigPage, GamePage, SettingsPage
    │       └── widgets/                     # BoardWidget, CellWidget, WinningLineOverlay, ScorePanel, …
    │
    └── settings/                # Feature paramètres (langue)
        ├── domain/              # AppLocale (enum), LocaleRepository (abstrait)
        ├── data/                # LocaleRepositoryImpl (SharedPreferences)
        └── presentation/        # LocaleController (AsyncNotifier), SettingsPage
```

Règles clés :

- **Le domain ne connaît rien de Flutter, de Riverpod, ni de SharedPreferences.** Il est testé uniquement avec des assertions pures.
- L'inversion de dépendance est matérialisée par `ScoreRepository` (abstrait dans `domain`, implémenté dans `data`, injecté depuis `presentation`).
- Le modèle d'état `GameState` est une **sealed union freezed** (`InProgress | Won | Draw`). Les composants consomment cette union via du pattern-matching exhaustif — le compilateur attrape les cas oubliés.
- `GameOutcomeRecorder` est séparé de `GameController` : il écoute les transitions `InProgress → Won/Draw` et délègue l'enregistrement au `ScoreController`. SRP respecté.

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

Le `GameController` (Riverpod `Notifier<GameUiState>` paramétré par `GameConfig`) détient toute la logique de tour. Les victoires/défaites/nulles sont observées par un `GameOutcomeRecorder` qui écrit dans le `ScoreController` — séparation propre entre logique de jeu et bookkeeping du score.

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
- **AppProviderObserver** : transitions debug / AsyncError / providerDidFail.
- **Widgets** : `BoardWidget` (taps, sémantique a11y), `WinningLineOverlay` (animation, IgnorePointer, ExcludeSemantics), `ConfigPage` (sélections, navigation), `SettingsPage` (langue, version).
- **Golden** : plateau en état de victoire, `GamePage` en cours et en état gagné.

Régénérer les goldens si le thème change : `flutter test --update-goldens`.

## Décisions architecturales

### ADR-1 — Riverpod 3 plutôt que BLoC / Provider

**Contexte** : le projet nécessite une injection de dépendances, un état asynchrone et des providers paramétrés (family).  
**Décision** : Riverpod 3 avec `riverpod_generator`. `AsyncNotifier` unifie l'initialisation asynchrone et les mutations dans une seule classe ; `family` permet des providers paramétrés sans singleton global fragile ; `ProviderScope` remplace `get_it` sans couche supplémentaire.  
**Alternatives écartées** : BLoC (trop verbeux pour un projet de taille moyenne) ; Provider v2 (pas de `AsyncNotifier`, dispose manuel).

---

### ADR-2 — Freezed 3 pour les modèles de domaine

**Contexte** : les entités (`GameState`, `GameConfig`, `Score`) doivent être immuables, comparables par valeur et supportent le pattern-matching.  
**Décision** : `@freezed` pour les records et les unions scellées ; `@immutable` manuel pour `BoardEntity` (objet avec logique métier et invariants explicites — Freezed ne serait qu'un raccourci de boilerplate ici).  
**Alternatives écartées** : classes manuelles (risque d'oubli de `==` / `hashCode`) ; `equatable` (moins expressif pour les unions scellées).

---

### ADR-3 — AutoRoute 10 pour la navigation

**Contexte** : les routes transportent des paramètres typés (`GameRoute(config: config)`).  
**Décision** : AutoRoute avec codegen. Les routes sont fortement typées, les paramètres sont validés à la compilation, et l'API (`context.router.push`) est identique sur toutes les plateformes.  
**Alternatives écartées** : `go_router` (paramètres de route moins type-safe, sérialisation manuelle) ; navigation impérative `Navigator.push` (pas de type-safety sur les paramètres).

---

### ADR-4 — Result<T> plutôt que les exceptions pour les erreurs récupérables

**Contexte** : les opérations de persistance (`ScoreRepository`, `LocaleRepository`) peuvent échouer de façon prévisible.  
**Décision** : sealed class `Result<T>` avec variantes `Success` / `Error`. Les callers sont forcés de gérer l'erreur au niveau du type ; pas d'exception implicite qui remonte silencieusement.  
**Alternatives écartées** : exceptions Dart (invisibles dans la signature, oubliées facilement) ; `Either` (introduit `dartz` comme dépendance lourde pour ce besoin simple).

---

### ADR-5 — SharedPreferences plutôt que Hive / Drift

**Contexte** : la persistence se résume à 3 entiers (wins, losses, draws) et une clé locale (locale).  
**Décision** : `shared_preferences`. Zéro schéma, zéro migration, zéro dépendance native supplémentaire. L'abstraction `ScoreRepository` permet de remplacer l'implémentation sans toucher au domaine.  
**Alternatives écartées** : Hive / Drift (sur-ingénierie pour 4 valeurs primitives).

---

### ADR-6 — Séparation GameController / GameOutcomeRecorder

**Contexte** : enregistrer le score à chaque fin de partie est une responsabilité distincte de la logique de jeu.  
**Décision** : `GameOutcomeRecorder` est un `Notifier` séparé qui écoute `GameController` via `ref.listen`. Il détecte uniquement la **transition** `InProgress → Won/Draw` (`justEnded`) pour éviter les doubles enregistrements. `GameController` ne connaît pas `ScoreController`.  
**Alternatives écartées** : enregistrement direct dans `GameController` (violerait SRP et rendrait les tests du contrôleur plus complexes).

---

## Choix techniques assumés

- **Pas de package `json_serializable`** : aucune sérialisation JSON nécessaire (données locales simples → 3 `int` dans `SharedPreferences`).
- **Pas de `get_it` / service locator** : Riverpod remplit ce rôle, pas besoin d'une seconde couche d'injection.
- **Auto-dispose par défaut** : `@riverpod` sans `keepAlive` pour le `GameController` et `ConfigNotifier` — une nouvelle partie / ouverture de page = un state propre. `ScoreController` et `LocaleController` sont `keepAlive` (valeurs de session).
- **Animations légères** : `AnimatedSwitcher` sur les cellules, `TweenAnimationBuilder` pour tracer la ligne gagnante. Objectif : du feedback visuel sans framework d'animation lourd.
- **Accessibilité** : labels sémantiques localisés sur toutes les cellules, live region sur le bandeau de statut, résumé vocal du score. `WinningLineOverlay` est exclu de l'arbre sémantique (information déjà annoncée par le bandeau).

## Hors scope (à discuter en entretien)

- Mode multijoueur en ligne (backend, WebSocket, conflits de tour).
- CI/CD — un `.github/workflows/ci.yml` minimal (`flutter analyze` + `flutter test`) se branche en 10 lignes si pertinent.

---

Test rédigé dans le cadre d'un recrutement Betclic. Code organisé pour servir de base de discussion technique, pas comme livraison finale de produit.
