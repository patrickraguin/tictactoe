import 'package:flutter_test/flutter_test.dart';
import 'package:settings_domain/entities/app_locale.dart';

void main() {
  group('AppLocale.fromCode', () {
    test("'fr' returns fr", () => expect(AppLocale.fromCode('fr'), AppLocale.fr));
    test("'en' returns en", () => expect(AppLocale.fromCode('en'), AppLocale.en));
    test('null returns system', () => expect(AppLocale.fromCode(null), AppLocale.system));
    test('unknown code returns system', () => expect(AppLocale.fromCode('de'), AppLocale.system));
    test('empty string returns system', () => expect(AppLocale.fromCode(''), AppLocale.system));
  });

  group('languageCode', () {
    test('fr returns "fr"', () => expect(AppLocale.fr.languageCode, 'fr'));
    test('en returns "en"', () => expect(AppLocale.en.languageCode, 'en'));
    test('system returns null', () => expect(AppLocale.system.languageCode, isNull));
  });

  group('round-trip via languageCode', () {
    for (final locale in AppLocale.values) {
      test('${locale.name} survives round-trip', () {
        expect(AppLocale.fromCode(locale.languageCode), locale);
      });
    }
  });
}
