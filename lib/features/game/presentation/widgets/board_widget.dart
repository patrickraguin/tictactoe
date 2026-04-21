import 'package:flutter/material.dart';

import '../../domain/entities/board_entity.dart';
import '../../domain/entities/cell_mark_enum.dart';
import '../../domain/entities/game_state_entity.dart';
import 'cell_widget.dart';
import 'winning_line_overlay.dart';

/// Widget affichant la grille de jeu 3×3.
///
/// Rend chaque cellule via [CellWidget] et superpose [WinningLineOverlay]
/// en cas de victoire. Les cellules ne répondent aux taps que lorsque
/// c'est le tour de l'humain et que le CPU n'est pas en train de réfléchir.
class BoardWidget extends StatelessWidget {
  const BoardWidget({
    super.key,
    required this.state,
    required this.onCellTap,
  });

  final GameStateEntity state;
  final ValueChanged<int> onCellTap;

  @override
  Widget build(BuildContext context) {
    final board = state.board;
    final List<int>? winningLine = switch (state) {
      WonEntity(:final line) => line,
      _ => null,
    };
    final acceptsTaps = switch (state) {
      InProgressEntity(:final turn, :final humanMark, :final cpuThinking) =>
        turn == humanMark && !cpuThinking,
      _ => false,
    };

    const gap = 8.0;
    return AspectRatio(
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
              return CellWidget(
                key: ValueKey('cell-$i'),
                mark: mark,
                highlighted: highlighted,
                onTap: (acceptsTaps && mark == CellMarkEnum.empty)
                    ? () => onCellTap(i)
                    : null,
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
    );
  }
}
