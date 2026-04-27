import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tictactoe/core/app.dart';
import 'package:tictactoe/core/error/app_provider_observer.dart';
import 'package:tictactoe/core/logging/app_logger.dart';
import 'package:tictactoe/core/logging/console_logger.dart';
import 'package:tictactoe/core/logging/logger_provider.dart';
import 'package:tictactoe/core/persistence/shared_prefs_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const logger = ConsoleLogger(
    minLevel: kDebugMode ? LogLevel.debug : LogLevel.info,
  );

  // Capture Flutter framework errors (widget tree, rendering, etc.)
  FlutterError.onError = (details) => logger.error(
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
        tag: 'FlutterError',
      );

  // Capture platform & async zone errors (Dart isolate, Future, etc.)
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('Uncaught error', error: error, stackTrace: stack, tag: 'PlatformDispatcher');
    return true;
  };

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      observers: [AppProviderObserver(logger)],
      overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
        loggerProvider.overrideWithValue(logger),
      ],
      child: const TicTacToeApp(),
    ),
  );
}

