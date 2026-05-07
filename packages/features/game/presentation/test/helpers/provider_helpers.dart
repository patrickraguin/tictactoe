import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/src/internals.dart' show Override;
import 'package:shared_preferences/shared_preferences.dart';

/// Crée un [ProviderContainer] isolé avec teardown automatique.
ProviderContainer makeContainer({List<Override> overrides = const []}) {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  return container;
}

/// Initialise [SharedPreferences] avec des valeurs mockées et retourne l'instance.
Future<SharedPreferences> makeSharedPrefs({
  Map<String, Object> values = const {},
}) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}
