import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/presentation/pages/config_page.dart';
import 'package:tictactoe/features/game/presentation/pages/game_page.dart';
import 'package:tictactoe/features/game/presentation/pages/home_page.dart';
import 'package:tictactoe/features/settings/presentation/pages/settings_page.dart';

part 'app_router.gr.dart';

/// Routeur principal de l'application, généré par auto_route.
///
/// Déclare les quatre routes de l'application : [HomeRoute], [ConfigRoute],
/// [GameRoute] et [SettingsRoute].
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: ConfigRoute.page),
        AutoRoute(page: GameRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ];
}
