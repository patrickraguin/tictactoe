import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/ai/heuristic_strategy.dart';
import 'package:game_domain/entities/board_entity.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';

BoardEntity _b(String s) {
  final flat = s.replaceAll(RegExp(r'\s+'), '');
  return BoardEntity(flat.split('').map((c) => switch (c) {
        'X' => CellMarkEnum.x,
        'O' => CellMarkEnum.o,
        _ => CellMarkEnum.empty,
      }).toList());
}

void main() {
  final strategy = HeuristicStrategy(random: Random(0));

  test('plays winning move when available', () {
    //  X X .
    //  . O .
    //  . . O
    final board = _b('XX. .O. ..O');
    expect(strategy.nextMove(board, CellMarkEnum.x), 2);
  });

  test('blocks opponent winning move', () {
    //  O O .
    //  . X .
    //  . . .
    final board = _b('OO. .X. ...');
    expect(strategy.nextMove(board, CellMarkEnum.x), 2);
  });

  test('takes center when available and no decisive move', () {
    final board = _b('X.. ... ...');
    expect(strategy.nextMove(board, CellMarkEnum.o), 4);
  });

  test('takes a corner when center taken', () {
    //  . . .
    //  . X .
    //  . . .
    final board = _b('... .X. ...');
    expect([0, 2, 6, 8], contains(strategy.nextMove(board, CellMarkEnum.o)));
  });
}
