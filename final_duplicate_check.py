#!/usr/bin/env python3
"""
Script pour une vérification finale approfondie des doublons
"""

import json
from pathlib import Path
from collections import Counter

def load_json_file(file_path):
    """Charger un fichier JSON"""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def main():
    # Chemin du fichier
    quiz_file = Path("/home/mathieu/git/top10challenge/data/quiz_facile.json")
    
    # Charger les données
    print("Chargement du fichier quiz_facile.json...")
    quiz_data = load_json_file(quiz_file)
    
    print("Recherche de 'Dominic Solanke' dans tous les quiz...")
    
    for quiz in quiz_data['quizzes']:
        for i, answer in enumerate(quiz['answers']):
            if 'Dominic Solanke' in answer.get('name', ''):
                print(f"Quiz ID {quiz['id']}: {quiz['title']}")
                print(f"  Position {i+1}: {answer['name']} - {answer.get('nationality', 'N/A')} - {answer.get('hint', 'N/A')}")
                print(f"  Thème: {quiz.get('theme', 'N/A')}")
                
                # Vérifier les doublons dans ce quiz spécifique
                names = [ans['name'] for ans in quiz['answers']]
                name_counts = Counter(names)
                duplicates = [name for name, count in name_counts.items() if count > 1]
                if duplicates:
                    print(f"  ⚠️ Ce quiz a des doublons: {', '.join(duplicates)}")
                else:
                    print(f"  ✅ Ce quiz n'a pas de doublons")
                print()

if __name__ == "__main__":
    main()