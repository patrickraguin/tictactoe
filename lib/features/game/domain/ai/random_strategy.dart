import 'dart:math';

import '../entities/board_entity.dart';
import '../entities/cell_mark_enum.dart';
import 'ai_strategy.dart';

/// Stratégie IA de niveau facile : choisit un coup au hasard parmi les cases libres.
///
/// [Random] peut être injecté pour faciliter les tests déterministes.
class RandomStrategy extends AiStrategy {
  RandomStrategy({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  int nextMove(BoardEntity board, CellMarkEnum _) {
    final moves = board.availableMoves;
    assert(moves.isNotEmpty, 'No available moves');
    return moves[_random.nextInt(moves.length)];
  }
}
