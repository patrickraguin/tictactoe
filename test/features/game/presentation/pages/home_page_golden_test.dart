@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/l10n/app_localizations.dart';
import 'package:tictactoe/core/theme/app_theme.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/score_controller.dart';
import 'package:tictactoe/features/game/presentation/pages/home_page.dart';

// Retourne un score figé sans accéder à la persistance.
class _FakeScoreController extends ScoreController {
  _FakeScoreController(this._score);
  final ScoreEntity _score;

  @override
  Future<ScoreEntity> build() async => _score;
}

Widget _buildApp(ScoreEntity score, {ThemeData? theme}) => ProviderScope(
      overrides: [
        scoreControllerProvider.overrideWith(() => _FakeScoreController(score)),
      ],
      child: MaterialApp(
        theme: theme ?? buildLightTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );

void _setViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  group('HomePage — goldens', () {
    testWidgets('home_score_zero_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(_buildApp(ScoreEntity.zero()));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/home_score_zero_light.png'),
      );
    });

    testWidgets('home_score_played_light', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(
        _buildApp(const ScoreEntity(wins: 5, losses: 2, draws: 1)),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/home_score_played_light.png'),
      );
    });

    testWidgets('home_score_played_dark', (tester) async {
      _setViewport(tester);
      await tester.pumpWidget(
        _buildApp(
          const ScoreEntity(wins: 5, losses: 2, draws: 1),
          theme: buildDarkTheme(),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/home_score_played_dark.png'),
      );
    });
  });
}
