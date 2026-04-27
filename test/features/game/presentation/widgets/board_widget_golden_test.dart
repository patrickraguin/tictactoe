@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/l10n/app_localizations.dart';
import 'package:tictactoe/core/theme/app_theme.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/presentation/widgets/board_widget.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? buildLightTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(child: child),
        ),
      ),
    );

void _setViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 390);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

// ── États ──────────────────────────────────────────────────────────────────

final _emptyInProgress = GameStateEntity.inProgress(
  board: BoardEntity.empty(),
  turn: CellMarkEnum.x,
  humanMark: CellMarkEnum.x,
);

final _midGameState = GameStateEntity.inProgress(
  board: BoardEntity.empty()
      .place(0, CellMarkEnum.x)
      .place(4, CellMarkEnum.o)
      .place(2, CellMarkEnum.x)
      .place(3, CellMarkEnum.o),
  turn: CellMarkEnum.x,
  humanMark: CellMarkEnum.x,
);

final _wonState = GameStateEntity.won(
  board: BoardEntity.empty()
      .place(0, CellMarkEnum.x)
      .place(3, CellMarkEnum.o)
      .place(1, CellMarkEnum.x)
      .place(4, CellMarkEnum.o)
      .place(2, CellMarkEnum.x),
  winner: CellMarkEnum.x,
  line: const [0, 1, 2],
  humanMark: CellMarkEnum.x,
);

final _drawState = GameStateEntity.draw(
  board: BoardEntity(const [
    CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.x, //
    CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.o, //
    CellMarkEnum.o, CellMarkEnum.x, CellMarkEnum.x, //
  ]),
  humanMark: CellMarkEnum.x,
);

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('BoardWidget — goldens', () {
    testWidgets('board_empty_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_wrap(
        BoardWidget(state: _emptyInProgress, cpuThinking: false, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(BoardWidget),
        matchesGoldenFile('goldens/board_empty_light.png'),
      );
    });

    testWidgets('board_mid_game_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_wrap(
        BoardWidget(state: _midGameState, cpuThinking: false, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(BoardWidget),
        matchesGoldenFile('goldens/board_mid_game_light.png'),
      );
    });

    testWidgets('board_cpu_thinking_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_wrap(
        BoardWidget(state: _midGameState, cpuThinking: true, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(BoardWidget),
        matchesGoldenFile('goldens/board_cpu_thinking_light.png'),
      );
    });

    testWidgets('board_won_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_wrap(
        BoardWidget(state: _wonState, cpuThinking: false, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(BoardWidget),
        matchesGoldenFile('goldens/board_won_light.png'),
      );
    });

    testWidgets('board_draw_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_wrap(
        BoardWidget(state: _drawState, cpuThinking: false, onCellTap: (_) {}),
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(BoardWidget),
        matchesGoldenFile('goldens/board_draw_light.png'),
      );
    });

    testWidgets('board_empty_dark', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_wrap(
        BoardWidget(state: _emptyInProgress, cpuThinking: false, onCellTap: (_) {}),
        theme: buildDarkTheme(),
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(BoardWidget),
        matchesGoldenFile('goldens/board_empty_dark.png'),
      );
    });

    testWidgets('board_won_dark', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_wrap(
        BoardWidget(state: _wonState, cpuThinking: false, onCellTap: (_) {}),
        theme: buildDarkTheme(),
      ));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(BoardWidget),
        matchesGoldenFile('goldens/board_won_dark.png'),
      );
    });
  });
}
