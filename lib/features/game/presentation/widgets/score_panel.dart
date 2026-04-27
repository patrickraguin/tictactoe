import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tictactoe/core/l10n_ext.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/score_controller.dart';

/// Panneau affichant le score cumulé (victoires, nuls, défaites).
///
/// Gère les trois états asynchrones de [ScoreController] :
/// chargement (indicateur), erreur (message) et données ([_ScoreChunk] × 3).
/// Réutilisable sur [HomePage] et [GamePage].
class ScorePanel extends ConsumerWidget {
  const ScorePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(scoreControllerProvider);
    final l10n = context.l10n;
    return scoreAsync.when(
      loading: () => const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 16, color: Theme.of(context).colorScheme.error),
          const SizedBox(width: 8),
          Text(
            l10n.scoreLoadError,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () => ref.invalidate(scoreControllerProvider),
            child: Text(l10n.scoreRetry),
          ),
        ],
      ),
      data: (score) {
        final cs = Theme.of(context).colorScheme;
        return Semantics(
          label: l10n.semanticsScoreSummary(score.wins, score.draws, score.losses),
          excludeSemantics: true,
          child: Row(
            children: [
              Expanded(
                child: _ScoreChunk(
                  label: l10n.scoreWins,
                  value: score.wins,
                  valueColor: cs.primary,
                  backgroundColor: cs.primaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ScoreChunk(
                  label: l10n.scoreDraws,
                  value: score.draws,
                  valueColor: cs.onSurfaceVariant,
                  backgroundColor: cs.surfaceContainerHighest,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ScoreChunk(
                  label: l10n.scoreLosses,
                  value: score.losses,
                  valueColor: cs.error,
                  backgroundColor: cs.errorContainer,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScoreChunk extends StatelessWidget {
  const _ScoreChunk({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.backgroundColor,
  });

  final String label;
  final int value;
  final Color valueColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$value',
            style: text.headlineSmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: text.labelMedium?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
