import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/entities/board_entity.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';
import 'package:game_domain/entities/game_state_entity.dart';
import 'package:game_presentation/widgets/game_status_banner.dart';

Widget _wrap(Widget child) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

const CellMarkEnum _humanMark = CellMarkEnum.x;

final _inProgress = GameStateEntity.inProgress(
  board: BoardEntity.empty(),
  turn: _humanMark,
  humanMark: _humanMark,
);

final _wonByHuman = GameStateEntity.won(
  board: BoardEntity.empty().place(0, CellMarkEnum.x).place(1, CellMarkEnum.x).place(2, CellMarkEnum.x),
  winner: CellMarkEnum.x,
  line: [0, 1, 2],
  humanMark: _humanMark,
);

final _draw = GameStateEntity.draw(
  board: BoardEntity(const [
    CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.x,
    CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.o,
    CellMarkEnum.o, CellMarkEnum.x, CellMarkEnum.x,
  ]),
  humanMark: _humanMark,
);

void main() {
  group('GameStatusBanner', () {
    testWidgets('shows "Your turn" when human plays next', (tester) async {
      await tester.pumpWidget(_wrap(GameStatusBanner(state: _inProgress, cpuThinking: false)));
      await tester.pumpAndSettle();

      // "Your turn" in English locale
      expect(find.text('Your turn'), findsOneWidget);
    });

    testWidgets('shows win message when human wins', (tester) async {
      await tester.pumpWidget(_wrap(GameStatusBanner(state: _wonByHuman, cpuThinking: false)));
      await tester.pumpAndSettle();

      expect(find.text('You win!'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('shows draw message on draw', (tester) async {
      await tester.pumpWidget(_wrap(GameStatusBanner(state: _draw, cpuThinking: false)));
      await tester.pumpAndSettle();

      expect(find.text('Draw.'), findsOneWidget);
      expect(find.byIcon(Icons.handshake), findsOneWidget);
    });
  });
}
