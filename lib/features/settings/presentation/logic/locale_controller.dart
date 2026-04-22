import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/result/result.dart';
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
    final result = await ref.watch(localeRepositoryProvider).load();
    return switch (result) {
      Success(:final value) => _toLocale(value),
      Error(:final failure) => throw StorageException(failure.message),
    };
  }

  Future<void> setLocale(Locale? locale) async {
    final appLocale = AppLocale.fromCode(locale?.languageCode);
    final result = await ref.read(localeRepositoryProvider).save(appLocale);
    if (result is Error) return;
    state = AsyncData(locale);
  }

  Locale? _toLocale(AppLocale appLocale) {
    final code = appLocale.languageCode;
    return code != null ? Locale(code) : null;
  }
}
