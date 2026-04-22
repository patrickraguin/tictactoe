import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/persistence/shared_prefs_provider.dart';
import '../../data/repositories/locale_repository_impl.dart';
import '../../domain/repositories/locale_repository.dart';

/// Fournit le [LocaleRepository] concret via [SharedPreferences].
///
/// Provider non code-gen intentionnel : simple délégation sans état,
/// `overrideWithValue` disponible pour l'injection de fakes en test.
final localeRepositoryProvider = Provider<LocaleRepository>(
  (ref) => LocaleRepositoryImpl(ref.watch(sharedPreferencesInstanceProvider)),
);
