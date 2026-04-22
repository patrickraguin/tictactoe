/// Niveaux de sévérité des messages de log.
enum LogLevel { debug, info, warning, error }

/// Interface de logging extensible.
///
/// Implémentations concrètes : [ConsoleLogger] (console, filtrage par [minLevel]),
/// et tout futur backend (Datadog, Firebase, etc.) via override de [loggerProvider].
abstract class AppLogger {
  LogLevel get minLevel;

  void debug(String message, {String? tag});
  void info(String message, {String? tag});
  void warning(String message, {Object? error, StackTrace? stackTrace, String? tag});
  void error(String message, {Object? error, StackTrace? stackTrace, String? tag});
}
