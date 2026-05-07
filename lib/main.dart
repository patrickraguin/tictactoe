import 'package:core/error/app_provider_observer.dart';
import 'package:core/logging/console_logger.dart';
import 'package:core/logging/logger_provider.dart';
import 'package:core/persistence/shared_prefs_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_data/datasources/score_local_datasource.dart';
import 'package:game_data/repositories/score_repository_impl.dart';
import 'package:game_presentation/logic/providers/score_providers.dart';
import 'package:settings_data/repositories/locale_repository_impl.dart';
import 'package:settings_presentation/logic/locale_repository_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const logger = ConsoleLogger(

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
      observers: const [AppProviderObserver(logger)],
      overrides: [
        sharedPreferencesInstanceProvider.overrideWithValue(prefs),
        loggerProvider.overrideWithValue(logger),
        scoreRepositoryProvider.overrideWith(
          (ref) => ScoreRepositoryImpl(
            ScoreLocalDatasource(ref.watch(sharedPreferencesInstanceProvider)),
          ),
        ),
        localeRepositoryProvider.overrideWith(
          (ref) => LocaleRepositoryImpl(
            ref.watch(sharedPreferencesInstanceProvider),
          ),
        ),
      ],
      child: const TicTacToeApp(),
    ),
  );
}
