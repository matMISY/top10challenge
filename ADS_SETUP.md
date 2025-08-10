# Configuration des Publicités - Guide Utilisateur

## 🎯 Actions requises de votre part

### 1. Création du compte AdMob (obligatoire pour la production)

1. **Créer un compte AdMob** :
   - Aller sur https://admob.google.com
   - Se connecter avec votre compte Google
   - Créer une nouvelle application : "Top10 Challenge"

2. **Créer les unités publicitaires** :
   - Type : "Récompensée" (Rewarded)
   - Nom : "Life Reward Ad" ou similaire
   - Récupérer les IDs de production (format : ca-app-pub-xxxxxxxxx/xxxxxxxxx)

### 2. Remplacer les IDs de test dans le code

**Fichier à modifier** : `lib/services/ads_service.dart`

```dart
// REMPLACER CES LIGNES :
static const String _rewardedAdUnitIdAndroid = 'ca-app-pub-3940256099942544/5224354917'; // ID de test
static const String _rewardedAdUnitIdIOS = 'ca-app-pub-3940256099942544/1712485313'; // ID de test

// PAR VOS VRAIS IDs AdMob :
static const String _rewardedAdUnitIdAndroid = 'ca-app-pub-VOTRE-ID-ANDROID/XXXXXXXXX';
static const String _rewardedAdUnitIdIOS = 'ca-app-pub-VOTRE-ID-IOS/XXXXXXXXX';
```

### 3. Configuration Android (android/app/src/main/AndroidManifest.xml)

Ajouter dans `<application>` :

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-VOTRE-APP-ID~XXXXXXXXX"/>
```

### 4. Configuration iOS (ios/Runner/Info.plist)

Ajouter dans le dictionnaire :

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-VOTRE-APP-ID~XXXXXXXXX</string>
```

### 5. Tests recommandés

1. **Flutter pub get** :
   ```bash
   flutter pub get
   ```

2. **Test sur émulateur avec IDs de test** :
   - Vérifier que les pubs s'affichent
   - Tester le flow complet (regarder pub → gagner vie)

3. **Test sur appareil réel avec vrais IDs** :
   - Créer un build de test avec vos IDs de production
   - Tester sur Android et iOS physiques

## 🔧 Paramètres actuels configurés

### Publicités pour les vies
- **Cooldown** : 2 minutes entre chaque pub
- **Récompense** : +5 vies par pub
- **Limite** : Maximum 10 vies (avec pubs), 5 vies naturelles
- **Affichage** : Bouton visible uniquement si vies < 5

### Publicités pour les indices  
- **Cooldown** : 5 minutes entre chaque pub
- **Récompense** : +12 points d'indices par pub
- **Limite** : Maximum 999 points d'indices
- **Affichage** : Bouton toujours visible

### Interface commune
- **États adaptatifs** : Loading, cooldown timer, erreurs
- **Fallbacks** : Gestion des erreurs réseau/indisponibilité

## 📱 Fonctionnalités implémentées

✅ **HomeScreen** : 
  - Bouton pub pour vies (visible si vies < 5)
  - Bouton pub pour indices (toujours visible)
✅ **GameScreen** : Option pub après Game Over  
✅ **États UI** : Loading, cooldown timer, erreurs  
✅ **Persistance** : Sauvegarde des cooldowns entre sessions  
✅ **UX** : Messages de feedback utilisateur clairs

## 🎮 Logique d'affichage des boutons publicitaires

### Bouton publicité pour les vies

**Condition d'affichage :**
- Visible uniquement si `lives < 5` (GameState.maxLives)

**États du bouton :**
- **Activé** si :
  - Moins de 10 vies (limite absolue)
  - Cooldown respecté (2 minutes depuis dernière pub)
  - Service publicitaire prêt
  - Aucune pub en cours

- **Désactivé** si :
  - En cooldown (affiche temps restant)
  - Service publicitaire non prêt
  - Publicité en cours de chargement

### Bouton publicité pour les indices

**Condition d'affichage :**
- Toujours visible sur l'écran principal

**États du bouton :**
- **Activé** si :
  - Cooldown respecté (5 minutes depuis dernière pub)
  - Service publicitaire prêt
  - Aucune pub en cours

- **Désactivé** si :
  - En cooldown (affiche temps restant)
  - Service publicitaire non prêt
  - Publicité en cours de chargement

### Implémentation technique

**Fichiers impliqués :**
- `lib/screens/home_screen.dart:82-89` : Logique d'affichage
- `lib/providers/game_provider.dart:387,464` : Méthodes de validation
- `lib/models/game_state.dart:186,207` : Conditions cooldown
- `lib/services/ads_service.dart` : Service publicitaire  

## 🚀 Prêt pour production

L'implémentation est **complète et prête pour la production** après :
1. Remplacement des IDs de test
2. Configuration AndroidManifest.xml / Info.plist
3. Tests sur appareils réels

## ⚙️ Personnalisations possibles

Si vous souhaitez ajuster :
- **Cooldown vies** : Modifier `adCooldownDuration` dans `GameState` (ligne 19)
- **Cooldown indices** : Modifier `hintAdCooldownDuration` dans `GameState` (ligne 20)  
- **Récompenses** : Modifier `HintConfig.pointsPerAd` pour les indices
- **Couleurs boutons** : 
  - Vies : `Colors.purple` dans `home_screen.dart:321`
  - Indices : `Colors.amber` dans `home_screen.dart:439`
- **Messages** : Personnaliser les textes dans les SnackBar