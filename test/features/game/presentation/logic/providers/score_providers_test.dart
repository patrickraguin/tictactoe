import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/core/persistence/shared_prefs_provider.dart';
import 'package:tictactoe/features/game/domain/repositories/score_repository.dart';
import 'package:tictactoe/features/game/presentation/logic/providers/score_providers.dart';

import '../../../../../helpers/provider_helpers.dart';

void main() {
  test('sharedPreferencesInstanceProvider throws if not overridden', () {
    final container = makeContainer();
    expect(
      () => container.read(sharedPreferencesInstanceProvider),
      throwsA(isA<Exception>()),
    );
  });

  test('scoreRepositoryProvider returns a ScoreRepository when prefs are provided', () async {
    final prefs = await makeSharedPrefs();
    final container = makeContainer(overrides: [
      sharedPreferencesInstanceProvider.overrideWithValue(prefs),
    ]);
    expect(container.read(scoreRepositoryProvider), isA<ScoreRepository>());
  });
}
