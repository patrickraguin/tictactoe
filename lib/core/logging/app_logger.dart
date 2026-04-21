/// Interface de logging extensible.
///
/// Implémentations concrètes : [ConsoleLogger] (console, debug uniquement),
/// et tout futur backend (Datadog, Firebase, etc.) via override de [loggerProvider].
abstract class AppLogger {
  void debug(String message, {String? tag});
  void info(String message, {String? tag});
  void warning(String message, {Object? error, StackTrace? stackTrace, String? tag});
  void error(String message, {Object? error, StackTrace? stackTrace, String? tag});
}
