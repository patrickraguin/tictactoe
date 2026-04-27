import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:tictactoe/core/persistence/shared_prefs_provider.dart';
import 'package:tictactoe/features/game/data/datasources/score_local_datasource.dart';
import 'package:tictactoe/features/game/data/repositories/score_repository_impl.dart';
import 'package:tictactoe/features/game/domain/repositories/score_repository.dart';

part 'score_providers.g.dart';

@Riverpod(keepAlive: true)
ScoreRepository scoreRepository(Ref ref) => ScoreRepositoryImpl(
      ScoreLocalDatasource(ref.watch(sharedPreferencesInstanceProvider)),
    );
