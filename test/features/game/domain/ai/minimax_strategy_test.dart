import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/ai/ai_strategy.dart';
import 'package:tictactoe/features/game/domain/ai/minimax_strategy.dart';
import 'package:tictactoe/features/game/domain/ai/random_strategy.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';

BoardEntity _b(String s) {
  final flat = s.replaceAll(RegExp(r'\s+'), '');
  return BoardEntity(flat.split('').map((c) => switch (c) {
        'X' => CellMarkEnum.x,
        'O' => CellMarkEnum.o,
        _ => CellMarkEnum.empty,
      }).toList());
}

void main() {
  const minimax = MinimaxStrategy();

  test('plays winning move immediately', () {
    final board = _b('XX. .O. ..O');
    expect(minimax.nextMove(board, CellMarkEnum.x), 2);
  });

  test('blocks opponent winning move', () {
    final board = _b('OO. .X. ...');
    expect(minimax.nextMove(board, CellMarkEnum.x), 2);
  });

  test('opening move is a corner or center', () {
    // All first moves that do not immediately lose are equivalent under
    // minimax (every line is a forced draw against perfect play). We only
    // assert the AI doesn't play a side, which is strictly dominated.
    final move = minimax.nextMove(BoardEntity.empty(), CellMarkEnum.x);
    expect([0, 2, 4, 6, 8], contains(move));
  });

  test('never loses against random over 50 games', () {
    final random = Random(2026);
    final dumb = RandomStrategy(random: random);
    for (var i = 0; i < 50; i++) {
      final outcome = _play(minimax, dumb);
      expect(outcome != CellMarkEnum.o, isTrue,
          reason: 'Minimax (X) lost game #$i');
    }
  });

  test('never loses against itself starting second', () {
    final outcome = _play(const MinimaxStrategy(), const MinimaxStrategy());
    // Two perfect players → draw.
    expect(outcome, isNull);
  });
}

CellMarkEnum? _play(AiStrategy xStrategy, AiStrategy oStrategy) {
  var board = BoardEntity.empty();
  var turn = CellMarkEnum.x;
  while (board.winner == null && !board.isFull) {
    final strat = turn == CellMarkEnum.x ? xStrategy : oStrategy;
    final move = strat.nextMove(board, turn);
    board = board.place(move, turn);
    turn = turn.opponent;
  }
  return board.winner;
}
