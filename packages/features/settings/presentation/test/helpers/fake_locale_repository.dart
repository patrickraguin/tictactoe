import 'package:core/result/result.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:settings_domain/repositories/locale_repository.dart';

class FakeLocaleRepository implements LocaleRepository {
  FakeLocaleRepository({AppLocale initial = AppLocale.system}) : _locale = initial;

  AppLocale _locale;

  AppLocale get current => _locale;

  @override
  Future<Result<AppLocale>> load() async => Success(_locale);

  @override
  Future<Result<void>> save(AppLocale locale) async {
    _locale = locale;
    return const Success(null);
  }
}
