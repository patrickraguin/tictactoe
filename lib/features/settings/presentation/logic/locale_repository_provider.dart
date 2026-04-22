import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/persistence/shared_prefs_provider.dart';
import '../../data/repositories/locale_repository_impl.dart';
import '../../domain/repositories/locale_repository.dart';

part 'locale_repository_provider.g.dart';

/// Fournit le [LocaleRepository] concret via [SharedPreferences].
@riverpod
LocaleRepository localeRepository(Ref ref) =>
    LocaleRepositoryImpl(ref.watch(sharedPreferencesInstanceProvider));
