#!/usr/bin/env python3
import json
import os
import re
from pathlib import Path

def fix_title_errors(file_path):
    """
    Corrige les erreurs dans les titres : remplace "entre {année}" par "en {année}"
    mais garde "entre {année1} et {année2}" intact
    """
    with open(file_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    changes_made = 0
    
    # Parcourir tous les quiz
    for quiz in data.get('quizzes', []):
        original_title = quiz.get('title', '')
        
        # Pattern pour identifier "entre {année}" seule (pas "entre {année1} et {année2}")
        # Recherche "entre" suivi d'un espace, puis 4 chiffres, puis pas " et "
        pattern = r'\bentre (\d{4})(?!\s+et\s+\d{4})'
        
        new_title = re.sub(pattern, r'en \1', original_title)
        
        if new_title != original_title:
            quiz['title'] = new_title
            changes_made += 1
            print(f"✓ Corrigé: '{original_title}' → '{new_title}'")
    
    if changes_made > 0:
        # Sauvegarder le fichier modifié
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"\n✓ {changes_made} corrections appliquées dans {file_path}")
    else:
        print(f"✓ Aucune correction nécessaire dans {file_path}")
    
    return changes_made

def main():
    """Parcourir tous les fichiers JSON dans le dossier data"""
    data_dir = Path('data')
    json_files = list(data_dir.glob('**/*.json'))
    
    print(f"Recherche de fichiers JSON dans {data_dir}...")
    print(f"Trouvé {len(json_files)} fichiers JSON\n")
    
    total_changes = 0
    
    for json_file in json_files:
        print(f"\nTraitement de {json_file}...")
        try:
            changes = fix_title_errors(json_file)
            total_changes += changes
        except Exception as e:
            print(f"❌ Erreur lors du traitement de {json_file}: {e}")
    
    print(f"\n{'='*50}")
    print(f"RÉSUMÉ: {total_changes} corrections au total")
    print(f"{'='*50}")

if __name__ == "__main__":
    main()