import '../../../../core/result/result.dart';
import '../../domain/entities/score_entity.dart';
import '../../domain/repositories/score_repository.dart';
import '../datasources/score_local_datasource.dart';

/// Implémentation concrète de [ScoreRepository] utilisant [ScoreLocalDatasource].
///
/// Enveloppe chaque appel à la datasource dans un try/catch et retourne
/// un [Result] pour que les erreurs de persistence soient modélisées explicitement
/// plutôt que propagées comme exceptions non contrôlées.
class ScoreRepositoryImpl implements ScoreRepository {
  ScoreRepositoryImpl(this._local);

  final ScoreLocalDatasource _local;

  @override
  Future<Result<ScoreEntity>> load() async {
    try {
      return Success(ScoreEntity(
        wins: _local.readWins(),
        losses: _local.readLosses(),
        draws: _local.readDraws(),
      ));
    } catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(ScoreEntity score) async {
    try {
      await _local.write(wins: score.wins, losses: score.losses, draws: score.draws);
      return Success(null);
    } catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> reset() async {
    try {
      await _local.clear();
      return Success(null);
    } catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }
}
