import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/app_locale.dart';
import 'locale_repository_provider.dart';

part 'locale_controller.g.dart';

/// Contrôleur de la locale applicative (keepAlive).
///
/// Charge la préférence de langue depuis [LocaleRepository] à l'initialisation.
/// `null` signifie « utiliser la locale système ».
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Future<Locale?> build() async {
    final appLocale = await ref.watch(localeRepositoryProvider).load();
    final code = appLocale.languageCode;
    return code != null ? Locale(code) : null;
  }

  Future<void> setLocale(Locale? locale) async {
    final appLocale = AppLocale.fromCode(locale?.languageCode);
    await ref.read(localeRepositoryProvider).save(appLocale);
    state = AsyncData(locale);
  }
}
