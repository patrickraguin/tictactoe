import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_logger.dart';
import 'console_logger.dart';

part 'logger_provider.g.dart';

/// Provider du logger applicatif.
///
/// Par défaut utilise [ConsoleLogger]. Pour brancher un autre backend
/// (Datadog, Firebase…), overrider ce provider dans [ProviderScope] de `main.dart` :
///
/// ```dart
/// loggerProvider.overrideWithValue(DatadogLogger())
/// ```
@Riverpod(keepAlive: true)
AppLogger logger(Ref ref) => const ConsoleLogger();
