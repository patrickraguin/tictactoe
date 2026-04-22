import 'package:shared_preferences/shared_preferences.dart';

/// Source de données locale pour le score, basée sur [SharedPreferences].
///
/// Encapsule les clés de stockage et fournit des méthodes de lecture synchrone
/// et d'écriture/suppression asynchrone via [Future.wait] pour paralléliser les appels.
class ScoreLocalDatasource {
  ScoreLocalDatasource(this._prefs);

  final SharedPreferences _prefs;

  static const _winsKey = 'score.wins';
  static const _lossesKey = 'score.losses';
  static const _drawsKey = 'score.draws';

  // SharedPreferences est synchrone après la première initialisation (await getInstance).
  // L'asymétrie read-sync / write-async est intentionnelle et garantie par le framework.
  int readWins() => _prefs.getInt(_winsKey) ?? 0;
  int readLosses() => _prefs.getInt(_lossesKey) ?? 0;
  int readDraws() => _prefs.getInt(_drawsKey) ?? 0;

  Future<void> write({required int wins, required int losses, required int draws}) async {
    await Future.wait([
      _prefs.setInt(_winsKey, wins),
      _prefs.setInt(_lossesKey, losses),
      _prefs.setInt(_drawsKey, draws),
    ]);
  }

  Future<void> clear() async {
    await Future.wait([
      _prefs.remove(_winsKey),
      _prefs.remove(_lossesKey),
      _prefs.remove(_drawsKey),
    ]);
  }
}
