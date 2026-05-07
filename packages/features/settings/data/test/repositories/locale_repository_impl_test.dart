import 'package:core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_data/repositories/locale_repository_impl.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('LocaleRepositoryImpl', () {
    test('load returns system when no key is stored', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = LocaleRepositoryImpl(prefs);

      final result = await repo.load();
      expect((result as Success<AppLocale>).value, AppLocale.system);
    });

    test('save(fr) persists and load returns fr', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = LocaleRepositoryImpl(prefs);

      await repo.save(AppLocale.fr);
      final result = await repo.load();
      expect((result as Success<AppLocale>).value, AppLocale.fr);
    });

    test('save(en) persists and load returns en', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = LocaleRepositoryImpl(prefs);

      await repo.save(AppLocale.en);
      final result = await repo.load();
      expect((result as Success<AppLocale>).value, AppLocale.en);
    });

    test('save(system) removes key and load returns system', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = LocaleRepositoryImpl(prefs);

      await repo.save(AppLocale.fr);
      await repo.save(AppLocale.system);

      final result = await repo.load();
      expect((result as Success<AppLocale>).value, AppLocale.system);
    });

    test('save returns Success', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = LocaleRepositoryImpl(prefs);

      expect(await repo.save(AppLocale.fr), isA<Success<void>>());
    });

    test('overwriting locale with a new value works', () async {
      final prefs = await SharedPreferences.getInstance();
      final repo = LocaleRepositoryImpl(prefs);

      await repo.save(AppLocale.fr);
      await repo.save(AppLocale.en);

      final result = await repo.load();
      expect((result as Success<AppLocale>).value, AppLocale.en);
    });
  });
}
