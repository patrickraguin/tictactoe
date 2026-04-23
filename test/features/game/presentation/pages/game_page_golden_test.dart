import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/l10n/app_localizations.dart';
import 'package:tictactoe/core/theme/app_theme.dart';
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
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';

// ── Fakes ──────────────────────────────────────────────────────────────────

// GameController figé sur un état prédéfini, sans accès aux providers IA/log.
class _FixedGameController extends GameController {
  _FixedGameController(this._state);
  final GameUiState _state;

  @override
  GameUiState build(GameConfigEntity config) => _state;
}

// ScoreController figé sans accès à la persistance.
class _FakeScoreController extends ScoreController {
  _FakeScoreController(this._score);
  final ScoreEntity _score;

  @override
  Future<ScoreEntity> build() async => _score;
}

// GameOutcomeRecorder désactivé : évite d'enregistrer le score au build initial
// quand le contrôleur est figé sur un état terminé.
class _NoOpGameOutcomeRecorder extends GameOutcomeRecorder {
  @override
  void build(GameConfigEntity config) {}
}

// ── Config et états ────────────────────────────────────────────────────────

const _config = GameConfigEntity(
  humanMark: CellMarkEnum.x,
  firstPlayer: TypePlayerEnum.human,
  difficulty: DifficultyEnum.hard,
);

const _score = ScoreEntity(wins: 3, losses: 1, draws: 2);

final _inProgressUiState = GameUiState(
  game: GameStateEntity.inProgress(
    board: BoardEntity.empty()
        .place(0, CellMarkEnum.x)
        .place(4, CellMarkEnum.o)
        .place(2, CellMarkEnum.x),
    turn: CellMarkEnum.o,
    humanMark: CellMarkEnum.x,
  ),
);

final _cpuThinkingUiState = GameUiState(
  game: GameStateEntity.inProgress(
    board: BoardEntity.empty().place(0, CellMarkEnum.x),
    turn: CellMarkEnum.o,
    humanMark: CellMarkEnum.x,
  ),
  cpuThinking: true,
);

final _humanWonUiState = GameUiState(
  game: GameStateEntity.won(
    board: BoardEntity.empty()
        .place(0, CellMarkEnum.x)
        .place(3, CellMarkEnum.o)
        .place(1, CellMarkEnum.x)
        .place(4, CellMarkEnum.o)
        .place(2, CellMarkEnum.x),
    winner: CellMarkEnum.x,
    line: const [0, 1, 2],
    humanMark: CellMarkEnum.x,
  ),
);

final _drawUiState = GameUiState(
  game: GameStateEntity.draw(
    board: BoardEntity([
      CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.x, //
      CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.o, //
      CellMarkEnum.o, CellMarkEnum.x, CellMarkEnum.x, //
    ]),
    humanMark: CellMarkEnum.x,
  ),
);

// ── Helpers ────────────────────────────────────────────────────────────────

Widget _buildApp(GameUiState uiState, {ThemeData? theme}) => ProviderScope(
      overrides: [
        gameControllerProvider(_config).overrideWith(() => _FixedGameController(uiState)),
        scoreControllerProvider.overrideWith(() => _FakeScoreController(_score)),
        gameOutcomeRecorderProvider(_config).overrideWith(() => _NoOpGameOutcomeRecorder()),
      ],
      child: MaterialApp(
        theme: theme ?? buildLightTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: GamePage(config: _config),
      ),
    );

void _setViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('GamePage — goldens', () {
    testWidgets('game_in_progress_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_buildApp(_inProgressUiState));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/game_in_progress_light.png'),
      );
    });

    testWidgets('game_cpu_thinking_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_buildApp(_cpuThinkingUiState));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/game_cpu_thinking_light.png'),
      );
    });

    testWidgets('game_human_won_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_buildApp(_humanWonUiState));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/game_human_won_light.png'),
      );
    });

    testWidgets('game_human_won_dark', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_buildApp(_humanWonUiState, theme: buildDarkTheme()));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/game_human_won_dark.png'),
      );
    });

    testWidgets('game_draw_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_buildApp(_drawUiState));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/game_draw_light.png'),
      );
    });
  });
}
