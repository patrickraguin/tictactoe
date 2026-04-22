import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe/core/error/app_provider_observer.dart';
import 'package:tictactoe/core/logging/app_logger.dart';

class _MockAppLogger extends Mock implements AppLogger {
  // AppLogger.minLevel is used by ConsoleLogger but not by the observer.
  @override
  LogLevel get minLevel => LogLevel.debug;
}

class _IncrementNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}

ProviderContainer _makeContainer(_MockAppLogger logger) {
  final container = ProviderContainer(observers: [AppProviderObserver(logger)]);
  addTearDown(container.dispose);
  return container;
}

void main() {
  late _MockAppLogger logger;

  setUp(() => logger = _MockAppLogger());

  group('didUpdateProvider', () {
    test('logs debug on a normal (non-async) state update', () {
      final container = _makeContainer(logger);
      // Use a Notifier so we can trigger a real state change → didUpdateProvider.
      final provider = NotifierProvider<_IncrementNotifier, int>(
        _IncrementNotifier.new,
        name: 'counter',
      );

      container.read(provider.notifier).increment();

      verify(() => logger.debug(any(), tag: any(named: 'tag'))).called(
        greaterThanOrEqualTo(1),
      );
      verifyNever(
        () => logger.error(
          any(),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: any(named: 'tag'),
        ),
      );
    });

    test('does not log while provider is in AsyncLoading state', () async {
      final container = _makeContainer(logger);
      final completer = Completer<int>();
      final provider = FutureProvider<int>(
        (ref) => completer.future,
        name: 'loadingProvider',
      );

      container.listen(provider, (_, _) {});

      // At this point the provider is AsyncLoading — no debug or error log.
      verifyNever(() => logger.debug(any(), tag: any(named: 'tag')));
      verifyNever(
        () => logger.error(
          any(),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: any(named: 'tag'),
        ),
      );

      completer.complete(0); // let the future resolve for clean teardown
    });

    test('logs error when a FutureProvider transitions to AsyncError', () async {
      final container = _makeContainer(logger);
      final provider = FutureProvider<int>(
        (ref) async => throw StateError('async boom'),
        name: 'errorProvider',
      );

      await container.read(provider.future).catchError((_) => 0);

      verify(
        () => logger.error(
          any(),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: any(named: 'tag'),
        ),
      ).called(greaterThanOrEqualTo(1));
    });

    test('does not log error for AsyncData after AsyncLoading', () async {
      final container = _makeContainer(logger);
      final provider = FutureProvider<int>((ref) async => 7, name: 'dataProvider');

      await container.read(provider.future);

      // Only debug should have been called (for AsyncData), not error.
      verifyNever(
        () => logger.error(
          any(),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: any(named: 'tag'),
        ),
      );
      verify(() => logger.debug(any(), tag: any(named: 'tag'))).called(
        greaterThanOrEqualTo(1),
      );
    });
  });

  group('providerDidFail', () {
    test('logs error when a provider throws synchronously', () {
      final container = _makeContainer(logger);
      final provider = Provider<int>(
        (ref) => throw StateError('sync boom'),
        name: 'syncFailProvider',
      );

      expect(() => container.read(provider), throwsA(anything));

      verify(
        () => logger.error(
          any(),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
          tag: any(named: 'tag'),
        ),
      ).called(greaterThanOrEqualTo(1));
    });
  });
}
