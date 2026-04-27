import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:tictactoe/features/game/domain/entities/score_entity.dart';

/// Source de données locale pour le score, basée sur [SharedPreferences].
///
/// Sérialise [ScoreEntity] en JSON dans une **seule clé** pour garantir
/// l'atomicité : une coupure entre deux écritures ne peut pas produire un
/// état incohérent (ex. victoires mises à jour, défaites non).
class ScoreLocalDatasource {
  ScoreLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const _scoreKey = 'score.v2';

  ScoreEntity read() {
    final raw = _prefs.getString(_scoreKey);
    if (raw == null) return ScoreEntity.zero();
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return ScoreEntity(
        wins: map['wins'] as int? ?? 0,
        losses: map['losses'] as int? ?? 0,
        draws: map['draws'] as int? ?? 0,
      );
    } on Object {
      return ScoreEntity.zero();
    }
  }

  Future<void> write(ScoreEntity score) async {
    final json = jsonEncode({
      'wins': score.wins,
      'losses': score.losses,
      'draws': score.draws,
    });
    await _prefs.setString(_scoreKey, json);
  }

  Future<void> clear() async {
    await _prefs.remove(_scoreKey);
  }
}
