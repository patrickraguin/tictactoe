import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tictactoe/core/persistence/shared_prefs_provider.dart';
import 'package:tictactoe/features/settings/data/repositories/locale_repository_impl.dart';
import 'package:tictactoe/features/settings/domain/repositories/locale_repository.dart';

part 'locale_repository_provider.g.dart';

/// Fournit le [LocaleRepository] concret via [SharedPreferences].
@riverpod
LocaleRepository localeRepository(Ref ref) =>
    LocaleRepositoryImpl(ref.watch(sharedPreferencesInstanceProvider));
