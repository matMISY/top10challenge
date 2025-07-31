# TOP10 Challenge ⚽

Une application mobile de quiz de football développée avec Flutter. Testez vos connaissances sur les meilleurs joueurs, transferts, et statistiques du football !

## 📱 Fonctionnalités

- **Quiz interactifs** : Trouvez les 10 meilleurs joueurs dans différentes catégories
- **Système de vies** : 5 vies par session de jeu
- **Indices** : Utilisez des indices pour révéler des réponses
- **Sauvegarde automatique** : Vos réponses sont sauvegardées si vous quittez un quiz
- **Progression** : Débloquez de nouveaux niveaux en complétant les précédents
- **Interface moderne** : Design élégant avec animations fluides

## 🎮 Catégories de Quiz

- **Transferts** : Les plus gros transferts du football
- **Buteurs** : Meilleurs buteurs par compétition
- **Passeurs** : Meilleurs passeurs de championnats
- **Coupes européennes** : Buteurs en compétitions internationales

## 📥 Installation

### APK Release
Téléchargez la dernière version depuis le dossier `release/` :
- [top10-challenge-v1.0.0.apk](release/top10-challenge-v1.0.0.apk)

### Développement
```bash
# Cloner le repository
git clone https://github.com/matMISY/top10challenge.git
cd top10challenge

# Installer les dépendances
flutter pub get

# Lancer en mode debug
flutter run

# Construire l'APK release
flutter build apk --release
```

## 🛠️ Architecture

### Structure du projet
```
lib/
├── data/                    # Données des quiz (JSON)
├── models/                  # Modèles de données
├── providers/               # Gestion d'état avec Provider
├── screens/                 # Écrans de l'application
├── services/                # Services (données, recherche, etc.)
├── utils/                   # Utilitaires et configuration
└── widgets/                 # Composants réutilisables
```

### Technologies utilisées
- **Flutter** : Framework de développement mobile
- **Provider** : Gestion d'état
- **SharedPreferences** : Stockage local des données
- **Google Fonts** : Polices personnalisées
- **Flag** : Affichage des drapeaux de pays

## 🎯 Système de Jeu

### Vies et Indices
- **5 vies** par session
- **3 indices** au début
- Gagnez des indices en complétant des niveaux
- Les vies se rechargent quotidiennement

### Progression
- Débloquez les niveaux séquentiellement
- Vos réponses sont sauvegardées automatiquement
- Retournez à un quiz en cours pour continuer où vous vous êtes arrêté

## 🔧 Configuration Debug

Le fichier `lib/utils/debug_config.dart` permet d'activer des fonctionnalités de debug :

```dart
static const bool enableRevealAnswers = true;  // Révéler les réponses
static const bool enableSkipLevel = true;      // Passer un niveau
static const bool hideDailyChallenge = true;   // Masquer le défi quotidien
```

## 📊 Données

Les quiz sont chargés depuis des fichiers JSON dans le dossier `data/` :
- Transferts, buteurs, passeurs
- Plus de 2400+ noms de joueurs pour l'autocomplétion
- Données mises à jour régulièrement

## 🚀 Versions

### v1.0.0 (Actuelle)
- ✅ Sauvegarde des réponses dévoilées dans les quiz
- ✅ Masquage du bouton "Défi Quotidien"
- ✅ Correction du chargement des fichiers JSON
- ✅ Interface utilisateur complète
- ✅ Système de progression et déblocage

## 🤝 Contribution

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le projet
2. Créez une branche pour votre fonctionnalité
3. Committez vos changements
4. Poussez vers la branche
5. Ouvrez une Pull Request

## 📱 Screenshots

*À venir : captures d'écran de l'application*

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 🏆 Crédits

- Données de joueurs via Transfermarkt
- Développé avec Flutter
- Icônes et design personnalisés

---

**Amusez-vous bien avec TOP10 Challenge ! ⚽🎯**