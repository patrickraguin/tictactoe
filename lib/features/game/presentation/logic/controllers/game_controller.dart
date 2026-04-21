import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/logging/app_logger.dart';
import '../../../../../core/logging/logger_provider.dart';
import '../../../domain/ai/ai_strategy.dart';
import '../../../domain/ai/ai_strategy_factory.dart';
import '../../../domain/entities/board_entity.dart';
import '../../../domain/entities/game_config_entity.dart';
import '../../../domain/entities/game_state_entity.dart';
import '../../../domain/usecases/play_move.dart';
import '../../../domain/usecases/resolve_first_player.dart';

part 'game_controller.g.dart';

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameStateEntity] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est instanciée une
/// seule fois à la construction et réutilisée pour toute la durée de vie.
@riverpod
class GameController extends _$GameController {
  static const _tag = 'GameController';

  /// Delay before the CPU plays so the move feels intentional.
  static const _cpuThinkingDelay = Duration(milliseconds: 450);

  /// Cached strategy for the lifetime of this controller instance.
  late AiStrategy _strategy;
  late AppLogger _log;

  @override
  GameStateEntity build(GameConfigEntity config) {
    _log = ref.read(loggerProvider);
    _strategy = aiStrategyFor(config.difficulty);
    final firstMark = resolveFirstPlayer(config);
    final initial = initialState(
      board: BoardEntity.empty(),
      firstToPlay: firstMark,
      humanMark: config.humanMark,
    );
    _log.info(
      'Game started — humanMark: ${config.humanMark.name}, '
      'firstToPlay: ${firstMark.name}, difficulty: ${config.difficulty.name}',
      tag: _tag,
    );
    if (firstMark != config.humanMark) {
      _log.info('CPU goes first, scheduling opening move', tag: _tag);
      // Schedule CPU's opening move after the widget tree is ready.
      Future<void>.microtask(_playCpuIfNeeded);
    }
    return initial;
  }

  Future<void> playHumanMove(int index) async {
    final current = state;
    if (current is! InProgressEntity) return;
    if (current.turn != current.humanMark) return;

    _log.info('Human move: index=$index', tag: _tag);
    state = playMove(state: current, index: index, mark: current.humanMark);
    await _playCpuIfNeeded();
  }

  void restart() {
    _log.info('Game restarted', tag: _tag);
    ref.invalidateSelf();
  }

  Future<void> _playCpuIfNeeded() async {
    final current = state;
    if (current is! InProgressEntity) return;
    if (current.turn == current.humanMark) return;

    state = current.copyWith(cpuThinking: true);
    await Future<void>.delayed(_cpuThinkingDelay);

    // Guard against disposal during the delay (e.g. user navigates away).
    if (!ref.mounted) return;

    final snapshot = state;
    if (snapshot is! InProgressEntity) return;

    final cpuMark = snapshot.humanMark.opponent;
    final move = _strategy.nextMove(snapshot.board, cpuMark);
    _log.info('CPU move: index=$move', tag: _tag);

    final next = playMove(
      state: snapshot.copyWith(cpuThinking: false),
      index: move,
      mark: cpuMark,
    );

    if (next is WonEntity) {
      _log.info('Game over — winner: ${next.winner.name}', tag: _tag);
    } else if (next is DrawEntity) {
      _log.info('Game over — draw', tag: _tag);
    }

    state = next;
  }
}
