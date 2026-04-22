import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/result/result.dart';
import '../../../domain/entities/score_entity.dart';
import '../../../domain/usecases/record_outcome.dart';
import '../providers/score_providers.dart';

part 'score_controller.g.dart';

/// Gestionnaire d'état du score (Riverpod AsyncNotifier, keepAlive).
///
/// Charge le score depuis [ScoreRepository] à l'initialisation, expose
/// des méthodes de mutation ([recordWin], [recordLoss], [recordDraw], [reset])
/// qui mettent à jour l'état en mémoire puis persistent immédiatement sur disque.
///
/// Les transitions d'état sont loguées automatiquement par [AppProviderObserver].
@Riverpod(keepAlive: true)
class ScoreController extends _$ScoreController {
  @override
  Future<ScoreEntity> build() async {
    final repo = ref.watch(scoreRepositoryProvider);
    final result = await repo.load();
    return switch (result) {
      Success(:final value) => value,
      Error(:final failure) => throw StorageException(failure.message),
    };
  }

  Future<void> recordWin() => _mutate((s) => recordOutcome(s, GameOutcome.win));
  Future<void> recordLoss() => _mutate((s) => recordOutcome(s, GameOutcome.loss));
  Future<void> recordDraw() => _mutate((s) => recordOutcome(s, GameOutcome.draw));

  Future<void> reset() async {
    await ref.read(scoreRepositoryProvider).reset();
    state = AsyncData(ScoreEntity.zero());
  }

  Future<void> _mutate(ScoreEntity Function(ScoreEntity) update) async {
    final current = state.value;
    if (current == null) return;
    final next = update(current);
    state = AsyncData(next);
    await ref.read(scoreRepositoryProvider).save(next);
  }
}
