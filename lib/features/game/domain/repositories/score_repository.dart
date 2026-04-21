import '../entities/score_entity.dart';

/// Contrat abstrait pour la persistance du score.
///
/// Découple le domaine de toute technologie de stockage concrète.
/// L'implémentation par défaut utilise SharedPreferences via [ScoreRepositoryImpl].
abstract class ScoreRepository {
  Future<ScoreEntity> load();
  Future<void> save(ScoreEntity score);
  Future<void> reset();
}
