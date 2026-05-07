import 'package:auto_route/auto_route.dart';
import 'package:core/router/route_contributor.dart';
import 'package:settings_presentation/pages/settings_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class SettingsPresentationRouter implements RouteContributor {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SettingsRoute.page),
      ];
}
