import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/persistence/shared_prefs_provider.dart';

part 'locale_controller.g.dart';

const _localeKey = 'locale';

/// Contrôleur de la locale applicative (keepAlive).
///
/// Charge la préférence de langue depuis [SharedPreferences] à l'initialisation.
/// `null` signifie « utiliser la locale système ».
/// Persisté sous la clé [_localeKey] ('fr', 'en', ou absent).
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Future<Locale?> build() async {
    final prefs = ref.watch(sharedPreferencesInstanceProvider);
    final code = prefs.getString(_localeKey);
    return code != null ? Locale(code) : null;
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = ref.read(sharedPreferencesInstanceProvider);
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
    state = AsyncData(locale);
  }
}
