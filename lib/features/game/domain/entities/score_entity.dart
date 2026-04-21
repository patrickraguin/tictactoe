import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_entity.freezed.dart';

/// Agrégat immutable du score cumulé de la session.
///
/// Contient le nombre de victoires, défaites et matchs nuls.
/// [ScoreEntity.zero] initialise le score à zéro pour une nouvelle session.
@freezed
abstract class ScoreEntity with _$ScoreEntity {
  const factory ScoreEntity({
    @Default(0) int wins,
    @Default(0) int losses,
    @Default(0) int draws,
  }) = _ScoreEntity;

  factory ScoreEntity.zero() => const ScoreEntity();
}
