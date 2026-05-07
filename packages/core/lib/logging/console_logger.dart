import 'dart:developer' as dev;

import 'package:core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Implémentation console de [AppLogger] basée sur [dart:developer.log].
///
/// N'émet rien en mode release ([kReleaseMode]).
/// Filtre les messages en dessous de [minLevel] pour réduire le bruit
/// en mode profile ou lors de sessions de debug spécifiques.
/// Les niveaux correspondent aux valeurs standard de [dart:developer] :
/// debug → 0, info → 800, warning → 900, error → 1000.
class ConsoleLogger implements AppLogger {
  const ConsoleLogger({this.minLevel = LogLevel.debug});

  @override
  final LogLevel minLevel;

  bool _shouldLog(LogLevel level) => !kReleaseMode && level.index >= minLevel.index;

  @override
  void debug(String message, {String? tag}) {
    if (!_shouldLog(LogLevel.debug)) return;
    dev.log(message, name: tag ?? '');
  }

  @override
  void info(String message, {String? tag}) {
    if (!_shouldLog(LogLevel.info)) return;
    dev.log(message, name: tag ?? '', level: 800);
  }

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_shouldLog(LogLevel.warning)) return;
    dev.log(
      message,
      name: tag ?? '',
      level: 900,
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (!_shouldLog(LogLevel.error)) return;
    dev.log(
      message,
      name: tag ?? '',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
