import 'package:auto_route/auto_route.dart';
import 'package:core/router/route_contributor.dart';
import 'package:game_presentation/game_route.dart';
import 'package:game_presentation/pages/config_page.dart';
import 'package:game_presentation/pages/home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class GamePresentationRouter implements RouteContributor {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: ConfigRoute.page),
        AutoRoute(page: GameRoute.page),
      ];
}
