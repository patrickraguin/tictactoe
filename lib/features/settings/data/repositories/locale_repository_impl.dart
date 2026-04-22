import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_locale.dart';
import '../../domain/repositories/locale_repository.dart';

/// Implémentation de [LocaleRepository] via [SharedPreferences].
class LocaleRepositoryImpl implements LocaleRepository {
  LocaleRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;
  static const _localeKey = 'locale';

  @override
  Future<AppLocale> load() async =>
      AppLocale.fromCode(_prefs.getString(_localeKey));

  @override
  Future<void> save(AppLocale locale) async {
    final code = locale.languageCode;
    if (code == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, code);
    }
  }
}
