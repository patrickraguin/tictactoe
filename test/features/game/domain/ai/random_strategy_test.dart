import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/ai/random_strategy.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';

void main() {
  test('RandomStrategy always returns an empty cell', () {
    final rng = Random(42);
    final strategy = RandomStrategy(random: rng);
    for (var i = 0; i < 200; i++) {
      var board = BoardEntity.empty();
      while (board.availableMoves.isNotEmpty && board.winner == null) {
        final move = strategy.nextMove(board, CellMarkEnum.x);
        expect(board.availableMoves, contains(move));
        board = board.place(move, CellMarkEnum.x);
        if (board.availableMoves.isEmpty) break;
        final move2 = strategy.nextMove(board, CellMarkEnum.o);
        board = board.place(move2, CellMarkEnum.o);
      }
    }
  });
}
