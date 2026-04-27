import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';

/// Contrat abstrait pour la persistance du score.
///
/// Découple le domaine de toute technologie de stockage concrète.
/// Les méthodes retournent un [Result] pour modéliser explicitement les échecs
/// de persistence sans lever d'exceptions non contrôlées.
abstract class ScoreRepository {
  Future<Result<ScoreEntity>> load();
  Future<Result<void>> save(ScoreEntity score);
  Future<Result<void>> reset();
}
