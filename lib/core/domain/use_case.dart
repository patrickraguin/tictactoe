import '../result/result.dart';

/// Contrat de base pour tous les use cases synchrones.
///
/// [Params] : objet encapsulant les paramètres d'entrée.
/// [Type]   : type de la valeur retournée en cas de succès.
///
/// Convention : les use cases sans dépendances externes sont `const`
/// et instanciés directement (`const PlayMove()`). Ceux qui requièrent
/// une dépendance (repo, logger, clock) l'injectent via le constructeur
/// et exposent un provider Riverpod.
abstract interface class UseCase<Params, Type> {
  Result<Type> call(Params params);
}

/// Variante sans paramètres d'entrée (ex. chargement d'état initial).
abstract interface class UseCaseNoParams<Type> {
  Result<Type> call();
}
