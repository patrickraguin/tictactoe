import 'package:core/result/result.dart';

/// Contrat de base pour tous les use cases synchrones.
///
/// [Params]  : objet encapsulant les paramètres d'entrée.
/// [Output]  : type de la valeur retournée en cas de succès.
///
/// Convention : les use cases sans dépendances externes sont `const`
/// et instanciés directement (`const PlayMove()`). Ceux qui requièrent
/// une dépendance (repo, logger, clock) l'injectent via le constructeur.
abstract interface class UseCase<Params, Output> {
  Result<Output> call(Params params);
}

/// Variante synchrone sans paramètres d'entrée.
abstract interface class UseCaseNoParams<Output> {
  Result<Output> call();
}

/// Contrat de base pour tous les use cases asynchrones.
///
/// À utiliser dès qu'une opération implique de l'I/O (repo, réseau, horloge).
abstract interface class AsyncUseCase<Params, Output> {
  Future<Result<Output>> call(Params params);
}

/// Variante asynchrone sans paramètres d'entrée (ex. chargement initial).
abstract interface class AsyncUseCaseNoParams<Output> {
  Future<Result<Output>> call();
}
