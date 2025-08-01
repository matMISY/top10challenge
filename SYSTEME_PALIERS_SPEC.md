# Spécification : Système de Paliers avec 5 Niveaux

## Vue d'ensemble

Refonte complète du système de progression pour introduire une structure de **paliers** contenant chacun **5 niveaux**. Les niveaux complétés donnent des **points** (étoiles/clés) qui permettent de débloquer les paliers suivants. Quand un palier est débloqué, ses 5 niveaux sont immédiatement jouables.

## Architecture Actuelle (À Modifier)

### État Actuel
- **Model Level** : `lib/models/level.dart`
  - `id`: identifiant unique du niveau
  - `difficulty`: difficulté de 1 à 3
  - `isUnlocked/isCompleted`: états de progression
- **GameService** : `lib/services/game_service.dart`
  - Déblocage séquentiel (niveau n+1 après niveau n)
  - Système de vies et indices basé sur la difficulté
- **DataLoaderService** : `lib/services/data_loader_service.dart`
  - Chargement mélangé déterministe de tous les quiz
  - Difficulté calculée automatiquement par position

## Nouvelle Architecture : Système de Paliers

### 1. Structure des Paliers

```
Palier 1 (Niveaux 1-5) : GRATUIT - Débloqué par défaut
├── Niveau 1 : Très facile (1 point) 
├── Niveau 2 : Très facile (1 point)
├── Niveau 3 : Facile (2 points)
├── Niveau 4 : Facile (2 points)
└── Niveau 5 : Moyen (3 points) → Total: 9 points

Palier 2 (Niveaux 6-10) : Coût 5 points ✅
├── Niveau 6 : Facile (2 points)
├── Niveau 7 : Facile (2 points)
├── Niveau 8 : Moyen (3 points)
├── Niveau 9 : Moyen (3 points)
└── Niveau 10 : Difficile (4 points) → Total: 14 points

Palier 3 (Niveaux 11-15) : Coût 15 points ✅
├── Niveau 11 : Moyen (3 points)
├── Niveau 12 : Moyen (3 points)
├── Niveau 13 : Difficile (4 points)
├── Niveau 14 : Difficile (4 points)
└── Niveau 15 : Très difficile (5 points) → Total: 19 points

Palier 4 (Niveaux 16-20) : Coût 30 points ✅
├── Niveau 16 : Difficile (4 points)
├── Niveau 17 : Difficile (4 points)
├── Niveau 18 : Très difficile (5 points)
├── Niveau 19 : Très difficile (5 points)
└── Niveau 20 : Expert (6 points) → Total: 24 points

...progression garantie possible
```

### 2. Nouvelles Structures de Données

#### Modèle Palier
```dart
class Tier {
  final int id;              // 1, 2, 3...
  final String name;         // "Palier 1", "Palier 2"...
  final String description;  // Description du palier
  final List<int> levelIds;  // [1,2,3,4,5] pour le palier 1
  final bool isUnlocked;     // Palier débloqué ?
  final bool isCompleted;    // Tous les niveaux terminés ?
  final int minLevel;        // Premier niveau du palier
  final int maxLevel;        // Dernier niveau du palier
  final int unlockCost;      // Points nécessaires pour débloquer
}
```

#### Modèle Level Étendu
```dart
class Level {
  // Propriétés existantes...
  final int tierId;          // ID du palier parent
  final int positionInTier;  // Position dans le palier (1-5)
  final int pointsReward;    // Points gagnés en complétant ce niveau
  // ...
}
```

#### Modèle GameState Étendu
```dart
class GameState {
  // Propriétés existantes...
  final int totalPoints;     // Points totaux accumulés
  final List<int> unlockedTiers; // IDs des paliers débloqués
  // ...
}
```

### 3. Système de Points et Déblocage

#### Palier 1 (Niveaux 1-5) - GRATUIT
- **Coût de déblocage** : 0 points (débloqué par défaut)
- **Difficultés** : [1, 1, 2, 2, 3]
- **Points par niveau** : [1, 1, 2, 2, 3] = **9 points total**

#### Palier 2 (Niveaux 6-10) - 5 points
- **Coût de déblocage** : 5 points ✅ (accessible avec Palier 1 + 2 niveaux min)
- **Difficultés** : [2, 2, 3, 3, 4]
- **Points par niveau** : [2, 2, 3, 3, 4] = **14 points total**
- **Points cumulés** : 9 + 14 = **23 points**

#### Palier 3 (Niveaux 11-15) - 15 points
- **Coût de déblocage** : 15 points ✅ (accessible avec Palier 1 complet + 3 niveaux Palier 2)
- **Difficultés** : [3, 3, 4, 4, 5]
- **Points par niveau** : [3, 3, 4, 4, 5] = **19 points total**
- **Points cumulés** : 23 + 19 = **42 points**

#### Palier 4 (Niveaux 16-20) - 30 points
- **Coût de déblocage** : 30 points ✅ (accessible avec Paliers 1-2 complets + 4 niveaux Palier 3)
- **Difficultés** : [4, 4, 5, 5, 6]
- **Points par niveau** : [4, 4, 5, 5, 6] = **24 points total**
- **Points cumulés** : 42 + 24 = **66 points**

#### Palier 5 (Niveaux 21-25) - 50 points
- **Coût de déblocage** : 50 points ✅ (accessible avec Paliers 1-3 complets + 2 niveaux Palier 4)
- **Difficultés** : [5, 5, 6, 6, 7]
- **Points par niveau** : [5, 5, 6, 6, 7] = **29 points total**
- **Points cumulés** : 66 + 29 = **95 points**

#### Paliers 6+ - Progression contrôlée
- **Coût de déblocage** : Toujours ≤ 80% des points cumulés disponibles
- **Exemple Palier 6** : 70 points (sur 95 disponibles)

### 4. Modifications des Services

#### GameService Étendu
```dart
class GameService {
  // Nouvelles méthodes
  Future<List<Tier>> getTiers();
  Future<void> saveTiers(List<Tier> tiers);
  Future<void> unlockTier(int tierId);
  Future<bool> canUnlockTier(int tierId);
  Future<bool> isTierUnlocked(int tierId);
  Future<void> addPoints(int points);
  
  // Méthodes modifiées
  Future<void> completeLevel(int levelId) {
    // Ajouter les points du niveau
    // Vérifier si de nouveaux paliers peuvent être débloqués
  }
}
```

#### DataLoaderService Refactorisé
```dart
class DataLoaderService {
  // Nouvelle logique de chargement par paliers
  static Future<List<Tier>> loadTiers();
  static Future<List<Level>> loadLevelsForTier(int tierId);
  static int calculatePointsReward(int difficulty);
  static int calculateTierUnlockCost(int tierId);
}
```

### 5. Interface Utilisateur

#### Écran de Sélection des Paliers
- Vue d'ensemble des paliers disponibles
- Progression visuelle par palier
- Indicateurs de déblocage/complétion

#### Écran de Sélection des Niveaux (par Palier)
- Affichage des 5 niveaux du palier sélectionné
- Indication spéciale pour le niveau boss (niveau 5)
- Progression détaillée dans le palier

### 6. Système de Récompenses et Points

#### Complétion de Niveau
- **Points** : Équivalent à la difficulté du niveau
- **Vies** : +1 vie
- **Indices** : +difficulté indices

#### Système de Points
- **Gain de points** : difficulté du niveau (1-7 points)
- **Utilisation des points** : Débloquer de nouveaux paliers
- **Accumulation** : Les points se cumulent et ne se perdent jamais

#### Déblocage Automatique
- Quand un palier est débloqué (points suffisants), ses 5 niveaux sont immédiatement jouables
- Notification de déblocage avec animation

### 7. Migration des Données Existantes

#### Stratégie de Migration
1. **Analyse des niveaux existants** par difficulté
2. **Regroupement automatique** en paliers de 5
3. **Réassignation des IDs** selon la nouvelle structure
4. **Conversion de la progression** : niveaux complétés → points équivalents
5. **Calcul automatique des paliers débloqués** selon les nouveaux points

#### Script de Migration
```dart
class MigrationService {
  static Future<void> migrateToTierSystem() {
    // 1. Sauvegarder l'état actuel
    // 2. Analyser et regrouper les niveaux
    // 3. Créer les paliers
    // 4. Mettre à jour la progression utilisateur
    // 5. Valider la migration
  }
}
```

### 8. Avantages du Nouveau Système

#### Pour l'Utilisateur
- **Progression claire** : Objectifs à court terme (5 niveaux)
- **Système de points** : Motivation par l'accumulation de points
- **Liberté de choix** : Tous les niveaux d'un palier débloqué sont jouables
- **Défis graduels** : Montée en difficulté maîtrisée

#### Pour le Développement
- **Extensibilité** : Ajout facile de nouveaux paliers
- **Équilibrage** : Contrôle précis de la difficulté
- **Maintenance** : Structure plus organisée
- **Analytics** : Suivi de progression par palier

### 9. Implémentation Technique

#### Phase 1 : Modèles et Services
1. Créer le modèle `Tier`
2. Étendre le modèle `Level`
3. Modifier `GameService` et `GameProvider`
4. Implémenter la logique de paliers

#### Phase 2 : Interface Utilisateur
1. Écran de sélection des paliers
2. Modification de l'écran de niveaux
3. Indicateurs visuels de progression
4. Animations de déblocage

#### Phase 3 : Migration et Tests
1. Script de migration des données
2. Tests de régression
3. Validation de la nouvelle logique
4. Déploiement progressif

### 10. Configuration des Paliers

#### Fichier de Configuration
```json
{
  "tiers": [
    {
      "id": 1,
      "name": "Palier 1",
      "description": "Premiers défis",
      "unlockCost": 0,
      "difficulties": [1, 1, 2, 2, 3],
      "pointsRewards": [1, 1, 2, 2, 3]
    },
    {
      "id": 2,
      "name": "Palier 2", 
      "description": "Montée en difficulté",
      "unlockCost": 5,
      "difficulties": [2, 2, 3, 3, 4],
      "pointsRewards": [2, 2, 3, 3, 4]
    }
  ]
}
```

## Résumé des Changements Clés

### Différences avec le système actuel :

1. **Déblocage** : 
   - **Avant** : Niveau par niveau (niveau N+1 après niveau N)
   - **Après** : Par paliers de 5 niveaux avec système de points

2. **Progression** :
   - **Avant** : Linéaire et séquentielle 
   - **Après** : Liberté de choix dans chaque palier débloqué

3. **Points/Étoiles** :
   - **Nouveau** : Chaque niveau donne des points = difficulté
   - **Usage** : Débloque automatiquement les paliers suivants

4. **Structure** :
   - **Nouveau** : Groupes de 5 niveaux avec progression de difficulté interne

### Exemple de progression corrigée :
- Joueur complète niveaux 1-4 du Palier 1 → gagne 6 points  
- Avec 6 points (≥ 5) → Palier 2 se débloque automatiquement
- Tous les niveaux 6-10 deviennent jouables immédiatement
- Le joueur peut choisir l'ordre dans le Palier 2
- Pour débloquer Palier 3 (15 points), il doit compléter Palier 1 entièrement (9 points) + 3 niveaux du Palier 2 (6 points minimum)

Ce système permettra une progression plus engageante et structurée, avec des objectifs clairs et une montée en difficulté maîtrisée.