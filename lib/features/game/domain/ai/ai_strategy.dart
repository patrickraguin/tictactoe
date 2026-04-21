import '../entities/board_entity.dart';
import '../entities/cell_mark_enum.dart';

/// Interface de stratégie IA pour choisir le prochain coup du CPU.
///
/// Les implémentations doivent être pures : pour un même [board] et [mark],
/// elles retournent toujours l'index d'une cellule vide valide.
/// L'aléatoire est autorisé, mais aucun I/O n'est permis.
abstract class AiStrategy {
  const AiStrategy();

  int nextMove(BoardEntity board, CellMarkEnum mark);
}
