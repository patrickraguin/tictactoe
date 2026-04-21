import 'package:flutter/material.dart';

import '../../../../core/l10n_ext.dart';
import '../../domain/entities/game_state_entity.dart';

/// Bandeau de statut animé indiquant le tour actuel ou le résultat de la partie.
///
/// Utilise [AnimatedSwitcher] pour une transition fluide entre les messages.
/// L'icône et la couleur s'adaptent automatiquement à l'état du jeu.
class GameStatusBanner extends StatelessWidget {
  const GameStatusBanner({super.key, required this.state});

  final GameStateEntity state;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final message = switch (state) {
      InProgressEntity(cpuThinking: true) => l10n.gameCpuThinking,
      InProgressEntity(:final turn, :final humanMark) =>
        turn == humanMark ? l10n.gameYourTurn : l10n.gameCpuTurn,
      WonEntity(:final winner, :final humanMark) =>
        winner == humanMark ? l10n.gameYouWin : l10n.gameCpuWins,
      DrawEntity() => l10n.gameDraw,
    };
    final icon = switch (state) {
      WonEntity(:final winner, :final humanMark) =>
        winner == humanMark ? Icons.emoji_events : Icons.sentiment_dissatisfied,
      DrawEntity() => Icons.handshake,
      _ => Icons.sports_esports,
    };
    final color = switch (state) {
      WonEntity(:final winner, :final humanMark) => winner == humanMark
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.error,
      _ => Theme.of(context).colorScheme.onSurface,
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Row(
        key: ValueKey(message),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(message, style: text.titleLarge?.copyWith(color: color)),
        ],
      ),
    );
  }
}
