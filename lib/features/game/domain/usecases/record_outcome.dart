import 'package:tictactoe/core/domain/use_case.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';

/// Issue possible d'une partie.
enum GameOutcome { win, loss, draw }

class RecordOutcomeParams {
  const RecordOutcomeParams({required this.current, required this.outcome});

  final ScoreEntity current;
  final GameOutcome outcome;
}

/// Applique le résultat d'une partie et retourne le score mis à jour.
///
/// Toujours un [Success] — aucun chemin d'erreur possible.
class RecordOutcome implements UseCase<RecordOutcomeParams, ScoreEntity> {
  const RecordOutcome();

  @override
  Result<ScoreEntity> call(RecordOutcomeParams params) => Success(
        switch (params.outcome) {
          GameOutcome.win => params.current.copyWith(wins: params.current.wins + 1),
          GameOutcome.loss => params.current.copyWith(losses: params.current.losses + 1),
          GameOutcome.draw => params.current.copyWith(draws: params.current.draws + 1),
        },
      );
}
