import '../entities/app_locale.dart';

/// Contrat abstrait pour la persistance de la préférence de langue.
///
/// Découple le domaine de toute technologie de stockage concrète.
abstract class LocaleRepository {
  Future<AppLocale> load();
  Future<void> save(AppLocale locale);
}
