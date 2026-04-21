import '../entities/difficulty_enum.dart';
import 'ai_strategy.dart';
import 'heuristic_strategy.dart';
import 'minimax_strategy.dart';
import 'random_strategy.dart';

AiStrategy aiStrategyFor(DifficultyEnum difficulty) => switch (difficulty) {
      DifficultyEnum.easy => RandomStrategy(),
      DifficultyEnum.medium => HeuristicStrategy(),
      DifficultyEnum.hard => const MinimaxStrategy(),
    };
