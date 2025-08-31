// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TOP10';

  @override
  String get challengeSubtitle => 'CHALLENGE';

  @override
  String get lives => 'Vies';

  @override
  String get points => 'Points';

  @override
  String get hints => 'Indices';

  @override
  String get play => 'JOUER';

  @override
  String get dailyChallenge => 'Défi Quotidien';

  @override
  String level(int level) {
    return 'Niveau $level';
  }

  @override
  String get watchAdForLives => 'Regarder pub pour vies';

  @override
  String get watchAdForHints => 'Regarder pub pour indices';

  @override
  String get moneyTime => 'Money Time';

  @override
  String completed(Object plural) {
    return 'terminée$plural';
  }

  @override
  String get gameOver => 'Game Over';

  @override
  String get victory => 'Victoire !';

  @override
  String get nextLevel => 'Niveau Suivant';

  @override
  String get retry => 'Réessayer';

  @override
  String get back => 'Retour';

  @override
  String get settings => 'Paramètres';

  @override
  String get help => 'Aide';

  @override
  String get about => 'À propos';

  @override
  String get tiers => 'Paliers';

  @override
  String error(String error) {
    return 'Erreur: $error';
  }

  @override
  String get correctAnswer => 'Bonne réponse !';

  @override
  String correctAnswerWithName(String name) {
    return 'Bonne réponse !\n$name';
  }

  @override
  String get levelCompleted => '🎉 Niveau terminé !';

  @override
  String get congratulations =>
      'Félicitations ! Vous avez trouvé tous les joueurs.';

  @override
  String hintPointsGained(int points) {
    return 'Points d\'indice gagnés: +$points';
  }

  @override
  String levelPointsGained(int points) {
    return 'Points de niveau gagnés: +$points';
  }

  @override
  String get continueButton => 'Continuer';

  @override
  String get noLivesTitle => 'Vous avez épuisé toutes vos vies 😔';

  @override
  String nextLifeIn(String time) {
    return 'Prochaine vie dans :';
  }

  @override
  String get watchAdText => 'Regardez une publicité';

  @override
  String get watchAdSubtext => 'pour gagner des vies et continuer !';

  @override
  String get watchAdButton => 'Regarder une pub';

  @override
  String get debugRevealAnswers => '🐛 DEBUG: Réponses\nrévélées';

  @override
  String get debugHideAnswers => '🐛 DEBUG: Réponses\ncachées';

  @override
  String get debugLevelCompleted =>
      '🐛 DEBUG: Niveau\ncomplété automatiquement';

  @override
  String get loadingAd => 'Chargement de la publicité...';

  @override
  String get adUnavailableTitle => '❌ Publicité indisponible';

  @override
  String get adUnavailableContent =>
      'Impossible de charger la publicité. Que voulez-vous faire ?';

  @override
  String get restart => 'Recommencer';

  @override
  String get hideAnswers => 'Cacher les réponses';

  @override
  String get revealAnswers => 'Révéler les réponses';

  @override
  String get skipLevel => 'Passer le niveau (DEBUG)';

  @override
  String found(int found) {
    return 'Trouvés: $found/10';
  }

  @override
  String get alreadyCompleted => 'Déjà complété';

  @override
  String get comingSoon => 'Bientôt !';

  @override
  String get loading => 'Chargement...';

  @override
  String adForLives(int count) {
    return 'Pub pour +$count vies';
  }

  @override
  String nextAdIn(String time) {
    return 'Prochaine pub dans $time';
  }

  @override
  String get adNotAvailable => 'Pub non disponible';

  @override
  String livesGained(int count) {
    return 'Vous avez gagné\n$count vies !';
  }

  @override
  String get adNotAvailableTryLater =>
      'Publicité non\ndisponible.\nRéessayez plus tard.';

  @override
  String get adForHints => 'Pub pour +12 indices';

  @override
  String get adError => 'Erreur lors de la\nvisualisation de\nla publicité';

  @override
  String get hintsAdError =>
      'Erreur lors du\nchargement de la\npublicité d\'indices.';

  @override
  String get dailyChallengeTitle => 'Défi Quotidien';

  @override
  String get comeTomorrowForNewChallenge =>
      'Revenez demain pour un nouveau défi !';

  @override
  String get levels => 'Niveaux';

  @override
  String progress(int completed, int total) {
    return 'Progression: $completed/$total niveaux';
  }

  @override
  String levelPosition(int position) {
    return 'Niveau $position';
  }

  @override
  String levelId(String id) {
    return 'ID: $id';
  }

  @override
  String get difficultyVeryEasy => 'Très Facile';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyVeryHard => 'Très Difficile';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get difficultyMaster => 'Maître';

  @override
  String get difficultyLegend => 'Légende';

  @override
  String get easyLevels => 'Niveaux faciles';

  @override
  String get mediumLevels => 'Niveaux moyens';

  @override
  String get hardLevels => 'Niveaux difficiles';

  @override
  String get veryHardLevels => 'Niveaux très difficiles';

  @override
  String tier(Object number) {
    return 'Palier $number';
  }

  @override
  String get difficultyMythic => 'Mythique';

  @override
  String get difficultyDivine => 'Divin';

  @override
  String get noMoreLives => 'Plus de vies !';

  @override
  String get noMoreLivesToPlay => 'Vous n\'avez plus de vies pour jouer.';

  @override
  String get livesRecoverAutomatically =>
      'Les vies se récupèrent automatiquement !';

  @override
  String oneLifeEveryMinutes(int minutes) {
    return '1 vie toutes les $minutes minutes.';
  }

  @override
  String get watchAnAd => 'Regardez une publicité';

  @override
  String get toGetLives => 'pour gagner des vies !';

  @override
  String get close => 'Fermer';

  @override
  String get livesAdded => 'Vies ajoutées ! Bon jeu !';

  @override
  String get watchAnAdButton => 'Regarder une pub';

  @override
  String get typePlayerName => 'Tapez le nom d\'un joueur...';

  @override
  String get hintPoints => 'Points d\'indice';

  @override
  String get yourCurrentPoints => 'Vos points actuels';

  @override
  String get howToUse => '💡 Comment utiliser ?';

  @override
  String get howToUseDescription =>
      'Restez appuyé sur une case vide pour débloquer un indice avec vos points.';

  @override
  String get hintCosts => '💰 Coût des indices';

  @override
  String get descriptiveHint => 'Indice descriptif';

  @override
  String get nameStructure => 'Structure du nom';

  @override
  String get partialLetters => 'Lettres partielles';

  @override
  String get getMorePoints => '🎯 Obtenir plus de points';

  @override
  String get rewardedAd => 'Publicité récompensée';

  @override
  String get completeLevel => 'Compléter un niveau';

  @override
  String get accordingToDifficulty => 'selon la difficulté';

  @override
  String get understood => 'Compris !';

  @override
  String get activationInProgress => 'ACTIVATION EN COURS';

  @override
  String moneyTimeMinutes(int duration) {
    return 'Money Time $duration minutes';
  }

  @override
  String get advertisement => 'Publicité';

  @override
  String adsCompleted(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get preparingFirstAd => 'Préparation de la première publicité...';

  @override
  String get loadingNextAd => 'Chargement de la publicité suivante...';

  @override
  String get activatingMoneyTime => 'Activation du Money Time...';

  @override
  String get doNotLeaveScreen =>
      'Ne quittez pas l\'écran pendant l\'activation !';

  @override
  String get stayOnPage =>
      'Restez sur cette page pendant que nous préparons votre Money Time';

  @override
  String get securedByMoneyTime => 'Sécurisé par Money Time';

  @override
  String get chooseDuration => 'Choisissez votre durée :';

  @override
  String get recommendedLabel => 'Recommandé';

  @override
  String adsToWatch(int count, String plural) {
    return '$count publicité$plural à regarder';
  }

  @override
  String get duringMoneyTime => 'Pendant Money Time :';

  @override
  String get moneyTimeBenefits =>
      '• Vous ne perdez pas de vies\n• Vous pouvez continuer à jouer normalement\n• Les points et indices sont conservés';

  @override
  String get watchAdsButton => 'REGARDER LES PUBS';

  @override
  String get launching => 'Lancement...';

  @override
  String get cancel => 'Annuler';

  @override
  String get moneyTimeActive => 'Money Time Actif';

  @override
  String timeRemaining(String time) {
    return 'Temps restant: $time';
  }

  @override
  String get freeMoneyTime => 'Money Time Gratuit';

  @override
  String get newLabel => 'NOUVEAU';

  @override
  String get thirtyMinWithoutAds => '30 min sans pubs !';

  @override
  String get playWithoutLosingLives => 'Jouez sans perdre de vies !';

  @override
  String availableIn(String time) {
    return 'Disponible dans $time';
  }

  @override
  String get freeMoneyTimeTitle => 'Money Time Gratuit';

  @override
  String get enjoy30MinFree =>
      'Profitez de 30 minutes de Money Time gratuitement !';

  @override
  String get noLifeLossFor30Min => '🛡️ Aucune perte de vie pendant 30 minutes';

  @override
  String get uniqueWelcomeOffer => '🎁 Offre de bienvenue unique';

  @override
  String get immediateActivation => '⚡ Activation immédiate, sans publicité';

  @override
  String get activateNowQuestion =>
      'Voulez-vous activer votre Money Time gratuit maintenant ?';

  @override
  String get later => 'Plus tard';

  @override
  String get activate => 'Activer !';

  @override
  String get freeMoneyTimeActivated =>
      'Money Time Gratuit activé !\n\n🛡️ Vous ne perdrez pas de vies pendant 30 minutes.\n\nProfitez-en bien !';

  @override
  String get cannotActivateFreeMoneyTime =>
      'Impossible d\'activer le Money Time gratuit.\n\nVeuillez réessayer.';

  @override
  String get errorActivatingMoneyTime =>
      'Impossible d\'activer Money Time.\n\nVérifiez votre connexion et réessayez.';

  @override
  String get errorOccurred =>
      'Une erreur s\'est produite.\n\nRéessayez plus tard.';

  @override
  String get moneyTimeFinished => 'TERMINÉ';

  @override
  String get nextMoneyTimeIn => 'Prochain Money Time\ndisponible dans 4h';

  @override
  String get quizTitle_ballon_dor_year_0 => 'TOP 10 du Ballon d\'Or 2024';

  @override
  String get quizTitle_scorers_team_year_1 =>
      'TOP 10 des buteurs de Liga en 2023';

  @override
  String get quizTitle_top_10_des_buteurs_france_dans_les_grands_clubs_eu =>
      'TOP 10 des buteurs france dans les grands clubs européens en 2020-2024';

  @override
  String get quizTitle_top_10_des_joueurs_portugal_les_plus_prolifiques_b =>
      'TOP 10 des joueurs portugal les plus prolifiques (buts+passes) en 2015-2020';

  @override
  String get quizTitle_assists_team_period_4 =>
      'TOP 10 des passeurs de PSG en 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_5 => 'TOP 10 du Ballon d\'Or 2023';

  @override
  String get quizTitle_scorers_team_year_6 =>
      'TOP 10 des buteurs de Premier League en 2024';

  @override
  String get quizTitle_top_10_des_buteurs_portugal_dans_les_grands_clubs =>
      'TOP 10 des buteurs portugal dans les grands clubs européens en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_8 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Ligue 1)';

  @override
  String get quizTitle_most_minutes_team_year_9 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2024';

  @override
  String get quizTitle_ballon_dor_year_10 => 'TOP 10 du Ballon d\'Or 2022';

  @override
  String get quizTitle_top_10_des_joueurs_france_les_plus_prolifiques_but =>
      'TOP 10 des joueurs france les plus prolifiques (buts+passes) en 2015-2020';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_pre =>
      'TOP 10 des transferts les plus coûteux en 2024 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_14 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2024';

  @override
  String get quizTitle_scorers_team_year_15 =>
      'TOP 10 des buteurs de Premier League en 2023';

  @override
  String get quizTitle_most_minutes_team_year_17 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_18 =>
      'TOP 10 des passeurs de Premier League en 2024';

  @override
  String get quizTitle_ballon_dor_year_19 => 'TOP 10 du Ballon d\'Or 2018';

  @override
  String get quizTitle_scorers_team_year_20 =>
      'TOP 10 des buteurs de Liga en 2024';

  @override
  String get quizTitle_ballon_dor_year_22 => 'TOP 10 du Ballon d\'Or 2021';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_23 =>
      'TOP 10 des passeurs de Liga en 2024';

  @override
  String get quizTitle_assists_team_period_24 =>
      'TOP 10 des passeurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_lig =>
      'TOP 10 des transferts les plus coûteux en 2023 (Ligue 1)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_27 =>
      'TOP 10 des buteurs de la Coupe du Monde 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_28 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Liga)';

  @override
  String get quizTitle_most_minutes_team_year_29 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_30 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Liga)';

  @override
  String get quizTitle_ballon_dor_year_31 => 'TOP 10 du Ballon d\'Or 2021';

  @override
  String get quizTitle_expensive_transfers_period_league_32 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Ligue 1)';

  @override
  String get quizTitle_most_minutes_team_year_33 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_bun =>
      'TOP 10 des transferts les plus coûteux en 2023 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_35 =>
      'TOP 10 des buteurs de la Euro 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_pre =>
      'TOP 10 des transferts les plus coûteux en 2023 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_37 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_38 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_39 =>
      'TOP 10 des buteurs de la Coupe du Monde 2022';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_40 =>
      'TOP 10 des passeurs de Premier League en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_41 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Liga)';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_pre =>
      'TOP 10 des transferts les plus coûteux en 2022 (Premier League)';

  @override
  String get quizTitle_scorers_team_period_43 =>
      'TOP 10 des buteurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_scorers_team_year_44 =>
      'TOP 10 des buteurs de Liga en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_45 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_46 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Liga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_47 =>
      'TOP 10 des passeurs de Liga en 2023';

  @override
  String get quizTitle_most_minutes_team_year_48 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_49 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_50 => 'TOP 10 du Ballon d\'Or 2019';

  @override
  String get quizTitle_ballon_dor_year_51 => 'TOP 10 du Ballon d\'Or 2021';

  @override
  String get quizTitle_expensive_transfers_period_league_52 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_assists_team_period_53 =>
      'TOP 10 des passeurs de PSG en 2020-2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_lig =>
      'TOP 10 des transferts les plus coûteux en 2024 (Liga)';

  @override
  String get quizTitle_most_minutes_team_year_55 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_56 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_57 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_59 =>
      'TOP 10 des passeurs de Liga en 2020-2024';

  @override
  String get quizTitle_top_10_des_joueurs_avec_le_meilleur_ratio_butsminu =>
      'TOP 10 des joueurs avec le meilleur ratio buts/minutes de Premier League en 2024';

  @override
  String get quizTitle_most_minutes_team_year_61 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_62 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_63 =>
      'TOP 10 des passeurs de Premier League en 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_64 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Liga)';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_lig =>
      'TOP 10 des transferts les plus coûteux en 2022 (Liga)';

  @override
  String get quizTitle_most_minutes_team_year_66 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_68 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2023_ser =>
      'TOP 10 des transferts les plus coûteux en 2023 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_70 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_72 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_ballon_dor_year_73 => 'TOP 10 du Ballon d\'Or 2022';

  @override
  String get quizTitle_most_minutes_team_year_74 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2023';

  @override
  String get quizTitle_scorers_team_period_75 =>
      'TOP 10 des buteurs de Man City en 2020-2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_ser =>
      'TOP 10 des transferts les plus coûteux en 2024 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_77 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Ligue 1)';

  @override
  String get quizTitle_expensive_transfers_period_league_78 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Liga)';

  @override
  String get quizTitle_most_minutes_team_year_82 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_83 =>
      'TOP 10 des passeurs de Ligue 1 en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_84 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_86 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_87 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2023';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_ser =>
      'TOP 10 des transferts les plus coûteux en 2022 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_89 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2023';

  @override
  String get quizTitle_scorers_team_period_90 =>
      'TOP 10 des buteurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_91 =>
      'TOP 10 des buteurs de la Copa América 2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_92 =>
      'TOP 10 des buteurs de la Euro 2024';

  @override
  String get quizTitle_scorers_team_year_93 =>
      'TOP 10 des buteurs de Premier League en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_94 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_95 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2023';

  @override
  String get quizTitle_scorers_team_year_97 =>
      'TOP 10 des buteurs de Liga en 2024';

  @override
  String get quizTitle_ballon_dor_year_98 => 'TOP 10 du Ballon d\'Or 2024';

  @override
  String get quizTitle_most_minutes_team_year_100 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2023';

  @override
  String get quizTitle_ballon_dor_year_101 => 'TOP 10 du Ballon d\'Or 2017';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_102 =>
      'TOP 10 des buteurs de la CAN 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_104 =>
      'TOP 10 des buteurs de la Coupe du Monde 2022';

  @override
  String get quizTitle_ballon_dor_year_105 => 'TOP 10 du Ballon d\'Or 2018';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_106 =>
      'TOP 10 des passeurs de Liga en 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_107 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Ligue 1)';

  @override
  String get quizTitle_scorers_team_period_110 =>
      'TOP 10 des buteurs de Man City en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_111 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2023';

  @override
  String get quizTitle_scorers_team_year_112 =>
      'TOP 10 des buteurs de Premier League en 2022';

  @override
  String get quizTitle_expensive_transfers_period_league_113 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Ligue 1)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_114 =>
      'TOP 10 des buteurs de la Coupe du Monde 2018';

  @override
  String get quizTitle_expensive_transfers_period_league_115 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_116 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_117 =>
      'TOP 10 des passeurs de Premier League en 2022';

  @override
  String get quizTitle_scorers_team_year_118 =>
      'TOP 10 des buteurs de Ligue 1 en 2024';

  @override
  String get quizTitle_most_minutes_team_year_119 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_120 =>
      'TOP 10 des passeurs de Bundesliga en 2024';

  @override
  String get quizTitle_most_minutes_team_year_121 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2022_bun =>
      'TOP 10 des transferts les plus coûteux en 2022 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_123 =>
      'TOP 10 des passeurs de Premier League en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_124 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_scorers_team_year_125 =>
      'TOP 10 des buteurs de Serie A en 2023';

  @override
  String get quizTitle_scorers_team_period_126 =>
      'TOP 10 des buteurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_127 =>
      'TOP 10 des passeurs de Bundesliga en 2023';

  @override
  String get quizTitle_scorers_team_period_128 =>
      'TOP 10 des buteurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_130 =>
      'TOP 10 des buteurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_131 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2023';

  @override
  String get quizTitle_assists_team_period_133 =>
      'TOP 10 des passeurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_scorers_team_year_134 =>
      'TOP 10 des buteurs de Ligue 1 en 2023';

  @override
  String get quizTitle_scorers_team_period_136 =>
      'TOP 10 des buteurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_137 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2023';

  @override
  String get quizTitle_assists_team_period_138 =>
      'TOP 10 des passeurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_139 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2023';

  @override
  String get quizTitle_most_minutes_team_year_140 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2024';

  @override
  String get quizTitle_most_minutes_team_year_141 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2024';

  @override
  String get quizTitle_most_minutes_team_year_143 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_144 =>
      'TOP 10 des passeurs de Serie A en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_145 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Serie A)';

  @override
  String get quizTitle_assists_team_period_146 =>
      'TOP 10 des passeurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_assists_team_period_147 =>
      'TOP 10 des passeurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_148 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_149 =>
      'TOP 10 des buteurs de la Euro 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_150 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Ligue 1)';

  @override
  String get quizTitle_scorers_team_period_151 =>
      'TOP 10 des buteurs de Liga en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_152 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_153 =>
      'TOP 10 des passeurs de Serie A en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_154 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Serie A)';

  @override
  String get quizTitle_assists_team_period_155 =>
      'TOP 10 des passeurs de Man City en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_156 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_157 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Serie A)';

  @override
  String get quizTitle_most_minutes_team_year_158 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2024';

  @override
  String get quizTitle_most_minutes_team_year_159 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_160 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Ligue 1)';

  @override
  String get quizTitle_scorers_team_period_161 =>
      'TOP 10 des buteurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_162 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2023';

  @override
  String get quizTitle_most_minutes_team_year_164 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2023';

  @override
  String get quizTitle_assists_team_period_165 =>
      'TOP 10 des passeurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_166 =>
      'TOP 10 des passeurs de Ligue 1 en 2024';

  @override
  String get quizTitle_scorers_team_year_167 =>
      'TOP 10 des buteurs de Bundesliga en 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_168 =>
      'TOP 10 des buteurs de la Euro 2021';

  @override
  String get quizTitle_scorers_team_year_169 =>
      'TOP 10 des buteurs de Liga en 2023';

  @override
  String get quizTitle_scorers_team_period_170 =>
      'TOP 10 des buteurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_171 =>
      'TOP 10 des passeurs de Ligue 1 en 2023';

  @override
  String get quizTitle_scorers_team_period_172 =>
      'TOP 10 des buteurs de Premier League en 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_173 =>
      'TOP 10 des buteurs de la Coupe du Monde 2018';

  @override
  String get quizTitle_assists_team_period_174 =>
      'TOP 10 des passeurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_scorers_team_year_175 =>
      'TOP 10 des buteurs de Serie A en 2024';

  @override
  String get quizTitle_top_10_des_transferts_les_plus_couteux_en_2024_bun =>
      'TOP 10 des transferts les plus coûteux en 2024 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_177 =>
      'TOP 10 des buteurs de la Copa América 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_178 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Bundesliga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_179 =>
      'TOP 10 des passeurs de Liga en 2022';

  @override
  String get quizTitle_most_minutes_team_year_180 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2023';

  @override
  String get quizTitle_scorers_team_year_181 =>
      'TOP 10 des buteurs de Liga en 2022';

  @override
  String get quizTitle_ballon_dor_year_182 => 'TOP 10 du Ballon d\'Or 2016';

  @override
  String get quizTitle_expensive_transfers_period_league_183 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_184 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_assists_team_period_185 =>
      'TOP 10 des passeurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_assists_team_period_186 =>
      'TOP 10 des passeurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_assists_team_period_188 =>
      'TOP 10 des passeurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2024_189 =>
      'TOP 10 des buteurs de la Euro 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_190 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Serie A)';

  @override
  String get quizTitle_scorers_team_year_191 =>
      'TOP 10 des buteurs de Bundesliga en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_192 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Ligue 1)';

  @override
  String get quizTitle_most_minutes_team_year_193 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2024';

  @override
  String get quizTitle_scorers_team_period_196 =>
      'TOP 10 des buteurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_197 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_198 =>
      'TOP 10 des passeurs de Serie A en 2023';

  @override
  String get quizTitle_assists_team_period_200 =>
      'TOP 10 des passeurs de PSG en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_201 =>
      'TOP 10 des passeurs de Ligue 1 en 2023';

  @override
  String get quizTitle_ballon_dor_year_202 => 'TOP 10 du Ballon d\'Or 2022';

  @override
  String get quizTitle_ballon_dor_year_203 => 'TOP 10 du Ballon d\'Or 2017';

  @override
  String get quizTitle_scorers_team_period_204 =>
      'TOP 10 des buteurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_206 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_207 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Liga)';

  @override
  String get quizTitle_assists_team_period_208 =>
      'TOP 10 des passeurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_209 =>
      'TOP 10 des passeurs de Bundesliga en 2023';

  @override
  String get quizTitle_assists_team_period_210 =>
      'TOP 10 des passeurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_211 =>
      'TOP 10 des buteurs de PSG en 2020-2024';

  @override
  String get quizTitle_assists_team_period_212 =>
      'TOP 10 des passeurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_213 =>
      'TOP 10 des passeurs de Ligue 1 en 2024';

  @override
  String get quizTitle_ballon_dor_year_214 => 'TOP 10 du Ballon d\'Or 2016';

  @override
  String get quizTitle_scorers_team_year_215 =>
      'TOP 10 des buteurs de Liga en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_216 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_scorers_team_period_217 =>
      'TOP 10 des buteurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_218 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_219 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_220 => 'TOP 10 du Ballon d\'Or 2018';

  @override
  String get quizTitle_expensive_transfers_period_league_221 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_222 => 'TOP 10 du Ballon d\'Or 2023';

  @override
  String get quizTitle_most_minutes_team_year_223 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2024';

  @override
  String get quizTitle_assists_team_period_224 =>
      'TOP 10 des passeurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_225 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2023';

  @override
  String get quizTitle_scorers_team_period_226 =>
      'TOP 10 des buteurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_227 =>
      'TOP 10 des buteurs de la Euro 2021';

  @override
  String get quizTitle_expensive_transfers_period_league_228 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Liga)';

  @override
  String get quizTitle_most_minutes_team_year_229 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2024';

  @override
  String get quizTitle_assists_team_period_231 =>
      'TOP 10 des passeurs de Man City en 2020-2024';

  @override
  String get quizTitle_assists_team_period_233 =>
      'TOP 10 des passeurs de Liga en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_234 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2023';

  @override
  String get quizTitle_assists_team_period_236 =>
      'TOP 10 des passeurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_237 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Liga)';

  @override
  String get quizTitle_ballon_dor_year_240 => 'TOP 10 du Ballon d\'Or 2019';

  @override
  String get quizTitle_scorers_team_period_243 =>
      'TOP 10 des buteurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_assists_team_period_244 =>
      'TOP 10 des passeurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_245 =>
      'TOP 10 des passeurs de Bundesliga en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_246 =>
      'TOP 10 des passeurs de Premier League en 2024';

  @override
  String get quizTitle_assists_team_period_247 =>
      'TOP 10 des passeurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_248 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Liga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_249 =>
      'TOP 10 des buteurs de la Coupe du Monde 2018';

  @override
  String get quizTitle_assists_team_period_250 =>
      'TOP 10 des passeurs de Liga en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_251 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_assists_team_period_252 =>
      'TOP 10 des passeurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_254 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2023';

  @override
  String get quizTitle_assists_team_period_255 =>
      'TOP 10 des passeurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_256 =>
      'TOP 10 des passeurs de Serie A en 2024';

  @override
  String get quizTitle_scorers_team_period_257 =>
      'TOP 10 des buteurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_260 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_262 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Liga)';

  @override
  String get quizTitle_scorers_team_period_263 =>
      'TOP 10 des buteurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_264 =>
      'TOP 10 des buteurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_266 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_268 =>
      'TOP 10 des passeurs de Premier League en 2022';

  @override
  String get quizTitle_most_minutes_team_year_269 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_270 =>
      'TOP 10 des passeurs de Premier League en 2023';

  @override
  String get quizTitle_assists_team_period_272 =>
      'TOP 10 des passeurs de Premier League en 2020-2024';

  @override
  String get quizTitle_scorers_team_year_274 =>
      'TOP 10 des buteurs de Premier League en 2024';

  @override
  String get quizTitle_most_minutes_team_year_276 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_277 =>
      'TOP 10 des buteurs de la Copa América 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_278 =>
      'TOP 10 des passeurs de Liga en 2023';

  @override
  String get quizTitle_ballon_dor_year_279 => 'TOP 10 du Ballon d\'Or 2019';

  @override
  String get quizTitle_most_minutes_team_year_280 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2024';

  @override
  String get quizTitle_scorers_team_period_281 =>
      'TOP 10 des buteurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_283 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2023';

  @override
  String get quizTitle_assists_team_period_284 =>
      'TOP 10 des passeurs de Man City en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_285 =>
      'TOP 10 des buteurs de PSG en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_286 =>
      'TOP 10 des passeurs de Bundesliga en 2023';

  @override
  String get quizTitle_scorers_team_period_287 =>
      'TOP 10 des buteurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_288 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2024';

  @override
  String get quizTitle_scorers_team_year_289 =>
      'TOP 10 des buteurs de Premier League en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_290 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Ligue 1)';

  @override
  String get quizTitle_ballon_dor_year_292 => 'TOP 10 du Ballon d\'Or 2018';

  @override
  String get quizTitle_expensive_transfers_period_league_293 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_294 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Liga)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_copa_america_2024_295 =>
      'TOP 10 des buteurs de la Copa América 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_296 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Liga)';

  @override
  String get quizTitle_assists_team_period_298 =>
      'TOP 10 des passeurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_299 =>
      'TOP 10 des buteurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_300 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_302 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_303 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_304 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Serie A)';

  @override
  String get quizTitle_scorers_team_period_306 =>
      'TOP 10 des buteurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_307 =>
      'TOP 10 des buteurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_scorers_team_year_308 =>
      'TOP 10 des buteurs de Premier League en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_310 =>
      'TOP 10 des passeurs de Liga en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_311 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_312 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_314 =>
      'TOP 10 des passeurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_315 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_316 =>
      'TOP 10 des buteurs de la CAN 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_317 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_318 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_319 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_320 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Liga)';

  @override
  String get quizTitle_ballon_dor_year_322 => 'TOP 10 du Ballon d\'Or 2024';

  @override
  String get quizTitle_ballon_dor_year_324 => 'TOP 10 du Ballon d\'Or 2017';

  @override
  String get quizTitle_expensive_transfers_period_league_325 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Serie A)';

  @override
  String get quizTitle_ballon_dor_year_326 => 'TOP 10 du Ballon d\'Or 2016';

  @override
  String get quizTitle_most_minutes_team_year_327 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2023';

  @override
  String get quizTitle_assists_team_period_328 =>
      'TOP 10 des passeurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_330 => 'TOP 10 du Ballon d\'Or 2022';

  @override
  String get quizTitle_scorers_team_period_331 =>
      'TOP 10 des buteurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_333 =>
      'TOP 10 des passeurs de Liga en 2023';

  @override
  String get quizTitle_most_minutes_team_year_334 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2023';

  @override
  String get quizTitle_most_minutes_team_year_335 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2024';

  @override
  String get quizTitle_most_minutes_team_year_336 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2024';

  @override
  String get quizTitle_ballon_dor_year_338 => 'TOP 10 du Ballon d\'Or 2023';

  @override
  String get quizTitle_scorers_team_period_339 =>
      'TOP 10 des buteurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_340 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_341 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_342 =>
      'TOP 10 des buteurs de la Euro 2021';

  @override
  String get quizTitle_most_minutes_team_year_343 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2023';

  @override
  String get quizTitle_most_minutes_team_year_344 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2023';

  @override
  String get quizTitle_scorers_team_period_345 =>
      'TOP 10 des buteurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_346 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2023';

  @override
  String get quizTitle_scorers_team_period_348 =>
      'TOP 10 des buteurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_349 =>
      'TOP 10 des buteurs de Chelsea en 2020-2024';

  @override
  String get quizTitle_assists_team_period_350 =>
      'TOP 10 des passeurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2023_351 =>
      'TOP 10 des passeurs de Ligue 1 en 2023';

  @override
  String get quizTitle_most_minutes_team_year_352 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_353 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_expensive_transfers_period_league_354 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_356 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_357 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Liga)';

  @override
  String get quizTitle_most_minutes_team_year_358 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_359 =>
      'TOP 10 des passeurs de Serie A en 2024';

  @override
  String get quizTitle_assists_team_period_360 =>
      'TOP 10 des passeurs de Premier League en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_361 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2024';

  @override
  String get quizTitle_assists_team_period_362 =>
      'TOP 10 des passeurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_363 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_365 =>
      'TOP 10 des passeurs de Premier League en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_366 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Liga)';

  @override
  String get quizTitle_most_minutes_team_year_367 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2024';

  @override
  String get quizTitle_assists_team_period_369 =>
      'TOP 10 des passeurs de Liga en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_372 =>
      'TOP 10 des joueurs avec le plus de minutes de PSG en 2023';

  @override
  String get quizTitle_scorers_team_period_373 =>
      'TOP 10 des buteurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_374 =>
      'TOP 10 des buteurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_377 => 'TOP 10 du Ballon d\'Or 2017';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_378 =>
      'TOP 10 des passeurs de Bundesliga en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_379 =>
      'TOP 10 des passeurs de Ligue 1 en 2024';

  @override
  String get quizTitle_scorers_team_period_380 =>
      'TOP 10 des buteurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_381 =>
      'TOP 10 des buteurs de Arsenal en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_383 =>
      'TOP 10 des buteurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_scorers_team_period_384 =>
      'TOP 10 des buteurs de Man City en 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_386 => 'TOP 10 du Ballon d\'Or 2023';

  @override
  String get quizTitle_most_minutes_team_year_387 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2024';

  @override
  String get quizTitle_assists_team_period_388 =>
      'TOP 10 des passeurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_389 =>
      'TOP 10 des passeurs de Liga en 2022';

  @override
  String get quizTitle_assists_team_period_392 =>
      'TOP 10 des passeurs de Barcelona en 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2018_393 =>
      'TOP 10 des buteurs de la Coupe du Monde 2018';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2022_394 =>
      'TOP 10 des passeurs de Premier League en 2022';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_395 =>
      'TOP 10 des passeurs de Premier League en 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_coupe_du_monde_2022_396 =>
      'TOP 10 des buteurs de la Coupe du Monde 2022';

  @override
  String get quizTitle_assists_team_period_397 =>
      'TOP 10 des passeurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_398 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2024';

  @override
  String get quizTitle_ballon_dor_year_399 => 'TOP 10 du Ballon d\'Or 2019';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2024_400 =>
      'TOP 10 des passeurs de Premier League en 2024';

  @override
  String get quizTitle_assists_team_period_402 =>
      'TOP 10 des passeurs de Man Utd en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_403 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_scorers_team_year_404 =>
      'TOP 10 des buteurs de Premier League en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_405 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_406 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_407 =>
      'TOP 10 des joueurs avec le plus de minutes de Liverpool en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_408 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Serie A)';

  @override
  String get quizTitle_assists_team_period_409 =>
      'TOP 10 des passeurs de Real Madrid en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_410 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_412 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_413 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2024';

  @override
  String get quizTitle_most_minutes_team_year_414 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2024';

  @override
  String get quizTitle_assists_team_period_415 =>
      'TOP 10 des passeurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_expensive_transfers_period_league_416 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Premier League)';

  @override
  String get quizTitle_ballon_dor_year_417 => 'TOP 10 du Ballon d\'Or 2016';

  @override
  String get quizTitle_assists_team_period_418 =>
      'TOP 10 des passeurs de Liverpool en 2020-2024';

  @override
  String get quizTitle_assists_team_period_419 =>
      'TOP 10 des passeurs de Bayern Munich en 2020-2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_420 =>
      'TOP 10 des passeurs de Serie A en 2023';

  @override
  String get quizTitle_most_minutes_team_year_421 =>
      'TOP 10 des joueurs avec le plus de minutes de Bayern Munich en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_premier_league_en_2023_422 =>
      'TOP 10 des passeurs de Premier League en 2023';

  @override
  String get quizTitle_scorers_team_period_423 =>
      'TOP 10 des buteurs de Inter Milan en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_424 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2023_426 =>
      'TOP 10 des passeurs de Liga en 2023';

  @override
  String get quizTitle_most_minutes_team_year_427 =>
      'TOP 10 des joueurs avec le plus de minutes de Chelsea en 2024';

  @override
  String get quizTitle_scorers_team_period_428 =>
      'TOP 10 des buteurs de PSG en 2020-2024';

  @override
  String get quizTitle_most_minutes_team_year_429 =>
      'TOP 10 des joueurs avec le plus de minutes de Real Madrid en 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_ligue_1_en_2024_431 =>
      'TOP 10 des passeurs de Ligue 1 en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_434 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_most_minutes_team_year_435 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_436 =>
      'TOP 10 des transferts les plus coûteux entrants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_437 =>
      'TOP 10 des transferts les plus coûteux entrants en 2010-2015 (Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_438 =>
      'TOP 10 des transferts les plus coûteux sortants en 2020-2024 (Serie A)';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2023_440 =>
      'TOP 10 des passeurs de Serie A en 2023';

  @override
  String get quizTitle_expensive_transfers_period_league_443 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Liga)';

  @override
  String get quizTitle_ballon_dor_year_444 => 'TOP 10 du Ballon d\'Or 2024';

  @override
  String get quizTitle_scorers_team_year_445 =>
      'TOP 10 des buteurs de Liga en 2024';

  @override
  String get quizTitle_assists_team_period_446 =>
      'TOP 10 des passeurs de Premier League en 2020-2024';

  @override
  String get quizTitle_scorers_team_year_447 =>
      'TOP 10 des buteurs de Premier League en 2023';

  @override
  String get quizTitle_most_minutes_team_year_448 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2024_449 =>
      'TOP 10 des passeurs de Bundesliga en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_450 =>
      'TOP 10 des transferts les plus coûteux entrants en 2020-2024 (Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_451 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Bundesliga)';

  @override
  String get quizTitle_assists_team_period_452 =>
      'TOP 10 des passeurs de PSG en 2020-2024';

  @override
  String get quizTitle_ballon_dor_year_453 => 'TOP 10 du Ballon d\'Or 2021';

  @override
  String get quizTitle_most_minutes_team_year_454 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2024';

  @override
  String get quizTitle_scorers_team_period_455 =>
      'TOP 10 des buteurs de PSG en 2020-2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_456 =>
      'TOP 10 des buteurs de la CAN 2023';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_euro_2021_457 =>
      'TOP 10 des buteurs de la Euro 2021';

  @override
  String get quizTitle_most_minutes_team_year_458 =>
      'TOP 10 des joueurs avec le plus de minutes de Arsenal en 2023';

  @override
  String get quizTitle_most_minutes_team_year_460 =>
      'TOP 10 des joueurs avec le plus de minutes de Inter Milan en 2023';

  @override
  String get quizTitle_most_minutes_team_year_461 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2023';

  @override
  String get quizTitle_most_minutes_team_year_462 =>
      'TOP 10 des joueurs avec le plus de minutes de Man City en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_463 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Serie A)';

  @override
  String get quizTitle_expensive_transfers_period_league_464 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Premier League)';

  @override
  String get quizTitle_expensive_transfers_period_league_465 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Premier League)';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2022_466 =>
      'TOP 10 des passeurs de Liga en 2022';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_467 =>
      'TOP 10 des passeurs de Liga en 2024';

  @override
  String get quizTitle_expensive_transfers_period_league_469 =>
      'TOP 10 des transferts les plus coûteux sortants en 2010-2015 (Liga)';

  @override
  String get quizTitle_expensive_transfers_period_league_470 =>
      'TOP 10 des transferts les plus coûteux sortants en 2015-2020 (Liga)';

  @override
  String get quizTitle_top_10_des_passeurs_de_bundesliga_en_2023_471 =>
      'TOP 10 des passeurs de Bundesliga en 2023';

  @override
  String get quizTitle_most_minutes_team_year_472 =>
      'TOP 10 des joueurs avec le plus de minutes de Barcelona en 2024';

  @override
  String get quizTitle_most_minutes_team_year_473 =>
      'TOP 10 des joueurs avec le plus de minutes de Man Utd en 2024';

  @override
  String get quizTitle_top_10_des_passeurs_de_serie_a_en_2024_476 =>
      'TOP 10 des passeurs de Serie A en 2024';

  @override
  String get quizTitle_top_10_des_buteurs_de_la_can_2023_477 =>
      'TOP 10 des buteurs de la CAN 2023';

  @override
  String get quizTitle_top_10_des_passeurs_de_liga_en_2024_478 =>
      'TOP 10 des passeurs de Liga en 2024';

  @override
  String get quizTitle_assists_team_period_479 =>
      'TOP 10 des passeurs de Man City en 2020-2024';
}
