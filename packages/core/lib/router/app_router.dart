import 'package:auto_route/auto_route.dart';
import 'package:core/router/route_contributor.dart';

class AppRouter extends RootStackRouter {
  AppRouter(this._contributors);

  final List<RouteContributor> _contributors;

  @override
  List<AutoRoute> get routes => [
        for (final contributor in _contributors) ...contributor.routes,
      ];
}
