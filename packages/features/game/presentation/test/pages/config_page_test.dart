import 'package:auto_route/auto_route.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';
import 'package:game_domain/entities/difficulty_enum.dart';
import 'package:game_domain/entities/game_config_entity.dart';
import 'package:game_domain/entities/type_player_enum.dart';
import 'package:game_presentation/game_route.dart';
import 'package:game_presentation/pages/config_page.dart';

/// Faux routeur capturant les appels à [push] sans dépendance Riverpod ni
/// initialisation d'une vraie navigation.
class _FakeStackRouter extends Fake implements StackRouter {
  final List<PageRouteInfo<dynamic>> pushed = [];

  @override
  Future<T?> push<T extends Object?>(
    PageRouteInfo<dynamic> route, {
    OnNavigationFailure? onFailure,
  }) {
    pushed.add(route);
    return Future<T?>.value();
  }
}

Widget _buildApp(_FakeStackRouter router) => ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StackRouterScope(
          controller: router,
          stateHash: 0,
          child: const ConfigPage(),
        ),
      ),
    );

void main() {
  group('ConfigPage', () {
    late _FakeStackRouter router;

    setUp(() => router = _FakeStackRouter());

    testWidgets('default selections are X, Human, Hard', (tester) async {
      await tester.pumpWidget(_buildApp(router));
      await tester.pumpAndSettle();

      final markBtn = tester.widget<SegmentedButton<CellMarkEnum>>(
        find.byType(SegmentedButton<CellMarkEnum>),
      );
      expect(markBtn.selected, {CellMarkEnum.x});

      final firstBtn = tester.widget<SegmentedButton<TypePlayerEnum>>(
        find.byType(SegmentedButton<TypePlayerEnum>),
      );
      expect(firstBtn.selected, {TypePlayerEnum.human});

      final diffBtn = tester.widget<SegmentedButton<DifficultyEnum>>(
        find.byType(SegmentedButton<DifficultyEnum>),
      );
      expect(diffBtn.selected, {DifficultyEnum.hard});
    });

    testWidgets('tapping O changes mark selection', (tester) async {
      await tester.pumpWidget(_buildApp(router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('O'));
      await tester.pumpAndSettle();

      final markBtn = tester.widget<SegmentedButton<CellMarkEnum>>(
        find.byType(SegmentedButton<CellMarkEnum>),
      );
      expect(markBtn.selected, {CellMarkEnum.o});
    });

    testWidgets('tapping CPU changes first-player selection', (tester) async {
      await tester.pumpWidget(_buildApp(router));
      await tester.pumpAndSettle();

      // English locale — label key configFirstPlayerCpu resolves to 'CPU'
      await tester.tap(find.text('CPU'));
      await tester.pumpAndSettle();

      final firstBtn = tester.widget<SegmentedButton<TypePlayerEnum>>(
        find.byType(SegmentedButton<TypePlayerEnum>),
      );
      expect(firstBtn.selected, {TypePlayerEnum.cpu});
    });

    testWidgets('tapping Easy changes difficulty selection', (tester) async {
      await tester.pumpWidget(_buildApp(router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle();

      final diffBtn = tester.widget<SegmentedButton<DifficultyEnum>>(
        find.byType(SegmentedButton<DifficultyEnum>),
      );
      expect(diffBtn.selected, {DifficultyEnum.easy});
    });

    testWidgets('Start button pushes GameRoute with correct config', (tester) async {
      await tester.pumpWidget(_buildApp(router));
      await tester.pumpAndSettle();

      // Change selections before tapping Start
      await tester.tap(find.text('O'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CPU'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Medium'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Start'));
      await tester.pumpAndSettle();

      expect(router.pushed, hasLength(1));
      final route = router.pushed.first;
      expect(route, isA<GameRoute>());
      expect(
        (route as GameRoute).args,
        const GameConfigEntity(
          humanMark: CellMarkEnum.o,
          firstPlayer: TypePlayerEnum.cpu,
          difficulty: DifficultyEnum.medium,
        ),
      );
    });
  });
}
