import 'package:core/result/result.dart';
import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/entities/app_locale.dart';
import 'package:settings_domain/usecases/load_locale.dart';
import 'package:settings_domain/usecases/set_locale.dart';
import 'package:settings_presentation/logic/locale_repository_provider.dart';

part 'locale_controller.g.dart';

/// Contrôleur de la locale applicative (keepAlive).
///
/// Charge la préférence de langue via [LoadLocale] à l'initialisation.
/// `null` signifie « utiliser la locale système ».
@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Future<Locale?> build() async {
    final repo = ref.watch(localeRepositoryProvider);
    final result = await LoadLocale(repo)();
    return result.fold(
      onSuccess: _toLocale,
      onError: (failure) => throw StorageException(failure.message),
    );
  }

  Future<void> setLocale(Locale? locale) async {
    final appLocale = AppLocale.fromCode(locale?.languageCode);
    final repo = ref.read(localeRepositoryProvider);
    (await SetLocale(repo)(appLocale)).fold(
      onSuccess: (_) => state = AsyncData(locale),
      onError: (_) {},
    );
  }

  Locale? _toLocale(AppLocale appLocale) {
    final code = appLocale.languageCode;
    return code != null ? Locale(code) : null;
  }
}
