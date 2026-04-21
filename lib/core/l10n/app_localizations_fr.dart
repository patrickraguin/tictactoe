// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tic-Tac-Toe';

  @override
  String get homeTitle => 'Humain vs CPU';

  @override
  String get homeSubtitle => 'Choisissez votre configuration et défiez l\'IA.';

  @override
  String get homePlayButton => 'Jouer';

  @override
  String get homeResetScoreButton => 'Réinitialiser le score';

  @override
  String get resetScoreDialogTitle => 'Réinitialiser le score ?';

  @override
  String get resetScoreDialogContent => 'Cette action est irréversible.';

  @override
  String get dialogCancel => 'Annuler';

  @override
  String get dialogConfirmReset => 'Réinitialiser';

  @override
  String get configPageTitle => 'Nouvelle partie';

  @override
  String get configYourSymbol => 'Votre symbole';

  @override
  String get configWhoStarts => 'Qui commence ?';

  @override
  String get configFirstPlayerHuman => 'Moi';

  @override
  String get configFirstPlayerCpu => 'CPU';

  @override
  String get configFirstPlayerRandom => 'Aléatoire';

  @override
  String get configDifficulty => 'Difficulté';

  @override
  String get configDifficultyEasy => 'Facile';

  @override
  String get configDifficultyMedium => 'Moyen';

  @override
  String get configDifficultyHard => 'Difficile';

  @override
  String get configStartButton => 'Commencer';

  @override
  String get gamePageTitle => 'Partie';

  @override
  String get gameRestartTooltip => 'Rejouer';

  @override
  String get gameChangeConfig => 'Changer la config';

  @override
  String get gameReplay => 'Rejouer';

  @override
  String get gameCpuThinking => 'Le CPU réfléchit…';

  @override
  String get gameYourTurn => 'À vous de jouer';

  @override
  String get gameCpuTurn => 'Tour du CPU';

  @override
  String get gameYouWin => 'Vous gagnez !';

  @override
  String get gameCpuWins => 'Le CPU gagne.';

  @override
  String get gameDraw => 'Match nul.';

  @override
  String scoreError(Object error) {
    return 'Erreur score : $error';
  }

  @override
  String get scoreWins => 'Victoires';

  @override
  String get scoreDraws => 'Nulles';

  @override
  String get scoreLosses => 'Défaites';

  @override
  String get scoreLoadError => 'Impossible de charger le score';

  @override
  String get settingsPageTitle => 'Paramètres';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsVersion => 'Version';
}
