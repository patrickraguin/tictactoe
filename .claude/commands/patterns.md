# Patterns de code — Référence annotée

## Sync Notifier (family) — GameController

```dart
@riverpod  // autoDispose par défaut
class GameController extends _$GameController {
  @override
  GameUiState build(GameConfigEntity config) {  // family : paramètre = clé du provider
    _strategy = ref.watch(aiStrategyProvider(config.difficulty));  // watch dans build = réactif
    final firstMark = const ResolveFirstPlayer()(config).unwrap();
    if (firstMark != config.humanMark) {
      unawaited(Future.microtask(_playCpuIfNeeded));  // CPU en premier via microtask
    }
    return GameUiState(game: initialState(board: BoardEntity.empty(), ...));
  }

  Future<void> playHumanMove(int index) async {
    // Mutations : guard + mise à jour de state directement
    state = state.copyWith(game: newState);
    await _playCpuIfNeeded();
  }

  void restart() => ref.invalidateSelf();  // re-exécute build() → réinitialise l'état
}
```

**Règle** : `ref.watch` dans `build()` uniquement. Mutations via `state = ...` dans les méthodes.

## AsyncNotifier avec mutation optimiste — ScoreController

```dart
@Riverpod(keepAlive: true)  // app-wide, jamais disposé
class ScoreController extends _$ScoreController {
  @override
  Future<ScoreEntity> build() async {  // chargement initial async
    final repo = ref.watch(scoreRepositoryProvider);
    final result = await repo.load();
    return switch (result) {
      Success(:final value) => value,
      Error(:final failure) => throw StorageException(failure.message),
    };
  }

  Future<void> recordWin() => _mutate(
    (s) => const RecordOutcome()(RecordOutcomeParams(current: s, outcome: GameOutcome.win)).unwrap(),
  );

  Future<void> _mutate(ScoreEntity Function(ScoreEntity) update) async {
    final current = state.value;
    if (current == null) return;           // garde : AsyncData seulement
    final next = update(current);
    state = AsyncData(next);               // 1. mise à jour optimiste immédiate (pas de loading)
    final result = await ref.read(scoreRepositoryProvider).save(next);
    if (result is Error) state = AsyncData(current);  // 2. rollback si persistence échoue
  }

  Future<void> reset() async {
    final previous = state.value;
    state = AsyncData(ScoreEntity.zero()); // optimiste
    final result = await ref.read(scoreRepositoryProvider).reset();
    if (result is! Success && previous != null) state = AsyncData(previous); // rollback
  }
}
```

**Règle** : pas d'état `loading` pendant les mutations — seulement pendant le `build()` initial. `ref.read` dans les mutations pour éviter les rebuilds.

## Notifier manuel sans codegen — ConfigNotifier

```dart
// Cas particulier : riverpod_generator ne peut pas résoudre les types Freezed 3
// abstraits comme état d'un Notifier → déclaration manuelle obligatoire.
final NotifierProvider<ConfigNotifier, GameConfigEntity> configNotifierProvider =
    NotifierProvider.autoDispose<ConfigNotifier, GameConfigEntity>(ConfigNotifier.new);

class ConfigNotifier extends Notifier<GameConfigEntity> {
  @override
  GameConfigEntity build() => const GameConfigEntity(
    humanMark: CellMarkEnum.x,
    firstPlayer: TypePlayerEnum.human,
    difficulty: DifficultyEnum.hard,
  );

  void setMark(CellMarkEnum mark) => state = state.copyWith(humanMark: mark);
  void setDifficulty(DifficultyEnum d) => state = state.copyWith(difficulty: d);
}
```

## Observer cross-controllers — GameOutcomeRecorder

```dart
// SRP : GameController ne connaît pas ScoreController.
// GameOutcomeRecorder les relie via ref.listen.
@riverpod
class GameOutcomeRecorder extends _$GameOutcomeRecorder {
  @override
  void build(GameConfigEntity config) {  // retourne void
    ref.listen<GameUiState>(
      gameControllerProvider(config),
      (previous, next) async {
        final justEnded = (previous == null || !previous.game.isOver) && next.game.isOver;
        if (!justEnded) return;  // filtre : uniquement la transition InProgress → Over

        final score = ref.read(scoreControllerProvider.notifier);
        switch (next.game) {
          case WonEntity(:final winner, :final humanMark):
            winner == humanMark ? await score.recordWin() : await score.recordLoss();
          case DrawEntity():
            await score.recordDraw();
          case InProgressEntity():
            break; // unreachable (guard justEnded)
        }
      },
    );
  }
}
```

## Result<T> — patterns d'usage

```dart
// 1. switch exhaustif (pattern le plus courant)
switch (result) {
  case Success(:final value): state = state.copyWith(game: value);
  case Error(:final failure): _log.warning(failure.message);
}

// 2. .unwrap() — pour les use cases infaillibles (toujours Success)
final firstMark = const ResolveFirstPlayer()(config).unwrap();

// 3. .fold() — dual-path symétrique
result.fold(
  onSuccess: (value) => state = AsyncData(value),
  onError: (failure) => throw StorageException(failure.message),
);

// 4. .map() — transformer le Success sans toucher au Error
final doubled = result.map((score) => score.copyWith(wins: score.wins * 2));
```

## Sealed union — pattern matching exhaustif

```dart
// Toujours switch expression (pas if-chain). Le compilateur détecte les cas manquants.
Widget build(BuildContext context, WidgetRef ref) {
  final game = ref.watch(gameControllerProvider(config)).game;
  return switch (game) {
    InProgressEntity(:final turn) => Text('Tour : ${turn.name}'),
    WonEntity(:final winner)      => Text('Gagnant : ${winner.name}'),
    DrawEntity()                  => const Text('Match nul'),
  };
}
```

## UI State vs Domain State

`GameUiState` est un état de présentation (Freezed) — il enrichit l'état domain de flags UI :

```dart
@freezed
class GameUiState with _$GameUiState {
  const factory GameUiState({
    required GameStateEntity game,      // état domain pur (sealed)
    @Default(false) bool cpuThinking,  // flag UI uniquement (spinner)
  }) = _GameUiState;
}
```

`cpuThinking` n'appartient pas à `GameStateEntity` (domain pur) — il est invisible pour les use cases.

## UseCase — conventions

```dart
// Const constructor quand aucune dépendance externe
class PlayMove implements UseCase<PlayMoveParams, GameStateEntity> {
  const PlayMove();
  @override
  Result<GameStateEntity> call(PlayMoveParams params) { ... }
}

// Params object pour plus d'un argument
class PlayMoveParams {
  const PlayMoveParams({required this.state, required this.index, required this.mark});
  final GameStateEntity state;
  final int index;
  final CellMarkEnum mark;
}

// Use case infaillible : retourne toujours Success (mais garde Result<T> pour cohérence)
class RecordOutcome implements UseCase<RecordOutcomeParams, ScoreEntity> {
  const RecordOutcome();
  @override
  Result<ScoreEntity> call(RecordOutcomeParams params) => Success(/* ... */);
}
```
