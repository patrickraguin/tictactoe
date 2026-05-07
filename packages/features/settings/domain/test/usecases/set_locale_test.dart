import 'package:core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:settings_domain/repositories/locale_repository.dart';
import 'package:settings_domain/usecases/set_locale.dart';

class _FakeLocaleRepository implements LocaleRepository {
  AppLocale? saved;
  final bool shouldFail;

  _FakeLocaleRepository({this.shouldFail = false});

  @override
  Future<Result<AppLocale>> load() async => const Success(AppLocale.system);

  @override
  Future<Result<void>> save(AppLocale locale) async {
    if (shouldFail) return const Error(StorageFailure('io error'));
    saved = locale;
    return const Success(null);
  }
}

void main() {
  group('SetLocale', () {
    test('delegates to repository.save and returns Success', () async {
      final repo = _FakeLocaleRepository();
      final useCase = SetLocale(repo);

      final result = await useCase(AppLocale.fr);

      expect(result, isA<Success<void>>());
      expect(repo.saved, AppLocale.fr);
    });

    test('saves correct locale for each value', () async {
      for (final locale in AppLocale.values) {
        final repo = _FakeLocaleRepository();
        await SetLocale(repo)(locale);
        expect(repo.saved, locale);
      }
    });

    test('propagates Error from repository', () async {
      final useCase = SetLocale(_FakeLocaleRepository(shouldFail: true));
      expect(await useCase(AppLocale.en), isA<Error<void>>());
    });
  });
}
