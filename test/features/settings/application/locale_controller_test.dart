import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/settings/application/locale_controller.dart';
import 'package:tictactoe/core/persistence/shared_prefs_provider.dart';

import '../../../helpers/provider_helpers.dart';

void main() {
  group('LocaleController', () {
    test('returns null when no locale is saved (system default)', () async {
      final prefs = await makeSharedPrefs();
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, isNull);
    });

    test('returns Locale("fr") when locale key is "fr"', () async {
      final prefs = await makeSharedPrefs(values: {'locale': 'fr'});
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('fr'));
    });

    test('returns Locale("en") when locale key is "en"', () async {
      final prefs = await makeSharedPrefs(values: {'locale': 'en'});
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('en'));
    });

    test('setLocale(fr) persists "fr" and updates state', () async {
      final prefs = await makeSharedPrefs();
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      await container.read(localeControllerProvider.notifier).setLocale(const Locale('fr'));

      expect(prefs.getString('locale'), 'fr');
      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('fr'));
    });

    test('setLocale(null) removes key from prefs and resets to system', () async {
      final prefs = await makeSharedPrefs(values: {'locale': 'fr'});
      final container = makeContainer(overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
      ]);

      await container.read(localeControllerProvider.notifier).setLocale(null);

      expect(prefs.getString('locale'), isNull);
      final locale = await container.read(localeControllerProvider.future);
      expect(locale, isNull);
    });
  });
}
