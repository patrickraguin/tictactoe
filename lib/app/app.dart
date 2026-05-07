import 'package:core/l10n/app_localizations.dart';
import 'package:core/router/app_router.dart';
import 'package:core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_presentation/router.dart';
import 'package:settings_presentation/logic/locale_controller.dart';
import 'package:settings_presentation/router.dart';

/// Point d'entrée du widget Flutter : configure [MaterialApp.router] avec
/// le thème, la localisation (FR/EN), la locale active et le routeur [AppRouter].
///
/// [ConsumerStatefulWidget] pour conserver l'instance du routeur entre les rebuilds
/// et observer le [localeControllerProvider].
class TicTacToeApp extends ConsumerStatefulWidget {
  const TicTacToeApp({super.key});

  @override
  ConsumerState<TicTacToeApp> createState() => _TicTacToeAppState();
}

class _TicTacToeAppState extends ConsumerState<TicTacToeApp> {
  final _router = AppRouter([
    GamePresentationRouter(),
    SettingsPresentationRouter(),
  ]);

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider).asData?.value;
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router.config(),
    );
  }
}
