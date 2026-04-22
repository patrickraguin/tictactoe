import '../entities/score_entity.dart';

/// Issue possible d'une partie.
enum GameOutcome { win, loss, draw }

/// Applique le résultat d'une partie et retourne le score mis à jour.
///
/// Fonction pure — sans I/O ni effets de bord.
ScoreEntity recordOutcome(ScoreEntity current, GameOutcome outcome) =>
    switch (outcome) {
      GameOutcome.win => current.copyWith(wins: current.wins + 1),
      GameOutcome.loss => current.copyWith(losses: current.losses + 1),
      GameOutcome.draw => current.copyWith(draws: current.draws + 1),
    };
