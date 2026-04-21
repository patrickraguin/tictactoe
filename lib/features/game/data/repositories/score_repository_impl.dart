import '../../domain/entities/score_entity.dart';
import '../../domain/repositories/score_repository.dart';
import '../datasources/score_local_datasource.dart';

/// Implémentation concrète de [ScoreRepository] utilisant [ScoreLocalDatasource].
///
/// Adapte les méthodes de la datasource au contrat défini par le domaine.
class ScoreRepositoryImpl implements ScoreRepository {
  ScoreRepositoryImpl(this._local);

  final ScoreLocalDatasource _local;

  @override
  Future<ScoreEntity> load() async => ScoreEntity(
        wins: _local.readWins(),
        losses: _local.readLosses(),
        draws: _local.readDraws(),
      );

  @override
  Future<void> save(ScoreEntity score) => _local.write(
        wins: score.wins,
        losses: score.losses,
        draws: score.draws,
      );

  @override
  Future<void> reset() => _local.clear();
}
