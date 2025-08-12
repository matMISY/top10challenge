# Système d'Organisation Manuelle des Quiz

## Vue d'ensemble

Ce projet implémente un système complet permettant de remplacer l'organisation déterministe aléatoire des quiz par une organisation manuelle personnalisée. Le système se compose de trois parties principales :

1. **Interface web de réorganisation** (`quiz_organizer.html`)
2. **Script de traitement** (`apply_quiz_order.py`) 
3. **Intégration Flutter** (modifications dans `DataLoaderService`)

## Problématique initiale

L'application Flutter utilisait un système de mélange déterministe avec une seed fixe pour organiser ~480 quiz across 96 tiers (5 quiz par tier). Ce système ne permettait pas de contrôler manuellement l'ordre et la répartition des quiz selon leur thématique ou difficulté.

## Architecture du système

### 1. Interface web de réorganisation (`quiz_organizer.html`)

**Fonctionnalités principales :**
- Chargement des 4 fichiers JSON sources (`quiz_facile.json`, `quiz_moyen.json`, `quiz_difficile.json`, `quiz_tres_difficile.json`)
- Interface drag & drop pour organiser manuellement les quiz dans 96 tiers
- Système de filtres (recherche, difficulté, thème)
- Auto-Fill intelligent avec progression de difficulté
- Auto-Complete pour remplir uniquement les emplacements vides
- Gestion des IDs dupliqués avec système d'ID unique

**Fonctionnalités avancées :**
- **Drag & drop interne** : Réorganisation des quiz au sein d'un même tier
- **Boutons de suppression** : Retirer un quiz d'un tier
- **Code couleur thématique** : Identification visuelle des thèmes (Buteurs=rouge, Passeurs=bleu, etc.)
- **Chargement de configuration** : Importer une configuration existante
- **Statistiques en temps réel** : Quiz assignés/non-assignés, tiers complétés

**Gestion des doublons :**
- Système d'ID unique : `${quiz.id}_${index}` pour gérer les IDs dupliqués dans les fichiers sources
- Préservation de l'ID original (`original_id`) pour la correspondance avec les fichiers sources

### 2. Script de traitement (`apply_quiz_order.py`)

**Rôle :** Pont entre l'interface web et l'application Flutter

**Processus en 7 étapes :**
1. **Lecture de configuration** : Charge `quiz_order_config.json` exporté depuis l'interface web
2. **Chargement des quiz originaux** : Lit les 4 fichiers JSON sources
3. **Validation** : Vérifie la cohérence entre configuration et fichiers sources
4. **Sauvegarde** : Crée un backup automatique des fichiers originaux
5. **Création du fichier ordonné** : Génère `data/quiz_custom_order.json`
6. **Statistiques** : Affiche la répartition par tiers, difficultés et thèmes
7. **Instructions d'intégration** : Crée `CUSTOM_ORDER_INTEGRATION.md`

**Gestion des doublons :**
- Détecte les IDs dupliqués dans les fichiers sources (343 doublons trouvés)
- Ne conserve que la première occurrence de chaque ID unique
- Utilise le champ `original_id` de la configuration pour la correspondance

### 3. Intégration Flutter (`DataLoaderService`)

**Modifications apportées :**

```dart
// Flag de contrôle
static bool useCustomOrder = true;

// Nouvelle méthode de chargement personnalisé
static Future<List<Level>> _loadCustomOrderedQuizzes() async {
  // Charge data/quiz_custom_order.json
  // Respecte les champs tier_id et position_in_tier
  // Fallback vers le système original en cas d'erreur
}

// Logique modifiée dans loadAllQuizzesWithTiers()
if (useCustomOrder) {
  allLevels = await _loadCustomOrderedQuizzes();
}
if (allLevels.isEmpty) {
  // Fallback vers le système déterministe original
}
```

## Workflow complet

### Étape 1 : Organisation manuelle
```bash
# Ouvrir l'interface web
open quiz_organizer.html

# Actions dans l'interface :
# 1. Load Quiz Files (charger les 4 fichiers JSON)
# 2. Organiser manuellement par drag & drop
# 3. Utiliser Auto-Fill ou Auto-Complete si besoin
# 4. Export Configuration (télécharge quiz_order_config.json)
```

### Étape 2 : Traitement
```bash
# Placer le fichier exporté à la racine du projet
cp ~/Téléchargements/quiz_order_config.json ./

# Exécuter le script de traitement
python3 apply_quiz_order.py

# Résultat : data/quiz_custom_order.json créé
```

### Étape 3 : Utilisation Flutter
```bash
# Rebuild de l'app Flutter
flutter build apk
# L'app utilise automatiquement l'ordre personnalisé
```

## Structure des fichiers

### Configuration exportée (`quiz_order_config.json`)
```json
{
  "quiz_order": [
    {
      "quiz_id": "1_343",           // ID unique (système anti-doublon)
      "original_id": 1,             // ID original du fichier source
      "title": "TOP 10 du Ballon d'Or 2024",
      "tier": 1,                    // Numéro du tier (1-96)
      "position": 1,                // Position dans le tier (1-5)
      "original_difficulty": 1
    }
  ]
}
```

### Fichier Flutter généré (`data/quiz_custom_order.json`)
```json
{
  "generated_at": "2025-08-12T23:38:24.034962Z",
  "custom_order_applied": true,
  "total_quizzes": 139,
  "quizzes": [
    {
      "id": 1,
      "title": "TOP 10 du Ballon d'Or 2024",
      "tier_id": 1,                 // Pour DataLoaderService
      "position_in_tier": 1,        // Pour DataLoaderService
      "custom_order": true,         // Flag d'identification
      // ... autres champs du quiz original
    }
  ]
}
```

## Fonctionnalités avancées

### Auto-Fill intelligent
- Répartition progressive de la difficulté (1-2 pour les premiers 20% de tiers, etc.)
- Sélection du 5ème quiz (boss) avec difficulté élevée
- Respect des thématiques disponibles

### Auto-Complete
- Préserve les quiz déjà placés manuellement
- Complète uniquement les emplacements vides
- Utilise la même logique de progression que l'Auto-Fill

### Code couleur thématique
```css
.theme-buteurs { color: #e74c3c; }      /* Rouge */
.theme-passeurs { color: #3498db; }     /* Bleu */
.theme-transferts { color: #f39c12; }   /* Orange */
.theme-competitions { color: #9b59b6; } /* Violet */
/* ... autres thèmes */
```

## Gestion des cas d'erreur

### Fichiers sources avec doublons
- **Problème** : 343 quiz ont des IDs dupliqués across les 4 fichiers
- **Solution** : Système d'ID unique `${id}_${index}` + utilisation du premier occurrence

### Configuration incomplète
- **Fallback automatique** : DataLoaderService rebascule vers le système déterministe
- **Logs explicites** : Indication claire du mode utilisé dans les logs Flutter

### Validation robuste
- Vérification de la cohérence entre configuration et fichiers sources
- Detection des champs manquants
- Backup automatique avant modification

## Statistiques du projet

**Données traitées :**
- 482 quiz au total dans les fichiers sources
- 139 quiz uniques (après déduplication)
- 96 tiers de 5 quiz chacun
- 343 doublons détectés et gérés

**Répartition thématique :**
- Transferts : 136 quiz
- Passeurs : 96 quiz  
- Minutes jouées : 80 quiz
- Buteurs : 64 quiz
- Ballon d'Or : 32 quiz

**Répartition par difficulté :**
- Difficulté 1 : 12 quiz
- Difficulté 2 : 135 quiz
- Difficulté 3 : 333 quiz

## Maintenance et évolution

### Ajout de nouveaux quiz
1. Ajouter les quiz dans les fichiers JSON sources
2. Réorganiser avec l'interface web si nécessaire
3. Relancer le script de traitement

### Modification de l'organisation
1. Charger la configuration existante dans l'interface web
2. Effectuer les modifications
3. Exporter et retraiter

### Désactivation du système personnalisé
```dart
// Dans DataLoaderService
static bool useCustomOrder = false;
```

## Outils de développement

### Scripts utiles
- `quiz_organizer.html` : Interface principale
- `apply_quiz_order.py` : Script de traitement
- Fichiers de backup automatiques dans `data/backup_YYYYMMDD_HHMMSS/`

### Debugging
- Logs détaillés dans le script Python
- Logs Flutter pour confirmer le mode utilisé
- Statistiques complètes lors du traitement

## Conclusion

Ce système offre une solution complète pour l'organisation manuelle des quiz tout en conservant la compatibilité avec le système original. L'architecture modulaire permet une maintenance facile et des évolutions futures. Le système de fallback garantit la robustesse en cas de problème avec l'ordre personnalisé.