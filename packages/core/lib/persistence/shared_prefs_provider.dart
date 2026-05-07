import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_prefs_provider.g.dart';

/// Instance de [SharedPreferences] injectée au démarrage dans `main.dart`.
///
/// Doit être overridée dans le [ProviderScope] avant utilisation :
/// ```dart
/// sharedPreferencesInstanceProvider.overrideWithValue(prefs)
/// ```
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferencesInstance(Ref ref) {
  throw UnimplementedError('sharedPreferencesInstance must be overridden');
}
