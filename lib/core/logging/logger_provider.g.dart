// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider du logger applicatif.
///
/// Par défaut utilise [ConsoleLogger]. Pour brancher un autre backend
/// (Datadog, Firebase…), overrider ce provider dans [ProviderScope] de `main.dart` :
///
/// ```dart
/// loggerProvider.overrideWithValue(DatadogLogger())
/// ```

@ProviderFor(logger)
const loggerProvider = LoggerProvider._();

/// Provider du logger applicatif.
///
/// Par défaut utilise [ConsoleLogger]. Pour brancher un autre backend
/// (Datadog, Firebase…), overrider ce provider dans [ProviderScope] de `main.dart` :
///
/// ```dart
/// loggerProvider.overrideWithValue(DatadogLogger())
/// ```

final class LoggerProvider
    extends $FunctionalProvider<AppLogger, AppLogger, AppLogger>
    with $Provider<AppLogger> {
  /// Provider du logger applicatif.
  ///
  /// Par défaut utilise [ConsoleLogger]. Pour brancher un autre backend
  /// (Datadog, Firebase…), overrider ce provider dans [ProviderScope] de `main.dart` :
  ///
  /// ```dart
  /// loggerProvider.overrideWithValue(DatadogLogger())
  /// ```
  const LoggerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loggerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loggerHash();

  @$internal
  @override
  $ProviderElement<AppLogger> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLogger create(Ref ref) {
    return logger(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLogger value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLogger>(value),
    );
  }
}

String _$loggerHash() => r'af6a5393c5b891fbea1cfe72697f062d541613ee';
