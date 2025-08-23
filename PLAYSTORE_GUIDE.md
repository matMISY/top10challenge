# Guide de Publication Play Store - Top10 Challenge

## ✅ Configuration Terminée

### 🔐 Signature et Sécurité
- ✅ Keystore de production créé (`android/app/upload-keystore.jks`)
- ✅ Configuration de signature dans `android/key.properties`
- ✅ Build.gradle configuré pour la production
- ✅ ProGuard configuré pour l'obfuscation

### 📱 Assets et Métadonnées
- ✅ Icône Play Store 512x512 disponible
- ✅ Descriptions FR/EN créées
- ✅ Script de build automatisé

## 🚀 Étapes de Publication

### 1. Générer les fichiers finaux
```bash
./build-playstore.sh
```

### 2. Google Play Console
1. Créer un compte développeur Google Play (25$ unique)
2. Créer une nouvelle application
3. Uploader l'App Bundle (`.aab`) - **Recommandé**

### 3. Métadonnées à compléter

#### Descriptions
- **Courte** : Utiliser `playstore-metadata/short-description-fr.txt`
- **Complète** : Utiliser `playstore-metadata/description-fr.txt`

#### Assets visuels requis
- ✅ **Icône d'application** : `assets/launcher_icons/android/playstore-icon.png`
- ❌ **Captures d'écran** : À prendre (téléphone et tablette)
- ❌ **Graphic feature** : 1024x500px (optionnel mais recommandé)

#### Informations de l'app
- **Nom** : Top10 Challenge
- **Catégorie** : Jeux > Quiz
- **Classification** : Tout public
- **Pays de publication** : France (ou mondial)

### 4. Politique de confidentialité
**⚠️ Obligatoire** - L'app utilise AdMob, une politique est requise.

### 5. Version de test (Recommandé)
- Commencer par une version de test interne
- Tester sur quelques appareils
- Puis publier en production

## 🔧 Fichiers Importants

### Configuration
- `android/key.properties` - Clés de signature
- `android/app/upload-keystore.jks` - Keystore (à sauvegarder)
- `android/app/build.gradle` - Configuration build

### Assets
- `assets/launcher_icons/android/playstore-icon.png` - Icône 512x512
- `playstore-metadata/` - Descriptions prêtes

### Scripts
- `build-playstore.sh` - Build automatique
- Version générée : `release/top10challenge-v3.2.0-[timestamp].aab`

## ⚠️ Points d'Attention

1. **Keystore** : Sauvegarder `upload-keystore.jks` et le mot de passe
2. **Politique de confidentialité** : Obligatoire pour AdMob
3. **Captures d'écran** : Min 2, max 8 par type d'appareil
4. **App Bundle** : Préférer `.aab` à `.apk`
5. **Version** : Incrémenter à chaque mise à jour

## 🎯 Prochaines Actions Manuelles

1. [ ] Prendre des captures d'écran
2. [ ] Créer une politique de confidentialité
3. [ ] Créer le compte Google Play Console
4. [ ] Uploader et configurer l'app
5. [ ] Soumettre pour révision

## 📞 Support
- Durée de révision : 1-7 jours
- En cas de rejet : suivre les recommandations Google
- Mise à jour : répéter le processus avec nouvelle version