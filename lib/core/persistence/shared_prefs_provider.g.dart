// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_prefs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Instance de [SharedPreferences] injectée au démarrage dans `main.dart`.
///
/// Doit être overridée dans le [ProviderScope] avant utilisation :
/// ```dart
/// sharedPreferencesInstanceProvider.overrideWithValue(prefs)
/// ```

@ProviderFor(sharedPreferencesInstance)
const sharedPreferencesInstanceProvider = SharedPreferencesInstanceProvider._();

/// Instance de [SharedPreferences] injectée au démarrage dans `main.dart`.
///
/// Doit être overridée dans le [ProviderScope] avant utilisation :
/// ```dart
/// sharedPreferencesInstanceProvider.overrideWithValue(prefs)
/// ```

final class SharedPreferencesInstanceProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// Instance de [SharedPreferences] injectée au démarrage dans `main.dart`.
  ///
  /// Doit être overridée dans le [ProviderScope] avant utilisation :
  /// ```dart
  /// sharedPreferencesInstanceProvider.overrideWithValue(prefs)
  /// ```
  const SharedPreferencesInstanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesInstanceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesInstanceHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferencesInstance(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesInstanceHash() =>
    r'044b40d445b468730b23b4c24262cc55f904b6dd';
