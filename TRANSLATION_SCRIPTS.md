# Scripts de Traduction - Documentation

Ce document liste tous les scripts créés pour le système de traduction de l'application TOP10 Challenge.

## Scripts Utilisés et Conservés ✅

### 1. **generate_quiz_translations.py** 
**Cas d'usage** : Script principal pour générer automatiquement les traductions anglaises à partir des titres français de quiz.
- Lit les données de quiz depuis `quiz_custom_order.json`
- Génère les clés de traduction normalisées 
- Crée les traductions EN/FR dans les fichiers ARB
- **CONSERVER** : Utile pour ajouter de nouveaux quiz à l'avenir

### 2. **update_main_quiz_file.py**
**Cas d'usage** : Met à jour le fichier principal `quiz_custom_order.json` avec les clés de traduction.
- Ajoute les champs `titleKey` aux objets quiz
- Normalise les clés pour éviter les conflits
- **CONSERVER** : Nécessaire pour maintenir la cohérence des données

### 3. **ultimate_translation_fix.py**
**Cas d'usage** : Script final pour les corrections de cohérence après analyse manuelle.
- Corrige les structures grammaticales incohérentes
- Standardise les formats de noms d'équipes
- **CONSERVER** : Peut être réutilisé pour de futures corrections ponctuelles

## Scripts Temporaires - Supprimés 🗑️

Les scripts suivants ont été créés pour des corrections spécifiques et ne sont plus nécessaires :

- `fix_translation_keys.py` - Normalisation des clés (terminé)
- `simple_fix_translations.py` - Corrections simples (remplacé)  
- `improve_english_translations.py` - Améliorations qualité (intégré)
- `comprehensive_translation_fix.py` - Corrections complètes (terminé)
- `final_translation_fix.py` - Corrections ciblées (terminé)
- `final_cleanup_fix.py` - Nettoyage final (terminé)
- `smart_translations_with_placeholders.py` - Test placeholders (obsolète)
- `fix_quiz_translations.py` - Corrections initiales (remplacé)
- `merge_translations.py` - Fusion manuelle (obsolète)
- `merge_main_translations.py` - Fusion principale (terminé)
- `create_final_translation_system.py` - Système final (intégré)
- `regenerate_extension_from_arb.py` - Régénération extension (obsolète)
- `generate_level_extension.py` - Extension niveau (non utilisé)

## Scripts Dart - Conservés 📱

### 1. **normalize_player_names.dart**
**Cas d'usage** : Normalise les noms de joueurs dans les données de quiz.
- **CONSERVER** : Utile pour maintenir la cohérence des données

### 2. **rebuild_player_names.dart** 
**Cas d'usage** : Reconstruit la liste des noms de joueurs.
- **CONSERVER** : Peut être nécessaire pour de futurs ajouts

### 3. **update_player_names.dart**
**Cas d'usage** : Met à jour les noms de joueurs existants.
- **CONSERVER** : Maintenance des données joueurs

## Résumé

- **Scripts conservés** : 6 scripts utiles pour la maintenance future
- **Scripts supprimés** : 12 scripts temporaires devenus obsolètes
- **Total de corrections appliquées** : 348 traductions corrigées

## Utilisation Future

Pour ajouter de nouveaux quiz :
1. Utiliser `generate_quiz_translations.py` pour les traductions
2. Utiliser `update_main_quiz_file.py` pour mettre à jour les données
3. Utiliser `ultimate_translation_fix.py` si des corrections sont nécessaires