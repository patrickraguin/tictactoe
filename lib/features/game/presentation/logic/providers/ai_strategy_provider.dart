import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/ai/ai_strategy.dart';
import '../../../domain/ai/ai_strategy_factory.dart';
import '../../../domain/entities/difficulty_enum.dart';

/// Fournit l'[AiStrategy] correspondant au niveau de difficulté.
///
/// Provider non code-gen intentionnel : simple délégation sans état,
/// `overrideWith` disponible pour l'injection de fakes en test.
final aiStrategyProvider =
    Provider.autoDispose.family<AiStrategy, DifficultyEnum>(
  (ref, difficulty) => aiStrategyFor(difficulty),
);
