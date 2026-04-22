// Modélisation explicite des succès et des erreurs pour les opérations de persistence.

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

// --- Failures ---

sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class StorageFailure extends Failure {
  const StorageFailure(super.message);
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