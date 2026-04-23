import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/data/datasources/score_local_datasource.dart';
import 'package:tictactoe/features/game/data/repositories/score_repository_impl.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('save then load returns the same score', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = ScoreRepositoryImpl(ScoreLocalDatasource(prefs));

    final saveResult = await repo.save(const ScoreEntity(wins: 3, losses: 1, draws: 2));
    expect(saveResult, isA<Success<void>>());

    final loadResult = await repo.load();
    expect(loadResult, isA<Success<ScoreEntity>>());
    expect((loadResult as Success<ScoreEntity>).value, const ScoreEntity(wins: 3, losses: 1, draws: 2));
  });

  test('reset clears persisted score', () async {
    SharedPreferences.setMockInitialValues({
      'score.v2': jsonEncode({'wins': 5, 'losses': 4, 'draws': 2}),
    });
    final prefs = await SharedPreferences.getInstance();
    final repo = ScoreRepositoryImpl(ScoreLocalDatasource(prefs));

    final resetResult = await repo.reset();
    expect(resetResult, isA<Success<void>>());

    final loadResult = await repo.load();
    expect((loadResult as Success<ScoreEntity>).value, ScoreEntity.zero());
  });

  test('load returns zero score when no data is stored', () async {
    final prefs = await SharedPreferences.getInstance();
    final repo = ScoreRepositoryImpl(ScoreLocalDatasource(prefs));

    final result = await repo.load();
    expect((result as Success<ScoreEntity>).value, ScoreEntity.zero());
  });

  test('load returns zero score when stored JSON is corrupted', () async {
    SharedPreferences.setMockInitialValues({'score.v2': 'not-valid-json'});
    final prefs = await SharedPreferences.getInstance();
    final repo = ScoreRepositoryImpl(ScoreLocalDatasource(prefs));

    final result = await repo.load();
    expect((result as Success<ScoreEntity>).value, ScoreEntity.zero());
  });
}
