import 'package:core/result/result.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:settings_domain/repositories/locale_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implémentation de [LocaleRepository] via [SharedPreferences].
class LocaleRepositoryImpl implements LocaleRepository {
  LocaleRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;
  static const _localeKey = 'locale';

  @override
  Future<Result<AppLocale>> load() async {
    try {
      return Success(AppLocale.fromCode(_prefs.getString(_localeKey)));
    } on Object catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(AppLocale locale) async {
    try {
      final code = locale.languageCode;
      if (code == null) {
        await _prefs.remove(_localeKey);
      } else {
        await _prefs.setString(_localeKey, code);
      }
      return const Success(null);
    } on Object catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }
}
