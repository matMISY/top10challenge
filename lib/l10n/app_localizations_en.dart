// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TOP10';

  @override
  String get challengeSubtitle => 'CHALLENGE';

  @override
  String get lives => 'Lives';

  @override
  String get points => 'Points';

  @override
  String get hints => 'Hints';

  @override
  String get play => 'PLAY';

  @override
  String get dailyChallenge => 'Daily Challenge';

  @override
  String level(int level) {
    return 'Level $level';
  }

  @override
  String get watchAdForLives => 'Watch ad for lives';

  @override
  String get watchAdForHints => 'Watch ad for hints';

  @override
  String get moneyTime => 'Money Time';

  @override
  String completed(Object plural) {
    return 'completed';
  }

  @override
  String get gameOver => 'Game Over';

  @override
  String get victory => 'Victory!';

  @override
  String get nextLevel => 'Next Level';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get settings => 'Settings';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get tiers => 'Tiers';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get correctAnswer => 'Correct answer!';

  @override
  String correctAnswerWithName(String name) {
    return 'Correct answer!\n$name';
  }

  @override
  String get levelCompleted => '🎉 Level completed!';

  @override
  String get congratulations => 'Congratulations! You found all the players.';

  @override
  String hintPointsGained(int points) {
    return 'Hint points earned: +$points';
  }

  @override
  String levelPointsGained(int points) {
    return 'Level points earned: +$points';
  }

  @override
  String get continueButton => 'Continue';

  @override
  String get noLivesTitle => 'You have exhausted all your lives 😔';

  @override
  String nextLifeIn(String time) {
    return 'Next life in:';
  }

  @override
  String get watchAdText => 'Watch an ad';

  @override
  String get watchAdSubtext => 'to get lives and continue!';

  @override
  String get watchAdButton => 'Watch ad';

  @override
  String get debugRevealAnswers => '🐛 DEBUG: Answers\nrevealed';

  @override
  String get debugHideAnswers => '🐛 DEBUG: Answers\nhidden';

  @override
  String get debugLevelCompleted => '🐛 DEBUG: Level\ncompleted automatically';

  @override
  String get loadingAd => 'Loading ad...';

  @override
  String get adUnavailableTitle => '❌ Ad unavailable';

  @override
  String get adUnavailableContent => 'Cannot load ad. What do you want to do?';

  @override
  String get restart => 'Restart';

  @override
  String get hideAnswers => 'Hide answers';

  @override
  String get revealAnswers => 'Reveal answers';

  @override
  String get skipLevel => 'Skip level (DEBUG)';

  @override
  String found(int found) {
    return 'Found: $found/10';
  }

  @override
  String get alreadyCompleted => 'Already completed';

  @override
  String get comingSoon => 'Coming soon!';

  @override
  String get loading => 'Loading...';

  @override
  String adForLives(int count) {
    return 'Ad for +$count lives';
  }

  @override
  String nextAdIn(String time) {
    return 'Next ad in $time';
  }

  @override
  String get adNotAvailable => 'Ad not available';

  @override
  String livesGained(int count) {
    return 'You earned\n$count lives!';
  }

  @override
  String get adNotAvailableTryLater => 'Ad not available.\nTry again later.';

  @override
  String get adForHints => 'Ad for +12 hints';

  @override
  String get adError => 'Error viewing ad';

  @override
  String get hintsAdError => 'Error loading\nhint ad.';

  @override
  String get dailyChallengeTitle => 'Daily Challenge';

  @override
  String get comeTomorrowForNewChallenge =>
      'Come back tomorrow for a new challenge!';

  @override
  String get levels => 'Levels';

  @override
  String progress(int completed, int total) {
    return 'Progress: $completed/$total levels';
  }

  @override
  String levelPosition(int position) {
    return 'Level $position';
  }

  @override
  String levelId(String id) {
    return 'ID: $id';
  }

  @override
  String get difficultyVeryEasy => 'Very Easy';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyVeryHard => 'Very Hard';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyMaster => 'Master';

  @override
  String get difficultyLegend => 'Legend';

  @override
  String get easyLevels => 'Easy levels';

  @override
  String get mediumLevels => 'Medium levels';

  @override
  String get hardLevels => 'Hard levels';

  @override
  String get veryHardLevels => 'Very hard levels';

  @override
  String tier(Object number) {
    return 'Tier $number';
  }

  @override
  String get difficultyMythic => 'Mythic';

  @override
  String get difficultyDivine => 'Divine';

  @override
  String get noMoreLives => 'No more lives!';

  @override
  String get noMoreLivesToPlay => 'You have no more lives to play.';

  @override
  String get livesRecoverAutomatically => 'Lives recover automatically!';

  @override
  String oneLifeEveryMinutes(int minutes) {
    return '1 life every $minutes minutes.';
  }

  @override
  String get watchAnAd => 'Watch an ad';

  @override
  String get toGetLives => 'to get lives!';

  @override
  String get close => 'Close';

  @override
  String get livesAdded => 'Lives added! Good game!';

  @override
  String get watchAnAdButton => 'Watch an ad';

  @override
  String get typePlayerName => 'Type a player\'s name...';

  @override
  String get hintPoints => 'Hint Points';

  @override
  String get yourCurrentPoints => 'Your current points';

  @override
  String get howToUse => '💡 How to use?';

  @override
  String get howToUseDescription =>
      'Hold down on an empty slot to unlock a hint with your points.';

  @override
  String get hintCosts => '💰 Hint costs';

  @override
  String get descriptiveHint => 'Descriptive hint';

  @override
  String get nameStructure => 'Name structure';

  @override
  String get partialLetters => 'Partial letters';

  @override
  String get getMorePoints => '🎯 Get more points';

  @override
  String get rewardedAd => 'Rewarded ad';

  @override
  String get completeLevel => 'Complete a level';

  @override
  String get accordingToDifficulty => 'according to difficulty';

  @override
  String get understood => 'Got it!';

  @override
  String get activationInProgress => 'ACTIVATION IN PROGRESS';

  @override
  String moneyTimeMinutes(int duration) {
    return 'Money Time $duration minutes';
  }

  @override
  String get advertisement => 'Advertisement';

  @override
  String adsCompleted(int current, int total) {
    return '$current of $total';
  }

  @override
  String get preparingFirstAd => 'Preparing first ad...';

  @override
  String get loadingNextAd => 'Loading next ad...';

  @override
  String get activatingMoneyTime => 'Activating Money Time...';

  @override
  String get doNotLeaveScreen => 'Do not leave the screen during activation!';

  @override
  String get stayOnPage => 'Stay on this page while we prepare your Money Time';

  @override
  String get securedByMoneyTime => 'Secured by Money Time';

  @override
  String get chooseDuration => 'Choose your duration:';

  @override
  String get recommendedLabel => 'Recommended';

  @override
  String adsToWatch(int count, String plural) {
    return '$count ad$plural to watch';
  }

  @override
  String get duringMoneyTime => 'During Money Time:';

  @override
  String get moneyTimeBenefits =>
      '• You don\'t lose lives\n• You can continue playing normally\n• Points and hints are preserved';

  @override
  String get watchAdsButton => 'WATCH THE ADS';

  @override
  String get launching => 'Launching...';

  @override
  String get cancel => 'Cancel';

  @override
  String get moneyTimeActive => 'Money Time Active';

  @override
  String timeRemaining(String time) {
    return 'Time remaining: $time';
  }

  @override
  String get freeMoneyTime => 'Free Money Time';

  @override
  String get newLabel => 'NEW';

  @override
  String get thirtyMinWithoutAds => '30 min without ads!';

  @override
  String get playWithoutLosingLives => 'Play without losing lives!';

  @override
  String availableIn(String time) {
    return 'Available in $time';
  }

  @override
  String get freeMoneyTimeTitle => 'Free Money Time';

  @override
  String get enjoy30MinFree => 'Enjoy 30 minutes of Money Time for free!';

  @override
  String get noLifeLossFor30Min => '🛡️ No life loss for 30 minutes';

  @override
  String get uniqueWelcomeOffer => '🎁 Unique welcome offer';

  @override
  String get immediateActivation => '⚡ Immediate activation, no ads';

  @override
  String get activateNowQuestion =>
      'Do you want to activate your free Money Time now?';

  @override
  String get later => 'Later';

  @override
  String get activate => 'Activate!';

  @override
  String get freeMoneyTimeActivated =>
      'Free Money Time activated!\n\n🛡️ You won\'t lose lives for 30 minutes.\n\nEnjoy!';

  @override
  String get cannotActivateFreeMoneyTime =>
      'Cannot activate free Money Time.\n\nPlease try again.';

  @override
  String get errorActivatingMoneyTime =>
      'Cannot activate Money Time.\n\nCheck your connection and try again.';

  @override
  String get errorOccurred => 'An error occurred.\n\nTry again later.';

  @override
  String get moneyTimeFinished => 'FINISHED';

  @override
  String get nextMoneyTimeIn => 'Next Money Time\navailable in 4h';

  @override
  String get quizTitle_ballon_dor_year_0 => 'TOP 10 for Ballon d\'Or 2024';

  @override
  String get quizTitle_scorers_team_year_1 => 'TOP 10 La Liga scorers in 2023';

  @override
  String get quizTitle_top_10_des_buteurs_france_dans_les_grands_clubs_eu =>
      'TOP 10 French scorers in major European clubs in 2020-2024';

  @override
  String get quizTitle_top_10_des_joueurs_portugal_les_plus_prolifiques_b =>
      'TOP 10 most prolific Portuguese players (goals+assists) in 2015-2020';

  @override
  String get quizTitle_assists_team_period_4 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_5 => 'TOP 10 for Ballon d\'Or 2023';

  @override
  String get quizTitle_scorers_team_year_6 =>
      'TOP 10 Premier League scorers in 2024';

  @override
  String get quizTitle_top_10_des_buteurs_portugal_dans_les_grands_clubs =>
      'TOP 10 Portuguese scorers in major European clubs in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_8 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Ligue 1)';

  @override
  String get quizTitle_most_minutes_team_year_9 =>
      'TOP 10 Arsenal players with most minutes in 2024';

  @override
  String get quizTitle_ballon_dor_year_10 => 'TOP 10 for Ballon d\'Or 2022';

  @override
  String get quizTitle_top_10_des_joueurs_france_les_plus_prolifiques_but =>
      'TOP 10 most prolific French players (goals+assists) in 2015-2020';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_pre =>
      'TOP 10 most expensive transfers in 2024 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_14 =>
      'TOP 10 PSG players with most minutes in 2024';

  @override
  String get quizTitle_scorers_team_year_15 =>
      'TOP 10 Premier League scorers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_17 =>
      'TOP 10 Barcelona players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_18 =>
      'TOP 10 Premier League assist providers in 2024';

  @override
  String get quizTitle_ballon_dor_year_19 => 'TOP 10 for Ballon d\'Or 2018';

  @override
  String get quizTitle_scorers_team_year_20 => 'TOP 10 La Liga scorers in 2024';

  @override
  String get quizTitle_ballon_dor_year_22 => 'TOP 10 for Ballon d\'Or 2021';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_23 =>
      'TOP 10 La Liga assist providers in 2024';

  @override
  String get quizTitle_assists_team_period_24 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_lig =>
      'TOP 10 most expensive transfers in 2023 (Ligue 1)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_27 =>
      'TOP 10 World Cup scorers 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_28 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_most_minutes_team_year_29 =>
      'TOP 10 Arsenal players with most minutes in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_30 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_ballon_dor_year_31 => 'TOP 10 for Ballon d\'Or 2021';

  @override
  String get quizTitle_expensive_transfers_period_league_32 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Ligue 1)';

  @override
  String get quizTitle_most_minutes_team_year_33 =>
      'TOP 10 Real Madrid players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_bun =>
      'TOP 10 most expensive transfers in 2023 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_35 =>
      'TOP 10 Euro scorers 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_pre =>
      'TOP 10 most expensive transfers in 2023 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_37 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_38 =>
      'TOP 10 Bayern Munich players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_39 =>
      'TOP 10 World Cup scorers 2022';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_40 =>
      'TOP 10 Premier League assist providers in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_41 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_pre =>
      'TOP 10 most expensive transfers in 2022 (Premier League)';

  @override
  String get quizTitle_scorers_team_period_43 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_year_44 => 'TOP 10 La Liga scorers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_45 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_46 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_47 =>
      'TOP 10 La Liga assist providers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_48 =>
      'TOP 10 PSG players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_49 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_50 => 'TOP 10 for Ballon d\'Or 2019';

  @override
  String get quizTitle_ballon_dor_year_51 => 'TOP 10 for Ballon d\'Or 2021';

  @override
  String get quizTitle_expensive_transfers_period_league_52 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_assists_team_period_53 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_lig =>
      'TOP 10 most expensive transfers in 2024 (La Liga)';

  @override
  String get quizTitle_most_minutes_team_year_55 =>
      'TOP 10 Inter Milan players with most minutes in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_56 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_57 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_59 =>
      'TOP 10 La Liga scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_joueurs_avec_le_meilleur_ratio_butsminu =>
      'TOP 10 players with best ratio goals/minutes of Premier League scorers in 2024';

  @override
  String get quizTitle_most_minutes_team_year_61 =>
      'TOP 10 Man Utd players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_62 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_63 =>
      'TOP 10 Premier League assist providers in 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_64 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_lig =>
      'TOP 10 most expensive transfers in 2022 (La Liga)';

  @override
  String get quizTitle_most_minutes_team_year_66 =>
      'TOP 10 Bayern Munich players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_68 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_ser =>
      'TOP 10 most expensive transfers in 2023 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_70 =>
      'TOP 10 Inter Milan players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_72 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_ballon_dor_year_73 => 'TOP 10 for Ballon d\'Or 2022';

  @override
  String get quizTitle_most_minutes_team_year_74 =>
      'TOP 10 Inter Milan players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_period_75 => 'TOP 10 Man City in 2020-2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_ser =>
      'TOP 10 most expensive transfers in 2024 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_77 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Ligue 1)';

  @override
  String get quizTitle_expensive_transfers_period_league_78 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_most_minutes_team_year_82 =>
      'TOP 10 Bayern Munich players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_83 =>
      'TOP 10 Ligue 1 assist providers in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_84 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_86 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_87 =>
      'TOP 10 Chelsea players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_ser =>
      'TOP 10 most expensive transfers in 2022 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_89 =>
      'TOP 10 Liverpool players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_period_90 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_91 =>
      'TOP 10 Copa America scorers 2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_92 =>
      'TOP 10 Euro scorers 2024';

  @override
  String get quizTitle_scorers_team_year_93 =>
      'TOP 10 Premier League scorers in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_94 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_95 =>
      'TOP 10 PSG players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_year_97 => 'TOP 10 La Liga scorers in 2024';

  @override
  String get quizTitle_ballon_dor_year_98 => 'TOP 10 for Ballon d\'Or 2024';

  @override
  String get quizTitle_most_minutes_team_year_100 =>
      'TOP 10 Liverpool players with most minutes in 2023';

  @override
  String get quizTitle_ballon_dor_year_101 => 'TOP 10 for Ballon d\'Or 2017';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_102 =>
      'TOP 10 AFCON scorers 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_104 =>
      'TOP 10 World Cup scorers 2022';

  @override
  String get quizTitle_ballon_dor_year_105 => 'TOP 10 for Ballon d\'Or 2018';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_106 =>
      'TOP 10 La Liga assist providers in 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_107 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Ligue 1)';

  @override
  String get quizTitle_scorers_team_period_110 =>
      'TOP 10 Man City in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_111 =>
      'TOP 10 Real Madrid players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_year_112 =>
      'TOP 10 Premier League scorers in 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_113 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Ligue 1)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_114 =>
      'TOP 10 World Cup scorers 2018';

  @override
  String get quizTitle_expensive_transfers_period_league_115 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_116 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_117 =>
      'TOP 10 Premier League assist providers in 2022';

  @override
  String get quizTitle_scorers_team_year_118 =>
      'TOP 10 Ligue 1 scorers in 2024';

  @override
  String get quizTitle_most_minutes_team_year_119 =>
      'TOP 10 Chelsea players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_120 =>
      'TOP 10 Bundesliga assist providers in 2024';

  @override
  String get quizTitle_most_minutes_team_year_121 =>
      'TOP 10 Real Madrid players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_bun =>
      'TOP 10 most expensive transfers in 2022 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_123 =>
      'TOP 10 Premier League scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_124 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_scorers_team_year_125 =>
      'TOP 10 Serie A scorers in 2023';

  @override
  String get quizTitle_scorers_team_period_126 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_127 =>
      'TOP 10 Bundesliga assist providers in 2023';

  @override
  String get quizTitle_scorers_team_period_128 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_130 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_131 =>
      'TOP 10 Man City players with most minutes in 2023';

  @override
  String get quizTitle_assists_team_period_133 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_year_134 =>
      'TOP 10 Ligue 1 scorers in 2023';

  @override
  String get quizTitle_scorers_team_period_136 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_137 =>
      'TOP 10 Barcelona players with most minutes in 2023';

  @override
  String get quizTitle_assists_team_period_138 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_139 =>
      'TOP 10 PSG players with most minutes in 2023';

  @override
  String get quizTitle_most_minutes_team_year_140 =>
      'TOP 10 Liverpool players with most minutes in 2024';

  @override
  String get quizTitle_most_minutes_team_year_141 =>
      'TOP 10 Man City players with most minutes in 2024';

  @override
  String get quizTitle_most_minutes_team_year_143 =>
      'TOP 10 Bayern Munich players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_144 =>
      'TOP 10 Serie A assist providers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_145 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Serie A)';

  @override
  String get quizTitle_assists_team_period_146 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_assists_team_period_147 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_148 =>
      'TOP 10 Man Utd players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_149 =>
      'TOP 10 Euro scorers 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_150 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Ligue 1)';

  @override
  String get quizTitle_scorers_team_period_151 =>
      'TOP 10 La Liga scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_152 =>
      'TOP 10 Chelsea players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_153 =>
      'TOP 10 Serie A assist providers in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_154 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Serie A)';

  @override
  String get quizTitle_assists_team_period_155 =>
      'TOP 10 Man City in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_156 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_157 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_158 =>
      'TOP 10 Chelsea players with most minutes in 2024';

  @override
  String get quizTitle_most_minutes_team_year_159 =>
      'TOP 10 Man Utd players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_160 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Ligue 1)';

  @override
  String get quizTitle_scorers_team_period_161 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_162 =>
      'TOP 10 Bayern Munich players with most minutes in 2023';

  @override
  String get quizTitle_most_minutes_team_year_164 =>
      'TOP 10 Arsenal players with most minutes in 2023';

  @override
  String get quizTitle_assists_team_period_165 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_166 =>
      'TOP 10 Ligue 1 assist providers in 2024';

  @override
  String get quizTitle_scorers_team_year_167 =>
      'TOP 10 Bundesliga scorers in 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_168 =>
      'TOP 10 Euro scorers 2021';

  @override
  String get quizTitle_scorers_team_year_169 =>
      'TOP 10 La Liga scorers in 2023';

  @override
  String get quizTitle_scorers_team_period_170 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_171 =>
      'TOP 10 Ligue 1 assist providers in 2023';

  @override
  String get quizTitle_scorers_team_period_172 =>
      'TOP 10 Premier League scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_173 =>
      'TOP 10 World Cup scorers 2018';

  @override
  String get quizTitle_assists_team_period_174 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_year_175 =>
      'TOP 10 Serie A scorers in 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_bun =>
      'TOP 10 most expensive transfers in 2024 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_177 =>
      'TOP 10 Copa America scorers 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_178 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_179 =>
      'TOP 10 La Liga assist providers in 2022';

  @override
  String get quizTitle_most_minutes_team_year_180 =>
      'TOP 10 Arsenal players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_year_181 =>
      'TOP 10 La Liga scorers in 2022';

  @override
  String get quizTitle_ballon_dor_year_182 => 'TOP 10 for Ballon d\'Or 2016';

  @override
  String get quizTitle_expensive_transfers_period_league_183 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_184 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_assists_team_period_185 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_assists_team_period_186 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_assists_team_period_188 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_189 =>
      'TOP 10 Euro scorers 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_190 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Serie A)';

  @override
  String get quizTitle_scorers_team_year_191 =>
      'TOP 10 Bundesliga scorers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_192 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Ligue 1)';

  @override
  String get quizTitle_most_minutes_team_year_193 =>
      'TOP 10 Barcelona players with most minutes in 2024';

  @override
  String get quizTitle_scorers_team_period_196 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_197 =>
      'TOP 10 Arsenal players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_198 =>
      'TOP 10 Serie A assist providers in 2023';

  @override
  String get quizTitle_assists_team_period_200 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_201 =>
      'TOP 10 Ligue 1 assist providers in 2023';

  @override
  String get quizTitle_ballon_dor_year_202 => 'TOP 10 for Ballon d\'Or 2022';

  @override
  String get quizTitle_ballon_dor_year_203 => 'TOP 10 for Ballon d\'Or 2017';

  @override
  String get quizTitle_scorers_team_period_204 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_206 =>
      'TOP 10 PSG players with most minutes in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_207 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_assists_team_period_208 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_209 =>
      'TOP 10 Bundesliga assist providers in 2023';

  @override
  String get quizTitle_assists_team_period_210 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_211 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_assists_team_period_212 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_213 =>
      'TOP 10 Ligue 1 assist providers in 2024';

  @override
  String get quizTitle_ballon_dor_year_214 => 'TOP 10 for Ballon d\'Or 2016';

  @override
  String get quizTitle_scorers_team_year_215 =>
      'TOP 10 La Liga scorers in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_216 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_scorers_team_period_217 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_218 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_219 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_220 => 'TOP 10 for Ballon d\'Or 2018';

  @override
  String get quizTitle_expensive_transfers_period_league_221 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_222 => 'TOP 10 for Ballon d\'Or 2023';

  @override
  String get quizTitle_most_minutes_team_year_223 =>
      'TOP 10 Real Madrid players with most minutes in 2024';

  @override
  String get quizTitle_assists_team_period_224 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_225 =>
      'TOP 10 Real Madrid players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_period_226 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_227 =>
      'TOP 10 Euro scorers 2021';

  @override
  String get quizTitle_expensive_transfers_period_league_228 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_most_minutes_team_year_229 =>
      'TOP 10 PSG players with most minutes in 2024';

  @override
  String get quizTitle_assists_team_period_231 =>
      'TOP 10 Man City in 2020-2024';

  @override
  String get quizTitle_assists_team_period_233 =>
      'TOP 10 La Liga scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_234 =>
      'TOP 10 Chelsea players with most minutes in 2023';

  @override
  String get quizTitle_assists_team_period_236 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_237 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_ballon_dor_year_240 => 'TOP 10 for Ballon d\'Or 2019';

  @override
  String get quizTitle_scorers_team_period_243 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_assists_team_period_244 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_245 =>
      'TOP 10 Bundesliga assist providers in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_246 =>
      'TOP 10 Premier League assist providers in 2024';

  @override
  String get quizTitle_assists_team_period_247 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_248 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_249 =>
      'TOP 10 World Cup scorers 2018';

  @override
  String get quizTitle_assists_team_period_250 =>
      'TOP 10 La Liga scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_251 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_assists_team_period_252 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_254 =>
      'TOP 10 Barcelona players with most minutes in 2023';

  @override
  String get quizTitle_assists_team_period_255 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_256 =>
      'TOP 10 Serie A assist providers in 2024';

  @override
  String get quizTitle_scorers_team_period_257 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_260 =>
      'TOP 10 Inter Milan players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_262 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_scorers_team_period_263 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_264 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_266 =>
      'TOP 10 Barcelona players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_268 =>
      'TOP 10 Premier League assist providers in 2022';

  @override
  String get quizTitle_most_minutes_team_year_269 =>
      'TOP 10 Chelsea players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_270 =>
      'TOP 10 Premier League assist providers in 2023';

  @override
  String get quizTitle_assists_team_period_272 =>
      'TOP 10 Premier League scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_year_274 =>
      'TOP 10 Premier League scorers in 2024';

  @override
  String get quizTitle_most_minutes_team_year_276 =>
      'TOP 10 Bayern Munich players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_277 =>
      'TOP 10 Copa America scorers 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_278 =>
      'TOP 10 La Liga assist providers in 2023';

  @override
  String get quizTitle_ballon_dor_year_279 => 'TOP 10 for Ballon d\'Or 2019';

  @override
  String get quizTitle_most_minutes_team_year_280 =>
      'TOP 10 PSG players with most minutes in 2024';

  @override
  String get quizTitle_scorers_team_period_281 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_283 =>
      'TOP 10 Man City players with most minutes in 2023';

  @override
  String get quizTitle_assists_team_period_284 =>
      'TOP 10 Man City in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_285 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_286 =>
      'TOP 10 Bundesliga assist providers in 2023';

  @override
  String get quizTitle_scorers_team_period_287 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_288 =>
      'TOP 10 Chelsea players with most minutes in 2024';

  @override
  String get quizTitle_scorers_team_year_289 =>
      'TOP 10 Premier League scorers in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_290 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Ligue 1)';

  @override
  String get quizTitle_ballon_dor_year_292 => 'TOP 10 for Ballon d\'Or 2018';

  @override
  String get quizTitle_expensive_transfers_period_league_293 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_294 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_295 =>
      'TOP 10 Copa America scorers 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_296 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_assists_team_period_298 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_299 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_300 =>
      'TOP 10 Inter Milan players with most minutes in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_302 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_303 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_304 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Serie A)';

  @override
  String get quizTitle_scorers_team_period_306 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_307 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_year_308 =>
      'TOP 10 Premier League scorers in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_310 =>
      'TOP 10 La Liga assist providers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_311 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_312 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_314 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_315 =>
      'TOP 10 Man City players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_316 =>
      'TOP 10 AFCON scorers 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_317 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_318 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_319 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_320 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_ballon_dor_year_322 => 'TOP 10 for Ballon d\'Or 2024';

  @override
  String get quizTitle_ballon_dor_year_324 => 'TOP 10 for Ballon d\'Or 2017';

  @override
  String get quizTitle_expensive_transfers_period_league_325 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_326 => 'TOP 10 for Ballon d\'Or 2016';

  @override
  String get quizTitle_most_minutes_team_year_327 =>
      'TOP 10 Man Utd players with most minutes in 2023';

  @override
  String get quizTitle_assists_team_period_328 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_330 => 'TOP 10 for Ballon d\'Or 2022';

  @override
  String get quizTitle_scorers_team_period_331 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_333 =>
      'TOP 10 La Liga assist providers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_334 =>
      'TOP 10 Liverpool players with most minutes in 2023';

  @override
  String get quizTitle_most_minutes_team_year_335 =>
      'TOP 10 Liverpool players with most minutes in 2024';

  @override
  String get quizTitle_most_minutes_team_year_336 =>
      'TOP 10 Man City players with most minutes in 2024';

  @override
  String get quizTitle_ballon_dor_year_338 => 'TOP 10 for Ballon d\'Or 2023';

  @override
  String get quizTitle_scorers_team_period_339 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_340 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_341 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_342 =>
      'TOP 10 Euro scorers 2021';

  @override
  String get quizTitle_most_minutes_team_year_343 =>
      'TOP 10 Man Utd players with most minutes in 2023';

  @override
  String get quizTitle_most_minutes_team_year_344 =>
      'TOP 10 Barcelona players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_period_345 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_346 =>
      'TOP 10 Real Madrid players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_period_348 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_349 =>
      'TOP 10 Chelsea scorers in 2020-2024';

  @override
  String get quizTitle_assists_team_period_350 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_351 =>
      'TOP 10 Ligue 1 assist providers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_352 =>
      'TOP 10 Bayern Munich players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_353 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_354 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_356 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_357 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_most_minutes_team_year_358 =>
      'TOP 10 Inter Milan players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_359 =>
      'TOP 10 Serie A assist providers in 2024';

  @override
  String get quizTitle_assists_team_period_360 =>
      'TOP 10 Premier League scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_361 =>
      'TOP 10 Liverpool players with most minutes in 2024';

  @override
  String get quizTitle_assists_team_period_362 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_363 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_365 =>
      'TOP 10 Premier League assist providers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_366 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_most_minutes_team_year_367 =>
      'TOP 10 Arsenal players with most minutes in 2024';

  @override
  String get quizTitle_assists_team_period_369 =>
      'TOP 10 La Liga scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_372 =>
      'TOP 10 PSG players with most minutes in 2023';

  @override
  String get quizTitle_scorers_team_period_373 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_374 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_377 => 'TOP 10 for Ballon d\'Or 2017';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_378 =>
      'TOP 10 Bundesliga assist providers in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_379 =>
      'TOP 10 Ligue 1 assist providers in 2024';

  @override
  String get quizTitle_scorers_team_period_380 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_381 =>
      'TOP 10 Arsenal scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_383 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_period_384 =>
      'TOP 10 Man City in 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_386 => 'TOP 10 for Ballon d\'Or 2023';

  @override
  String get quizTitle_most_minutes_team_year_387 =>
      'TOP 10 Liverpool players with most minutes in 2024';

  @override
  String get quizTitle_assists_team_period_388 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_389 =>
      'TOP 10 La Liga assist providers in 2022';

  @override
  String get quizTitle_assists_team_period_392 =>
      'TOP 10 Barcelona scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_393 =>
      'TOP 10 World Cup scorers 2018';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_394 =>
      'TOP 10 Premier League assist providers in 2022';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_395 =>
      'TOP 10 Premier League assist providers in 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_396 =>
      'TOP 10 World Cup scorers 2022';

  @override
  String get quizTitle_assists_team_period_397 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_398 =>
      'TOP 10 Arsenal players with most minutes in 2024';

  @override
  String get quizTitle_ballon_dor_year_399 => 'TOP 10 for Ballon d\'Or 2019';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_400 =>
      'TOP 10 Premier League assist providers in 2024';

  @override
  String get quizTitle_assists_team_period_402 => 'TOP 10 Man Utd in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_403 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_scorers_team_year_404 =>
      'TOP 10 Premier League scorers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_405 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_406 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_407 =>
      'TOP 10 Liverpool players with most minutes in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_408 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Serie A)';

  @override
  String get quizTitle_assists_team_period_409 =>
      'TOP 10 Real Madrid scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_410 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_412 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_413 =>
      'TOP 10 Barcelona players with most minutes in 2024';

  @override
  String get quizTitle_most_minutes_team_year_414 =>
      'TOP 10 Real Madrid players with most minutes in 2024';

  @override
  String get quizTitle_assists_team_period_415 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_416 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)';

  @override
  String get quizTitle_ballon_dor_year_417 => 'TOP 10 for Ballon d\'Or 2016';

  @override
  String get quizTitle_assists_team_period_418 =>
      'TOP 10 Liverpool scorers in 2020-2024';

  @override
  String get quizTitle_assists_team_period_419 =>
      'TOP 10 Bayern Munich scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_420 =>
      'TOP 10 Serie A assist providers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_421 =>
      'TOP 10 Bayern Munich players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_422 =>
      'TOP 10 Premier League assist providers in 2023';

  @override
  String get quizTitle_scorers_team_period_423 =>
      'TOP 10 Inter Milan in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_424 =>
      'TOP 10 Man City players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_426 =>
      'TOP 10 La Liga assist providers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_427 =>
      'TOP 10 Chelsea players with most minutes in 2024';

  @override
  String get quizTitle_scorers_team_period_428 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_429 =>
      'TOP 10 Real Madrid players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_431 =>
      'TOP 10 Ligue 1 assist providers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_434 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_435 =>
      'TOP 10 Man Utd players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_436 =>
      'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_437 =>
      'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_438 =>
      'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_440 =>
      'TOP 10 Serie A assist providers in 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_443 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_ballon_dor_year_444 => 'TOP 10 for Ballon d\'Or 2024';

  @override
  String get quizTitle_scorers_team_year_445 =>
      'TOP 10 La Liga scorers in 2024';

  @override
  String get quizTitle_assists_team_period_446 =>
      'TOP 10 Premier League scorers in 2020-2024';

  @override
  String get quizTitle_scorers_team_year_447 =>
      'TOP 10 Premier League scorers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_448 =>
      'TOP 10 Man Utd players with most minutes in 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_449 =>
      'TOP 10 Bundesliga assist providers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_450 =>
      'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_451 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_452 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_453 => 'TOP 10 for Ballon d\'Or 2021';

  @override
  String get quizTitle_most_minutes_team_year_454 =>
      'TOP 10 Inter Milan players with most minutes in 2024';

  @override
  String get quizTitle_scorers_team_period_455 =>
      'TOP 10 PSG scorers in 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_456 =>
      'TOP 10 AFCON scorers 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_457 =>
      'TOP 10 Euro scorers 2021';

  @override
  String get quizTitle_most_minutes_team_year_458 =>
      'TOP 10 Arsenal players with most minutes in 2023';

  @override
  String get quizTitle_most_minutes_team_year_460 =>
      'TOP 10 Inter Milan players with most minutes in 2023';

  @override
  String get quizTitle_most_minutes_team_year_461 =>
      'TOP 10 Man City players with most minutes in 2023';

  @override
  String get quizTitle_most_minutes_team_year_462 =>
      'TOP 10 Man City players with most minutes in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_463 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_464 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_465 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_466 =>
      'TOP 10 La Liga assist providers in 2022';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_467 =>
      'TOP 10 La Liga assist providers in 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_469 =>
      'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_470 =>
      'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_471 =>
      'TOP 10 Bundesliga assist providers in 2023';

  @override
  String get quizTitle_most_minutes_team_year_472 =>
      'TOP 10 Barcelona players with most minutes in 2024';

  @override
  String get quizTitle_most_minutes_team_year_473 =>
      'TOP 10 Man Utd players with most minutes in 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_476 =>
      'TOP 10 Serie A assist providers in 2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_477 =>
      'TOP 10 AFCON scorers 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_478 =>
      'TOP 10 La Liga assist providers in 2024';

  @override
  String get quizTitle_assists_team_period_479 =>
      'TOP 10 Man City in 2020-2024';
}
