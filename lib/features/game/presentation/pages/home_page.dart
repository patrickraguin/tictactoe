import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tictactoe/core/l10n_ext.dart';
import 'package:tictactoe/core/router/app_router.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/score_controller.dart';
import 'package:tictactoe/features/game/presentation/widgets/score_panel.dart';

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
              const _HeroSection(),
              const SizedBox(height: 28),
              Text(
                l10n.homeTitle,
                textAlign: TextAlign.center,
                style: text.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.homeSubtitle,
                textAlign: TextAlign.center,
                style: text.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
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

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MarkBadge('X', cs.primaryContainer, cs.primary),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'vs',
            style: text.headlineMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        _MarkBadge('O', cs.tertiaryContainer, cs.tertiary),
      ],
    );
  }
}

class _MarkBadge extends StatelessWidget {
  const _MarkBadge(this.mark, this.background, this.foreground);

  final String mark;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.center,
      child: Text(
        mark,
        style: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.w800,
          color: foreground,
          height: 1,
        ),
      ),
    );
  }
}
