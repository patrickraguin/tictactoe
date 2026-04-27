import 'package:flutter/material.dart';

import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';

/// Widget représentant une cellule individuelle du plateau.
///
/// Anime le changement de couleur de fond ([AnimatedContainer]) et l'apparition
/// du symbole X/O ([AnimatedSwitcher] + [ScaleTransition] + [FadeTransition]).
/// La taille du texte s'adapte automatiquement via [FittedBox].
/// La cellule est mise en surbrillance si elle fait partie de la ligne gagnante.
class CellWidget extends StatelessWidget {
  const CellWidget({
    super.key,
    required this.mark,
    required this.onTap,
    required this.highlighted,
  });

  final CellMarkEnum mark;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bgColor = highlighted
        ? colors.primaryContainer
        : colors.surfaceContainerHighest;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: mark.isPlayed
                  ? FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        mark == CellMarkEnum.x ? 'X' : 'O',
                        key: ValueKey(mark),
                        style: TextStyle(
                          fontSize: 200,
                          fontWeight: FontWeight.w700,
                          color: mark == CellMarkEnum.x
                              ? colors.primary
                              : colors.tertiary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
