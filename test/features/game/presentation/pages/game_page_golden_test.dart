import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe/core/l10n/app_localizations.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/difficulty_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';
import 'package:tictactoe/features/game/domain/entities/type_player_enum.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/game_controller.dart';
import 'package:tictactoe/features/game/presentation/logic/game_ui_state.dart';
import 'package:tictactoe/features/game/presentation/logic/providers/score_providers.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';

import '../../../../helpers/mock_score_repository.dart';
import '../../../../helpers/provider_helpers.dart';

const _config = GameConfigEntity(
  humanMark: CellMarkEnum.x,
  firstPlayer: TypePlayerEnum.human,
  difficulty: DifficultyEnum.hard,
);

/// Fake contrôleur retournant un état fixe, sans IA ni timer.
class _FakeGameController extends GameController {
  _FakeGameController(this._fixedState);
  final GameStateEntity _fixedState;

  @override
  GameUiState build(GameConfigEntity config) => GameUiState(game: _fixedState);
}

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(useMaterial3: true),
        home: const GamePage(config: _config),
      ),
    );

ProviderContainer _makeContainer(GameStateEntity state) {
  final mockRepo = MockScoreRepository();
  when(() => mockRepo.load())
      .thenAnswer((_) async => const Success(ScoreEntity(wins: 3, draws: 1, losses: 2)));
  when(() => mockRepo.save(any())).thenAnswer((_) async => Success(Unit.instance));
  when(() => mockRepo.reset()).thenAnswer((_) async => Success(Unit.instance));

  return makeContainer(overrides: [
    gameControllerProvider.overrideWith(() => _FakeGameController(state)),
    scoreRepositoryProvider.overrideWithValue(mockRepo),
  ]);
}

void main() {
  setUpAll(registerScoreFallbacks);

  final _inProgress = GameStateEntity.inProgress(
    board: BoardEntity.empty(),
    turn: CellMarkEnum.x,
    humanMark: CellMarkEnum.x,
  );

  final _board = BoardEntity.empty()
      .place(0, CellMarkEnum.x)
      .place(1, CellMarkEnum.x)
      .place(2, CellMarkEnum.x)
      .place(3, CellMarkEnum.o)
      .place(4, CellMarkEnum.o);

  final _won = GameStateEntity.won(
    board: _board,
    winner: CellMarkEnum.x,
    line: const [0, 1, 2],
    humanMark: CellMarkEnum.x,
  );

  testWidgets('GamePage in-progress golden', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = _makeContainer(_inProgress);
    await tester.pumpWidget(_buildApp(container));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(GamePage),
      matchesGoldenFile('goldens/game_page_in_progress.png'),
    );
  });

  testWidgets('GamePage won golden', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final container = _makeContainer(_won);
    await tester.pumpWidget(_buildApp(container));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(GamePage),
      matchesGoldenFile('goldens/game_page_won.png'),
    );
  });
}
