import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/domain/usecases/play_move.dart';

const _playMove = PlayMove();

void main() {
  group('PlayMove', () {
    test('advances turn on a valid move', () {
      final state = initialState(
        board: BoardEntity.empty(),
        firstToPlay: CellMarkEnum.x,
        humanMark: CellMarkEnum.x,
      );
      final result = _playMove(PlayMoveParams(state: state, index: 0, mark: CellMarkEnum.x));
      expect(result, isA<Success<GameStateEntity>>());
      final next = (result as Success<GameStateEntity>).value;
      expect(next, isA<InProgressEntity>());
      expect((next as InProgressEntity).turn, CellMarkEnum.o);
      expect(next.board.cellAt(0), CellMarkEnum.x);
    });

    test('returns InvalidMoveFailure on occupied cell', () {
      final state = initialState(
        board: BoardEntity.empty().place(0, CellMarkEnum.x),
        firstToPlay: CellMarkEnum.o,
        humanMark: CellMarkEnum.x,
      );
      final result = _playMove(PlayMoveParams(state: state, index: 0, mark: CellMarkEnum.o));
      expect(result, isA<Error<GameStateEntity>>());
      expect((result as Error<GameStateEntity>).failure, isA<InvalidMoveFailure>());
    });

    test("returns InvalidMoveFailure when not player's turn", () {
      final state = initialState(
        board: BoardEntity.empty(),
        firstToPlay: CellMarkEnum.x,
        humanMark: CellMarkEnum.x,
      );
      final result = _playMove(PlayMoveParams(state: state, index: 0, mark: CellMarkEnum.o));
      expect(result, isA<Error<GameStateEntity>>());
      expect((result as Error<GameStateEntity>).failure, isA<InvalidMoveFailure>());
    });

    test('returns InvalidMoveFailure when game is already over', () {
      final board = BoardEntity.empty()
          .place(0, CellMarkEnum.x)
          .place(1, CellMarkEnum.x)
          .place(2, CellMarkEnum.x);
      final state = GameStateEntity.won(
        board: board,
        winner: CellMarkEnum.x,
        line: const [0, 1, 2],
        humanMark: CellMarkEnum.x,
      );
      final result = _playMove(PlayMoveParams(state: state, index: 4, mark: CellMarkEnum.o));
      expect(result, isA<Error<GameStateEntity>>());
      expect((result as Error<GameStateEntity>).failure, isA<InvalidMoveFailure>());
    });

    test('transitions to WonEntity when move completes a line', () {
      final board = BoardEntity.empty()
          .place(0, CellMarkEnum.x)
          .place(3, CellMarkEnum.o)
          .place(1, CellMarkEnum.x)
          .place(4, CellMarkEnum.o);
      final state = GameStateEntity.inProgress(
        board: board,
        turn: CellMarkEnum.x,
        humanMark: CellMarkEnum.x,
      );
      final result = _playMove(PlayMoveParams(state: state, index: 2, mark: CellMarkEnum.x));
      expect(result, isA<Success<GameStateEntity>>());
      final next = (result as Success<GameStateEntity>).value;
      expect(next, isA<WonEntity>());
      expect((next as WonEntity).line, [0, 1, 2]);
      expect(next.winner, CellMarkEnum.x);
    });

    test('transitions to DrawEntity when board fills without winner', () {
      // X O X
      // X O O
      // O X .  → X plays 8 → draw
      final board = BoardEntity(const [
        CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.x,
        CellMarkEnum.x, CellMarkEnum.o, CellMarkEnum.o,
        CellMarkEnum.o, CellMarkEnum.x, CellMarkEnum.empty,
      ]);
      final state = GameStateEntity.inProgress(
        board: board,
        turn: CellMarkEnum.x,
        humanMark: CellMarkEnum.x,
      );
      final result = _playMove(PlayMoveParams(state: state, index: 8, mark: CellMarkEnum.x));
      expect(result, isA<Success<GameStateEntity>>());
      expect((result as Success<GameStateEntity>).value, isA<DrawEntity>());
    });
  });
}
