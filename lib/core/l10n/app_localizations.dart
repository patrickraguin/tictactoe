import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tic-Tac-Toe'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Humain vs CPU'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre configuration et défiez l\'IA.'**
  String get homeSubtitle;

  /// No description provided for @homePlayButton.
  ///
  /// In fr, this message translates to:
  /// **'Jouer'**
  String get homePlayButton;

  /// No description provided for @homeResetScoreButton.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le score'**
  String get homeResetScoreButton;

  /// No description provided for @resetScoreDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser le score ?'**
  String get resetScoreDialogTitle;

  /// No description provided for @resetScoreDialogContent.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get resetScoreDialogContent;

  /// No description provided for @dialogCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get dialogCancel;

  /// No description provided for @dialogConfirmReset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get dialogConfirmReset;

  /// No description provided for @configPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle partie'**
  String get configPageTitle;

  /// No description provided for @configYourSymbol.
  ///
  /// In fr, this message translates to:
  /// **'Votre symbole'**
  String get configYourSymbol;

  /// No description provided for @configWhoStarts.
  ///
  /// In fr, this message translates to:
  /// **'Qui commence ?'**
  String get configWhoStarts;

  /// No description provided for @configFirstPlayerHuman.
  ///
  /// In fr, this message translates to:
  /// **'Moi'**
  String get configFirstPlayerHuman;

  /// No description provided for @configFirstPlayerCpu.
  ///
  /// In fr, this message translates to:
  /// **'CPU'**
  String get configFirstPlayerCpu;

  /// No description provided for @configFirstPlayerRandom.
  ///
  /// In fr, this message translates to:
  /// **'Aléatoire'**
  String get configFirstPlayerRandom;

  /// No description provided for @configDifficulty.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get configDifficulty;

  /// No description provided for @configDifficultyEasy.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get configDifficultyEasy;

  /// No description provided for @configDifficultyMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get configDifficultyMedium;

  /// No description provided for @configDifficultyHard.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get configDifficultyHard;

  /// No description provided for @configStartButton.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get configStartButton;

  /// No description provided for @gamePageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Partie'**
  String get gamePageTitle;

  /// No description provided for @gameRestartTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get gameRestartTooltip;

  /// No description provided for @gameChangeConfig.
  ///
  /// In fr, this message translates to:
  /// **'Changer la config'**
  String get gameChangeConfig;

  /// No description provided for @gameReplay.
  ///
  /// In fr, this message translates to:
  /// **'Rejouer'**
  String get gameReplay;

  /// No description provided for @gameCpuThinking.
  ///
  /// In fr, this message translates to:
  /// **'Le CPU réfléchit…'**
  String get gameCpuThinking;

  /// No description provided for @gameYourTurn.
  ///
  /// In fr, this message translates to:
  /// **'À vous de jouer'**
  String get gameYourTurn;

  /// No description provided for @gameCpuTurn.
  ///
  /// In fr, this message translates to:
  /// **'Tour du CPU'**
  String get gameCpuTurn;

  /// No description provided for @gameYouWin.
  ///
  /// In fr, this message translates to:
  /// **'Vous gagnez !'**
  String get gameYouWin;

  /// No description provided for @gameCpuWins.
  ///
  /// In fr, this message translates to:
  /// **'Le CPU gagne.'**
  String get gameCpuWins;

  /// No description provided for @gameDraw.
  ///
  /// In fr, this message translates to:
  /// **'Match nul.'**
  String get gameDraw;

  /// No description provided for @scoreError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur score : {error}'**
  String scoreError(Object error);

  /// No description provided for @scoreWins.
  ///
  /// In fr, this message translates to:
  /// **'Victoires'**
  String get scoreWins;

  /// No description provided for @scoreDraws.
  ///
  /// In fr, this message translates to:
  /// **'Nulles'**
  String get scoreDraws;

  /// No description provided for @scoreLosses.
  ///
  /// In fr, this message translates to:
  /// **'Défaites'**
  String get scoreLosses;

  /// No description provided for @scoreLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le score'**
  String get scoreLoadError;

  /// No description provided for @scoreRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get scoreRetry;

  /// No description provided for @settingsPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsPageTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @semanticsCellEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {row}, colonne {col}, vide, appuyer pour jouer'**
  String semanticsCellEmpty(int row, int col);

  /// No description provided for @semanticsCellPlayed.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {row}, colonne {col}, {mark}'**
  String semanticsCellPlayed(int row, int col, String mark);

  /// No description provided for @semanticsGameBoard.
  ///
  /// In fr, this message translates to:
  /// **'Plateau de jeu'**
  String get semanticsGameBoard;

  /// No description provided for @semanticsWinningLine.
  ///
  /// In fr, this message translates to:
  /// **'Ligne gagnante'**
  String get semanticsWinningLine;

  /// No description provided for @semanticsScoreSummary.
  ///
  /// In fr, this message translates to:
  /// **'{wins} victoires, {draws} nuls, {losses} défaites'**
  String semanticsScoreSummary(int wins, int draws, int losses);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
