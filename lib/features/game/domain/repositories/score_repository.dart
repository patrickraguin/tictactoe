import '../../../../core/result/result.dart';
import '../entities/score_entity.dart';

/// Contrat abstrait pour la persistance du score.
///
/// Découple le domaine de toute technologie de stockage concrète.
/// Les méthodes retournent un [Result] pour modéliser explicitement les échecs
/// de persistence sans lever d'exceptions non contrôlées.
abstract class ScoreRepository {
  Future<Result<ScoreEntity>> load();
  Future<Result<Unit>> save(ScoreEntity score);
  Future<Result<Unit>> reset();
}
