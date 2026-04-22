import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/difficulty_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';
import 'package:tictactoe/features/game/domain/entities/type_player_enum.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/game_controller.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/score_controller.dart';
import 'package:tictactoe/features/game/presentation/logic/game_ui_state.dart';
import 'package:tictactoe/features/game/presentation/logic/recorders/game_outcome_recorder.dart';
import 'package:tictactoe/features/game/presentation/logic/providers/score_providers.dart';

import '../../../../../helpers/mock_score_repository.dart';
import '../../../../../helpers/provider_helpers.dart';

/// Fake controller whose state can be driven directly via [emit].
/// Overrides [build] so no AI strategy or timer logic is involved.
class _FakeGameController extends GameController {
  @override
  GameUiState build(GameConfigEntity config) {
    return GameUiState(
      game: GameStateEntity.inProgress(
        board: BoardEntity.empty(),
        turn: config.humanMark,
        humanMark: config.humanMark,
      ),
    );
  }

  void emit(GameStateEntity newState) => state = GameUiState(game: newState);
}

const _config = GameConfigEntity(
  humanMark: CellMarkEnum.x,
  firstPlayer: TypePlayerEnum.human,
  difficulty: DifficultyEnum.easy,
);

final _wonByHuman = GameStateEntity.won(
  board: BoardEntity.empty().place(0, CellMarkEnum.x).place(1, CellMarkEnum.x).place(2, CellMarkEnum.x),
  winner: CellMarkEnum.x,
  line: [0, 1, 2],
  humanMark: CellMarkEnum.x,
);

final _wonByCpu = GameStateEntity.won(
  board: BoardEntity.empty().place(0, CellMarkEnum.o).place(1, CellMarkEnum.o).place(2, CellMarkEnum.o),
  winner: CellMarkEnum.o,
  line: [0, 1, 2],
  humanMark: CellMarkEnum.x,
);

final _draw = GameStateEntity.draw(
  board: BoardEntity(const [
    CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.x,
    CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.o,
    CellMarkEnum.o, CellMarkEnum.x, CellMarkEnum.x,
  ]),
  humanMark: CellMarkEnum.x,
);

void main() {
  late MockScoreRepository mockRepo;

  setUpAll(registerScoreFallbacks);

  setUp(() {
    mockRepo = MockScoreRepository();
    when(() => mockRepo.load()).thenAnswer((_) async => Success(ScoreEntity.zero()));
    when(() => mockRepo.save(any())).thenAnswer((_) async => Success(null));
    when(() => mockRepo.reset()).thenAnswer((_) async => Success(null));
  });

  makeRecorderContainer() => makeContainer(overrides: [
        gameControllerProvider.overrideWith(() => _FakeGameController()),
        scoreRepositoryProvider.overrideWithValue(mockRepo),
      ]);

  /// Keeps the recorder alive and pre-initialises the score controller so
  /// that async mutations in recorder callbacks do not race with init.
  Future<void> activateRecorder(ProviderContainer container) async {
    container.listen(gameOutcomeRecorderProvider(_config), (_, __) {});
    await container.read(scoreControllerProvider.future);
  }

  /// Convenience: retrieves the fake controller from the container.
  _FakeGameController fakeController(ProviderContainer container) =>
      container.read(gameControllerProvider(_config).notifier) as _FakeGameController;

  test('records a win when the human wins', () async {
    final container = makeRecorderContainer();
    await activateRecorder(container);

    fakeController(container).emit(_wonByHuman);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(scoreControllerProvider).value?.wins, 1);
    expect(container.read(scoreControllerProvider).value?.losses, 0);
    expect(container.read(scoreControllerProvider).value?.draws, 0);
  });

  test('records a loss when the CPU wins', () async {
    final container = makeRecorderContainer();
    await activateRecorder(container);

    fakeController(container).emit(_wonByCpu);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(scoreControllerProvider).value?.losses, 1);
    expect(container.read(scoreControllerProvider).value?.wins, 0);
  });

  test('records a draw on draw', () async {
    final container = makeRecorderContainer();
    await activateRecorder(container);

    fakeController(container).emit(_draw);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(scoreControllerProvider).value?.draws, 1);
  });

  test('does not record again if the previous state was already over', () async {
    final container = makeRecorderContainer();
    await activateRecorder(container);

    fakeController(container).emit(_wonByHuman);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(scoreControllerProvider).value?.wins, 1);

    // Second emit with same won state simulates a spurious rebuild
    fakeController(container).emit(_wonByHuman);
    await Future<void>.delayed(Duration.zero);

    expect(container.read(scoreControllerProvider).value?.wins, 1);
  });
}
