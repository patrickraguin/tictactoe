import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';

BoardEntity _b(String rows) {
  final flat = rows.replaceAll(RegExp(r'\s+'), '');
  expect(flat.length, 9);
  final cells = flat.split('').map((c) {
    switch (c) {
      case 'X':
        return CellMarkEnum.x;
      case 'O':
        return CellMarkEnum.o;
      default:
        return CellMarkEnum.empty;
    }
  }).toList();
  return BoardEntity(cells);
}

void main() {
  group('BoardEntity', () {
    test('empty board has 9 available moves', () {
      final board = BoardEntity.empty();
      expect(board.availableMoves, hasLength(9));
      expect(board.isFull, isFalse);
      expect(board.winner, isNull);
    });

    test('place returns a new board, leaves original untouched', () {
      final board = BoardEntity.empty();
      final next = board.place(0, CellMarkEnum.x);
      expect(board.cellAt(0), CellMarkEnum.empty);
      expect(next.cellAt(0), CellMarkEnum.x);
    });

    test('detects row win', () {
      final board = _b('XXX ... ...');
      expect(board.winner, CellMarkEnum.x);
      expect(board.winningLineFor(CellMarkEnum.x), [0, 1, 2]);
    });

    test('detects column and diagonal wins', () {
      expect(_b('O.. O.. O..').winner, CellMarkEnum.o);
      expect(_b('X.. .X. ..X').winningLineFor(CellMarkEnum.x), [0, 4, 8]);
      expect(_b('..X .X. X..').winningLineFor(CellMarkEnum.x), [2, 4, 6]);
    });

    test('isFull without winner means draw-able state', () {
      final board = _b('XOX XOO OXO');
      expect(board.isFull, isTrue);
      expect(board.winner, isNull);
    });

    test('equality based on cell contents', () {
      expect(_b('X.. ... ...'), equals(_b('X.. ... ...')));
      expect(_b('X.. ... ...'), isNot(_b('.X. ... ...')));
    });
  });
}
