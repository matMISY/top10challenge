# Système d'indices - Top 10 Challenge

## Vue d'ensemble
Le système d'indices permet aux joueurs d'obtenir de l'aide progressive pour trouver les réponses en échange de points d'indices. Les indices se débloquent séquentiellement - chaque utilisation révèle le niveau suivant, et tous les indices précédents restent visibles.

## Structure des données existantes
- **name** : Le nom du joueur/réponse (ex: "Martial", "Griezmann")
- **hint** : Indice prédéfini qui peut être :
  - Les initiales du joueur (ex: "A.M." pour Anthony Martial)
  - Le nom du club (ex: "Manchester United")
  - Autre information contextuelle

## Système progressif d'indices

### Principe de fonctionnement
- Les indices se débloquent **séquentiellement** (pas de choix du niveau)
- Chaque nouvel indice **s'ajoute** aux précédents (cumul d'informations)
- Le hint reste **toujours visible** une fois débloqué

### Niveau 1 - Indice de base
- **Coût** : 3 points
- **Débloqué** : Au premier appui sur le bouton indice
- **Affichage** : Le champ `hint` existant
- **Exemple** : 
  - Si `hint = "A.M."` → Affiche "A.M."
  - Si `hint = "Real Madrid"` → Affiche "Real Madrid"

### Niveau 2 - Structure du nom
- **Coût** : 4 points (total cumulé : 7 points)
- **Débloqué** : Au deuxième appui sur le bouton indice
- **Affichage** : Hint (niveau 1) + longueur du nom sous forme de tirets
- **Exemple** :
  - "Martial" avec hint "A.M." → 
    ```
    A.M.
    _ _ _ _ _ _ _
    ```
  - "Griezmann" avec hint "Atlético" → 
    ```
    Atlético
    _ _ _ _ _ _ _ _ _
    ```

### Niveau 3 - Lettres partielles
- **Coût** : 5 points (total cumulé : 12 points)
- **Débloqué** : Au troisième appui sur le bouton indice
- **Affichage** : Hint + structure avec lettres révélées (1 sur 3, première toujours visible)
- **Exemple** :
  - "Martial" avec hint "A.M." → 
    ```
    A.M.
    M _ r _ i _ l
    ```
  - "Griezmann" avec hint "Atlético" → 
    ```
    Atlético
    G _ i _ z _ a _ n
    ```

## Interface utilisateur

### Bouton unique d'indice
Utiliser le systeme actuel : appui long sur la case pour déclencher un indice supplémentaire

### Zone d'affichage des indices
```
┌─────────────────────────┐
│     [Hint toujours]     │  ← Niveau 1
│     [Structure nom] &   │  ← Niveau 2
│   [Lettres partielles]  │  
└─────────────────────────┘
```
- Les indices s'empilent verticalement
- Animation d'apparition pour chaque nouveau niveau
- Le hint reste en haut et toujours visible
- Quand les lettres partielles sont dévoilées, cela remplace la structure nom.

### Affichage des points
- Icône ampoule + nombre de points en haut de l'écran (garder l'existant)
- Animation lors du changement de points
- Couleur rouge brièvement si tentative sans assez de points

## Système de points d'indices

### Obtention de points
0. **Initialisation**
A la première connection, donner 50 points d'indices. Utiliser une variable configurable pour ce paramètre
1. **Complétion de niveau** : 
   - Niveau facile : 6 point
   - Niveau moyen : 9 points
   - Niveau difficile : 12 points

2. **Publicité récompensée** :
   - 12 points d'indices par publicité. Utiliser une variable configurable pour ce paramètre
   - Cooldown : 5 minutes (distinct du cooldown des vies). Utiliser une variable configurable pour ce paramètre
   - Message : "Regarder une pub pour +12 points d'indices" (utiliser la variable pour rendre le +12 reactif en fonction de la configuration choisie par l'admin)

### Stockage
- SharedPreferences :
  - `hint_points` : nombre de points actuels
  - `hint_level_[niveau_id]_[question_id]` : niveau d'indice atteint pour chaque question
- Points initiaux : 10 points au premier lancement

## Logique d'implémentation

### Pseudocode de la fonction d'indice
```dart
void onHintButtonPressed() {
  int currentLevel = getCurrentHintLevel(); // 0, 1, 2 ou 3
  
  if (currentLevel >= 3) {
    showMessage("Tous les indices ont été utilisés");
    return;
  }
  
  int cost = getHintCost(currentLevel + 1); // 3, 4 ou 5
  
  if (points < cost) {
    showNotEnoughPointsAnimation();
    offerWatchAd();
    return;
  }
  
  deductPoints(cost);
  incrementHintLevel();
  updateHintDisplay(); // Ajoute le nouveau niveau à l'affichage existant
}
```

### Fonction d'affichage
```dart
Widget buildHintDisplay() {
  List<Widget> hints = [];
  
  // Niveau 1 : Toujours afficher le hint s'il est débloqué
  if (hintLevel >= 1) {
    hints.add(Text(question.hint));
  }
  
  // Niveau 2 : Ajouter la structure
  if (hintLevel >= 2) {
    hints.add(Text(getNameStructure())); // "_ _ _ _ _"
  }
  
  // Niveau 3 : Remplacer la structure par les lettres partielles
  if (hintLevel >= 3) {
    hints.removeLast(); // Enlever la structure simple
    hints.add(Text(getPartialLetters())); // "M _ r _ i _ l"
  }
  
  return Column(children: hints);
}
```

## États et persistance

### Par question
- Mémoriser le niveau d'indice atteint pour chaque question
- Si le joueur revient sur une question, afficher directement tous les indices déjà débloqués
- Réinitialiser lors du passage au niveau suivant

### Global
- Les points d'indices sont persistants entre les sessions
- Sauvegarder après chaque modification

## Équilibrage

### Coûts progressifs
- Total pour tous les indices : 12 points
- Équivalent à : 1 pub OU 1 niveau difficle complété
- Permet d'aider sur ~1 question difficile par session de jeu normale

### Ajustements suggérés
- Si trop difficile : Réduire les coûts à 2/3/4 points
- Si trop facile : Augmenter à 4/5/6 points
- Possibilité d'ajuster selon les statistiques d'utilisation

## Notes techniques

### Animations
- Fade-in progressif pour chaque niveau d'indice
- Pulsation du bouton quand nouveaux points disponibles
- Transition smooth entre "_ _ _" et "M _ r" au niveau 3

### Gestion d'erreur
- Vérifier que le hint existe avant affichage
- Gérer les noms courts (< 3 lettres) pour le niveau 3
- Cas des espaces et caractères spéciaux dans les noms
