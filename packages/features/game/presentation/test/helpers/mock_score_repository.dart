import 'package:core/result/result.dart';
import 'package:game_domain/entities/score_entity.dart';
import 'package:game_domain/repositories/score_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockScoreRepository extends Mock implements ScoreRepository {}

/// À appeler dans [setUpAll] des suites qui utilisent [MockScoreRepository]
/// avec [any()] sur des arguments de type [ScoreEntity].
void registerScoreFallbacks() {
  registerFallbackValue(ScoreEntity.zero());
  registerFallbackValue(const Success(ScoreEntity()));
}
