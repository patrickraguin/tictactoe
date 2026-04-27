import 'package:tictactoe/core/domain/use_case.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';

class PlayMoveParams {
  const PlayMoveParams({
    required this.state,
    required this.index,
    required this.mark,
  });

  final GameStateEntity state;
  final int index;
  final CellMarkEnum mark;
}

/// Applique un coup et retourne le nouvel état de la partie.
///
/// Retourne [InvalidMoveFailure] pour tout coup invalide
/// (partie terminée, mauvais tour, case occupée).
class PlayMove implements UseCase<PlayMoveParams, GameStateEntity> {
  const PlayMove();

  @override
  Result<GameStateEntity> call(PlayMoveParams params) {
    final state = params.state;

    if (state is! InProgressEntity) {
      return const Error(InvalidMoveFailure('la partie est déjà terminée'));
    }
    if (state.turn != params.mark) {
      return const Error(InvalidMoveFailure("ce n'est pas votre tour"));
    }
    if (state.board.cellAt(params.index).isPlayed) {
      return const Error(InvalidMoveFailure('la case est déjà occupée'));
    }

    final newBoard = state.board.place(params.index, params.mark);
    final line = newBoard.winningLineFor(params.mark);
    if (line != null) {
      return Success(GameStateEntity.won(
        board: newBoard,
        winner: params.mark,
        line: line,
        humanMark: state.humanMark,
      ));
    }
    if (newBoard.isFull) {
      return Success(GameStateEntity.draw(board: newBoard, humanMark: state.humanMark));
    }
    return Success(GameStateEntity.inProgress(
      board: newBoard,
      turn: params.mark.opponent,
      humanMark: state.humanMark,
    ));
  }
}

/// Construit l'état initial d'une partie.
///
/// Fonction utilitaire pure — pas de logique métier, pas de chemin d'erreur.
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
