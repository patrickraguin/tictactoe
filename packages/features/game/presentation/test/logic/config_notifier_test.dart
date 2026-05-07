import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/entities/cell_mark_enum.dart';
import 'package:game_domain/entities/difficulty_enum.dart';
import 'package:game_domain/entities/type_player_enum.dart';
import 'package:game_presentation/logic/config_notifier.dart';

import '../helpers/provider_helpers.dart';

void main() {
  group('ConfigNotifier', () {
    test('initial state is X / human / hard', () {
      final container = makeContainer();
      final sub = container.listen(configNotifierProvider, (_, _) {});
      addTearDown(sub.close);

      final config = sub.read();
      expect(config.humanMark, CellMarkEnum.x);
      expect(config.firstPlayer, TypePlayerEnum.human);
      expect(config.difficulty, DifficultyEnum.hard);
    });

    test('setMark(o) updates humanMark', () {
      final container = makeContainer();
      final sub = container.listen(configNotifierProvider, (_, _) {});
      addTearDown(sub.close);

      container.read(configNotifierProvider.notifier).setMark(CellMarkEnum.o);

      expect(sub.read().humanMark, CellMarkEnum.o);
    });

    test('setFirstPlayer(cpu) updates firstPlayer', () {
      final container = makeContainer();
      final sub = container.listen(configNotifierProvider, (_, _) {});
      addTearDown(sub.close);

      container.read(configNotifierProvider.notifier).setFirstPlayer(TypePlayerEnum.cpu);

      expect(sub.read().firstPlayer, TypePlayerEnum.cpu);
    });

    test('setDifficulty(easy) updates difficulty', () {
      final container = makeContainer();
      final sub = container.listen(configNotifierProvider, (_, _) {});
      addTearDown(sub.close);

      container.read(configNotifierProvider.notifier).setDifficulty(DifficultyEnum.easy);

      expect(sub.read().difficulty, DifficultyEnum.easy);
    });

    test('mutations are independent — unrelated fields stay at default', () {
      final container = makeContainer();
      final sub = container.listen(configNotifierProvider, (_, _) {});
      addTearDown(sub.close);

      final config = sub.read();
      expect(config.humanMark, CellMarkEnum.o);
      expect(config.firstPlayer, TypePlayerEnum.human);
      expect(config.difficulty, DifficultyEnum.medium);
    });
  });
}
