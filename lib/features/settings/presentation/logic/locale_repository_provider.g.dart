// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fournit le [LocaleRepository] concret via [SharedPreferences].

@ProviderFor(localeRepository)
final localeRepositoryProvider = LocaleRepositoryProvider._();

/// Fournit le [LocaleRepository] concret via [SharedPreferences].

final class LocaleRepositoryProvider
    extends
        $FunctionalProvider<
          LocaleRepository,
          LocaleRepository,
          LocaleRepository
        >
    with $Provider<LocaleRepository> {
  /// Fournit le [LocaleRepository] concret via [SharedPreferences].
  LocaleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocaleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocaleRepository create(Ref ref) {
    return localeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocaleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocaleRepository>(value),
    );
  }
}

String _$localeRepositoryHash() => r'9893568486c7a3297056f9caa2971669ea823411';
