import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/presentation/widgets/board_widget.dart';

void main() {
  testWidgets('BoardWidget winning state golden', (tester) async {
    final board = BoardEntity([
      CellMarkEnum.x, CellMarkEnum.x, CellMarkEnum.x,
      CellMarkEnum.o, CellMarkEnum.o, CellMarkEnum.empty,
      CellMarkEnum.empty, CellMarkEnum.empty, CellMarkEnum.empty,
    ]);
    final state = GameStateEntity.won(
      board: board,
      winner: CellMarkEnum.x,
      line: const [0, 1, 2],
      humanMark: CellMarkEnum.x,
    );

    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: BoardWidget(state: state, onCellTap: (_) {}),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(BoardWidget),
      matchesGoldenFile('goldens/board_win.png'),
    );
  });
}
