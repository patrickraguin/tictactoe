/// Locale applicative supportée.
///
/// [system] signifie « utiliser la locale du système ».
/// Valeur pure Dart — aucune dépendance Flutter dans le domaine.
enum AppLocale {
  system,
  fr,
  en;

  /// Construit un [AppLocale] depuis un code de langue ISO 639-1 (nullable).
  /// Tout code inconnu ou `null` revient à [system].
  static AppLocale fromCode(String? code) => switch (code) {
        'fr' => AppLocale.fr,
        'en' => AppLocale.en,
        _ => AppLocale.system,
      };

  /// Code de langue ISO 639-1, ou `null` pour la locale système.
  String? get languageCode => switch (this) {
        AppLocale.system => null,
        AppLocale.fr => 'fr',
        AppLocale.en => 'en',
      };
}
