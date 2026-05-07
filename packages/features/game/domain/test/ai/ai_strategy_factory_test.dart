import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/ai/ai_strategy.dart';
import 'package:game_domain/ai/heuristic_strategy.dart';
import 'package:game_domain/ai/minimax_strategy.dart';
import 'package:game_domain/ai/random_strategy.dart';
import 'package:game_domain/entities/difficulty_enum.dart';

void main() {
  group('AiStrategy.fromDifficulty', () {
    test('easy returns RandomStrategy', () {
      expect(AiStrategy.fromDifficulty(DifficultyEnum.easy), isA<RandomStrategy>());
    });

    test('medium returns HeuristicStrategy', () {
      expect(AiStrategy.fromDifficulty(DifficultyEnum.medium), isA<HeuristicStrategy>());
    });

    test('hard returns MinimaxStrategy', () {
      expect(AiStrategy.fromDifficulty(DifficultyEnum.hard), isA<MinimaxStrategy>());
    });

    test('each difficulty returns a distinct type', () {
      final strategies = DifficultyEnum.values.map(AiStrategy.fromDifficulty).toList();
      final types = strategies.map((s) => s.runtimeType).toSet();
      expect(types.length, DifficultyEnum.values.length);
    });
  });
}
