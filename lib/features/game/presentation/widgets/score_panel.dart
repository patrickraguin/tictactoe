import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_ext.dart';
import '../logic/controllers/score_controller.dart';

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
      error: (_, __) => Row(
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
      data: (score) => Semantics(
        label: l10n.semanticsScoreSummary(score.wins, score.draws, score.losses),
        // Suppress individual _ScoreChunk texts to avoid redundant reading.
        excludeSemantics: true,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ScoreChunk(label: l10n.scoreWins, value: score.wins),
                _ScoreChunk(label: l10n.scoreDraws, value: score.draws),
                _ScoreChunk(label: l10n.scoreLosses, value: score.losses),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Colonne affichant une valeur numérique et son libellé (ex. "3 Victoires").
class _ScoreChunk extends StatelessWidget {
  const _ScoreChunk({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$value', style: text.headlineSmall),
        Text(label, style: text.labelMedium),
      ],
    );
  }
}
