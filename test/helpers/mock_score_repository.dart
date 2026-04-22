import 'package:mocktail/mocktail.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';
import 'package:tictactoe/features/game/domain/repositories/score_repository.dart';

class MockScoreRepository extends Mock implements ScoreRepository {}

/// À appeler dans [setUpAll] des suites qui utilisent [MockScoreRepository]
/// avec [any()] sur des arguments de type [ScoreEntity].
void registerScoreFallbacks() {
  registerFallbackValue(ScoreEntity.zero());
  registerFallbackValue(const Success(ScoreEntity(wins: 0, losses: 0, draws: 0)));
}
