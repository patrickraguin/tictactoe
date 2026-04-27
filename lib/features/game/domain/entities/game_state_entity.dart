import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:tictactoe/features/game/domain/entities/board_entity.dart';
import 'package:tictactoe/features/game/domain/entities/cell_mark_enum.dart';

part 'game_state_entity.freezed.dart';

/// État de la partie.
///
/// Trois variantes possibles :
/// - [InProgressEntity] : la partie est en cours (tour actuel, indicateur CPU).
/// - [WonEntity] : un joueur a gagné (vainqueur, ligne gagnante).
/// - [DrawEntity] : la partie est nulle (plateau plein, pas de vainqueur).
@freezed
sealed class GameStateEntity with _$GameStateEntity {
  const GameStateEntity._();

  const factory GameStateEntity.inProgress({
    required BoardEntity board,
    required CellMarkEnum turn,
    required CellMarkEnum humanMark,
  }) = InProgressEntity;

  const factory GameStateEntity.won({
    required BoardEntity board,
    required CellMarkEnum winner,
    required List<int> line,
    required CellMarkEnum humanMark,
  }) = WonEntity;

  const factory GameStateEntity.draw({
    required BoardEntity board,
    required CellMarkEnum humanMark,
  }) = DrawEntity;

  @override
  BoardEntity get board => switch (this) {
        InProgressEntity(:final board) => board,
        WonEntity(:final board) => board,
        DrawEntity(:final board) => board,
      };

  @override
  CellMarkEnum get humanMark => switch (this) {
        InProgressEntity(:final humanMark) => humanMark,
        WonEntity(:final humanMark) => humanMark,
        DrawEntity(:final humanMark) => humanMark,
      };

  bool get isOver => this is! InProgressEntity;
}
