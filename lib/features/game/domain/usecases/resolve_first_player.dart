import 'dart:math';

import '../entities/cell_mark_enum.dart';
import '../entities/game_config_entity.dart';
import '../entities/type_player_enum.dart';

/// Détermine le symbole ([CellMarkEnum]) qui joue en premier selon la [GameConfigEntity].
///
/// Fonction pure — [random] est injectable pour rendre les tests déterministes.
CellMarkEnum resolveFirstPlayer(GameConfigEntity config, {Random? random}) {
  final humanMark = config.humanMark;
  final cpuMark = humanMark.opponent;
  return switch (config.firstPlayer) {
    TypePlayerEnum.human => humanMark,
    TypePlayerEnum.cpu => cpuMark,
    TypePlayerEnum.random => (random ?? Random()).nextBool() ? humanMark : cpuMark,
  };
}
