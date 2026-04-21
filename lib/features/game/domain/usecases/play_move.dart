import '../entities/board_entity.dart';
import '../entities/cell_mark_enum.dart';
import '../entities/game_state_entity.dart';

/// Applique un coup et retourne le nouvel état de la partie.
///
/// Fonction pure — sans aléatoire ni I/O. Ignore les coups invalides
/// (mauvais tour, cellule déjà occupée, partie terminée) en retournant
/// l'état inchangé. Détecte automatiquement victoire et match nul.
GameStateEntity playMove({
  required GameStateEntity state,
  required int index,
  required CellMarkEnum mark,
}) {
  if (state is! InProgressEntity) return state;
  if (state.turn != mark) return state;
  if (state.board.cellAt(index).isPlayed) return state;

  final newBoard = state.board.place(index, mark);
  final line = newBoard.winningLineFor(mark);
  if (line != null) {
    return GameStateEntity.won(
      board: newBoard,
      winner: mark,
      line: line,
      humanMark: state.humanMark,
    );
  }
  if (newBoard.isFull) {
    return GameStateEntity.draw(board: newBoard, humanMark: state.humanMark);
  }
  return GameStateEntity.inProgress(
    board: newBoard,
    turn: mark.opponent,
    humanMark: state.humanMark,
  );
}

/// Construit l'état initial d'une partie à partir d'un plateau vide,
/// du premier joueur à jouer et du symbole de l'humain.
GameStateEntity initialState({
  required BoardEntity board,
  required CellMarkEnum firstToPlay,
  required CellMarkEnum humanMark,
}) =>
    GameStateEntity.inProgress(
      board: board,
      turn: firstToPlay,
      humanMark: humanMark,
    );
