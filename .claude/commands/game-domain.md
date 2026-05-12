# Game Domain — Référence

## Entités

### `GameStateEntity` (sealed Freezed)

```dart
sealed class GameStateEntity {
  InProgressEntity { board, turn: CellMarkEnum, humanMark: CellMarkEnum }
  WonEntity        { board, winner: CellMarkEnum, line: List<int>, humanMark }
  DrawEntity       { board, humanMark }
}
```

- `.isOver` → `bool` (true pour Won et Draw)
- `.board`, `.humanMark` → getters partagés via `switch`
- Pattern matching **obligatoirement exhaustif** (sealed garantit la complétude)

### `BoardEntity` (`@immutable`, PAS Freezed)

Invariant fort : exactement 9 cellules. Validé dans le constructeur → `@immutable` manuel.

```dart
board.place(index, mark)   // → nouveau BoardEntity (immuable)
board.availableMoves        // → List<int> (indices des cases libres)
board.winningLineFor(mark)  // → List<int>? (null si pas de victoire)
board.winner                // → CellMarkEnum? (null si partie en cours)
board.isFull                // → bool
BoardEntity.empty()         // factory : plateau initial
```

8 lignes gagnantes statiques : 3 lignes, 3 colonnes, 2 diagonales.

### `GameConfigEntity` (Freezed frozen)

`humanMark: CellMarkEnum`, `firstPlayer: TypePlayerEnum`, `difficulty: DifficultyEnum`

### `ScoreEntity` (Freezed frozen)

`wins`, `losses`, `draws` — `ScoreEntity.zero()` pour initialisation.

### Enums clés

- `CellMarkEnum` : `x | o | empty` — `.opponent`, `.isEmpty`, `.isPlayed`
- `DifficultyEnum` : `easy | medium | hard`
- `TypePlayerEnum` : `human | cpu | random`
- `GameOutcome` : `win | loss | draw`

---

## Use Cases

### `PlayMove`

```dart
const PlayMove()(PlayMoveParams(state: current, index: i, mark: m))
// → Result<GameStateEntity>
// Failures : InvalidMoveFailure (partie terminée, mauvais tour, case occupée)
// Success  : WonEntity | DrawEntity | InProgressEntity suivant
```

### `ResolveFirstPlayer`

```dart
const ResolveFirstPlayer()(config)
// → Result<CellMarkEnum> (toujours Success)
// human → humanMark, cpu → humanMark.opponent, random → aléatoire
```

### `RecordOutcome`

```dart
const RecordOutcome()(RecordOutcomeParams(current: score, outcome: GameOutcome.win))
// → Result<ScoreEntity> (toujours Success)
// Incrémente wins/losses/draws selon l'outcome
```

### Fonction libre `initialState`

```dart
initialState(board: BoardEntity.empty(), firstToPlay: mark, humanMark: humanMark)
// → InProgressEntity (toujours)
```

---

## AI Strategies

| Difficulté | Classe | Comportement |
|---|---|---|
| Easy | `RandomStrategy` | Case libre au hasard |
| Medium | `HeuristicStrategy` | Gagner → bloquer → centre(4) → coin aléatoire → côté |
| Hard | `MinimaxStrategy` | Minimax avec élagage alpha-beta |

**Scoring minimax** : `10 - depth` (victoire) / `depth - 10` (défaite). L'IA préfère gagner le plus vite possible et retarder toute défaite inévitable. Mathématiquement imbattable sur un plateau 3×3.

**`AiStrategy.fromDifficulty(difficulty)`** → factory qui instancie la bonne stratégie.

**Ajouter un niveau de difficulté** :
1. Ajouter la valeur dans `DifficultyEnum`
2. Implémenter `class NomStrategy implements AiStrategy`
3. Ajouter le case dans `AiStrategy.fromDifficulty` switch
4. Ajouter la string l10n dans les deux fichiers ARB
5. Ajouter `ButtonSegment` dans `ConfigPage`
6. Écrire les tests (voir `/testing`)

---

## Flux GameController

```
build(config)
  ├─ ref.watch(aiStrategyProvider(config.difficulty))   # injecte la stratégie
  ├─ ResolveFirstPlayer()(config).unwrap()              # qui joue en premier
  ├─ initialState(...)                                  # état initial
  └─ Si CPU premier → Future.microtask(_playCpuIfNeeded)

playHumanMove(index)
  ├─ Guard : partie en cours + tour humain
  ├─ PlayMove()(params) → Result
  │   Success → state = state.copyWith(game: value)
  │   Error   → log warning (coup invalide)
  └─ _playCpuIfNeeded()

_playCpuIfNeeded()
  ├─ Guard : partie en cours + tour CPU
  ├─ state = state.copyWith(cpuThinking: true)
  ├─ await Future.delayed(400ms)         # délai UI simulé
  ├─ Guard : ref.mounted (évite post-dispose emit)
  ├─ strategy.nextMove(board, cpuMark)
  └─ PlayMove()(params) → Result → state = GameUiState(game: value)

restart()
  └─ ref.invalidateSelf()                # re-exécute build()
```

---

## Flux score (GameOutcomeRecorder)

```
GameOutcomeRecorder.build(config)
  └─ ref.listen(gameControllerProvider(config), (previous, next) {
       guard : transition InProgress → Over seulement
       switch(next.game) {
         WonEntity(winner == humanMark) → scoreController.recordWin()
         WonEntity(winner != humanMark) → scoreController.recordLoss()
         DrawEntity()                   → scoreController.recordDraw()
       }
     })
```

`GameController` ne connaît pas `ScoreController` — c'est `GameOutcomeRecorder` qui les relie (SRP).
`ScoreController` est `keepAlive` et persist les scores même après destruction de `GameController`.
