import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/difficulty_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/type_player_enum.dart';
import 'package:tictactoe/features/game/domain/usecases/resolve_first_player.dart';

class _MockRandom extends Mock implements Random {}

void main() {
  group('resolveFirstPlayer', () {
    GameConfigEntity makeConfig({
      required TypePlayerEnum firstPlayer,
      CellMarkEnum humanMark = CellMarkEnum.x,
    }) =>
        GameConfigEntity(
          humanMark: humanMark,
          firstPlayer: firstPlayer,
          difficulty: DifficultyEnum.hard,
        );

    test('retourne le symbole humain quand firstPlayer est human', () {
      final mark = resolveFirstPlayer(
        makeConfig(firstPlayer: TypePlayerEnum.human, humanMark: CellMarkEnum.o),
      );
      expect(mark, CellMarkEnum.o);
    });

    test('retourne le symbole CPU quand firstPlayer est cpu', () {
      final mark = resolveFirstPlayer(
        makeConfig(firstPlayer: TypePlayerEnum.cpu, humanMark: CellMarkEnum.x),
      );
      expect(mark, CellMarkEnum.o); // opponent de X
    });

    test('retourne le symbole humain quand random donne true', () {
      final rng = _MockRandom();
      when(() => rng.nextBool()).thenReturn(true);

      final mark = resolveFirstPlayer(
        makeConfig(firstPlayer: TypePlayerEnum.random, humanMark: CellMarkEnum.x),
        random: rng,
      );
      expect(mark, CellMarkEnum.x);
    });

    test('retourne le symbole CPU quand random donne false', () {
      final rng = _MockRandom();
      when(() => rng.nextBool()).thenReturn(false);

      final mark = resolveFirstPlayer(
        makeConfig(firstPlayer: TypePlayerEnum.random, humanMark: CellMarkEnum.x),
        random: rng,
      );
      expect(mark, CellMarkEnum.o); // opponent de X
    });
  });
}
