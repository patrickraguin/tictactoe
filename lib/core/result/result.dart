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

extension ResultX<T> on Result<T> {
  /// Transforme la valeur en cas de succès, propage l'erreur sinon.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success(:final value) => Success(transform(value)),
        Error(:final failure) => Error(failure),
      };

  /// Chaîne deux opérations faillibles sans imbriquer les `switch`.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
        Success(:final value) => transform(value),
        Error(:final failure) => Error(failure),
      };

  /// Consomme le résultat en fournissant un chemin pour chaque cas.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onError,
  }) =>
      switch (this) {
        Success(:final value) => onSuccess(value),
        Error(:final failure) => onError(failure),
      };

  /// Retourne la valeur ou le résultat de [fallback] en cas d'erreur.
  T getOrElse(T Function() fallback) => switch (this) {
        Success(:final value) => value,
        Error() => fallback(),
      };

  /// Extrait la valeur ou lève une [StateError].
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