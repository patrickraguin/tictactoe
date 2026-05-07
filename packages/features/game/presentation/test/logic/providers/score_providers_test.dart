import 'package:core/persistence/shared_prefs_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_presentation/logic/providers/score_providers.dart';

import '../../helpers/provider_helpers.dart';

void main() {
  test('sharedPreferencesInstanceProvider throws if not overridden', () {
    final container = makeContainer();
    expect(
      () => container.read(sharedPreferencesInstanceProvider),
      throwsA(isA<Exception>()),
    );
  });

  test('scoreRepositoryProvider throws if not overridden', () {
    final container = makeContainer();
    expect(
      () => container.read(scoreRepositoryProvider),
      throwsA(anything),
    );
  });
}
