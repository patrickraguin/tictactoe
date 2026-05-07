import 'package:core/l10n_ext.dart';
import 'package:flutter/material.dart';

/// Boutons d'action affichés à la fin d'une partie.
///
/// Propose de rejouer la même configuration ([onReplay])
/// ou de revenir à l'écran de configuration ([onChangeConfig]).
/// Sans dépendance Riverpod : les callbacks sont injectés par [GamePage].
class GameEndActions extends StatelessWidget {
  const GameEndActions({
    required this.onReplay, required this.onChangeConfig, super.key,
  });

  final VoidCallback onReplay;
  final VoidCallback onChangeConfig;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onChangeConfig,
            icon: const Icon(Icons.tune),
            label: Text(l10n.gameChangeConfig),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: onReplay,
            icon: const Icon(Icons.replay),
            label: Text(l10n.gameReplay),
          ),
        ),
      ],
    );
  }
}
