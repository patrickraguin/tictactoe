import 'package:flutter/material.dart';

import 'package:tictactoe/core/l10n_ext.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/presentation/widgets/cell_widget.dart';
import 'package:tictactoe/features/game/presentation/widgets/winning_line_overlay.dart';

/// Widget affichant la grille de jeu 3×3.
///
/// Rend chaque cellule via [CellWidget] et superpose [WinningLineOverlay]
/// en cas de victoire. Les cellules ne répondent aux taps que lorsque
/// c'est le tour de l'humain et que le CPU n'est pas en train de réfléchir.
/// Chaque cellule expose un label sémantique pour les lecteurs d'écran.
class BoardWidget extends StatelessWidget {
  const BoardWidget({
    required this.state, required this.cpuThinking, required this.onCellTap, super.key,
  });

  final GameStateEntity state;
  final bool cpuThinking;
  final ValueChanged<int> onCellTap;

  @override
  Widget build(BuildContext context) {
    final board = state.board;
    final l10n = context.l10n;
    final List<int>? winningLine = switch (state) {
      WonEntity(:final line) => line,
      _ => null,
    };
    final acceptsTaps = switch (state) {
      InProgressEntity(:final turn, :final humanMark) => turn == humanMark && !cpuThinking,
      _ => false,
    };

    const gap = 8.0;
    return Semantics(
      label: l10n.semanticsGameBoard,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: BoardEntity.size,
                mainAxisSpacing: gap,
                crossAxisSpacing: gap,
              ),
              itemCount: BoardEntity.cellCount,
              itemBuilder: (context, i) {
                final mark = board.cellAt(i);
                final highlighted = winningLine?.contains(i) ?? false;
                final canTap = acceptsTaps && mark == CellMarkEnum.empty;
                final row = i ~/ 3 + 1;
                final col = i % 3 + 1;
                final semanticsLabel = mark.isPlayed
                    ? l10n.semanticsCellPlayed(row, col, mark == CellMarkEnum.x ? 'X' : 'O')
                    : l10n.semanticsCellEmpty(row, col);
                return Semantics(
                  label: semanticsLabel,
                  button: canTap,
                  // Suppress inner Text ('X'/'O') to avoid double-reading.
                  excludeSemantics: true,
                  child: CellWidget(
                    key: ValueKey('cell-$i'),
                    mark: mark,
                    highlighted: highlighted,
                    onTap: canTap ? () => onCellTap(i) : null,
                  ),
                );
              },
            ),
            if (winningLine != null)
              Positioned.fill(
                child: WinningLineOverlay(
                  line: winningLine,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
