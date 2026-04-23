import 'package:flutter/material.dart';

import '../../../../core/l10n_ext.dart';
import '../../domain/entities/game_state_entity.dart';

/// Bandeau de statut animé indiquant le tour actuel ou le résultat de la partie.
///
/// Utilise [AnimatedSwitcher] pour une transition fluide entre les messages.
/// L'icône, la couleur et le fond s'adaptent automatiquement à l'état du jeu.
class GameStatusBanner extends StatelessWidget {
  const GameStatusBanner({super.key, required this.state, required this.cpuThinking});

  final GameStateEntity state;
  final bool cpuThinking;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    final message = switch (state) {
      InProgressEntity() when cpuThinking => l10n.gameCpuThinking,
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

    final (fgColor, bgColor) = switch (state) {
      WonEntity(:final winner, :final humanMark) when winner == humanMark =>
        (cs.primary, cs.primaryContainer),
      WonEntity() => (cs.error, cs.errorContainer),
      DrawEntity() => (cs.onSurfaceVariant, cs.surfaceContainerHighest),
      _ => (cs.onSurface, cs.surfaceContainerLow),
    };

    return Semantics(
      liveRegion: true,
      label: message,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Row(
            key: ValueKey(message),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: fgColor),
              const SizedBox(width: 8),
              Text(message, style: text.titleLarge?.copyWith(color: fgColor)),
            ],
          ),
        ),
      ),
    );
  }
}
