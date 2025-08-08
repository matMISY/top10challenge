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

- **Cooldown** : 30 minutes entre chaque pub pour vie
- **Limite** : +1 vie par pub (max 5 vies)
- **Interface** : Boutons adaptatifs selon disponibilité
- **Fallbacks** : Gestion des erreurs réseau/indisponibilité

## 📱 Fonctionnalités implémentées

✅ **HomeScreen** : Bouton "Regarder une pub" si vies < 5  
✅ **GameScreen** : Option pub après Game Over  
✅ **États UI** : Loading, cooldown timer, erreurs  
✅ **Persistance** : Sauvegarde du cooldown entre sessions  
✅ **UX** : Messages de feedback utilisateur clairs  

## 🚀 Prêt pour production

L'implémentation est **complète et prête pour la production** après :
1. Remplacement des IDs de test
2. Configuration AndroidManifest.xml / Info.plist
3. Tests sur appareils réels

## ⚙️ Personnalisations possibles

Si vous souhaitez ajuster :
- **Cooldown** : Modifier `adCooldownDuration` dans `GameState` (ligne 16)
- **Couleur boutons** : Modifier `Colors.purple` dans `home_screen.dart`
- **Messages** : Personnaliser les textes dans les SnackBar