import 'package:tictactoe/core/result/result.dart';
import 'package:tictactoe/features/settings/domain/entities/app_locale.dart';

/// Contrat abstrait pour la persistance de la préférence de langue.
///
/// Découple le domaine de toute technologie de stockage concrète.
abstract class LocaleRepository {
  Future<Result<AppLocale>> load();
  Future<Result<void>> save(AppLocale locale);
}
