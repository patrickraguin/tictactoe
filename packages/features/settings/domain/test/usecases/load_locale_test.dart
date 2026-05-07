import 'package:core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:settings_domain/repositories/locale_repository.dart';
import 'package:settings_domain/usecases/load_locale.dart';

class _FakeLocaleRepository implements LocaleRepository {
  _FakeLocaleRepository(this._result);
  final Result<AppLocale> _result;

  @override
  Future<Result<AppLocale>> load() async => _result;

  @override
  Future<Result<void>> save(AppLocale locale) async => const Success(null);
}

void main() {
  group('LoadLocale', () {
    test('delegates to repository and returns Success', () async {
      final useCase = LoadLocale(_FakeLocaleRepository(const Success(AppLocale.fr)));
      expect(await useCase(), const Success(AppLocale.fr));
    });

    test('returns system locale from repository', () async {
      final useCase = LoadLocale(_FakeLocaleRepository(const Success(AppLocale.system)));
      expect(await useCase(), const Success(AppLocale.system));
    });

    test('propagates Error from repository', () async {
      final useCase = LoadLocale(_FakeLocaleRepository(const Error(StorageFailure('disk'))));
      expect(await useCase(), isA<Error<AppLocale>>());
    });
  });
}
