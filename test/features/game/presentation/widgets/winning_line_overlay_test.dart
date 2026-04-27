import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/presentation/widgets/winning_line_overlay.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: SizedBox(width: 300, height: 300, child: child),
      ),
    );

void main() {
  group('WinningLineOverlay', () {
    testWidgets('renders without error for a valid diagonal line', (tester) async {
      await tester.pumpWidget(
        _wrap(const WinningLineOverlay(line: [0, 4, 8], color: Colors.blue)),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error for a horizontal line', (tester) async {
      await tester.pumpWidget(
        _wrap(const WinningLineOverlay(line: [0, 1, 2], color: Colors.red)),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without error when line has fewer than 3 elements',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const WinningLineOverlay(line: [0], color: Colors.green)),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('animation progresses to completion after pumpAndSettle',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const WinningLineOverlay(line: [2, 4, 6], color: Colors.purple)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('does not intercept pointer events (IgnorePointer)', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () => tapped = true,
                  child: const SizedBox(
                    width: 300,
                    height: 300,
                    child: ColoredBox(key: Key('tap-target'), color: Colors.red),
                  ),
                ),
                const SizedBox(
                  width: 300,
                  height: 300,
                  child: WinningLineOverlay(
                    line: [0, 1, 2],
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(const Key('tap-target')));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('is excluded from semantics tree', (tester) async {
      await tester.pumpWidget(
        _wrap(const WinningLineOverlay(line: [0, 1, 2], color: Colors.blue)),
      );
      await tester.pumpAndSettle();

      // ExcludeSemantics is the root of WinningLineOverlay — the overlay is
      // purely visual and must not contribute to the a11y tree.
      expect(
        find.descendant(
          of: find.byType(WinningLineOverlay),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
    });
  });
}
