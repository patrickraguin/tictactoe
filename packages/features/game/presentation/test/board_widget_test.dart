import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/entities/board_entity.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';
import 'package:game_domain/entities/game_state_entity.dart';
import 'package:game_presentation/widgets/board_widget.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('taps on empty cells invoke onCellTap', (tester) async {
    final taps = <int>[];
    final state = GameStateEntity.inProgress(
      board: BoardEntity.empty(),
      turn: CellMarkEnum.x,
      humanMark: CellMarkEnum.x,
    );

    await tester.pumpWidget(_wrap(
      BoardWidget(state: state, cpuThinking: false, onCellTap: taps.add),
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
      BoardWidget(state: state, cpuThinking: false, onCellTap: taps.add),
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
      BoardWidget(state: state, cpuThinking: false, onCellTap: taps.add),
    ));
    await tester.tap(find.byKey(const ValueKey('cell-4')));
    await tester.pumpAndSettle();
    expect(taps, isEmpty);
  });

  group('Semantics', () {
    testWidgets('empty interactive cell exposes correct semantic label',
        (tester) async {
      final handle = tester.ensureSemantics();
      final state = GameStateEntity.inProgress(
        board: BoardEntity.empty(),
        turn: CellMarkEnum.x,
        humanMark: CellMarkEnum.x,
      );

      await tester.pumpWidget(_wrap(
        BoardWidget(state: state, cpuThinking: false, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();

      // Cell 0 = row 1, col 1 (English locale).
      final node = tester.getSemantics(find.byKey(const ValueKey('cell-0')));
      expect(node.label, contains('1')); // row and col both appear
      expect(node.flagsCollection.isButton, isTrue);
      handle.dispose();
    });

    testWidgets('played cell exposes mark in semantic label', (tester) async {
      final handle = tester.ensureSemantics();
      final state = GameStateEntity.inProgress(
        board: BoardEntity.empty().place(0, CellMarkEnum.x),
        turn: CellMarkEnum.o,
        humanMark: CellMarkEnum.x,
      );

      await tester.pumpWidget(_wrap(
        BoardWidget(state: state, cpuThinking: false, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();

      final node = tester.getSemantics(find.byKey(const ValueKey('cell-0')));
      expect(node.label, contains('X'));
      handle.dispose();
    });

    testWidgets('game-over cell is not a button in semantics', (tester) async {
      final handle = tester.ensureSemantics();
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
        BoardWidget(state: state, cpuThinking: false, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();

      // Cell 4 is empty but game is over — not a button.
      final node = tester.getSemantics(find.byKey(const ValueKey('cell-4')));
      expect(node.flagsCollection.isButton, isFalse);
      handle.dispose();
    });
  });
}
