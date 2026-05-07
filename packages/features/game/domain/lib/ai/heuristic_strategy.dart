import 'dart:math';

import 'package:game_domain/ai/ai_strategy.dart';
import 'package:game_domain/entities/board_entity.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';

/// Stratégie IA de niveau moyen basée sur des règles heuristiques.
///
/// Ordre de priorité des coups :
/// 1. Jouer le coup gagnant s'il existe.
/// 2. Bloquer le coup gagnant de l'adversaire.
/// 3. Prendre le centre.
/// 4. Prendre un coin libre (au hasard).
/// 5. Prendre un côté libre (au hasard).
class HeuristicStrategy extends AiStrategy {
  HeuristicStrategy({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const List<int> _corners = [0, 2, 6, 8];
  static const List<int> _sides = [1, 3, 5, 7];
  static const int _center = 4;

  @override
  int nextMove(BoardEntity board, CellMarkEnum mark) {
    final available = board.availableMoves;
    assert(available.isNotEmpty, 'No available moves');

    final winning = _findDecisiveMove(board, mark);
    if (winning != null) return winning;

    final blocking = _findDecisiveMove(board, mark.opponent);
    if (blocking != null) return blocking;

    if (available.contains(_center)) return _center;

    final freeCorners = _corners.where(available.contains).toList();
    if (freeCorners.isNotEmpty) {
      return freeCorners[_random.nextInt(freeCorners.length)];
    }

    final freeSides = _sides.where(available.contains).toList();
    return freeSides[_random.nextInt(freeSides.length)];
  }

  /// Returns an index where placing [mark] completes a winning line, or null.
  int? _findDecisiveMove(BoardEntity board, CellMarkEnum mark) {
    for (final i in board.availableMoves) {
      final hypothetical = board.place(i, mark);
      if (hypothetical.winningLineFor(mark) != null) return i;
    }
    return null;
  }
}
