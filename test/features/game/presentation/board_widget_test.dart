import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/presentation/widgets/board_widget.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('taps on empty cells invoke onCellTap', (tester) async {
    final taps = <int>[];
    final state = GameStateEntity.inProgress(
      board: BoardEntity.empty(),
      turn: CellMarkEnum.x,
      humanMark: CellMarkEnum.x,
    );

    await tester.pumpWidget(_wrap(
      BoardWidget(state: state, onCellTap: taps.add),
    ));
    await tester.tap(find.byKey(const ValueKey('cell-4')));
    await tester.pumpAndSettle();
    expect(taps, [4]);
  });

  testWidgets('taps on played cells are ignored', (tester) async {
    final taps = <int>[];
    final state = GameStateEntity.inProgress(
      board: BoardEntity.empty().place(0, CellMarkEnum.x),
      turn: CellMarkEnum.x,
      humanMark: CellMarkEnum.x,
    );

    await tester.pumpWidget(_wrap(
      BoardWidget(state: state, onCellTap: taps.add),
    ));
    await tester.tap(find.byKey(const ValueKey('cell-0')));
    await tester.pumpAndSettle();
    expect(taps, isEmpty);
  });

  testWidgets('when game is over, cells do not respond', (tester) async {
    final taps = <int>[];
    final board = BoardEntity.empty()
        .place(0, CellMarkEnum.x)
        .place(1, CellMarkEnum.x)
        .place(2, CellMarkEnum.x);
    final state = GameStateEntity.won(
      board: board,
      winner: CellMarkEnum.x,
      line: const [0, 1, 2],
      humanMark: CellMarkEnum.x,
    );

    await tester.pumpWidget(_wrap(
      BoardWidget(state: state, onCellTap: taps.add),
    ));
    await tester.tap(find.byKey(const ValueKey('cell-4')));
    await tester.pumpAndSettle();
    expect(taps, isEmpty);
  });
}
