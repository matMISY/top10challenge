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
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TOP10'**
  String get appTitle;

  /// No description provided for @challengeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'CHALLENGE'**
  String get challengeSubtitle;

  /// No description provided for @lives.
  ///
  /// In en, this message translates to:
  /// **'Lives'**
  String get lives;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @hints.
  ///
  /// In en, this message translates to:
  /// **'Hints'**
  String get hints;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'PLAY'**
  String get play;

  /// No description provided for @dailyChallenge.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallenge;

  /// Current level number
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String level(int level);

  /// No description provided for @watchAdForLives.
  ///
  /// In en, this message translates to:
  /// **'Watch ad for lives'**
  String get watchAdForLives;

  /// No description provided for @watchAdForHints.
  ///
  /// In en, this message translates to:
  /// **'Watch ad for hints'**
  String get watchAdForHints;

  /// No description provided for @moneyTime.
  ///
  /// In en, this message translates to:
  /// **'Money Time'**
  String get moneyTime;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String completed(Object plural);

  /// No description provided for @gameOver.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// No description provided for @victory.
  ///
  /// In en, this message translates to:
  /// **'Victory!'**
  String get victory;

  /// No description provided for @nextLevel.
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get nextLevel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @tiers.
  ///
  /// In en, this message translates to:
  /// **'Tiers'**
  String get tiers;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String error(String error);

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer!'**
  String get correctAnswer;

  /// Correct answer feedback with player name
  ///
  /// In en, this message translates to:
  /// **'Correct answer!\n{name}'**
  String correctAnswerWithName(String name);

  /// No description provided for @levelCompleted.
  ///
  /// In en, this message translates to:
  /// **'🎉 Level completed!'**
  String get levelCompleted;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You found all the players.'**
  String get congratulations;

  /// Hint points earned message
  ///
  /// In en, this message translates to:
  /// **'Hint points earned: +{points}'**
  String hintPointsGained(int points);

  /// Level points earned message
  ///
  /// In en, this message translates to:
  /// **'Level points earned: +{points}'**
  String levelPointsGained(int points);

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @noLivesTitle.
  ///
  /// In en, this message translates to:
  /// **'You have exhausted all your lives 😔'**
  String get noLivesTitle;

  /// Time until next life
  ///
  /// In en, this message translates to:
  /// **'Next life in:'**
  String nextLifeIn(String time);

  /// No description provided for @watchAdText.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad'**
  String get watchAdText;

  /// No description provided for @watchAdSubtext.
  ///
  /// In en, this message translates to:
  /// **'to get lives and continue!'**
  String get watchAdSubtext;

  /// No description provided for @watchAdButton.
  ///
  /// In en, this message translates to:
  /// **'Watch ad'**
  String get watchAdButton;

  /// No description provided for @debugRevealAnswers.
  ///
  /// In en, this message translates to:
  /// **'🐛 DEBUG: Answers\nrevealed'**
  String get debugRevealAnswers;

  /// No description provided for @debugHideAnswers.
  ///
  /// In en, this message translates to:
  /// **'🐛 DEBUG: Answers\nhidden'**
  String get debugHideAnswers;

  /// No description provided for @debugLevelCompleted.
  ///
  /// In en, this message translates to:
  /// **'🐛 DEBUG: Level\ncompleted automatically'**
  String get debugLevelCompleted;

  /// No description provided for @loadingAd.
  ///
  /// In en, this message translates to:
  /// **'Loading ad...'**
  String get loadingAd;

  /// No description provided for @adUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'❌ Ad unavailable'**
  String get adUnavailableTitle;

  /// No description provided for @adUnavailableContent.
  ///
  /// In en, this message translates to:
  /// **'Cannot load ad. What do you want to do?'**
  String get adUnavailableContent;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @hideAnswers.
  ///
  /// In en, this message translates to:
  /// **'Hide answers'**
  String get hideAnswers;

  /// No description provided for @revealAnswers.
  ///
  /// In en, this message translates to:
  /// **'Reveal answers'**
  String get revealAnswers;

  /// No description provided for @skipLevel.
  ///
  /// In en, this message translates to:
  /// **'Skip level (DEBUG)'**
  String get skipLevel;

  /// Found answers count
  ///
  /// In en, this message translates to:
  /// **'Found: {found}/10'**
  String found(int found);

  /// No description provided for @alreadyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Already completed'**
  String get alreadyCompleted;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon!'**
  String get comingSoon;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Ad button text for lives
  ///
  /// In en, this message translates to:
  /// **'Ad for +{count} lives'**
  String adForLives(int count);

  /// Ad cooldown time
  ///
  /// In en, this message translates to:
  /// **'Next ad in {time}'**
  String nextAdIn(String time);

  /// No description provided for @adNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Ad not available'**
  String get adNotAvailable;

  /// Lives gained message
  ///
  /// In en, this message translates to:
  /// **'You earned\n{count} lives!'**
  String livesGained(int count);

  /// No description provided for @adNotAvailableTryLater.
  ///
  /// In en, this message translates to:
  /// **'Ad not available.\nTry again later.'**
  String get adNotAvailableTryLater;

  /// No description provided for @adForHints.
  ///
  /// In en, this message translates to:
  /// **'Ad for +12 hints'**
  String get adForHints;

  /// No description provided for @adError.
  ///
  /// In en, this message translates to:
  /// **'Error viewing ad'**
  String get adError;

  /// No description provided for @hintsAdError.
  ///
  /// In en, this message translates to:
  /// **'Error loading\nhint ad.'**
  String get hintsAdError;

  /// No description provided for @dailyChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Challenge'**
  String get dailyChallengeTitle;

  /// No description provided for @comeTomorrowForNewChallenge.
  ///
  /// In en, this message translates to:
  /// **'Come back tomorrow for a new challenge!'**
  String get comeTomorrowForNewChallenge;

  /// No description provided for @levels.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get levels;

  /// Progress indicator
  ///
  /// In en, this message translates to:
  /// **'Progress: {completed}/{total} levels'**
  String progress(int completed, int total);

  /// Level position in tier
  ///
  /// In en, this message translates to:
  /// **'Level {position}'**
  String levelPosition(int position);

  /// Level identifier
  ///
  /// In en, this message translates to:
  /// **'ID: {id}'**
  String levelId(String id);

  /// No description provided for @difficultyVeryEasy.
  ///
  /// In en, this message translates to:
  /// **'Very Easy'**
  String get difficultyVeryEasy;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyVeryHard.
  ///
  /// In en, this message translates to:
  /// **'Very Hard'**
  String get difficultyVeryHard;

  /// No description provided for @difficultyExpert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get difficultyExpert;

  /// No description provided for @difficultyMaster.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get difficultyMaster;

  /// No description provided for @difficultyLegend.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get difficultyLegend;

  /// No description provided for @easyLevels.
  ///
  /// In en, this message translates to:
  /// **'Easy levels'**
  String get easyLevels;

  /// No description provided for @mediumLevels.
  ///
  /// In en, this message translates to:
  /// **'Medium levels'**
  String get mediumLevels;

  /// No description provided for @hardLevels.
  ///
  /// In en, this message translates to:
  /// **'Hard levels'**
  String get hardLevels;

  /// No description provided for @veryHardLevels.
  ///
  /// In en, this message translates to:
  /// **'Very hard levels'**
  String get veryHardLevels;

  /// No description provided for @tier.
  ///
  /// In en, this message translates to:
  /// **'Tier {number}'**
  String tier(Object number);

  /// No description provided for @difficultyMythic.
  ///
  /// In en, this message translates to:
  /// **'Mythic'**
  String get difficultyMythic;

  /// No description provided for @difficultyDivine.
  ///
  /// In en, this message translates to:
  /// **'Divine'**
  String get difficultyDivine;

  /// No description provided for @noMoreLives.
  ///
  /// In en, this message translates to:
  /// **'No more lives!'**
  String get noMoreLives;

  /// No description provided for @noMoreLivesToPlay.
  ///
  /// In en, this message translates to:
  /// **'You have no more lives to play.'**
  String get noMoreLivesToPlay;

  /// No description provided for @livesRecoverAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Lives recover automatically!'**
  String get livesRecoverAutomatically;

  /// Life recovery time
  ///
  /// In en, this message translates to:
  /// **'1 life every {minutes} minutes.'**
  String oneLifeEveryMinutes(int minutes);

  /// No description provided for @watchAnAd.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad'**
  String get watchAnAd;

  /// No description provided for @toGetLives.
  ///
  /// In en, this message translates to:
  /// **'to get lives!'**
  String get toGetLives;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @livesAdded.
  ///
  /// In en, this message translates to:
  /// **'Lives added! Good game!'**
  String get livesAdded;

  /// No description provided for @watchAnAdButton.
  ///
  /// In en, this message translates to:
  /// **'Watch an ad'**
  String get watchAnAdButton;

  /// No description provided for @typePlayerName.
  ///
  /// In en, this message translates to:
  /// **'Type a player\'s name...'**
  String get typePlayerName;

  /// No description provided for @hintPoints.
  ///
  /// In en, this message translates to:
  /// **'Hint Points'**
  String get hintPoints;

  /// No description provided for @yourCurrentPoints.
  ///
  /// In en, this message translates to:
  /// **'Your current points'**
  String get yourCurrentPoints;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'💡 How to use?'**
  String get howToUse;

  /// No description provided for @howToUseDescription.
  ///
  /// In en, this message translates to:
  /// **'Hold down on an empty slot to unlock a hint with your points.'**
  String get howToUseDescription;

  /// No description provided for @hintCosts.
  ///
  /// In en, this message translates to:
  /// **'💰 Hint costs'**
  String get hintCosts;

  /// No description provided for @descriptiveHint.
  ///
  /// In en, this message translates to:
  /// **'Descriptive hint'**
  String get descriptiveHint;

  /// No description provided for @nameStructure.
  ///
  /// In en, this message translates to:
  /// **'Name structure'**
  String get nameStructure;

  /// No description provided for @partialLetters.
  ///
  /// In en, this message translates to:
  /// **'Partial letters'**
  String get partialLetters;

  /// No description provided for @getMorePoints.
  ///
  /// In en, this message translates to:
  /// **'🎯 Get more points'**
  String get getMorePoints;

  /// No description provided for @rewardedAd.
  ///
  /// In en, this message translates to:
  /// **'Rewarded ad'**
  String get rewardedAd;

  /// No description provided for @completeLevel.
  ///
  /// In en, this message translates to:
  /// **'Complete a level'**
  String get completeLevel;

  /// No description provided for @accordingToDifficulty.
  ///
  /// In en, this message translates to:
  /// **'according to difficulty'**
  String get accordingToDifficulty;

  /// No description provided for @understood.
  ///
  /// In en, this message translates to:
  /// **'Got it!'**
  String get understood;

  /// No description provided for @activationInProgress.
  ///
  /// In en, this message translates to:
  /// **'ACTIVATION IN PROGRESS'**
  String get activationInProgress;

  /// Money Time duration
  ///
  /// In en, this message translates to:
  /// **'Money Time {duration} minutes'**
  String moneyTimeMinutes(int duration);

  /// No description provided for @advertisement.
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get advertisement;

  /// Ads completion status
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String adsCompleted(int current, int total);

  /// No description provided for @preparingFirstAd.
  ///
  /// In en, this message translates to:
  /// **'Preparing first ad...'**
  String get preparingFirstAd;

  /// No description provided for @loadingNextAd.
  ///
  /// In en, this message translates to:
  /// **'Loading next ad...'**
  String get loadingNextAd;

  /// No description provided for @activatingMoneyTime.
  ///
  /// In en, this message translates to:
  /// **'Activating Money Time...'**
  String get activatingMoneyTime;

  /// No description provided for @doNotLeaveScreen.
  ///
  /// In en, this message translates to:
  /// **'Do not leave the screen during activation!'**
  String get doNotLeaveScreen;

  /// No description provided for @stayOnPage.
  ///
  /// In en, this message translates to:
  /// **'Stay on this page while we prepare your Money Time'**
  String get stayOnPage;

  /// No description provided for @securedByMoneyTime.
  ///
  /// In en, this message translates to:
  /// **'Secured by Money Time'**
  String get securedByMoneyTime;

  /// No description provided for @chooseDuration.
  ///
  /// In en, this message translates to:
  /// **'Choose your duration:'**
  String get chooseDuration;

  /// No description provided for @recommendedLabel.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommendedLabel;

  /// Number of ads to watch
  ///
  /// In en, this message translates to:
  /// **'{count} ad{plural} to watch'**
  String adsToWatch(int count, String plural);

  /// No description provided for @duringMoneyTime.
  ///
  /// In en, this message translates to:
  /// **'During Money Time:'**
  String get duringMoneyTime;

  /// No description provided for @moneyTimeBenefits.
  ///
  /// In en, this message translates to:
  /// **'• You don\'t lose lives\n• You can continue playing normally\n• Points and hints are preserved'**
  String get moneyTimeBenefits;

  /// No description provided for @watchAdsButton.
  ///
  /// In en, this message translates to:
  /// **'WATCH THE ADS'**
  String get watchAdsButton;

  /// No description provided for @launching.
  ///
  /// In en, this message translates to:
  /// **'Launching...'**
  String get launching;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @moneyTimeActive.
  ///
  /// In en, this message translates to:
  /// **'Money Time Active'**
  String get moneyTimeActive;

  /// Remaining time display
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String timeRemaining(String time);

  /// No description provided for @freeMoneyTime.
  ///
  /// In en, this message translates to:
  /// **'Free Money Time'**
  String get freeMoneyTime;

  /// No description provided for @newLabel.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newLabel;

  /// No description provided for @thirtyMinWithoutAds.
  ///
  /// In en, this message translates to:
  /// **'30 min without ads!'**
  String get thirtyMinWithoutAds;

  /// No description provided for @playWithoutLosingLives.
  ///
  /// In en, this message translates to:
  /// **'Play without losing lives!'**
  String get playWithoutLosingLives;

  /// Availability countdown
  ///
  /// In en, this message translates to:
  /// **'Available in {time}'**
  String availableIn(String time);

  /// No description provided for @freeMoneyTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Money Time'**
  String get freeMoneyTimeTitle;

  /// No description provided for @enjoy30MinFree.
  ///
  /// In en, this message translates to:
  /// **'Enjoy 30 minutes of Money Time for free!'**
  String get enjoy30MinFree;

  /// No description provided for @noLifeLossFor30Min.
  ///
  /// In en, this message translates to:
  /// **'🛡️ No life loss for 30 minutes'**
  String get noLifeLossFor30Min;

  /// No description provided for @uniqueWelcomeOffer.
  ///
  /// In en, this message translates to:
  /// **'🎁 Unique welcome offer'**
  String get uniqueWelcomeOffer;

  /// No description provided for @immediateActivation.
  ///
  /// In en, this message translates to:
  /// **'⚡ Immediate activation, no ads'**
  String get immediateActivation;

  /// No description provided for @activateNowQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to activate your free Money Time now?'**
  String get activateNowQuestion;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate!'**
  String get activate;

  /// No description provided for @freeMoneyTimeActivated.
  ///
  /// In en, this message translates to:
  /// **'Free Money Time activated!\n\n🛡️ You won\'t lose lives for 30 minutes.\n\nEnjoy!'**
  String get freeMoneyTimeActivated;

  /// No description provided for @cannotActivateFreeMoneyTime.
  ///
  /// In en, this message translates to:
  /// **'Cannot activate free Money Time.\n\nPlease try again.'**
  String get cannotActivateFreeMoneyTime;

  /// No description provided for @errorActivatingMoneyTime.
  ///
  /// In en, this message translates to:
  /// **'Cannot activate Money Time.\n\nCheck your connection and try again.'**
  String get errorActivatingMoneyTime;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred.\n\nTry again later.'**
  String get errorOccurred;

  /// No description provided for @moneyTimeFinished.
  ///
  /// In en, this message translates to:
  /// **'FINISHED'**
  String get moneyTimeFinished;

  /// No description provided for @nextMoneyTimeIn.
  ///
  /// In en, this message translates to:
  /// **'Next Money Time\navailable in 4h'**
  String get nextMoneyTimeIn;

  /// No description provided for @quizTitle_ballon_dor_year_0.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2024'**
  String get quizTitle_ballon_dor_year_0;

  /// No description provided for @quizTitle_scorers_team_year_1.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2023'**
  String get quizTitle_scorers_team_year_1;

  /// No description provided for @quizTitle_top_10_des_buteurs_france_dans_les_grands_clubs_eu.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 French scorers in major European clubs in 2020-2024'**
  String get quizTitle_top_10_des_buteurs_france_dans_les_grands_clubs_eu;

  /// No description provided for @quizTitle_top_10_des_joueurs_portugal_les_plus_prolifiques_b.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most prolific Portuguese players (goals+assists) in 2015-2020'**
  String get quizTitle_top_10_des_joueurs_portugal_les_plus_prolifiques_b;

  /// No description provided for @quizTitle_assists_team_period_4.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_assists_team_period_4;

  /// No description provided for @quizTitle_ballon_dor_year_5.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2023'**
  String get quizTitle_ballon_dor_year_5;

  /// No description provided for @quizTitle_scorers_team_year_6.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2024'**
  String get quizTitle_scorers_team_year_6;

  /// No description provided for @quizTitle_top_10_des_buteurs_portugal_dans_les_grands_clubs.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Portuguese scorers in major European clubs in 2020-2024'**
  String get quizTitle_top_10_des_buteurs_portugal_dans_les_grands_clubs;

  /// No description provided for @quizTitle_expensive_transfers_period_league_8.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_8;

  /// No description provided for @quizTitle_most_minutes_team_year_9.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_9;

  /// No description provided for @quizTitle_ballon_dor_year_10.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2022'**
  String get quizTitle_ballon_dor_year_10;

  /// No description provided for @quizTitle_top_10_des_joueurs_france_les_plus_prolifiques_but.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most prolific French players (goals+assists) in 2015-2020'**
  String get quizTitle_top_10_des_joueurs_france_les_plus_prolifiques_but;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_pre.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2024 (Premier League)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_pre;

  /// No description provided for @quizTitle_most_minutes_team_year_14.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_14;

  /// No description provided for @quizTitle_scorers_team_year_15.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2023'**
  String get quizTitle_scorers_team_year_15;

  /// No description provided for @quizTitle_most_minutes_team_year_17.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_17;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2024_18.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_18;

  /// No description provided for @quizTitle_ballon_dor_year_19.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2018'**
  String get quizTitle_ballon_dor_year_19;

  /// No description provided for @quizTitle_scorers_team_year_20.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2024'**
  String get quizTitle_scorers_team_year_20;

  /// No description provided for @quizTitle_ballon_dor_year_22.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2021'**
  String get quizTitle_ballon_dor_year_22;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2024_23.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_23;

  /// No description provided for @quizTitle_assists_team_period_24.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_assists_team_period_24;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_lig.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2023 (Ligue 1)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_lig;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_27.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2022'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_27;

  /// No description provided for @quizTitle_expensive_transfers_period_league_28.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_28;

  /// No description provided for @quizTitle_most_minutes_team_year_29.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_29;

  /// No description provided for @quizTitle_expensive_transfers_period_league_30.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_30;

  /// No description provided for @quizTitle_ballon_dor_year_31.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2021'**
  String get quizTitle_ballon_dor_year_31;

  /// No description provided for @quizTitle_expensive_transfers_period_league_32.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_32;

  /// No description provided for @quizTitle_most_minutes_team_year_33.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_33;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_bun.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2023 (Bundesliga)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_bun;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2024_35.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_35;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_pre.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2023 (Premier League)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_pre;

  /// No description provided for @quizTitle_expensive_transfers_period_league_37.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_37;

  /// No description provided for @quizTitle_most_minutes_team_year_38.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_38;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_39.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2022'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_39;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2023_40.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_40;

  /// No description provided for @quizTitle_expensive_transfers_period_league_41.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_41;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_pre.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2022 (Premier League)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_pre;

  /// No description provided for @quizTitle_scorers_team_period_43.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_43;

  /// No description provided for @quizTitle_scorers_team_year_44.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2024'**
  String get quizTitle_scorers_team_year_44;

  /// No description provided for @quizTitle_expensive_transfers_period_league_45.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_45;

  /// No description provided for @quizTitle_expensive_transfers_period_league_46.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_46;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2023_47.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_47;

  /// No description provided for @quizTitle_most_minutes_team_year_48.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_48;

  /// No description provided for @quizTitle_expensive_transfers_period_league_49.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_49;

  /// No description provided for @quizTitle_ballon_dor_year_50.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2019'**
  String get quizTitle_ballon_dor_year_50;

  /// No description provided for @quizTitle_ballon_dor_year_51.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2021'**
  String get quizTitle_ballon_dor_year_51;

  /// No description provided for @quizTitle_expensive_transfers_period_league_52.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_52;

  /// No description provided for @quizTitle_assists_team_period_53.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_assists_team_period_53;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_lig.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2024 (La Liga)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_lig;

  /// No description provided for @quizTitle_most_minutes_team_year_55.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_55;

  /// No description provided for @quizTitle_expensive_transfers_period_league_56.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_56;

  /// No description provided for @quizTitle_expensive_transfers_period_league_57.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_57;

  /// No description provided for @quizTitle_assists_team_period_59.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2020-2024'**
  String get quizTitle_assists_team_period_59;

  /// No description provided for @quizTitle_top_10_des_joueurs_avec_le_meilleur_ratio_butsminu.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 players with best ratio goals/minutes of Premier League scorers in 2024'**
  String get quizTitle_top_10_des_joueurs_avec_le_meilleur_ratio_butsminu;

  /// No description provided for @quizTitle_most_minutes_team_year_61.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_61;

  /// No description provided for @quizTitle_expensive_transfers_period_league_62.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_62;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2022_63.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_63;

  /// No description provided for @quizTitle_expensive_transfers_period_league_64.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_64;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_lig.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2022 (La Liga)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_lig;

  /// No description provided for @quizTitle_most_minutes_team_year_66.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_66;

  /// No description provided for @quizTitle_expensive_transfers_period_league_68.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_68;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_ser.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2023 (Serie A)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_ser;

  /// No description provided for @quizTitle_most_minutes_team_year_70.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_70;

  /// No description provided for @quizTitle_expensive_transfers_period_league_72.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_72;

  /// No description provided for @quizTitle_ballon_dor_year_73.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2022'**
  String get quizTitle_ballon_dor_year_73;

  /// No description provided for @quizTitle_most_minutes_team_year_74.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_74;

  /// No description provided for @quizTitle_scorers_team_period_75.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City in 2020-2024'**
  String get quizTitle_scorers_team_period_75;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_ser.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2024 (Serie A)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_ser;

  /// No description provided for @quizTitle_expensive_transfers_period_league_77.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_77;

  /// No description provided for @quizTitle_expensive_transfers_period_league_78.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_78;

  /// No description provided for @quizTitle_most_minutes_team_year_82.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_82;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_83.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_83;

  /// No description provided for @quizTitle_expensive_transfers_period_league_84.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_84;

  /// No description provided for @quizTitle_expensive_transfers_period_league_86.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_86;

  /// No description provided for @quizTitle_most_minutes_team_year_87.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_87;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_ser.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2022 (Serie A)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_ser;

  /// No description provided for @quizTitle_most_minutes_team_year_89.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_89;

  /// No description provided for @quizTitle_scorers_team_period_90.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_scorers_team_period_90;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_copa_america_2024_91.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Copa America scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_91;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2024_92.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_92;

  /// No description provided for @quizTitle_scorers_team_year_93.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2023'**
  String get quizTitle_scorers_team_year_93;

  /// No description provided for @quizTitle_expensive_transfers_period_league_94.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_94;

  /// No description provided for @quizTitle_most_minutes_team_year_95.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_95;

  /// No description provided for @quizTitle_scorers_team_year_97.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2024'**
  String get quizTitle_scorers_team_year_97;

  /// No description provided for @quizTitle_ballon_dor_year_98.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2024'**
  String get quizTitle_ballon_dor_year_98;

  /// No description provided for @quizTitle_most_minutes_team_year_100.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_100;

  /// No description provided for @quizTitle_ballon_dor_year_101.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2017'**
  String get quizTitle_ballon_dor_year_101;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_can_2023_102.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 AFCON scorers 2023'**
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_102;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_104.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2022'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_104;

  /// No description provided for @quizTitle_ballon_dor_year_105.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2018'**
  String get quizTitle_ballon_dor_year_105;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2022_106.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_106;

  /// No description provided for @quizTitle_expensive_transfers_period_league_107.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_107;

  /// No description provided for @quizTitle_scorers_team_period_110.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City in 2020-2024'**
  String get quizTitle_scorers_team_period_110;

  /// No description provided for @quizTitle_most_minutes_team_year_111.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_111;

  /// No description provided for @quizTitle_scorers_team_year_112.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2022'**
  String get quizTitle_scorers_team_year_112;

  /// No description provided for @quizTitle_expensive_transfers_period_league_113.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_113;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_114.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2018'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_114;

  /// No description provided for @quizTitle_expensive_transfers_period_league_115.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_115;

  /// No description provided for @quizTitle_expensive_transfers_period_league_116.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_116;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2022_117.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_117;

  /// No description provided for @quizTitle_scorers_team_year_118.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 scorers in 2024'**
  String get quizTitle_scorers_team_year_118;

  /// No description provided for @quizTitle_most_minutes_team_year_119.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_119;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_120.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_120;

  /// No description provided for @quizTitle_most_minutes_team_year_121.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_121;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_bun.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2022 (Bundesliga)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_bun;

  /// No description provided for @quizTitle_assists_team_period_123.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2020-2024'**
  String get quizTitle_assists_team_period_123;

  /// No description provided for @quizTitle_expensive_transfers_period_league_124.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_124;

  /// No description provided for @quizTitle_scorers_team_year_125.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A scorers in 2023'**
  String get quizTitle_scorers_team_year_125;

  /// No description provided for @quizTitle_scorers_team_period_126.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_scorers_team_period_126;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_127.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_127;

  /// No description provided for @quizTitle_scorers_team_period_128.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_128;

  /// No description provided for @quizTitle_scorers_team_period_130.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_130;

  /// No description provided for @quizTitle_most_minutes_team_year_131.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_131;

  /// No description provided for @quizTitle_assists_team_period_133.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_assists_team_period_133;

  /// No description provided for @quizTitle_scorers_team_year_134.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 scorers in 2023'**
  String get quizTitle_scorers_team_year_134;

  /// No description provided for @quizTitle_scorers_team_period_136.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_136;

  /// No description provided for @quizTitle_most_minutes_team_year_137.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_137;

  /// No description provided for @quizTitle_assists_team_period_138.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_assists_team_period_138;

  /// No description provided for @quizTitle_most_minutes_team_year_139.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_139;

  /// No description provided for @quizTitle_most_minutes_team_year_140.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_140;

  /// No description provided for @quizTitle_most_minutes_team_year_141.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_141;

  /// No description provided for @quizTitle_most_minutes_team_year_143.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_143;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2024_144.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_144;

  /// No description provided for @quizTitle_expensive_transfers_period_league_145.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_145;

  /// No description provided for @quizTitle_assists_team_period_146.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_assists_team_period_146;

  /// No description provided for @quizTitle_assists_team_period_147.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_assists_team_period_147;

  /// No description provided for @quizTitle_most_minutes_team_year_148.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_148;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2024_149.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_149;

  /// No description provided for @quizTitle_expensive_transfers_period_league_150.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_150;

  /// No description provided for @quizTitle_scorers_team_period_151.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_151;

  /// No description provided for @quizTitle_most_minutes_team_year_152.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_152;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2023_153.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_153;

  /// No description provided for @quizTitle_expensive_transfers_period_league_154.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_154;

  /// No description provided for @quizTitle_assists_team_period_155.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City in 2020-2024'**
  String get quizTitle_assists_team_period_155;

  /// No description provided for @quizTitle_expensive_transfers_period_league_156.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_156;

  /// No description provided for @quizTitle_expensive_transfers_period_league_157.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_157;

  /// No description provided for @quizTitle_most_minutes_team_year_158.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_158;

  /// No description provided for @quizTitle_most_minutes_team_year_159.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_159;

  /// No description provided for @quizTitle_expensive_transfers_period_league_160.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_160;

  /// No description provided for @quizTitle_scorers_team_period_161.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_scorers_team_period_161;

  /// No description provided for @quizTitle_most_minutes_team_year_162.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_162;

  /// No description provided for @quizTitle_most_minutes_team_year_164.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_164;

  /// No description provided for @quizTitle_assists_team_period_165.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_assists_team_period_165;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_166.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_166;

  /// No description provided for @quizTitle_scorers_team_year_167.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga scorers in 2023'**
  String get quizTitle_scorers_team_year_167;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2021_168.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2021'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_168;

  /// No description provided for @quizTitle_scorers_team_year_169.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2023'**
  String get quizTitle_scorers_team_year_169;

  /// No description provided for @quizTitle_scorers_team_period_170.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_170;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_171.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_171;

  /// No description provided for @quizTitle_scorers_team_period_172.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_172;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_173.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2018'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_173;

  /// No description provided for @quizTitle_assists_team_period_174.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_assists_team_period_174;

  /// No description provided for @quizTitle_scorers_team_year_175.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A scorers in 2024'**
  String get quizTitle_scorers_team_year_175;

  /// No description provided for @quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_bun.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers in 2024 (Bundesliga)'**
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_bun;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_copa_america_2024_177.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Copa America scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_177;

  /// No description provided for @quizTitle_expensive_transfers_period_league_178.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_178;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2022_179.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_179;

  /// No description provided for @quizTitle_most_minutes_team_year_180.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_180;

  /// No description provided for @quizTitle_scorers_team_year_181.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2022'**
  String get quizTitle_scorers_team_year_181;

  /// No description provided for @quizTitle_ballon_dor_year_182.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2016'**
  String get quizTitle_ballon_dor_year_182;

  /// No description provided for @quizTitle_expensive_transfers_period_league_183.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_183;

  /// No description provided for @quizTitle_expensive_transfers_period_league_184.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_184;

  /// No description provided for @quizTitle_assists_team_period_185.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_assists_team_period_185;

  /// No description provided for @quizTitle_assists_team_period_186.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_assists_team_period_186;

  /// No description provided for @quizTitle_assists_team_period_188.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_assists_team_period_188;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2024_189.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_189;

  /// No description provided for @quizTitle_expensive_transfers_period_league_190.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_190;

  /// No description provided for @quizTitle_scorers_team_year_191.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga scorers in 2024'**
  String get quizTitle_scorers_team_year_191;

  /// No description provided for @quizTitle_expensive_transfers_period_league_192.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_192;

  /// No description provided for @quizTitle_most_minutes_team_year_193.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_193;

  /// No description provided for @quizTitle_scorers_team_period_196.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_196;

  /// No description provided for @quizTitle_most_minutes_team_year_197.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_197;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2023_198.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_198;

  /// No description provided for @quizTitle_assists_team_period_200.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_assists_team_period_200;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_201.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_201;

  /// No description provided for @quizTitle_ballon_dor_year_202.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2022'**
  String get quizTitle_ballon_dor_year_202;

  /// No description provided for @quizTitle_ballon_dor_year_203.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2017'**
  String get quizTitle_ballon_dor_year_203;

  /// No description provided for @quizTitle_scorers_team_period_204.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_204;

  /// No description provided for @quizTitle_most_minutes_team_year_206.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_206;

  /// No description provided for @quizTitle_expensive_transfers_period_league_207.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_207;

  /// No description provided for @quizTitle_assists_team_period_208.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_assists_team_period_208;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_209.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_209;

  /// No description provided for @quizTitle_assists_team_period_210.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_assists_team_period_210;

  /// No description provided for @quizTitle_scorers_team_period_211.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_211;

  /// No description provided for @quizTitle_assists_team_period_212.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_assists_team_period_212;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_213.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_213;

  /// No description provided for @quizTitle_ballon_dor_year_214.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2016'**
  String get quizTitle_ballon_dor_year_214;

  /// No description provided for @quizTitle_scorers_team_year_215.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2023'**
  String get quizTitle_scorers_team_year_215;

  /// No description provided for @quizTitle_expensive_transfers_period_league_216.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_216;

  /// No description provided for @quizTitle_scorers_team_period_217.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_scorers_team_period_217;

  /// No description provided for @quizTitle_expensive_transfers_period_league_218.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_218;

  /// No description provided for @quizTitle_expensive_transfers_period_league_219.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_219;

  /// No description provided for @quizTitle_ballon_dor_year_220.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2018'**
  String get quizTitle_ballon_dor_year_220;

  /// No description provided for @quizTitle_expensive_transfers_period_league_221.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_221;

  /// No description provided for @quizTitle_ballon_dor_year_222.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2023'**
  String get quizTitle_ballon_dor_year_222;

  /// No description provided for @quizTitle_most_minutes_team_year_223.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_223;

  /// No description provided for @quizTitle_assists_team_period_224.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_assists_team_period_224;

  /// No description provided for @quizTitle_most_minutes_team_year_225.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_225;

  /// No description provided for @quizTitle_scorers_team_period_226.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_226;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2021_227.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2021'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_227;

  /// No description provided for @quizTitle_expensive_transfers_period_league_228.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_228;

  /// No description provided for @quizTitle_most_minutes_team_year_229.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_229;

  /// No description provided for @quizTitle_assists_team_period_231.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City in 2020-2024'**
  String get quizTitle_assists_team_period_231;

  /// No description provided for @quizTitle_assists_team_period_233.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2020-2024'**
  String get quizTitle_assists_team_period_233;

  /// No description provided for @quizTitle_most_minutes_team_year_234.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_234;

  /// No description provided for @quizTitle_assists_team_period_236.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_assists_team_period_236;

  /// No description provided for @quizTitle_expensive_transfers_period_league_237.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_237;

  /// No description provided for @quizTitle_ballon_dor_year_240.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2019'**
  String get quizTitle_ballon_dor_year_240;

  /// No description provided for @quizTitle_scorers_team_period_243.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_scorers_team_period_243;

  /// No description provided for @quizTitle_assists_team_period_244.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_assists_team_period_244;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_245.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_245;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2024_246.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_246;

  /// No description provided for @quizTitle_assists_team_period_247.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_assists_team_period_247;

  /// No description provided for @quizTitle_expensive_transfers_period_league_248.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_248;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_249.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2018'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_249;

  /// No description provided for @quizTitle_assists_team_period_250.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2020-2024'**
  String get quizTitle_assists_team_period_250;

  /// No description provided for @quizTitle_expensive_transfers_period_league_251.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_251;

  /// No description provided for @quizTitle_assists_team_period_252.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_assists_team_period_252;

  /// No description provided for @quizTitle_most_minutes_team_year_254.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_254;

  /// No description provided for @quizTitle_assists_team_period_255.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_assists_team_period_255;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2024_256.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_256;

  /// No description provided for @quizTitle_scorers_team_period_257.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_257;

  /// No description provided for @quizTitle_most_minutes_team_year_260.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_260;

  /// No description provided for @quizTitle_expensive_transfers_period_league_262.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_262;

  /// No description provided for @quizTitle_scorers_team_period_263.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_263;

  /// No description provided for @quizTitle_scorers_team_period_264.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_264;

  /// No description provided for @quizTitle_most_minutes_team_year_266.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_266;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2022_268.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_268;

  /// No description provided for @quizTitle_most_minutes_team_year_269.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_269;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2023_270.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_270;

  /// No description provided for @quizTitle_assists_team_period_272.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2020-2024'**
  String get quizTitle_assists_team_period_272;

  /// No description provided for @quizTitle_scorers_team_year_274.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2024'**
  String get quizTitle_scorers_team_year_274;

  /// No description provided for @quizTitle_most_minutes_team_year_276.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_276;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_copa_america_2024_277.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Copa America scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_277;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2023_278.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_278;

  /// No description provided for @quizTitle_ballon_dor_year_279.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2019'**
  String get quizTitle_ballon_dor_year_279;

  /// No description provided for @quizTitle_most_minutes_team_year_280.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_280;

  /// No description provided for @quizTitle_scorers_team_period_281.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_281;

  /// No description provided for @quizTitle_most_minutes_team_year_283.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_283;

  /// No description provided for @quizTitle_assists_team_period_284.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City in 2020-2024'**
  String get quizTitle_assists_team_period_284;

  /// No description provided for @quizTitle_scorers_team_period_285.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_285;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_286.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_286;

  /// No description provided for @quizTitle_scorers_team_period_287.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_287;

  /// No description provided for @quizTitle_most_minutes_team_year_288.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_288;

  /// No description provided for @quizTitle_scorers_team_year_289.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2023'**
  String get quizTitle_scorers_team_year_289;

  /// No description provided for @quizTitle_expensive_transfers_period_league_290.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Ligue 1)'**
  String get quizTitle_expensive_transfers_period_league_290;

  /// No description provided for @quizTitle_ballon_dor_year_292.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2018'**
  String get quizTitle_ballon_dor_year_292;

  /// No description provided for @quizTitle_expensive_transfers_period_league_293.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_293;

  /// No description provided for @quizTitle_expensive_transfers_period_league_294.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_294;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_copa_america_2024_295.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Copa America scorers 2024'**
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_295;

  /// No description provided for @quizTitle_expensive_transfers_period_league_296.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_296;

  /// No description provided for @quizTitle_assists_team_period_298.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_assists_team_period_298;

  /// No description provided for @quizTitle_scorers_team_period_299.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_299;

  /// No description provided for @quizTitle_most_minutes_team_year_300.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_300;

  /// No description provided for @quizTitle_expensive_transfers_period_league_302.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_302;

  /// No description provided for @quizTitle_expensive_transfers_period_league_303.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_303;

  /// No description provided for @quizTitle_expensive_transfers_period_league_304.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_304;

  /// No description provided for @quizTitle_scorers_team_period_306.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_306;

  /// No description provided for @quizTitle_scorers_team_period_307.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_307;

  /// No description provided for @quizTitle_scorers_team_year_308.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2024'**
  String get quizTitle_scorers_team_year_308;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2024_310.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_310;

  /// No description provided for @quizTitle_expensive_transfers_period_league_311.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_311;

  /// No description provided for @quizTitle_expensive_transfers_period_league_312.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_312;

  /// No description provided for @quizTitle_assists_team_period_314.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_assists_team_period_314;

  /// No description provided for @quizTitle_most_minutes_team_year_315.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_315;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_can_2023_316.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 AFCON scorers 2023'**
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_316;

  /// No description provided for @quizTitle_expensive_transfers_period_league_317.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_317;

  /// No description provided for @quizTitle_expensive_transfers_period_league_318.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_318;

  /// No description provided for @quizTitle_expensive_transfers_period_league_319.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_319;

  /// No description provided for @quizTitle_expensive_transfers_period_league_320.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_320;

  /// No description provided for @quizTitle_ballon_dor_year_322.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2024'**
  String get quizTitle_ballon_dor_year_322;

  /// No description provided for @quizTitle_ballon_dor_year_324.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2017'**
  String get quizTitle_ballon_dor_year_324;

  /// No description provided for @quizTitle_expensive_transfers_period_league_325.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_325;

  /// No description provided for @quizTitle_ballon_dor_year_326.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2016'**
  String get quizTitle_ballon_dor_year_326;

  /// No description provided for @quizTitle_most_minutes_team_year_327.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_327;

  /// No description provided for @quizTitle_assists_team_period_328.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_assists_team_period_328;

  /// No description provided for @quizTitle_ballon_dor_year_330.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2022'**
  String get quizTitle_ballon_dor_year_330;

  /// No description provided for @quizTitle_scorers_team_period_331.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_331;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2023_333.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_333;

  /// No description provided for @quizTitle_most_minutes_team_year_334.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_334;

  /// No description provided for @quizTitle_most_minutes_team_year_335.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_335;

  /// No description provided for @quizTitle_most_minutes_team_year_336.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_336;

  /// No description provided for @quizTitle_ballon_dor_year_338.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2023'**
  String get quizTitle_ballon_dor_year_338;

  /// No description provided for @quizTitle_scorers_team_period_339.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_339;

  /// No description provided for @quizTitle_expensive_transfers_period_league_340.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_340;

  /// No description provided for @quizTitle_expensive_transfers_period_league_341.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_341;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2021_342.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2021'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_342;

  /// No description provided for @quizTitle_most_minutes_team_year_343.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_343;

  /// No description provided for @quizTitle_most_minutes_team_year_344.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_344;

  /// No description provided for @quizTitle_scorers_team_period_345.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_345;

  /// No description provided for @quizTitle_most_minutes_team_year_346.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_346;

  /// No description provided for @quizTitle_scorers_team_period_348.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_scorers_team_period_348;

  /// No description provided for @quizTitle_scorers_team_period_349.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_349;

  /// No description provided for @quizTitle_assists_team_period_350.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_assists_team_period_350;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_351.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_351;

  /// No description provided for @quizTitle_most_minutes_team_year_352.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_352;

  /// No description provided for @quizTitle_expensive_transfers_period_league_353.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_353;

  /// No description provided for @quizTitle_expensive_transfers_period_league_354.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_354;

  /// No description provided for @quizTitle_expensive_transfers_period_league_356.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_356;

  /// No description provided for @quizTitle_expensive_transfers_period_league_357.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_357;

  /// No description provided for @quizTitle_most_minutes_team_year_358.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_358;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2024_359.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_359;

  /// No description provided for @quizTitle_assists_team_period_360.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2020-2024'**
  String get quizTitle_assists_team_period_360;

  /// No description provided for @quizTitle_most_minutes_team_year_361.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_361;

  /// No description provided for @quizTitle_assists_team_period_362.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_assists_team_period_362;

  /// No description provided for @quizTitle_expensive_transfers_period_league_363.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_363;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2024_365.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_365;

  /// No description provided for @quizTitle_expensive_transfers_period_league_366.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_366;

  /// No description provided for @quizTitle_most_minutes_team_year_367.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_367;

  /// No description provided for @quizTitle_assists_team_period_369.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2020-2024'**
  String get quizTitle_assists_team_period_369;

  /// No description provided for @quizTitle_most_minutes_team_year_372.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_372;

  /// No description provided for @quizTitle_scorers_team_period_373.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_373;

  /// No description provided for @quizTitle_scorers_team_period_374.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_374;

  /// No description provided for @quizTitle_ballon_dor_year_377.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2017'**
  String get quizTitle_ballon_dor_year_377;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_378.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_378;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_379.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_379;

  /// No description provided for @quizTitle_scorers_team_period_380.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_scorers_team_period_380;

  /// No description provided for @quizTitle_scorers_team_period_381.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_381;

  /// No description provided for @quizTitle_scorers_team_period_383.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_383;

  /// No description provided for @quizTitle_scorers_team_period_384.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City in 2020-2024'**
  String get quizTitle_scorers_team_period_384;

  /// No description provided for @quizTitle_ballon_dor_year_386.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2023'**
  String get quizTitle_ballon_dor_year_386;

  /// No description provided for @quizTitle_most_minutes_team_year_387.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_387;

  /// No description provided for @quizTitle_assists_team_period_388.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_assists_team_period_388;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2022_389.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_389;

  /// No description provided for @quizTitle_assists_team_period_392.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona scorers in 2020-2024'**
  String get quizTitle_assists_team_period_392;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_393.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2018'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_393;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2022_394.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_394;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2023_395.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_395;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_396.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 World Cup scorers 2022'**
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_396;

  /// No description provided for @quizTitle_assists_team_period_397.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_assists_team_period_397;

  /// No description provided for @quizTitle_most_minutes_team_year_398.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_398;

  /// No description provided for @quizTitle_ballon_dor_year_399.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2019'**
  String get quizTitle_ballon_dor_year_399;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2024_400.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_400;

  /// No description provided for @quizTitle_assists_team_period_402.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd in 2020-2024'**
  String get quizTitle_assists_team_period_402;

  /// No description provided for @quizTitle_expensive_transfers_period_league_403.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_403;

  /// No description provided for @quizTitle_scorers_team_year_404.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2024'**
  String get quizTitle_scorers_team_year_404;

  /// No description provided for @quizTitle_expensive_transfers_period_league_405.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_405;

  /// No description provided for @quizTitle_expensive_transfers_period_league_406.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_406;

  /// No description provided for @quizTitle_most_minutes_team_year_407.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_407;

  /// No description provided for @quizTitle_expensive_transfers_period_league_408.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_408;

  /// No description provided for @quizTitle_assists_team_period_409.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid scorers in 2020-2024'**
  String get quizTitle_assists_team_period_409;

  /// No description provided for @quizTitle_expensive_transfers_period_league_410.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_410;

  /// No description provided for @quizTitle_expensive_transfers_period_league_412.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_412;

  /// No description provided for @quizTitle_most_minutes_team_year_413.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_413;

  /// No description provided for @quizTitle_most_minutes_team_year_414.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_414;

  /// No description provided for @quizTitle_assists_team_period_415.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_assists_team_period_415;

  /// No description provided for @quizTitle_expensive_transfers_period_league_416.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_416;

  /// No description provided for @quizTitle_ballon_dor_year_417.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2016'**
  String get quizTitle_ballon_dor_year_417;

  /// No description provided for @quizTitle_assists_team_period_418.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Liverpool scorers in 2020-2024'**
  String get quizTitle_assists_team_period_418;

  /// No description provided for @quizTitle_assists_team_period_419.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich scorers in 2020-2024'**
  String get quizTitle_assists_team_period_419;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2023_420.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_420;

  /// No description provided for @quizTitle_most_minutes_team_year_421.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bayern Munich players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_421;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_premier_league_en_2023_422.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_422;

  /// No description provided for @quizTitle_scorers_team_period_423.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan in 2020-2024'**
  String get quizTitle_scorers_team_period_423;

  /// No description provided for @quizTitle_most_minutes_team_year_424.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_424;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2023_426.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_426;

  /// No description provided for @quizTitle_most_minutes_team_year_427.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Chelsea players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_427;

  /// No description provided for @quizTitle_scorers_team_period_428.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_428;

  /// No description provided for @quizTitle_most_minutes_team_year_429.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Real Madrid players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_429;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_431.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Ligue 1 assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_431;

  /// No description provided for @quizTitle_expensive_transfers_period_league_434.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_434;

  /// No description provided for @quizTitle_most_minutes_team_year_435.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_435;

  /// No description provided for @quizTitle_expensive_transfers_period_league_436.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_436;

  /// No description provided for @quizTitle_expensive_transfers_period_league_437.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_437;

  /// No description provided for @quizTitle_expensive_transfers_period_league_438.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2020-2024 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_438;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2023_440.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_440;

  /// No description provided for @quizTitle_expensive_transfers_period_league_443.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_443;

  /// No description provided for @quizTitle_ballon_dor_year_444.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2024'**
  String get quizTitle_ballon_dor_year_444;

  /// No description provided for @quizTitle_scorers_team_year_445.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga scorers in 2024'**
  String get quizTitle_scorers_team_year_445;

  /// No description provided for @quizTitle_assists_team_period_446.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2020-2024'**
  String get quizTitle_assists_team_period_446;

  /// No description provided for @quizTitle_scorers_team_year_447.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Premier League scorers in 2023'**
  String get quizTitle_scorers_team_year_447;

  /// No description provided for @quizTitle_most_minutes_team_year_448.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_448;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_449.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_449;

  /// No description provided for @quizTitle_expensive_transfers_period_league_450.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers entrants in 2020-2024 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_450;

  /// No description provided for @quizTitle_expensive_transfers_period_league_451.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Bundesliga)'**
  String get quizTitle_expensive_transfers_period_league_451;

  /// No description provided for @quizTitle_assists_team_period_452.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_assists_team_period_452;

  /// No description provided for @quizTitle_ballon_dor_year_453.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 for Ballon d\'Or 2021'**
  String get quizTitle_ballon_dor_year_453;

  /// No description provided for @quizTitle_most_minutes_team_year_454.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_454;

  /// No description provided for @quizTitle_scorers_team_period_455.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 PSG scorers in 2020-2024'**
  String get quizTitle_scorers_team_period_455;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_can_2023_456.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 AFCON scorers 2023'**
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_456;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_euro_2021_457.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Euro scorers 2021'**
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_457;

  /// No description provided for @quizTitle_most_minutes_team_year_458.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Arsenal players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_458;

  /// No description provided for @quizTitle_most_minutes_team_year_460.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Inter Milan players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_460;

  /// No description provided for @quizTitle_most_minutes_team_year_461.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2023'**
  String get quizTitle_most_minutes_team_year_461;

  /// No description provided for @quizTitle_most_minutes_team_year_462.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_462;

  /// No description provided for @quizTitle_expensive_transfers_period_league_463.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Serie A)'**
  String get quizTitle_expensive_transfers_period_league_463;

  /// No description provided for @quizTitle_expensive_transfers_period_league_464.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_464;

  /// No description provided for @quizTitle_expensive_transfers_period_league_465.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (Premier League)'**
  String get quizTitle_expensive_transfers_period_league_465;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2022_466.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2022'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_466;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2024_467.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_467;

  /// No description provided for @quizTitle_expensive_transfers_period_league_469.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2010-2015 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_469;

  /// No description provided for @quizTitle_expensive_transfers_period_league_470.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 most expensive transfers sortants in 2015-2020 (La Liga)'**
  String get quizTitle_expensive_transfers_period_league_470;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_471.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Bundesliga assist providers in 2023'**
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_471;

  /// No description provided for @quizTitle_most_minutes_team_year_472.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Barcelona players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_472;

  /// No description provided for @quizTitle_most_minutes_team_year_473.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man Utd players with most minutes in 2024'**
  String get quizTitle_most_minutes_team_year_473;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_serie_a_en_2024_476.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Serie A assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_476;

  /// No description provided for @quizTitle_top_10_des_buteurs_de_la_can_2023_477.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 AFCON scorers 2023'**
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_477;

  /// No description provided for @quizTitle_top_10_des_passeurs_de_liga_en_2024_478.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 La Liga assist providers in 2024'**
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_478;

  /// No description provided for @quizTitle_assists_team_period_479.
  ///
  /// In en, this message translates to:
  /// **'TOP 10 Man City in 2020-2024'**
  String get quizTitle_assists_team_period_479;
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
      'that was used.');
}
