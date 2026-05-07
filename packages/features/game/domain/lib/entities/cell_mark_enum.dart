/// Contenu possible d'une cellule du plateau : X, O ou vide.
///
/// Fournit des raccourcis booléens ([isEmpty], [isPlayed])
/// et le calcul de l'adversaire ([opponent]).
enum CellMarkEnum {
  x,
  o,
  empty;

  bool get isEmpty => this == CellMarkEnum.empty;
  bool get isPlayed => !isEmpty;

  CellMarkEnum get opponent => switch (this) {
        CellMarkEnum.x => CellMarkEnum.o,
        CellMarkEnum.o => CellMarkEnum.x,
        CellMarkEnum.empty => CellMarkEnum.empty,
      };
}
