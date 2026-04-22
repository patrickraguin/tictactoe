import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_ext.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/cell_mark_enum.dart';
import '../../domain/entities/difficulty_enum.dart';
import '../../domain/entities/type_player_enum.dart';
import '../logic/config_notifier.dart';

/// Page de configuration d'une partie : choix du symbole, du premier joueur
/// et du niveau de difficulté avant de lancer la partie.
///
/// L'état éphémère des sélections est géré par [ConfigNotifier] (auto-dispose) :
/// chaque ouverture repart des valeurs par défaut (X / Humain / Difficile).
@RoutePage()
class ConfigPage extends ConsumerWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configNotifierProvider);
    final notifier = ref.read(configNotifierProvider.notifier);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.configPageTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SectionLabel(l10n.configYourSymbol),
              SegmentedButton<CellMarkEnum>(
                segments: const [
                  ButtonSegment(value: CellMarkEnum.x, label: Text('X')),
                  ButtonSegment(value: CellMarkEnum.o, label: Text('O')),
                ],
                selected: {config.humanMark},
                onSelectionChanged: (s) => notifier.setMark(s.first),
              ),
              const SizedBox(height: 24),
              _SectionLabel(l10n.configWhoStarts),
              SegmentedButton<TypePlayerEnum>(
                segments: [
                  ButtonSegment(
                    value: TypePlayerEnum.human,
                    label: Text(l10n.configFirstPlayerHuman),
                  ),
                  ButtonSegment(
                    value: TypePlayerEnum.cpu,
                    label: Text(l10n.configFirstPlayerCpu),
                  ),
                  ButtonSegment(
                    value: TypePlayerEnum.random,
                    label: Text(l10n.configFirstPlayerRandom),
                  ),
                ],
                selected: {config.firstPlayer},
                onSelectionChanged: (s) => notifier.setFirstPlayer(s.first),
              ),
              const SizedBox(height: 24),
              _SectionLabel(l10n.configDifficulty),
              SegmentedButton<DifficultyEnum>(
                segments: [
                  ButtonSegment(
                    value: DifficultyEnum.easy,
                    label: Text(l10n.configDifficultyEasy),
                  ),
                  ButtonSegment(
                    value: DifficultyEnum.medium,
                    label: Text(l10n.configDifficultyMedium),
                  ),
                  ButtonSegment(
                    value: DifficultyEnum.hard,
                    label: Text(l10n.configDifficultyHard),
                  ),
                ],
                selected: {config.difficulty},
                onSelectionChanged: (s) => notifier.setDifficulty(s.first),
              ),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    l10n.configStartButton,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                onPressed: () => context.router.push(GameRoute(config: config)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Libellé de section stylisé (titleMedium) avec une marge basse fixe.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );
}
