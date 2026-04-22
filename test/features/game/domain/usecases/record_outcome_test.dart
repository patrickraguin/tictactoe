import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';
import 'package:tictactoe/features/game/domain/usecases/record_outcome.dart';

void main() {
  const zero = ScoreEntity(wins: 0, losses: 0, draws: 0);
  const base = ScoreEntity(wins: 1, losses: 2, draws: 3);

  group('recordOutcome', () {
    test('win increments wins only', () {
      expect(
        recordOutcome(zero, GameOutcome.win),
        const ScoreEntity(wins: 1, losses: 0, draws: 0),
      );
    });

    test('loss increments losses only', () {
      expect(
        recordOutcome(zero, GameOutcome.loss),
        const ScoreEntity(wins: 0, losses: 1, draws: 0),
      );
    });

    test('draw increments draws only', () {
      expect(
        recordOutcome(zero, GameOutcome.draw),
        const ScoreEntity(wins: 0, losses: 0, draws: 1),
      );
    });

    test('does not mutate other fields', () {
      final result = recordOutcome(base, GameOutcome.win);
      expect(result.wins, 2);
      expect(result.losses, base.losses);
      expect(result.draws, base.draws);
    });

    test('accumulates correctly over multiple calls', () {
      var score = zero;
      score = recordOutcome(score, GameOutcome.win);
      score = recordOutcome(score, GameOutcome.win);
      score = recordOutcome(score, GameOutcome.loss);
      score = recordOutcome(score, GameOutcome.draw);

      expect(score, const ScoreEntity(wins: 2, losses: 1, draws: 1));
    });
  });
}
