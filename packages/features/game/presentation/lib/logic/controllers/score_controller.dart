import 'package:core/result/result.dart';
import 'package:game_domain/entities/score_entity.dart';
import 'package:game_domain/usecases/record_outcome.dart';
import 'package:game_presentation/logic/providers/score_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Future<void> recordWin() => _mutate(
        (s) => const RecordOutcome()(RecordOutcomeParams(current: s, outcome: GameOutcome.win)).unwrap(),
      );

  Future<void> recordLoss() => _mutate(
        (s) => const RecordOutcome()(RecordOutcomeParams(current: s, outcome: GameOutcome.loss)).unwrap(),
      );

  Future<void> recordDraw() => _mutate(
        (s) => const RecordOutcome()(RecordOutcomeParams(current: s, outcome: GameOutcome.draw)).unwrap(),
      );

  Future<void> reset() async {
    final previous = state.value;
    state = AsyncData(ScoreEntity.zero());
    final result = await ref.read(scoreRepositoryProvider).reset();
    // Rollback to previous value if persistence fails.
    if (result is! Success && previous != null) state = AsyncData(previous);
  }

  Future<void> _mutate(ScoreEntity Function(ScoreEntity) update) async {
    final current = state.value;
    if (current == null) return;
    final next = update(current);
    state = AsyncData(next);
    final result = await ref.read(scoreRepositoryProvider).save(next);
    // Rollback to previous value if persistence fails.
    if (result is Error) state = AsyncData(current);
  }
}
