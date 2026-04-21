import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tictactoe/core/l10n/app_localizations.dart';
import 'package:tictactoe/core/persistence/package_info_provider.dart';
import 'package:tictactoe/core/persistence/shared_prefs_provider.dart';
import 'package:tictactoe/features/settings/application/locale_controller.dart';
import 'package:tictactoe/features/settings/presentation/pages/settings_page.dart';

import '../../../../helpers/provider_helpers.dart';

final _fakePackageInfo = PackageInfo(
  appName: 'tictactoe',
  packageName: 'com.example.tictactoe',
  version: '1.2.3',
  buildNumber: '42',
);

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
    Future<ProviderContainer> makeSettingsContainer() async {
      final prefs = await makeSharedPrefs();
      return makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
        packageInfoProvider.overrideWith((_) async => _fakePackageInfo),
      ]);
    }

    testWidgets('shows all three language options', (tester) async {
      final container = await makeSettingsContainer();

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      // All 3 radio options are displayed (English locale by default in tests)
      expect(find.text('System'), findsOneWidget);
      expect(find.text('French'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('System option is selected by default when no locale is saved', (tester) async {
      final container = await makeSettingsContainer();

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, isNull);
    });

    testWidgets('tapping French updates locale to fr', (tester) async {
      final prefs = await makeSharedPrefs();
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
        packageInfoProvider.overrideWith((_) async => _fakePackageInfo),
      ]);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('French'));
      await tester.pumpAndSettle();

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('fr'));
      expect(prefs.getString('locale'), 'fr');
    });

    testWidgets('shows version from packageInfoProvider', (tester) async {
      final container = await makeSettingsContainer();

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.2.3+42'), findsOneWidget);
    });
  });
}
