import 'package:core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result.map', () {
    test('transforms value on Success', () {
      final result = const Success(2).map((v) => v * 3);
      expect((result as Success<int>).value, 6);
    });

    test('propagates Failure on Error without calling transform', () {
      var called = false;
      const Error<int>(StorageFailure('x')).map((_) { called = true; return 0; });
      expect(called, isFalse);
    });

    test('Error preserves the original Failure type', () {
      final result = const Error<int>(InvalidMoveFailure('bad')).map((v) => v);
      expect((result as Error<int>).failure, isA<InvalidMoveFailure>());
    });
  });

  group('Result.flatMap', () {
    test('chains Success through the transform', () {
      final result = const Success(5).flatMap((v) => Success(v + 1));
      expect((result as Success<int>).value, 6);
    });

    test('Success can flatMap into an Error', () {
      final out = const Success(5).flatMap<int>((_) => const Error(StorageFailure('fail')));
      expect(out, isA<Error<int>>());
    });

    test('short-circuits on Error without calling transform', () {
      var called = false;
      const Error<int>(StorageFailure('e')).flatMap((v) { called = true; return Success(v); });
      expect(called, isFalse);
    });
  });

  group('Result.fold', () {
    test('calls onSuccess on Success', () {
      final out = const Success(42).fold(onSuccess: (v) => v * 2, onError: (_) => -1);
      expect(out, 84);
    });

    test('calls onError on Error', () {
      final out = const Error<int>(StorageFailure('err')).fold(onSuccess: (v) => v, onError: (_) => -1);
      expect(out, -1);
    });
  });

  group('Result.getOrElse', () {
    test('returns value on Success', () {
      expect(const Success(7).getOrElse(() => 0), 7);
    });

    test('calls fallback on Error', () {
      expect(const Error<int>(StorageFailure('x')).getOrElse(() => 99), 99);
    });
  });

  group('Result.unwrap', () {
    test('returns value on Success', () {
      expect(const Success('hello').unwrap(), 'hello');
    });

    test('throws StateError on Error', () {
      expect(
        () => const Error<String>(StorageFailure('bad')).unwrap(),
        throwsA(isA<StateError>()),
      );
    });

    test('StateError message includes the failure message', () {
      expect(
        () => const Error<int>(StorageFailure('disk full')).unwrap(),
        throwsA(
          isA<StateError>().having((e) => e.message, 'message', contains('disk full')),
        ),
      );
    });
  });

  group('Failure subtypes', () {
    test('StorageFailure carries message', () {
      expect(const StorageFailure('disk full').message, 'disk full');
    });

    test('InvalidMoveFailure carries message', () {
      expect(const InvalidMoveFailure('occupied').message, 'occupied');
    });
  });

  group('StorageException', () {
    test('toString includes message', () {
      expect(
        const StorageException('disk full').toString(),
        'StorageException: disk full',
      );
    });
  });
}
