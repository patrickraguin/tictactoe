# Testing — Guide par couche

## Structure des tests

Chaque package a son propre `test/` qui mirror `lib/` :

```
domain/test/
  entities/         # BoardEntity, GameStateEntity
  usecases/         # PlayMove, RecordOutcome, ResolveFirstPlayer
  ai/               # RandomStrategy, HeuristicStrategy, MinimaxStrategy (fuzz inclus)

data/test/
  repositories/     # ScoreRepositoryImpl avec SharedPreferences mock

presentation/test/
  logic/
    controllers/    # GameController, ScoreController (ProviderContainer)
    providers/      # score providers
  pages/            # widget tests
  widgets/          # widget tests
  helpers/          # helpers partagés (provider_helpers.dart, mocks)
```

---

## Domain — tests purs

Aucun mock, aucun Flutter test, aucune I/O.

```dart
test('place marks cell and returns new board', () {
  final board = BoardEntity.empty().place(4, CellMarkEnum.x);
  expect(board.cells[4], CellMarkEnum.x);
});

test('minimax never loses against random (fuzz)', () {
  for (var i = 0; i < 50; i++) {
    // Jouer une partie complète minimax vs random
    expect(result, isNot(GameOutcome.loss));
  }
});
```

---

## Data — SharedPreferences mock

```dart
setUp(() async {
  SharedPreferences.setMockInitialValues({});
  prefs = await SharedPreferences.getInstance();
  repo = ScoreRepositoryImpl(ScoreLocalDatasource(prefs));
});

test('load returns zero on empty prefs', () async {
  final result = await repo.load();
  expect(result, isA<Success<ScoreEntity>>());
  expect((result as Success).value, ScoreEntity.zero());
});
```

Clé SharedPreferences : `'score.v2'`. Si le schéma change → incrémenter la version.

---

## Controllers Riverpod — ProviderContainer

```dart
late ProviderContainer container;

setUp(() {
  container = ProviderContainer(
    overrides: [
      scoreRepositoryProvider.overrideWith((_) => FakeScoreRepository()),
      loggerProvider.overrideWith((_) => _NoOpLogger()),
    ],
  );
  addTearDown(container.dispose);  // nettoyage obligatoire
});

test('recordWin increments wins optimistically', () async {
  // Lire le notifier
  final notifier = container.read(scoreControllerProvider.notifier);
  await container.read(scoreControllerProvider.future);  // attendre build()

  await notifier.recordWin();

  final score = container.read(scoreControllerProvider).value!;
  expect(score.wins, 1);
});
```

### `_NoOpLogger`

```dart
class _NoOpLogger implements AppLogger {
  @override void info(String msg, {String? tag}) {}
  @override void warning(String msg, {String? tag}) {}
  @override void error(String msg, {Object? error, StackTrace? stackTrace, String? tag}) {}
}
```

---

## GameController — fake_async (délai CPU 400ms)

```dart
test('cpu plays after 400ms delay', () {
  fakeAsync((fake) {
    final container = ProviderContainer(overrides: [...]);
    addTearDown(container.dispose);

    final config = GameConfigEntity(firstPlayer: TypePlayerEnum.cpu, ...);
    container.read(gameControllerProvider(config));  // build → schedule microtask CPU

    fake.elapse(const Duration(milliseconds: 500));  // avancer le temps
    fake.flushMicrotasks();

    final state = container.read(gameControllerProvider(config));
    expect(state.game, isA<InProgressEntity>());  // CPU a joué, partie continue
  });
});
```

---

## Fake vs Mock

| Approche | Quand l'utiliser |
|---|---|
| **Fake** (impl manuelle) | Comportement stateful, séquence de retours, logique conditionnelle |
| **Mock** (mocktail) | Stub simple + vérification d'appels (`verify(mock.method()).called(1)`) |

```dart
// Fake stateful
class FakeScoreRepository implements ScoreRepository {
  ScoreEntity _stored = ScoreEntity.zero();
  bool shouldFail = false;

  @override
  Future<Result<ScoreEntity>> load() async =>
    shouldFail ? Error(StorageFailure('fail')) : Success(_stored);

  @override
  Future<Result<void>> save(ScoreEntity score) async {
    _stored = score;
    return const Success(null);
  }
}

// Mock mocktail
class MockScoreRepository extends Mock implements ScoreRepository {}
when(() => mock.load()).thenAnswer((_) async => Success(ScoreEntity.zero()));
```

---

## Widget tests

```dart
testWidgets('displays score panel', (tester) async {
  final container = ProviderContainer(overrides: [...]);
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: HomePage()),
    ),
  );
  await tester.pump();  // laisser les futures se résoudre

  expect(find.byType(ScorePanel), findsOneWidget);
});
```

---

## Helpers partagés

**Location** : `test/helpers/` dans chaque package presentation.

- `provider_helpers.dart` : factories de `ProviderContainer` pré-configurées pour les tests
- `fake_<nom>_repository.dart` : fakes des repositories

---

## Commandes

```bash
melos run test:all             # tous les packages, goldens exclus
flutter test                   # depuis la racine, inclut les goldens
flutter test --tags golden     # goldens uniquement
flutter test --name "minimax"  # filtrer par nom de test
```
