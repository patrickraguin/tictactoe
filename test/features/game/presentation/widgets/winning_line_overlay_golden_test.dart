@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/presentation/widgets/winning_line_overlay.dart';

Widget _wrap(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2F6FEB)),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 300, height: 300, child: child),
        ),
      ),
    );

void main() {
  group('WinningLineOverlay — golden tests', () {
    testWidgets('diagonal top-left to bottom-right', (tester) async {
      await tester.pumpWidget(
        _wrap(WinningLineOverlay(line: const [0, 4, 8], color: const Color(0xFF2F6FEB))),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(WinningLineOverlay),
        matchesGoldenFile('goldens/winning_line_diagonal_tlbr.png'),
      );
    });

    testWidgets('diagonal top-right to bottom-left', (tester) async {
      await tester.pumpWidget(
        _wrap(WinningLineOverlay(line: const [2, 4, 6], color: const Color(0xFF2F6FEB))),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(WinningLineOverlay),
        matchesGoldenFile('goldens/winning_line_diagonal_trbl.png'),
      );
    });

    testWidgets('horizontal top row', (tester) async {
      await tester.pumpWidget(
        _wrap(WinningLineOverlay(line: const [0, 1, 2], color: const Color(0xFF2F6FEB))),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(WinningLineOverlay),
        matchesGoldenFile('goldens/winning_line_horizontal_top.png'),
      );
    });

    testWidgets('vertical left column', (tester) async {
      await tester.pumpWidget(
        _wrap(WinningLineOverlay(line: const [0, 3, 6], color: const Color(0xFF2F6FEB))),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(WinningLineOverlay),
        matchesGoldenFile('goldens/winning_line_vertical_left.png'),
      );
    });
  });
}
