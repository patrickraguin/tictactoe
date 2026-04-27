import 'package:tictactoe/features/game/domain/ai/heuristic_strategy.dart';
import 'package:tictactoe/features/game/domain/ai/minimax_strategy.dart';
import 'package:tictactoe/features/game/domain/ai/random_strategy.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/difficulty_enum.dart';

/// Interface de stratégie IA pour choisir le prochain coup du CPU.
///
/// Les implémentations doivent être pures : pour un même [board] et [mark],
/// elles retournent toujours l'index d'une cellule vide valide.
/// L'aléatoire est autorisé, mais aucun I/O n'est permis.
abstract class AiStrategy {
  const AiStrategy();

  factory AiStrategy.fromDifficulty(DifficultyEnum difficulty) =>
      switch (difficulty) {
        DifficultyEnum.easy => RandomStrategy(),
        DifficultyEnum.medium => HeuristicStrategy(),
        DifficultyEnum.hard => const MinimaxStrategy(),
      };

  int nextMove(BoardEntity board, CellMarkEnum mark);
}
