import 'package:auto_route/auto_route.dart';
import 'package:game_domain/entities/game_config_entity.dart';
import 'package:game_presentation/pages/game_page.dart';

class GameRoute extends PageRouteInfo<GameConfigEntity> {
  const GameRoute({required GameConfigEntity config, List<PageRouteInfo>? children})
      : super(GameRoute.name, args: config, initialChildren: children);

  static const String name = 'GameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) => GamePage(config: data.argsAs<GameConfigEntity>()),
  );
}
