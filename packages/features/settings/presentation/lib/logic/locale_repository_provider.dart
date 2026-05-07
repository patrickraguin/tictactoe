import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_domain/repositories/locale_repository.dart';

part 'locale_repository_provider.g.dart';

@riverpod
LocaleRepository localeRepository(Ref ref) => throw UnimplementedError(
      'localeRepositoryProvider must be overridden in ProviderScope',
    );
