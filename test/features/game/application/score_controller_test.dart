import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/game/domain/entities/score_entity.dart';
import 'package:tictactoe/features/game/presentation/logic/controllers/score_controller.dart';
import 'package:tictactoe/features/game/presentation/logic/providers/score_providers.dart';

import '../../../helpers/mock_score_repository.dart';
import '../../../helpers/provider_helpers.dart';

void main() {
  late MockScoreRepository mockRepo;

  setUpAll(registerScoreFallbacks);

  setUp(() {
    mockRepo = MockScoreRepository();
    when(() => mockRepo.load()).thenAnswer((_) async => Success(ScoreEntity.zero()));
    when(() => mockRepo.save(any())).thenAnswer((_) async => Success(Unit.instance));
    when(() => mockRepo.reset()).thenAnswer((_) async => Success(Unit.instance));
  });

  makeScoreContainer() => makeContainer(overrides: [
        scoreRepositoryProvider.overrideWithValue(mockRepo),
      ]);

  test('loads score from repository on init', () async {
    when(() => mockRepo.load())
        .thenAnswer((_) async => const Success(ScoreEntity(wins: 3, losses: 1, draws: 2)));

    final container = makeScoreContainer();
    final score = await container.read(scoreControllerProvider.future);

    expect(score, const ScoreEntity(wins: 3, losses: 1, draws: 2));
  });

  test('recordWin increments wins', () async {
    final container = makeScoreContainer();
    await container.read(scoreControllerProvider.future);
    await container.read(scoreControllerProvider.notifier).recordWin();

    final score = container.read(scoreControllerProvider).value;
    expect(score?.wins, 1);
    expect(score?.losses, 0);
    expect(score?.draws, 0);
  });

  test('recordWin persists to repository', () async {
    final container = makeScoreContainer();
    await container.read(scoreControllerProvider.future);
    await container.read(scoreControllerProvider.notifier).recordWin();

    verify(() => mockRepo.save(const ScoreEntity(wins: 1, losses: 0, draws: 0))).called(1);
  });

  test('recordLoss increments losses', () async {
    final container = makeScoreContainer();
    await container.read(scoreControllerProvider.future);
    await container.read(scoreControllerProvider.notifier).recordLoss();

    expect(container.read(scoreControllerProvider).value?.losses, 1);
    expect(container.read(scoreControllerProvider).value?.wins, 0);
  });

  test('recordDraw increments draws', () async {
    final container = makeScoreContainer();
    await container.read(scoreControllerProvider.future);
    await container.read(scoreControllerProvider.notifier).recordDraw();

    expect(container.read(scoreControllerProvider).value?.draws, 1);
  });

  test('reset sets score to zero and calls repo.reset', () async {
    when(() => mockRepo.load())
        .thenAnswer((_) async => const Success(ScoreEntity(wins: 5, losses: 3, draws: 1)));

    final container = makeScoreContainer();
    await container.read(scoreControllerProvider.future);
    await container.read(scoreControllerProvider.notifier).reset();

    expect(container.read(scoreControllerProvider).value, ScoreEntity.zero());
    verify(() => mockRepo.reset()).called(1);
  });

  test('multiple mutations accumulate correctly', () async {
    final container = makeScoreContainer();
    await container.read(scoreControllerProvider.future);
    final notifier = container.read(scoreControllerProvider.notifier);

    await notifier.recordWin();
    await notifier.recordWin();
    await notifier.recordLoss();
    await notifier.recordDraw();

    expect(
      container.read(scoreControllerProvider).value,
      const ScoreEntity(wins: 2, losses: 1, draws: 1),
    );
  });

  test('does not mutate when state is not yet loaded', () async {
    // Simulate a slow load — mutate before build completes
    when(() => mockRepo.load()).thenAnswer(
      (_) => Future.delayed(const Duration(seconds: 1), () => Success(ScoreEntity.zero())),
    );

    final container = makeScoreContainer();
    // Don't await build — state is still AsyncLoading
    await container.read(scoreControllerProvider.notifier).recordWin();

    // Save should NOT have been called since state was null
    verifyNever(() => mockRepo.save(any()));
  });
}
