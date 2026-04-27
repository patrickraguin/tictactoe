import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tictactoe/core/logging/app_logger.dart';
import 'package:tictactoe/core/logging/logger_provider.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/ai/ai_strategy.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/domain/usecases/play_move.dart';
import 'package:tictactoe/features/game/domain/usecases/resolve_first_player.dart';
import 'package:tictactoe/features/game/presentation/logic/game_ui_state.dart';
import 'package:tictactoe/features/game/presentation/logic/providers/ai_strategy_provider.dart';

part 'game_controller.g.dart';

/// Contrôleur principal de la partie (Riverpod Notifier).
///
/// Gère la machine à états de [GameUiState] : validation des coups humains,
/// déclenchement asynchrone du coup CPU (avec délai d'attente simulé)
/// et réinitialisation via [restart]. La stratégie IA est injectée via
/// [aiStrategyProvider] pour permettre l'override en test.
///
/// [cpuThinking] est un état de présentation (spinner UI) maintenu dans
/// [GameUiState] et non dans [GameStateEntity] (domaine pur).
@riverpod
class GameController extends _$GameController {
  static const _tag = 'GameController';

  late AiStrategy _strategy;
  late AppLogger _log;

  @override
  GameUiState build(GameConfigEntity config) {
    _log = ref.read(loggerProvider);
    _strategy = ref.watch(aiStrategyProvider(config.difficulty));
    final firstMark = const ResolveFirstPlayer()(config).unwrap();
    final game = initialState(
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
      Future<void>.microtask(_playCpuIfNeeded);
    }
    return GameUiState(game: game);
  }

  Future<void> playHumanMove(int index) async {
    final current = state.game;
    if (current is! InProgressEntity) return;
    if (current.turn != current.humanMark) return;

    _log.info('Human move: index=$index', tag: _tag);
    final result = const PlayMove()(
      PlayMoveParams(state: current, index: index, mark: current.humanMark),
    );
    switch (result) {
      case Success(:final value):
        state = state.copyWith(game: value);
        await _playCpuIfNeeded();
      case Error(:final failure):
        _log.warning('Invalid human move at index=$index: ${failure.message}', tag: _tag);
    }
  }

  void restart() {
    _log.info('Game restarted', tag: _tag);
    ref.invalidateSelf();
  }

  Future<void> _playCpuIfNeeded() async {
    final current = state.game;
    if (current is! InProgressEntity) return;
    if (current.turn == current.humanMark) return;

    state = state.copyWith(cpuThinking: true);
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!ref.mounted) return;

    final snapshot = state.game;
    if (snapshot is! InProgressEntity) return;

    final cpuMark = snapshot.humanMark.opponent;
    final move = _strategy.nextMove(snapshot.board, cpuMark);
    _log.info('CPU move: index=$move', tag: _tag);

    final result = const PlayMove()(
      PlayMoveParams(state: snapshot, index: move, mark: cpuMark),
    );
    switch (result) {
      case Success(:final value):
        if (value is WonEntity) _log.info('Game over — winner: ${value.winner.name}', tag: _tag);
        if (value is DrawEntity) _log.info('Game over — draw', tag: _tag);
        state = GameUiState(game: value);
      case Error(:final failure):
        _log.warning('Invalid CPU move at index=$move: ${failure.message}', tag: _tag);
        state = state.copyWith(cpuThinking: false);
    }
  }
}
