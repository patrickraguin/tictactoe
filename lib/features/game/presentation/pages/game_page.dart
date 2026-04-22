import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_ext.dart';
import '../logic/controllers/game_controller.dart';
import '../logic/recorders/game_outcome_recorder.dart';
import '../../domain/entities/game_config_entity.dart';
import '../widgets/board_widget.dart';
import '../widgets/game_end_actions.dart';
import '../widgets/game_status_banner.dart';
import '../widgets/score_panel.dart';

/// Page principale de jeu : orchestre le plateau, le statut de la partie
/// et le panneau de score. Écoute [GameController] et [GameOutcomeRecorder].
@RoutePage()
class GamePage extends ConsumerWidget {
  const GamePage({super.key, required this.config});

  final GameConfigEntity config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(gameOutcomeRecorderProvider(config));
    final uiState = ref.watch(gameControllerProvider(config));
    final controller = ref.read(gameControllerProvider(config).notifier);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gamePageTitle),
        actions: [
          IconButton(
            tooltip: l10n.gameRestartTooltip,
            icon: const Icon(Icons.refresh),
            onPressed: controller.restart,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GameStatusBanner(state: uiState.game, cpuThinking: uiState.cpuThinking),
              const SizedBox(height: 16),
              BoardWidget(
                state: uiState.game,
                cpuThinking: uiState.cpuThinking,
                onCellTap: controller.playHumanMove,
              ),
              const Spacer(),
              const ScorePanel(),
              const SizedBox(height: 12),
              if (uiState.game.isOver)
                GameEndActions(
                  onReplay: controller.restart,
                  onChangeConfig: () => context.router.maybePop(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
