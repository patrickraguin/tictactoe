import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_ext.dart';
import '../../../../core/router/app_router.dart';
import '../logic/controllers/score_controller.dart';
import '../widgets/score_panel.dart';

/// Page d'accueil : affiche le titre, le score cumulé et les actions principales.
///
/// Permet de lancer une nouvelle partie (→ [ConfigRoute]) ou de réinitialiser
/// le score après confirmation via une boîte de dialogue.
@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsPageTitle,
            onPressed: () => context.router.push(const SettingsRoute()),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l10n.homeTitle,
                textAlign: TextAlign.center,
                style: text.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeSubtitle,
                textAlign: TextAlign.center,
                style: text.bodyMedium,
              ),
              const SizedBox(height: 32),
              const ScorePanel(),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.router.push(const ConfigRoute()),
                icon: const Icon(Icons.play_arrow),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(l10n.homePlayButton, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _confirmReset(context, ref),
                icon: const Icon(Icons.restart_alt),
                label: Text(l10n.homeResetScoreButton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmReset = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.resetScoreDialogTitle),
        content: Text(l10n.resetScoreDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.dialogCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.dialogConfirmReset),
          ),
        ],
      ),
    );
    if (confirmReset ?? false) {
      await ref.read(scoreControllerProvider.notifier).reset();
    }
  }
}
