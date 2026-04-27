import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tictactoe/core/l10n_ext.dart';
import 'package:tictactoe/core/persistence/package_info_provider.dart';
import 'package:tictactoe/features/settings/presentation/logic/locale_controller.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final localeAsync = ref.watch(localeControllerProvider);
    final currentLocale = localeAsync.asData?.value;
    final packageInfoAsync = ref.watch(packageInfoProvider);

    void setLocale(Locale? locale) =>
        ref.read(localeControllerProvider.notifier).setLocale(locale);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPageTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _SectionHeader(icon: Icons.language_outlined, label: l10n.settingsLanguage),
            if (localeAsync.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: cs.errorContainer,
                  child: ListTile(
                    leading: Icon(Icons.error_outline, color: cs.error),
                    title: Text(
                      l10n.settingsLanguageLoadError,
                      style: TextStyle(color: cs.onErrorContainer),
                    ),
                    trailing: TextButton(
                      onPressed: () => ref.invalidate(localeControllerProvider),
                      child: Text(l10n.retry),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: RadioGroup<Locale?>(
                    groupValue: currentLocale,
                    onChanged: setLocale,
                    child: Column(
                      children: [
                        RadioListTile<Locale?>(
                          title: Text(l10n.settingsLanguageSystem),
                          value: null,
                        ),
                        const Divider(indent: 16, endIndent: 16, height: 1),
                        RadioListTile<Locale?>(
                          title: Text(l10n.settingsLanguageFr),
                          value: const Locale('fr'),
                        ),
                        const Divider(indent: 16, endIndent: 16, height: 1),
                        RadioListTile<Locale?>(
                          title: Text(l10n.settingsLanguageEn),
                          value: const Locale('en'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.tag, color: cs.primary),
                  title: Text(l10n.settingsVersion),
                  trailing: packageInfoAsync.when(
                    data: (info) => Text(
                      '${info.version}+${info.buildNumber}',
                      style: text.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    loading: () => const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, _) => const Text('–'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: cs.primary,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}
