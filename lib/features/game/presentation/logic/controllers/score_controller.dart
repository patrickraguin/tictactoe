import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/score_entity.dart';
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
    return repo.load();
  }

  Future<void> recordWin() => _mutate((s) => s.copyWith(wins: s.wins + 1));
  Future<void> recordLoss() => _mutate((s) => s.copyWith(losses: s.losses + 1));
  Future<void> recordDraw() => _mutate((s) => s.copyWith(draws: s.draws + 1));

  Future<void> reset() async {
    final repo = ref.read(scoreRepositoryProvider);
    await repo.reset();
    state = AsyncData(ScoreEntity.zero());
  }

  Future<void> _mutate(ScoreEntity Function(ScoreEntity) update) async {
    final current = state.value ?? ScoreEntity.zero();
    final next = update(current);
    state = AsyncData(next);
    await ref.read(scoreRepositoryProvider).save(next);
  }
}
