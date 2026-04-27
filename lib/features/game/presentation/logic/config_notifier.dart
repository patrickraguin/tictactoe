import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/difficulty_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/type_player_enum.dart';

/// Provider auto-dispose gérant la configuration éphémère d'une partie.
///
/// Chaque ouverture de [ConfigPage] repart des valeurs par défaut (X / Humain /
/// Difficile) car le provider est auto-dispose : il est détruit dès que la page
/// quitte l'arbre et recréé à la prochaine ouverture.
///
/// Note : écrit manuellement (sans codegen) car le générateur Riverpod 3 ne
/// peut pas encore résoudre les types Freezed 3 abstraits comme état de Notifier.
final configNotifierProvider =
    NotifierProvider.autoDispose<ConfigNotifier, GameConfigEntity>(
  ConfigNotifier.new,
);

/// Notifier gérant les sélections de la page de configuration.
class ConfigNotifier extends Notifier<GameConfigEntity> {
  @override
  GameConfigEntity build() => const GameConfigEntity(
        humanMark: CellMarkEnum.x,
        firstPlayer: TypePlayerEnum.human,
        difficulty: DifficultyEnum.hard,
      );

  void setMark(CellMarkEnum mark) => state = state.copyWith(humanMark: mark);

  void setFirstPlayer(TypePlayerEnum first) =>
      state = state.copyWith(firstPlayer: first);

  void setDifficulty(DifficultyEnum difficulty) =>
      state = state.copyWith(difficulty: difficulty);
}
