import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n_ext.dart';
import '../../../../core/persistence/package_info_provider.dart';
import '../../application/locale_controller.dart';

@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final currentLocale = ref.watch(localeControllerProvider).asData?.value;
    final packageInfoAsync = ref.watch(packageInfoProvider);

    void setLocale(Locale? locale) =>
        ref.read(localeControllerProvider.notifier).setLocale(locale);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPageTitle)),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(l10n.settingsLanguage, style: Theme.of(context).textTheme.titleSmall),
            ),
            RadioGroup<Locale?>(
              groupValue: currentLocale,
              onChanged: setLocale,
              child: Column(
                children: [
                  RadioListTile<Locale?>(
                    title: Text(l10n.settingsLanguageSystem),
                    value: null,
                  ),
                  RadioListTile<Locale?>(
                    title: Text(l10n.settingsLanguageFr),
                    value: const Locale('fr'),
                  ),
                  RadioListTile<Locale?>(
                    title: Text(l10n.settingsLanguageEn),
                    value: const Locale('en'),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(l10n.settingsVersion),
              subtitle: packageInfoAsync.when(
                data: (info) => Text('${info.version}+${info.buildNumber}'),
                loading: () => const Text('…'),
                error: (_, __) => const Text('–'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
