import 'package:core/result/result.dart';
import 'package:game_data/datasources/score_local_datasource.dart';
import 'package:game_domain/entities/score_entity.dart';
import 'package:game_domain/repositories/score_repository.dart';

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
      return Success(_local.read());
    } on Object catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> save(ScoreEntity score) async {
    try {
      await _local.write(score);
      return const Success(null);
    } on Object catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> reset() async {
    try {
      await _local.clear();
      return const Success(null);
    } on Object catch (e) {
      return Error(StorageFailure(e.toString()));
    }
  }
}
