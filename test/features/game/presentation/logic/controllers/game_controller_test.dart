import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';
import 'package:tictactoe/features/game/domain/entities/difficulty_enum.dart';
import 'package:tictactoe/features/game/domain/entities/game_config_entity.dart';
import 'package:tictactoe/features/game/domain/entities/game_state_entity.dart';
import 'package:tictactoe/features/game/domain/entities/type_player_enum.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/game_controller.dart';

import '../../../../../helpers/provider_helpers.dart';

const _humanFirstConfig = GameConfigEntity(
  humanMark: CellMarkEnum.x,
  firstPlayer: TypePlayerEnum.human,
  difficulty: DifficultyEnum.easy,
);

const _cpuFirstConfig = GameConfigEntity(
  humanMark: CellMarkEnum.x,
  firstPlayer: TypePlayerEnum.cpu,
  difficulty: DifficultyEnum.easy,
);

void main() {
  group('initial state', () {
    test('is InProgress with human turn when human goes first', () {
      final container = makeContainer();
      final sub = container.listen(gameControllerProvider(_humanFirstConfig), (_, _) {});
      addTearDown(sub.close);

      final uiState = sub.read();

      expect(uiState.game, isA<InProgressEntity>());
      expect((uiState.game as InProgressEntity).turn, CellMarkEnum.x);
      expect(uiState.game.humanMark, CellMarkEnum.x);
    });

    test('is InProgress with CPU turn when CPU goes first', () {
      final container = makeContainer();
      final sub = container.listen(gameControllerProvider(_cpuFirstConfig), (_, _) {});
      addTearDown(sub.close);

      final uiState = sub.read();

      expect(uiState.game, isA<InProgressEntity>());
      expect((uiState.game as InProgressEntity).turn, CellMarkEnum.o); // CPU plays O
    });

    test('board is empty at start', () {
      final container = makeContainer();
      final sub = container.listen(gameControllerProvider(_humanFirstConfig), (_, _) {});
      addTearDown(sub.close);

      expect(sub.read().game.board.cells.every((c) => c.isEmpty), isTrue);
    });
  });

  group('playHumanMove', () {
    test('places human mark on the board', () {
      final container = makeContainer();
      final sub = container.listen(gameControllerProvider(_humanFirstConfig), (_, _) {});
      addTearDown(sub.close);

      fakeAsync((fake) {
        container.read(gameControllerProvider(_humanFirstConfig).notifier).playHumanMove(4);

        expect(sub.read().game.board.cellAt(4), CellMarkEnum.x);
      });
    });

    test('sets cpuThinking=true immediately after human plays', () {
      final container = makeContainer();
      final sub = container.listen(gameControllerProvider(_humanFirstConfig), (_, _) {});
      addTearDown(sub.close);

      fakeAsync((fake) {
        container.read(gameControllerProvider(_humanFirstConfig).notifier).playHumanMove(0);

        // Synchronous path: human move applied, cpuThinking scheduled before delay
        expect(sub.read().cpuThinking, isTrue);
      });
    });

    test('CPU plays exactly after 400 ms thinking delay', () {
      final container = makeContainer();
      final sub = container.listen(gameControllerProvider(_humanFirstConfig), (_, _) {});
      addTearDown(sub.close);

      fakeAsync((fake) {
        container.read(gameControllerProvider(_humanFirstConfig).notifier).playHumanMove(0);

        // Just before delay: CPU has not played yet
        fake.elapse(const Duration(milliseconds: 399));
        expect(sub.read().cpuThinking, isTrue);

        // At/after the delay: CPU has played (board has 2 pieces)
        fake.elapse(const Duration(milliseconds: 1));
        final uiState = sub.read();
        expect(uiState.game.board.cells.where((c) => c.isPlayed).length, 2);
        expect(uiState.cpuThinking, isFalse);
        expect((uiState.game as InProgressEntity).turn, CellMarkEnum.x); // back to human
      });
    });

    test('is ignored when it is not the human turn', () {
      final container = makeContainer();
      // CPU goes first → turn is O (CPU), human cannot play
      final sub = container.listen(gameControllerProvider(_cpuFirstConfig), (_, _) {});
      addTearDown(sub.close);

      // Board is empty, turn = O (CPU); human tries to play
      container.read(gameControllerProvider(_cpuFirstConfig).notifier).playHumanMove(0);

      expect(sub.read().game.board.cellAt(0), CellMarkEnum.empty);
    });
  });

  group('CPU goes first', () {
    test('plays opening move after microtask + 400 ms delay', () {
      final container = makeContainer();

      fakeAsync((fake) {
        // Create subscription INSIDE fakeAsync so the build() microtask is in the fake zone
        final sub = container.listen(gameControllerProvider(_cpuFirstConfig), (_, _) {});

        // Flush microtask that starts _playCpuIfNeeded
        fake.flushMicrotasks();
        expect(sub.read().cpuThinking, isTrue);

        fake.elapse(const Duration(milliseconds: 400));

        final uiState = sub.read();
        expect(uiState.game.board.cells.where((c) => c.isPlayed).length, 1);
        expect((uiState.game as InProgressEntity).turn, CellMarkEnum.x); // now human's turn
      });
    });
  });

  group('restart', () {
    test('resets board to empty and returns to initial turn', () {
      final container = makeContainer();
      final sub = container.listen(gameControllerProvider(_humanFirstConfig), (_, _) {});
      addTearDown(sub.close);

      fakeAsync((fake) {
        // Play a move and wait for CPU to respond (400 ms fixed delay)
        container.read(gameControllerProvider(_humanFirstConfig).notifier).playHumanMove(0);
        fake.elapse(const Duration(milliseconds: 400));
        expect(sub.read().game.board.cells.where((c) => c.isPlayed).length, 2);

        // Restart
        container.read(gameControllerProvider(_humanFirstConfig).notifier).restart();

        // Flush restart microtask (no CPU delay since human goes first)
        fake.flushMicrotasks();

        expect(sub.read().game.board.cells.every((c) => c.isEmpty), isTrue);
        expect((sub.read().game as InProgressEntity).turn, CellMarkEnum.x);
      });
    });
  });
}
