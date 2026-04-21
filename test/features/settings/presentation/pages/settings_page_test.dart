import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/l10n/app_localizations.dart';
import 'package:tictactoe/features/settings/application/locale_controller.dart';
import 'package:tictactoe/core/persistence/shared_prefs_provider.dart';
import 'package:tictactoe/features/settings/presentation/pages/settings_page.dart';

import '../../../../helpers/provider_helpers.dart';

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SettingsPage(),
      ),
    );

void main() {
  group('SettingsPage', () {
    testWidgets('shows all three language options', (tester) async {
      final prefs = await makeSharedPrefs();
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // All 3 radio options are displayed (English locale by default in tests)
      expect(find.text('System'), findsOneWidget);
      expect(find.text('French'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('System option is selected by default when no locale is saved', (tester) async {
      final prefs = await makeSharedPrefs();
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, isNull);
    });

    testWidgets('tapping French updates locale to fr', (tester) async {
      final prefs = await makeSharedPrefs();
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('French'));
      await tester.pumpAndSettle();

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('fr'));
      expect(prefs.getString('locale'), 'fr');
    });
  });
}
