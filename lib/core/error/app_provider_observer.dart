import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tictactoe/core/logging/app_logger.dart';

/// Observateur Riverpod centralisant la gestion des erreurs et le logging
/// des transitions d'état de tous les providers.
///
/// Enregistré dans [ProviderScope] au démarrage :
/// ```dart
/// ProviderScope(observers: [AppProviderObserver(logger)], ...)
/// ```
base class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver(this._logger);

  final AppLogger _logger;

  static const _tag = 'ProviderObserver';

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final name = context.provider.name ?? context.provider.runtimeType.toString();
    if (newValue is AsyncError) {
      _logger.error(
        'Provider error — $name',
        error: newValue.error,
        stackTrace: newValue.stackTrace,
        tag: _tag,
      );
    } else if (newValue is! AsyncLoading) {
      _logger.debug('$name → $newValue', tag: _tag);
    }
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final name = context.provider.name ?? context.provider.runtimeType.toString();
    _logger.error(
      'Provider failed — $name',
      error: error,
      stackTrace: stackTrace,
      tag: _tag,
    );
  }
}

