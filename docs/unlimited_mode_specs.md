# Spécifications - Money Time 💰⏰

## Vue d'ensemble
Le **Money Time** est une fonctionnalité premium permettant aux joueurs de jouer sans perdre de vies pendant une durée déterminée, en échange du visionnage de plusieurs publicités récompensées. Le nom fait référence aux moments décisifs dans le sport où chaque action compte.

## Objectifs
- **Monétisation** : Augmenter les revenus publicitaires via le visionnage de publicités multiples
- **Engagement** : Offrir aux joueurs des sessions de jeu prolongées sans frustration
- **Rétention** : Créer un mécanisme de récompense qui encourage le retour quotidien

## Mécaniques de base

### 1. Activation du mode

#### Conditions d'activation
- Le joueur doit regarder **3 publicités récompensées consécutives** (paramétrable)
- Les publicités doivent être regardées en entier pour compter
- Si le joueur quitte entre deux publicités, le compteur est réinitialisé
- Un cooldown de **4 heures** empêche la réactivation immédiate

#### Options de durée
Le joueur peut choisir la durée avant de lancer les publicités :
- **15 minutes** : 2 publicités
- **30 minutes** : 3 publicités (par défaut)
- **60 minutes** : 5 publicités

### 2. Comportement pendant le Money Time

#### Effets actifs
- **Immunité aux pertes de vies** : Les mauvaises réponses n'enlèvent pas de vies
- **Conservation des gains** : Les points et indices gagnés sont conservés
- **Progression normale** : Le joueur peut compléter des niveaux et débloquer des tiers

#### Restrictions
- Les indices continuent de coûter des points
- Le mode ne peut pas être cumulé (pas d'extension possible)
- Les vies normales ne se régénèrent pas pendant le Money Time

### 3. Interface utilisateur

#### Point d'entrée
- Bouton dédié sur l'écran principal : "Money Time 💰"
- Badge indicateur si disponible ou temps restant avant disponibilité

#### Écran d'activation
```
┌─────────────────────────────┐
│      MONEY TIME 💰⏰        │
│                             │
│  Jouez sans perdre de vies! │
│                             │
│  Choisissez votre durée :   │
│                             │
│  ○ 15 min (2 pubs)         │
│  ● 30 min (3 pubs)         │
│  ○ 60 min (5 pubs)         │
│                             │
│  [REGARDER LES PUBS]        │
│                             │
│  Disponible dans : --:--    │
└─────────────────────────────┘
```

#### Indicateurs visuels pendant le mode
- **Timer permanent** : Affichage du temps restant en haut de l'écran
- **Effet visuel** : Bouclier doré autour du compteur de vies
- **Animation** : Pulsation subtile du bouclier toutes les 5 secondes
- **Notification** : Alert 1 minute avant la fin

#### Écran de progression des publicités
```
┌─────────────────────────────┐
│   ACTIVATION EN COURS...    │
│                             │
│    Publicité 2 sur 3        │
│                             │
│    [██████████░░░░░░]       │
│                             │
│  Ne quittez pas l'écran !   │
└─────────────────────────────┘
```

## Implémentation technique

### Modifications du GameState

```dart
class GameState {
  // Nouveaux champs
  final DateTime? moneyTimeEndTime;
  final DateTime? lastMoneyTimeActivation;
  final int moneyTimeAdsWatched; // Compteur temporaire
  
  // Nouvelles méthodes
  bool isMoneyTimeActive();
  Duration? getMoneyTimeRemaining();
  bool canActivateMoneyTime();
  Duration? getTimeUntilMoneyTimeAvailable();
}
```

### Configuration

```dart
class MoneyTimeConfig {
  static const Map<int, int> durationToAds = {
    15: 2,  // 15 minutes = 2 pubs
    30: 3,  // 30 minutes = 3 pubs
    60: 5,  // 60 minutes = 5 pubs
  };
  
  static const Duration cooldownDuration = Duration(hours: 4);
  static const Duration warningBeforeEnd = Duration(minutes: 1);
}
```

### Service de gestion

```dart
class MoneyTimeService {
  // Gestion de l'activation
  Future<bool> startActivationProcess(int durationMinutes);
  void cancelActivation();
  
  // Gestion du mode
  bool shouldPreventLifeLoss();
  void checkAndNotifyTimeRemaining();
  
  // Persistance
  void saveState();
  void loadState();
}
```

## Flux utilisateur

### Premier usage
1. Le joueur découvre le bouton "Money Time" sur l'écran principal
2. Popup explicatif lors du premier clic
3. Sélection de la durée souhaitée
4. Visionnage des publicités requises
5. Activation du mode et retour au jeu

### Usage récurrent
1. Vérification de la disponibilité (cooldown)
2. Si disponible : processus d'activation
3. Si en cooldown : affichage du temps restant

### Gestion des interruptions
- **Entre les pubs** : Confirmation pour quitter + reset du compteur
- **Pendant une pub** : Impossible de quitter (comportement standard)
- **Après activation** : Sauvegarde immédiate de l'état

## Notifications et feedback

### Messages système
- **Activation réussie** : "Money Time activé pour 30 minutes ! 💰"
- **1 minute avant la fin** : "Attention ! Money Time termine dans 1 minute"
- **Fin du mode** : "Money Time terminé. Vous pouvez le réactiver dans 4h"
- **Tentative pendant cooldown** : "Money Time disponible dans X heures"

### Sons et animations
- **Son d'activation** : Fanfare courte et positive
- **Animation d'activation** : Effet de bouclier qui se déploie
- **Son d'avertissement** : Bip doux 1 minute avant la fin
-
## Architecture technique détaillée

### 1. Structure des données

#### GameState - Modifications
```dart
class GameState {
  // Champs existants
  final int lives;
  final DateTime? lastLifeLostTime;
  
  // Nouveaux champs Money Time
  final DateTime? moneyTimeEndTime;
  final DateTime? lastMoneyTimeActivation; 
  final int moneyTimeAdsWatched; // Compteur temporaire (0-5)
  final int selectedMoneyTimeDuration; // 15, 30 ou 60 minutes
  
  // Nouvelles méthodes
  bool isMoneyTimeActive() {
    if (moneyTimeEndTime == null) return false;
    return DateTime.now().isBefore(moneyTimeEndTime!);
  }
  
  Duration? getMoneyTimeRemaining() {
    if (!isMoneyTimeActive()) return null;
    return moneyTimeEndTime!.difference(DateTime.now());
  }
  
  bool canActivateMoneyTime() {
    if (lastMoneyTimeActivation == null) return true;
    final cooldown = DateTime.now().difference(lastMoneyTimeActivation!);
    return cooldown >= MoneyTimeConfig.cooldownDuration;
  }
  
  Duration? getTimeUntilMoneyTimeAvailable() {
    if (canActivateMoneyTime()) return null;
    final nextAvailable = lastMoneyTimeActivation!.add(MoneyTimeConfig.cooldownDuration);
    return nextAvailable.difference(DateTime.now());
  }
}
```

### 2. Services

#### MoneyTimeService - Service principal
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../services/ads_service.dart';
import '../providers/game_provider.dart';

class MoneyTimeService {
  final AdsService _adsService;
  final GameProvider _gameProvider;
  
  Timer? _warningTimer;
  Timer? _endTimer;
  Timer? _countdownTimer;
  
  // État de l'activation en cours
  int _currentAdsWatched = 0;
  int _targetAds = 0;
  int _selectedDuration = 30;
  
  MoneyTimeService({
    required AdsService adsService,
    required GameProvider gameProvider,
  }) : _adsService = adsService,
       _gameProvider = gameProvider;
  
  /// Démarre le processus d'activation
  Future<bool> startActivationProcess(int durationMinutes) async {
    _selectedDuration = durationMinutes;
    _targetAds = MoneyTimeConfig.durationToAds[durationMinutes] ?? 3;
    _currentAdsWatched = 0;
    
    // Sauvegarder la progression
    await _gameProvider.updateMoneyTimeProgress(_currentAdsWatched, _selectedDuration);
    
    // Lancer le visionnage des pubs
    return await _watchAdsSequentially();
  }
  
  /// Gère le visionnage séquentiel des pubs
  Future<bool> _watchAdsSequentially() async {
    while (_currentAdsWatched < _targetAds) {
      // Vérifier si une pub est prête
      if (!_adsService.isRewardedAdReady) {
        await _adsService.preloadRewardedAd();
        await Future.delayed(Duration(seconds: 2));
        
        if (!_adsService.isRewardedAdReady) {
          // Échec du chargement
          _resetActivation();
          return false;
        }
      }
      
      // Afficher la pub
      bool success = await _adsService.showRewardedAd();
      
      if (!success) {
        // L'utilisateur a quitté ou erreur
        _resetActivation();
        return false;
      }
      
      _currentAdsWatched++;
      await _gameProvider.updateMoneyTimeProgress(_currentAdsWatched, _selectedDuration);
      
      // Si pas la dernière pub, afficher la progression
      if (_currentAdsWatched < _targetAds) {
        // Le widget MoneyTimeProgress affichera l'état
        await Future.delayed(Duration(seconds: 1));
      }
    }
    
    // Toutes les pubs regardées, activer le mode
    return await _activateMoneyTime();
  }
  
  /// Active effectivement le Money Time
  Future<bool> _activateMoneyTime() async {
    final endTime = DateTime.now().add(Duration(minutes: _selectedDuration));
    
    await _gameProvider.activateMoneyTime(endTime);
    
    // Planifier les timers
    _scheduleWarning();
    _scheduleEnd();
    _startCountdownTimer();
    
    return true;
  }
  
  /// Planifie l'avertissement 1 minute avant la fin
  void _scheduleWarning() {
    final warningTime = Duration(minutes: _selectedDuration - 1);
    _warningTimer = Timer(warningTime, () {
      _gameProvider.showMoneyTimeWarning();
    });
  }
  
  /// Planifie la fin du Money Time
  void _scheduleEnd() {
    _endTimer = Timer(Duration(minutes: _selectedDuration), () {
      _endMoneyTime();
    });
  }
  
  /// Timer pour mise à jour UI chaque seconde
  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_gameProvider.gameState.isMoneyTimeActive()) {
        timer.cancel();
      } else {
        // Déclenche un rebuild des widgets qui écoutent
        _gameProvider.notifyListeners();
      }
    });
  }
  
  /// Termine le Money Time
  void _endMoneyTime() {
    _cancelTimers();
    _gameProvider.endMoneyTime();
  }
  
  /// Annule l'activation en cours
  void _resetActivation() {
    _currentAdsWatched = 0;
    _targetAds = 0;
    _gameProvider.resetMoneyTimeProgress();
  }
  
  /// Annule tous les timers
  void _cancelTimers() {
    _warningTimer?.cancel();
    _endTimer?.cancel();
    _countdownTimer?.cancel();
  }
  
  /// Vérifie si une perte de vie doit être empêchée
  bool shouldPreventLifeLoss() {
    return _gameProvider.gameState.isMoneyTimeActive();
  }
  
  void dispose() {
    _cancelTimers();
  }
}
```

### 3. UI Components

#### MoneyTimeButton - Bouton principal
```dart
class MoneyTimeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final canActivate = gameProvider.gameState.canActivateMoneyTime();
        final isActive = gameProvider.gameState.isMoneyTimeActive();
        final timeUntilAvailable = gameProvider.gameState.getTimeUntilMoneyTimeAvailable();
        
        if (isActive) {
          // Afficher le temps restant
          final remaining = gameProvider.gameState.getMoneyTimeRemaining();
          return _buildActiveButton(remaining);
        } else if (canActivate) {
          return _buildAvailableButton(context);
        } else {
          return _buildCooldownButton(timeUntilAvailable);
        }
      },
    );
  }
  
  Widget _buildActiveButton(Duration? remaining) {
    final minutes = remaining?.inMinutes ?? 0;
    final seconds = (remaining?.inSeconds ?? 0) % 60;
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Colors.orange],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Money Time: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4. Intégration GameProvider

```dart
// Ajouts dans GameProvider
class GameProvider extends ChangeNotifier {
  
  // Money Time methods
  Future<void> updateMoneyTimeProgress(int adsWatched, int duration) async {
    _gameState = _gameState.copyWith(
      moneyTimeAdsWatched: adsWatched,
      selectedMoneyTimeDuration: duration,
    );
    await _saveGameState();
    notifyListeners();
  }
  
  Future<void> activateMoneyTime(DateTime endTime) async {
    _gameState = _gameState.copyWith(
      moneyTimeEndTime: endTime,
      lastMoneyTimeActivation: DateTime.now(),
      moneyTimeAdsWatched: 0,
    );
    
    // Feedback visuel
    await _feedbackService.showSuccess(
      'Money Time activé pour ${_gameState.selectedMoneyTimeDuration} minutes! 💰',
    );
    
    await _saveGameState();
    notifyListeners();
  }
  
  void showMoneyTimeWarning() {
    _feedbackService.showWarning(
      'Money Time termine dans 1 minute!',
    );
  }
  
  Future<void> endMoneyTime() async {
    _gameState = _gameState.copyWith(
      moneyTimeEndTime: null,
    );
    
    await _feedbackService.showInfo(
      'Money Time terminé. Prochain disponible dans 4h',
    );
    
    await _saveGameState();
    notifyListeners();
  }
  
  void resetMoneyTimeProgress() {
    _gameState = _gameState.copyWith(
      moneyTimeAdsWatched: 0,
    );
    notifyListeners();
  }
  
  // Modifier la méthode loseLife existante
  Future<void> loseLife() async {
    // Vérifier si Money Time est actif
    if (_gameState.isMoneyTimeActive()) {
      // Ne pas perdre de vie, juste feedback
      await _feedbackService.showInfo(
        'Money Time actif - Pas de vie perdue! 💰',
      );
      return;
    }
    
    // Code existant pour perdre une vie...
  }
}
```

## Plan de développement détaillé

### Phase 1 : Backend Core (Jour 1)
**Matin (4h)**
- [ ] Créer la branche feature/money-time
- [ ] Modifier GameState avec les nouveaux champs
- [ ] Implémenter les méthodes isMoneyTimeActive, etc.
- [ ] Ajouter la sérialisation JSON
- [ ] Tests unitaires GameState

**Après-midi (4h)**
- [ ] Créer MoneyTimeConfig 
- [ ] Créer MoneyTimeService base
- [ ] Intégrer avec AdsService
- [ ] Tests unitaires MoneyTimeService

### Phase 2 : Intégration Provider (Jour 2)
**Matin (4h)**
- [ ] Modifier GameProvider avec méthodes Money Time
- [ ] Intégrer MoneyTimeService dans GameProvider
- [ ] Modifier la méthode loseLife()
- [ ] Tests d'intégration

**Après-midi (4h)**
- [ ] Gestion de la persistance
- [ ] Gestion des timers et lifecycle
- [ ] Gestion des cas d'erreur
- [ ] Tests edge cases

### Phase 3 : UI Activation (Jour 3)
**Matin (4h)**
- [ ] Créer MoneyTimeButton widget
- [ ] Créer MoneyTimeSelectionDialog
- [ ] Créer MoneyTimeProgressScreen
- [ ] Intégration dans HomeScreen

**Après-midi (4h)**
- [ ] Animations du bouton
- [ ] Gestion états (actif/cooldown/disponible)
- [ ] Tests UI widgets

### Phase 4 : UI In-Game (Jour 4)
**Matin (4h)**
- [ ] Créer MoneyTimeIndicator (timer en jeu)
- [ ] Effet visuel bouclier sur les vies
- [ ] Animation pulsation
- [ ] Intégration dans GameScreen

**Après-midi (4h)**
- [ ] Notification 1 minute avant fin
- [ ] Animation de fin
- [ ] Polish visuel
- [ ] Tests visuels

### Phase 5 : Polish & Feedback (Jour 5)
**Matin (4h)**
- [ ] Sons (activation, warning, fin)
- [ ] Feedback haptique
- [ ] Messages overlay_feedback
- [ ] Optimisation performances

**Après-midi (4h)**
- [ ] Tests end-to-end complets
- [ ] Fix bugs trouvés
- [ ] Documentation code
- [ ] Préparation release

### Phase 6 : Analytics & Release (Jour 6)
**Matin (4h)**
- [ ] Events analytics (activation, completion, abandon)
- [ ] Tracking revenus
- [ ] A/B test setup
- [ ] Tests en production test

**Après-midi (4h)**
- [ ] Build release
- [ ] Tests sur devices réels
- [ ] Documentation utilisateur
- [ ] Déploiement progressif

## Points d'attention techniques

### Gestion des états
- Sauvegarder après chaque pub regardée
- Gérer les crashes pendant les pubs
- Restaurer les timers au redémarrage app

### Performance
- Timer UI update seulement si écran visible
- Lazy loading des animations
- Dispose proper des timers

### Edge cases
- App en background pendant Money Time
- Changement d'heure système
- Perte connexion pendant les pubs
- Rotation écran pendant activation
