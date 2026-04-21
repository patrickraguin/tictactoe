import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/persistence/shared_prefs_provider.dart';
import '../../../data/datasources/score_local_datasource.dart';
import '../../../data/repositories/score_repository_impl.dart';
import '../../../domain/repositories/score_repository.dart';

part 'score_providers.g.dart';

@Riverpod(keepAlive: true)
ScoreRepository scoreRepository(Ref ref) => ScoreRepositoryImpl(
      ScoreLocalDatasource(ref.watch(sharedPreferencesInstanceProvider)),
    );
