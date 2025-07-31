# Intégration de la liste des joueurs

## Objectif
Intégrer une liste complète de joueurs pour améliorer le système de suggestions et rendre le jeu plus équilibré.

## Format du fichier fourni
- **Nom du fichier** : `joueurs.txt`
- **Format** : Un nom de joueur par ligne
- **Exemple** :
```
Lionel Messi
Cristiano Ronaldo
Kylian Mbappé
Neymar Jr
Robert Lewandowski
...
```

## Modifications à effectuer

### 1. Ajouter la liste dans SearchService
- Créer une propriété `List<String> _allPlayerNames` dans `SearchService`
- Charger la liste depuis le fichier txt ou l'intégrer directement dans le code

### 2. Modifier la méthode getSuggestions()
**Localisation** : `lib/services/search_service.dart:10-36`

**Changement** : Au lieu de chercher seulement dans `availableAnswers`, chercher dans toute la liste `_allPlayerNames`

**Logique actuelle** :
```dart
for (final answer in availableAnswers) {
  // Cherche seulement dans les bonnes réponses
}
```

**Nouvelle logique** :
```dart
for (final playerName in _allPlayerNames) {
  if (playerName.toLowerCase().contains(normalizedQuery)) {
    suggestions.add(playerName);
  }
}
```

### 3. Conserver la validation existante
- Garder `getCorrectAnswer()` qui valide contre `availableAnswers`
- Les suggestions montreront tous les joueurs, mais seules les bonnes réponses seront acceptées

### 4. Optimisations possibles
- Limiter les suggestions à 10 résultats maximum
- Prioriser les correspondances exactes
- Trier par pertinence (commence par la query, puis contient la query)

## Résultat attendu
- **Avant** : Taper "Messi" → aucune suggestion
- **Après** : Taper "Messi" → suggère "Lionel Messi" (mais ne sera pas accepté si pas dans le top 10)

## Test
1. Taper un nom qui n'est pas dans le top 10 → doit être suggéré mais rejeté
2. Taper un nom du top 10 → doit être suggéré et accepté
3. Vérifier que les réponses se placent dans le bon ordre du classement