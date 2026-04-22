import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/game_state_entity.dart';

part 'game_ui_state.freezed.dart';

/// État UI de la partie : combine [GameStateEntity] (domaine pur) et [cpuThinking]
/// (état de présentation). Évite de polluer le domaine avec des préoccupations UI.
@freezed
abstract class GameUiState with _$GameUiState {
  const factory GameUiState({
    required GameStateEntity game,
    @Default(false) bool cpuThinking,
  }) = _GameUiState;
}
