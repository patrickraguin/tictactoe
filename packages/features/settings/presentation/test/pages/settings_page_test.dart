import 'package:core/l10n/app_localizations.dart';
import 'package:core/persistence/package_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:settings_presentation/logic/locale_controller.dart';
import 'package:settings_presentation/logic/locale_repository_provider.dart';
import 'package:settings_presentation/pages/settings_page.dart';

import '../helpers/fake_locale_repository.dart';
import '../helpers/provider_helpers.dart';

final _fakePackageInfo = PackageInfo(
  appName: 'tictactoe',
  packageName: 'com.example.tictactoe',
  version: '1.2.3',
  buildNumber: '42',
);

Widget _buildApp(ProviderContainer container) => UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsPage(),
      ),
    );

ProviderContainer makeSettingsContainer({FakeLocaleRepository? repo}) => makeContainer(
      overrides: [
        localeRepositoryProvider.overrideWith((_) => repo ?? FakeLocaleRepository()),
        packageInfoProvider.overrideWith((_) async => _fakePackageInfo),
      ],
    );

void main() {
  group('SettingsPage', () {
    testWidgets('shows all three language options', (tester) async {
      await tester.pumpWidget(_buildApp(makeSettingsContainer()));
      await tester.pumpAndSettle();

      expect(find.text('System'), findsOneWidget);
      expect(find.text('French'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('System option is selected by default when no locale is saved', (tester) async {
      final container = makeSettingsContainer();
      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, isNull);
    });

    testWidgets('tapping French updates locale to fr', (tester) async {
      final repo = FakeLocaleRepository();
      final container = makeSettingsContainer(repo: repo);

      await tester.pumpWidget(_buildApp(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('French'));
      await tester.pumpAndSettle();

      expect(repo.current, AppLocale.fr);
      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('fr'));
    });

    testWidgets('shows version from packageInfoProvider', (tester) async {
      await tester.pumpWidget(_buildApp(makeSettingsContainer()));
      await tester.pumpAndSettle();

      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.2.3+42'), findsOneWidget);
    });
  });
}
