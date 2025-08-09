# Nouveau Système d'Indices - Spécification

## Vue d'ensemble
Remplacer le système actuel d'indices (révélation automatique d'une réponse) par un système permettant au joueur de choisir sur quelle case appliquer l'indice et révéler le hint spécifique à cette position.

## Interaction utilisateur

### Déclencheur
- **Action** : Appui long sur une case vide (environ 1.5 secondes)
- **Prérequis** : Le joueur doit avoir au moins 1 indice disponible
- **Cible** : Uniquement les cases vides (ni indice révélé, ni réponse trouvée)

### Feedback visuel pendant l'appui
- Animation de progression circulaire ou jauge qui se remplit
- Couleur d'accent (dorée/ambrée) qui apparaît progressivement
- Transition fluide pendant la durée de l'appui
- Si l'utilisateur relâche avant la fin : annulation de l'action

### Confirmation de l'action
- Vibration tactile courte
- Son de confirmation (optionnel)
- Consommation d'1 indice du compteur
- Révélation immédiate de l'indice dans la case

## États des cases

### 1. Case vide (état initial)
- **Visuel** : Numéro de position (1-10) en haut
- **Zone de texte** : Vide
- **Interaction** : Éligible pour appui long

### 2. Case avec indice révélé
- **Visuel** : Numéro de position conservé
- **Zone de texte** : Texte de l'indice (hint spécifique à cette réponse)
- **Style de texte** : Couleur dorée/ambrée, taille adaptée, style italique
- **Bordure** : Couleur spéciale pour indiquer qu'un indice a été utilisé
- **Interaction** : Plus d'appui long possible

### 3. Case avec réponse trouvée
- **Visuel** : Numéro de position conservé  
- **Zone de texte** : Nom du joueur (l'indice disparaît)
- **Style** : Style de succès habituel
- **Interaction** : Aucune

## Persistance des données

### Sauvegarde
- Les indices révélés doivent être sauvegardés comme les réponses trouvées
- Utiliser le même système que `saveFoundAnswersForLevel` 
- Créer une nouvelle méthode `saveRevealedHintsForLevel`

### Chargement
- Au chargement du niveau, restaurer les indices révélés
- Créer `getRevealedHintsForLevel` similaire à `getFoundAnswersForLevel`
- Appliquer les états des cases au chargement

### Structure de données
- Sauvegarder un Map<int, String> où :
  - Clé : index de la position (0-9)
  - Valeur : texte de l'indice révélé

## Modifications techniques requises

### 1. Modèle de données
- Ajouter `Map<int, String> revealedHints = {}` dans le state du GameScreen
- Méthodes de persistance dans GameService

### 2. Widget AnswerSlot
- Ajouter un paramètre `String? revealedHint`
- Implémenter la logique d'appui long avec GestureDetector
- Gérer les 3 états visuels (vide, indice, réponse)
- Animation de progression pendant l'appui long

### 3. GameScreen
- Gérer l'état `revealedHints`
- Callback pour traiter la révélation d'indice
- Chargement/sauvegarde des indices révélés
- Mise à jour de l'affichage lors des transitions d'état

### 4. GameService
- `saveRevealedHintsForLevel(String levelId, Map<int, String> hints)`
- `getRevealedHintsForLevel(String levelId)` 
- `clearRevealedHintsForLevel(String levelId)` (lors du reset)

## Cas d'usage

### Scénario 1 : Révélation d'indice
1. Joueur appuie longuement sur case 3 (vide)
2. Animation de progression s'affiche
3. Après 1.5s : vibration + consommation d'indice
4. Case 3 affiche l'indice spécifique à la position 3
5. L'indice est sauvegardé

### Scénario 2 : Réponse trouvée après indice
1. Case 5 a un indice révélé
2. Joueur trouve la bonne réponse via la recherche
3. L'indice disparaît, remplacé par le nom du joueur
4. Style de succès appliqué

### Scénario 3 : Persistance
1. Joueur révèle plusieurs indices
2. Ferme et rouvre le niveau
3. Les indices révélés sont restaurés
4. Les réponses trouvées également

## Validation
- Tester l'appui long sur différentes cases
- Vérifier l'annulation si relâchement prématuré  
- Contrôler la persistance des données
- Tester les transitions d'états
- Vérifier que les indices corrects sont affichés pour chaque position