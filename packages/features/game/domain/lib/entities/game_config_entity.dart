import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:game_domain/entities/cell_mark_enum.dart';
import 'package:game_domain/entities/difficulty_enum.dart';
import 'package:game_domain/entities/type_player_enum.dart';

part 'game_config_entity.freezed.dart';

/// Configuration d'une partie avant son démarrage.
///
/// Regroupe le symbole choisi par l'humain ([humanMark]),
/// Qui commence ([firstPlayer])
/// Le niveau de difficulté de l'IA ([difficulty]).
@freezed
abstract class GameConfigEntity with _$GameConfigEntity {
  const factory GameConfigEntity({
    required CellMarkEnum humanMark,
    required TypePlayerEnum firstPlayer,
    required DifficultyEnum difficulty,
  }) = _GameConfigEntity;
}
