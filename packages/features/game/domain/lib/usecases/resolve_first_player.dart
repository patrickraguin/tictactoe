import 'dart:math';

import 'package:core/domain/use_case.dart';
import 'package:core/result/result.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';
import 'package:game_domain/entities/game_config_entity.dart';
import 'package:game_domain/entities/type_player_enum.dart';

/// Détermine le symbole ([CellMarkEnum]) qui joue en premier selon la [GameConfigEntity].
///
/// [random] est injectable pour rendre les tests déterministes.
/// Toujours un [Success] — aucun chemin d'erreur possible.
class ResolveFirstPlayer implements UseCase<GameConfigEntity, CellMarkEnum> {
  const ResolveFirstPlayer({this.random});

  final Random? random;

  @override
  Result<CellMarkEnum> call(GameConfigEntity params) {
    final humanMark = params.humanMark;
    final cpuMark = humanMark.opponent;
    return Success(switch (params.firstPlayer) {
      TypePlayerEnum.human => humanMark,
      TypePlayerEnum.cpu => cpuMark,
      TypePlayerEnum.random => (random ?? Random()).nextBool() ? humanMark : cpuMark,
    });
  }
}
