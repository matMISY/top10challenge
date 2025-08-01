# Guide d'ajout de vos quiz par difficulté

## Organisation des fichiers par difficulté

Le système charge automatiquement les fichiers JSON selon leur difficulté. Placez vos fichiers dans le dossier `data/` et configurez-les selon leur niveau.

### 📁 Structure à créer

```
data/
├── vos_quiz_tres_faciles.json     (Très facile - Difficulté 1)
├── vos_quiz_faciles.json          (Facile - Difficulté 2)
├── vos_quiz_moyens.json           (Moyen - Difficulté 3)
└── vos_quiz_difficiles.json       (Difficile - Difficulté 4)
```

## 🆕 Configuration de vos fichiers

Éditez le fichier `lib/services/data_loader_service.dart` ligne 226-247 :

```dart
final difficultyFilePatterns = [
  // Très facile (difficulté 1)
  [
    'vos_quiz_tres_faciles.json',
    'autres_quiz_tres_faciles.json', // Si vous en avez plusieurs
  ],
  
  // Facile (difficulté 2) 
  [
    'vos_quiz_faciles.json',
  ],
  
  // Moyen (difficulté 3)
  [
    'vos_quiz_moyens.json',
  ],
  
  // Difficile (difficulté 4)
  [
    'vos_quiz_difficiles.json',
  ],
];
```

### Option 2: Nommage automatique (futur)

Nommez vos fichiers avec ces mots-clés pour une détection automatique :
- **Très facile** : `tres_facile`, `very_easy`, `beginner`, `debutant`
- **Facile** : `facile`, `easy`, `simple`
- **Moyen** : `moyen`, `medium`, `intermediate`, `normal`
- **Difficile** : `difficile`, `hard`, `expert`, `advanced`

## 📊 Progression des paliers

Le système est configuré pour 6 paliers avec cette répartition :

| Palier | Niveaux | Difficultés | Points | Coût déblocage |
|--------|---------|-------------|--------|----------------|
| 1      | 1-5     | [1,1,1,2,2] | 7 pts  | Gratuit        |
| 2      | 6-10    | [1,2,2,2,3] | 10 pts | 4 points       |
| 3      | 11-15   | [2,2,3,3,3] | 13 pts | 10 points      |
| 4      | 16-20   | [2,3,3,4,4] | 16 pts | 20 points      |
| 5      | 21-25   | [3,3,4,4,4] | 18 pts | 35 points      |
| 6      | 26-30   | [3,4,4,4,4] | 19 pts | 55 points      |

## 🔄 Comment ça fonctionne

1. **Chargement** : Les fichiers sont chargés dans l'ordre de difficulté
2. **Mélange** : Chaque groupe de difficulté est mélangé de façon déterministe  
3. **Attribution** : Les niveaux sont assignés aux paliers selon la configuration
4. **Points** : Les joueurs gagnent des points égaux à la difficulté du niveau

## ✅ Vérification

Après ajout de fichiers, vérifiez dans les logs :
```
flutter run
```

Vous devriez voir :
```
Chargé X niveaux de difficulté 1 depuis votre_fichier.json
Chargé Y niveaux de difficulté 2 depuis votre_fichier.json
...
```

## 📝 Format des fichiers JSON

Assurez-vous que vos fichiers respectent le format existant :
```json
{
  "data": [
    {
      "id": 1,
      "title": "Titre du quiz",
      "hint": "Indice pour aider",
      "theme": "Catégorie",
      "answers": [
        {
          "name": "Nom du joueur",
          "nationality": "Nationalité"
        }
      ]
    }
  ]
}
```