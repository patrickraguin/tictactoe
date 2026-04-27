import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/difficulty_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/type_player_enum.dart';
import 'package:tictactoe/features/game/domain/usecases/resolve_first_player.dart';

class _MockRandom extends Mock implements Random {}

void main() {
  group('ResolveFirstPlayer', () {
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
      final result = const ResolveFirstPlayer()(
        makeConfig(firstPlayer: TypePlayerEnum.human, humanMark: CellMarkEnum.o),
      );
      expect(result.unwrap(), CellMarkEnum.o);
    });

    test('retourne le symbole CPU quand firstPlayer est cpu', () {
      final result = const ResolveFirstPlayer()(
        makeConfig(firstPlayer: TypePlayerEnum.cpu),
      );
      expect(result.unwrap(), CellMarkEnum.o); // opponent de X
    });

    test('retourne le symbole humain quand random donne true', () {
      final rng = _MockRandom();
      when(rng.nextBool).thenReturn(true);

      final result = ResolveFirstPlayer(random: rng)(
        makeConfig(firstPlayer: TypePlayerEnum.random),
      );
      expect(result.unwrap(), CellMarkEnum.x);
    });

    test('retourne le symbole CPU quand random donne false', () {
      final rng = _MockRandom();
      when(rng.nextBool).thenReturn(false);

      final result = ResolveFirstPlayer(random: rng)(
        makeConfig(firstPlayer: TypePlayerEnum.random),
      );
      expect(result.unwrap(), CellMarkEnum.o); // opponent de X
    });

    test('always returns Success', () {
      final result = const ResolveFirstPlayer()(
        makeConfig(firstPlayer: TypePlayerEnum.human),
      );
      expect(result, isA<Success<CellMarkEnum>>());
    });
  });
}
