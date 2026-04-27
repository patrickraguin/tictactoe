import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tictactoe/core/logging/logger_provider.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/game_controller.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/score_controller.dart';
import 'package:tictactoe/features/game/presentation/logic/game_ui_state.dart';

part 'game_outcome_recorder.g.dart';

/// Observateur des fins de partie chargé de persister le score.
///
/// Écoute [GameController] via [ref.listen] et délègue l'enregistrement
/// à [ScoreController] dès qu'une transition vers [WonEntity] ou [DrawEntity] est détectée.
/// Séparé de [GameController] pour respecter le principe de responsabilité unique.
@riverpod
class GameOutcomeRecorder extends _$GameOutcomeRecorder {
  static const _tag = 'GameOutcomeRecorder';

  @override
  void build(GameConfigEntity config) {
    final log = ref.read(loggerProvider);
    ref.listen<GameUiState>(
      gameControllerProvider(config),
      (previous, next) async {
        // Record only on the exact transition from in-progress to game-over.
        final justEnded =
            (previous == null || !previous.game.isOver) && next.game.isOver;
        if (!justEnded) return;

        final scoreController = ref.read(scoreControllerProvider.notifier);
        switch (next.game) {
          case WonEntity(:final winner, :final humanMark):
            if (winner == humanMark) {
              log.info('Outcome recorded: win', tag: _tag);
              await scoreController.recordWin();
            } else {
              log.info('Outcome recorded: loss', tag: _tag);
              await scoreController.recordLoss();
            }
          case DrawEntity():
            log.info('Outcome recorded: draw', tag: _tag);
            await scoreController.recordDraw();
          case InProgressEntity():
            break; // unreachable: justEnded guard ensures next.game.isOver
        }
      },
    );
  }
}
