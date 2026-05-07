import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:settings_presentation/logic/locale_controller.dart';
import 'package:settings_presentation/logic/locale_repository_provider.dart';

import '../helpers/fake_locale_repository.dart';
import '../helpers/provider_helpers.dart';

ProviderContainer makeLocaleContainer(FakeLocaleRepository repo) =>
    makeContainer(overrides: [
      localeRepositoryProvider.overrideWith((_) => repo),
    ]);

void main() {
  group('LocaleController', () {
    test('returns null when no locale is saved (system default)', () async {
      final container = makeLocaleContainer(FakeLocaleRepository());

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, isNull);
    });

    test('returns Locale("fr") when locale is fr', () async {
      final container = makeLocaleContainer(FakeLocaleRepository(initial: AppLocale.fr));

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('fr'));
    });

    test('returns Locale("en") when locale is en', () async {
      final container = makeLocaleContainer(FakeLocaleRepository(initial: AppLocale.en));

      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('en'));
    });

    test('setLocale(fr) saves and updates state to Locale("fr")', () async {
      final repo = FakeLocaleRepository();
      final container = makeLocaleContainer(repo);

      await container.read(localeControllerProvider.notifier).setLocale(const Locale('fr'));

      expect(repo.current, AppLocale.fr);
      final locale = await container.read(localeControllerProvider.future);
      expect(locale, const Locale('fr'));
    });

    test('setLocale(null) saves system and resets state to null', () async {
      final repo = FakeLocaleRepository(initial: AppLocale.fr);
      final container = makeLocaleContainer(repo);

      await container.read(localeControllerProvider.notifier).setLocale(null);

      expect(repo.current, AppLocale.system);
      final locale = await container.read(localeControllerProvider.future);
      expect(locale, isNull);
    });
  });
}
