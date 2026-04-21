import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n_ext.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/cell_mark_enum.dart';
import '../../domain/entities/difficulty_enum.dart';
import '../../domain/entities/type_player_enum.dart';
import '../../domain/entities/game_config_entity.dart';

/// Page de configuration d'une partie : choix du symbole, du premier joueur
/// et du niveau de difficulté avant de lancer la partie.
///
/// Utilise un [StatefulWidget] pour gérer l'état éphémère des sélections
/// (symbole, premier joueur, difficulté) avant de construire le [GameConfigEntity].
@RoutePage()
class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  CellMarkEnum _mark = CellMarkEnum.x;
  TypePlayerEnum _first = TypePlayerEnum.human;
  DifficultyEnum _difficulty = DifficultyEnum.hard;

  @override
  Widget build(BuildContext context) {
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
                selected: {_mark},
                onSelectionChanged: (s) => setState(() => _mark = s.first),
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
                selected: {_first},
                onSelectionChanged: (s) => setState(() => _first = s.first),
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
                selected: {_difficulty},
                onSelectionChanged: (s) =>
                    setState(() => _difficulty = s.first),
              ),
              const Spacer(),
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(l10n.configStartButton, style: const TextStyle(fontSize: 18)),
                ),
                onPressed: () {
                  final config = GameConfigEntity(
                    humanMark: _mark,
                    firstPlayer: _first,
                    difficulty: _difficulty,
                  );
                  context.router.push(GameRoute(config: config));
                },
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
