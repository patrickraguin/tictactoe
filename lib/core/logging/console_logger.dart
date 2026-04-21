import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

import 'app_logger.dart';

/// Implémentation console de [AppLogger] basée sur [dart:developer.log].
///
/// N'émet rien en mode release ([kReleaseMode]).
/// Les niveaux correspondent aux valeurs standard de [dart:developer] :
/// debug → 0, info → 800, warning → 900, error → 1000.
class ConsoleLogger implements AppLogger {
  const ConsoleLogger();

  @override
  void debug(String message, {String? tag}) {
    if (kReleaseMode) return;
    dev.log(message, name: tag ?? '', level: 0);
  }

  @override
  void info(String message, {String? tag}) {
    if (kReleaseMode) return;
    dev.log(message, name: tag ?? '', level: 800);
  }

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kReleaseMode) return;
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
    if (kReleaseMode) return;
    dev.log(
      message,
      name: tag ?? '',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
