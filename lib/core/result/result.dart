sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}

extension ResultUnwrap<T> on Result<T> {
  /// Extrait la valeur en cas de succès, ou lève une [StateError] si c'est une [Error].
  /// À utiliser uniquement pour les use cases garantis infaillibles.
  T unwrap() => switch (this) {
        Success(:final value) => value,
        Error(:final failure) => throw StateError(
            'unwrap() appelé sur Error: ${failure.message}',
          ),
      };
}

// --- Failures ---

sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

/// Coup de jeu invalide (mauvais tour, case occupée, partie terminée).
final class InvalidMoveFailure extends Failure {
  const InvalidMoveFailure(super.message);
}

// --- Exception ---

/// Exception levée lorsqu'un [StorageFailure] doit remonter comme exception
/// (ex. dans un AsyncNotifier Riverpod pour déclencher un état AsyncError).
final class StorageException implements Exception {
  const StorageException(this.message);
  final String message;

  @override
  String toString() => 'StorageException: $message';
}