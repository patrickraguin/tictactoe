import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';
import 'package:tictactoe/features/game/domain/usecases/record_outcome.dart';

const _recordOutcome = RecordOutcome();

ScoreEntity _call(ScoreEntity current, GameOutcome outcome) =>
    _recordOutcome(RecordOutcomeParams(current: current, outcome: outcome)).unwrap();

void main() {
  const zero = ScoreEntity(wins: 0, losses: 0, draws: 0);
  const base = ScoreEntity(wins: 1, losses: 2, draws: 3);

  group('RecordOutcome', () {
    test('win increments wins only', () {
      expect(
        _call(zero, GameOutcome.win),
        const ScoreEntity(wins: 1, losses: 0, draws: 0),
      );
    });

    test('loss increments losses only', () {
      expect(
        _call(zero, GameOutcome.loss),
        const ScoreEntity(wins: 0, losses: 1, draws: 0),
      );
    });

    test('draw increments draws only', () {
      expect(
        _call(zero, GameOutcome.draw),
        const ScoreEntity(wins: 0, losses: 0, draws: 1),
      );
    });

    test('does not mutate other fields', () {
      final result = _call(base, GameOutcome.win);
      expect(result.wins, 2);
      expect(result.losses, base.losses);
      expect(result.draws, base.draws);
    });

    test('accumulates correctly over multiple calls', () {
      var score = zero;
      score = _call(score, GameOutcome.win);
      score = _call(score, GameOutcome.win);
      score = _call(score, GameOutcome.loss);
      score = _call(score, GameOutcome.draw);

      expect(score, const ScoreEntity(wins: 2, losses: 1, draws: 1));
    });

    test('always returns Success', () {
      expect(
        _recordOutcome(RecordOutcomeParams(current: zero, outcome: GameOutcome.win)),
        isA<Success<ScoreEntity>>(),
      );
    });
  });
}
