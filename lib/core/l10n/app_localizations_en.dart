// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tic-Tac-Toe';

  @override
  String get homeTitle => 'Human vs CPU';

  @override
  String get homeSubtitle => 'Choose your settings and challenge the AI.';

  @override
  String get homePlayButton => 'Play';

  @override
  String get homeResetScoreButton => 'Reset score';

  @override
  String get resetScoreDialogTitle => 'Reset score?';

  @override
  String get resetScoreDialogContent => 'This action cannot be undone.';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogConfirmReset => 'Reset';

  @override
  String get configPageTitle => 'New game';

  @override
  String get configYourSymbol => 'Your symbol';

  @override
  String get configWhoStarts => 'Who goes first?';

  @override
  String get configFirstPlayerHuman => 'Me';

  @override
  String get configFirstPlayerCpu => 'CPU';

  @override
  String get configFirstPlayerRandom => 'Random';

  @override
  String get configDifficulty => 'Difficulty';

  @override
  String get configDifficultyEasy => 'Easy';

  @override
  String get configDifficultyMedium => 'Medium';

  @override
  String get configDifficultyHard => 'Hard';

  @override
  String get configStartButton => 'Start';

  @override
  String get gamePageTitle => 'Game';

  @override
  String get gameRestartTooltip => 'Replay';

  @override
  String get gameChangeConfig => 'Change settings';

  @override
  String get gameReplay => 'Replay';

  @override
  String get gameCpuThinking => 'CPU is thinking…';

  @override
  String get gameYourTurn => 'Your turn';

  @override
  String get gameCpuTurn => 'CPU\'s turn';

  @override
  String get gameYouWin => 'You win!';

  @override
  String get gameCpuWins => 'CPU wins.';

  @override
  String get gameDraw => 'Draw.';

  @override
  String scoreError(Object error) {
    return 'Score error: $error';
  }

  @override
  String get scoreWins => 'Wins';

  @override
  String get scoreDraws => 'Draws';

  @override
  String get scoreLosses => 'Losses';

  @override
  String get scoreLoadError => 'Could not load score';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageFr => 'French';

  @override
  String get settingsLanguageEn => 'English';
}
