import 'dart:math';

import '../../../../core/domain/use_case.dart';
import '../../../../core/result/result.dart';
import '../entities/cell_mark_enum.dart';
import '../entities/game_config_entity.dart';
import '../entities/type_player_enum.dart';

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
