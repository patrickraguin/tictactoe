import 'package:game_domain/repositories/score_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'score_providers.g.dart';

@Riverpod(keepAlive: true)
ScoreRepository scoreRepository(Ref ref) => throw UnimplementedError(
      'scoreRepositoryProvider must be overridden in ProviderScope',
    );
