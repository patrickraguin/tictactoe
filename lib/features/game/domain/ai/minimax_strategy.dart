import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/ai/ai_strategy.dart';

/// Stratégie IA de niveau difficile : algorithme minimax avec élagage alpha-bêta.
///
/// Le CPU est imbattable : il explore tous les états futurs possibles et
/// choisit le coup optimal. Le score est ajusté par la profondeur
/// (`10 - depth` / `depth - 10`) pour gagner le plus vite possible
/// et retarder une défaite inévitable.
class MinimaxStrategy extends AiStrategy {
  const MinimaxStrategy();

  @override
  int nextMove(BoardEntity board, CellMarkEnum mark) {
    final available = board.availableMoves;
    assert(available.isNotEmpty, 'No available moves');

    int bestScore = _minScore;
    int bestMove = available.first;

    for (final move in available) {
      final next = board.place(move, mark);
      final score = _minimax(
        next,
        mark.opponent,
        mark,
        1,
        _minScore,
        _maxScore,
      );
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }
    return bestMove;
  }

  static const int _maxScore = 100;
  static const int _minScore = -100;

  int _minimax(
    BoardEntity board,
    CellMarkEnum toPlay,
    CellMarkEnum aiMark,
    int depth,
    int alpha,
    int beta,
  ) {
    final winner = board.winner;
    if (winner != null) {
      return winner == aiMark ? 10 - depth : depth - 10;
    }
    if (board.isFull) return 0;

    final isMaximizing = toPlay == aiMark;
    int best = isMaximizing ? _minScore : _maxScore;

    for (final move in board.availableMoves) {
      final next = board.place(move, toPlay);
      final score = _minimax(
        next,
        toPlay.opponent,
        aiMark,
        depth + 1,
        alpha,
        beta,
      );
      if (isMaximizing) {
        if (score > best) best = score;
        if (best > alpha) alpha = best;
      } else {
        if (score < best) best = score;
        if (best < beta) beta = best;
      }
      if (beta <= alpha) break;
    }
    return best;
  }
}
