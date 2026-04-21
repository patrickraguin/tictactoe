import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/logging/logger_provider.dart';
import '../../../domain/entities/game_config_entity.dart';
import '../../../domain/entities/game_state_entity.dart';
import '../controllers/game_controller.dart';
import '../controllers/score_controller.dart';

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
    ref.listen<GameStateEntity>(
      gameControllerProvider(config),
      (previous, next) async {
        if (previous != null && previous.isOver) return;
        final controller = ref.read(scoreControllerProvider.notifier);
        switch (next) {
          case WonEntity(:final winner, :final humanMark):
            if (winner == humanMark) {
              log.info('Outcome recorded: win', tag: _tag);
              await controller.recordWin();
            } else {
              log.info('Outcome recorded: loss', tag: _tag);
              await controller.recordLoss();
            }
          case DrawEntity():
            log.info('Outcome recorded: draw', tag: _tag);
            await controller.recordDraw();
          case InProgressEntity():
            break;
        }
      },
    );
  }
}
