#!/usr/bin/env python3
"""
Script pour analyser la variété des quiz dans le dossier v3 et créer des fichiers organisés par difficulté
"""

import json
import os
from collections import defaultdict, Counter
from datetime import datetime
from pathlib import Path

def load_quiz_files():
    """Charge tous les fichiers JSON de quiz."""
    data_dir = Path("data")
    quiz_files = {}
    
    if not data_dir.exists():
        print("❌ Dossier 'data' non trouvé")
        return {}
    
    for file_path in data_dir.glob("REBALANCED_*.json"):
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                quiz_files[file_path.name] = data
                print(f"✅ Chargé: {file_path.name} ({data.get('total_quizzes', 0)} quiz)")
        except Exception as e:
            print(f"❌ Erreur lecture {file_path.name}: {e}")
    
    return quiz_files

def analyze_themes(all_quizzes):
    """Analyse la distribution des thèmes."""
    themes = Counter(quiz['theme'] for quiz in all_quizzes)
    
    print("\n📊 DISTRIBUTION DES THÈMES:")
    print("=" * 50)
    for theme, count in themes.most_common():
        percentage = (count / len(all_quizzes)) * 100
        print(f"{theme:20} : {count:3d} quiz ({percentage:5.1f}%)")
    
    return themes

def analyze_competitions(all_quizzes):
    """Analyse la distribution des compétitions."""
    competitions = Counter()
    
    for quiz in all_quizzes:
        comp = quiz.get('difficulty', {}).get('details', {}).get('competition')
        if comp:
            competitions[comp] += 1
    
    print("\n🏆 DISTRIBUTION DES COMPÉTITIONS:")
    print("=" * 50)
    for comp, count in competitions.most_common():
        percentage = (count / len(all_quizzes)) * 100
        print(f"{comp:25} : {count:3d} quiz ({percentage:5.1f}%)")
    
    return competitions

def analyze_question_types(all_quizzes):
    """Analyse les types de questions."""
    question_types = Counter()
    
    for quiz in all_quizzes:
        q_type = quiz.get('difficulty', {}).get('details', {}).get('question_type')
        if q_type:
            question_types[q_type] += 1
    
    print("\n❓ TYPES DE QUESTIONS:")
    print("=" * 50)
    for q_type, count in question_types.most_common():
        percentage = (count / len(all_quizzes)) * 100
        print(f"{q_type:20} : {count:3d} quiz ({percentage:5.1f}%)")
    
    return question_types

def analyze_temporal_distribution(all_quizzes):
    """Analyse la distribution temporelle."""
    years = []
    temporal_spans = Counter()
    
    for quiz in all_quizzes:
        details = quiz.get('difficulty', {}).get('details', {})
        temporal_span = details.get('temporal_span')
        ref_year = details.get('reference_year')
        
        if temporal_span:
            temporal_spans[temporal_span] += 1
        
        if ref_year:
            years.append(ref_year)
    
    print("\n📅 DISTRIBUTION TEMPORELLE:")
    print("=" * 50)
    
    if years:
        years_counter = Counter(years)
        print("Années de référence les plus fréquentes:")
        for year, count in years_counter.most_common(10):
            percentage = (count / len(years)) * 100
            print(f"  {year} : {count:3d} quiz ({percentage:5.1f}%)")
        
        print(f"\nPlage temporelle: {min(years)} - {max(years)}")
        print(f"Année médiane: {sorted(years)[len(years)//2]}")
    
    return temporal_spans, years

def analyze_difficulty_distribution(all_quizzes):
    """Analyse la distribution des difficultés."""
    difficulty_scores = Counter()
    difficulty_levels = Counter()
    
    for quiz in all_quizzes:
        diff = quiz.get('difficulty', {})
        score = diff.get('score')
        level = diff.get('level')
        
        if score:
            difficulty_scores[score] += 1
        if level:
            difficulty_levels[level] += 1
    
    print("\n⭐ DISTRIBUTION DES DIFFICULTÉS:")
    print("=" * 50)
    
    print("Par niveau:")
    for level, count in difficulty_levels.most_common():
        percentage = (count / len(all_quizzes)) * 100
        print(f"  {level:15} : {count:3d} quiz ({percentage:5.1f}%)")
    
    print("\nPar score:")
    for score, count in sorted(difficulty_scores.items()):
        percentage = (count / len(all_quizzes)) * 100
        print(f"  Score {score:2d}      : {count:3d} quiz ({percentage:5.1f}%)")
    
    return difficulty_scores, difficulty_levels

def analyze_answer_variety(all_quizzes):
    """Analyse la variété des réponses."""
    nationalities = Counter()
    players = Counter()
    
    for quiz in all_quizzes:
        answers = quiz.get('answers', [])
        for answer in answers:
            nationality = answer.get('nationality')
            name = answer.get('name')
            
            if nationality:
                nationalities[nationality] += 1
            if name:
                players[name] += 1
    
    print("\n🌍 VARIÉTÉ DES RÉPONSES:")
    print("=" * 50)
    
    print(f"Nationalités uniques: {len(nationalities)}")
    print("Top 10 nationalités:")
    for nat, count in nationalities.most_common(10):
        print(f"  {nat:15} : {count:3d} occurrences")
    
    print(f"\nJoueurs uniques: {len(players)}")
    print("Joueurs les plus fréquents:")
    for player, count in players.most_common(10):
        print(f"  {player:25} : {count:2d} occurrences")
    
    return nationalities, players

def generate_summary_report(quiz_files, all_quizzes):
    """Génère un rapport de synthèse."""
    total_quizzes = len(all_quizzes)
    
    print("\n" + "=" * 60)
    print("📋 RAPPORT DE SYNTHÈSE")
    print("=" * 60)
    
    print(f"📁 Fichiers analysés: {len(quiz_files)}")
    for filename, data in quiz_files.items():
        print(f"   • {filename}: {data.get('total_quizzes', 0)} quiz")
    
    print(f"\n📊 Total quiz analysés: {total_quizzes}")
    
    # Calcul de la variété
    themes = set(quiz['theme'] for quiz in all_quizzes)
    competitions = set()
    question_types = set()
    
    for quiz in all_quizzes:
        details = quiz.get('difficulty', {}).get('details', {})
        comp = details.get('competition')
        q_type = details.get('question_type')
        
        if comp:
            competitions.add(comp)
        if q_type:
            question_types.add(q_type)
    
    print(f"\n🎯 Indicateurs de variété:")
    print(f"   • Thèmes uniques: {len(themes)}")
    print(f"   • Compétitions uniques: {len(competitions)}")
    print(f"   • Types de questions uniques: {len(question_types)}")
    
    # Score de variété (simple)
    variety_score = len(themes) + len(competitions) + len(question_types)
    print(f"\n⭐ Score de variété: {variety_score}/100")
    
    if variety_score < 30:
        print("   🔴 Variété faible - Recommandé d'ajouter plus de diversité")
    elif variety_score < 60:
        print("   🟡 Variété moyenne - Possibilité d'amélioration")
    else:
        print("   🟢 Bonne variété")

def analyze_v3_structure():
    """Analyse la structure des fichiers v3"""
    v3_path = "data/v3"
    
    if not os.path.exists(v3_path):
        print("❌ Dossier data/v3 introuvable")
        return
        
    files = [f for f in os.listdir(v3_path) if f.endswith('.json')]
    print(f"📁 {len(files)} fichiers JSON trouvés dans v3/")
    
    total_quizzes = 0
    difficulty_distribution = Counter()
    theme_distribution = Counter()
    
    for filename in files:
        filepath = os.path.join(v3_path, filename)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
                
            file_quizzes = len(data.get('quizzes', []))
            total_quizzes += file_quizzes
            
            print(f"\n📄 {filename}:")
            print(f"   Quizzes: {file_quizzes}")
            
            # Analyse des difficultés et thèmes
            for quiz in data.get('quizzes', []):
                difficulty = quiz.get('difficulty', 0)
                theme = quiz.get('theme', 'Unknown')
                difficulty_distribution[difficulty] += 1
                theme_distribution[theme] += 1
                
        except Exception as e:
            print(f"❌ Erreur lors de la lecture de {filename}: {e}")
    
    print(f"\n📊 RÉSUMÉ:")
    print(f"Total quizzes: {total_quizzes}")
    print(f"\nDistribution par difficulté:")
    for diff in sorted(difficulty_distribution.keys()):
        print(f"  Niveau {diff}: {difficulty_distribution[diff]} quizzes")
    
    print(f"\nDistribution par thème:")
    for theme, count in theme_distribution.most_common():
        print(f"  {theme}: {count} quizzes")

def convert_difficulty_to_level_name(difficulty_num):
    """Convertit un niveau de difficulté numérique vers le nom de niveau pour l'organisation des fichiers"""
    
    difficulty_mapping = {
        1: "tres_facile",
        2: "facile", 
        3: "facile",
        4: "moyen",
        5: "difficile",
        6: "tres_difficile"
    }
    
    return difficulty_mapping.get(difficulty_num, "moyen")

def transform_quizzes():
    """Transforme les quiz v3 au format attendu par l'app"""
    v3_path = "data/v3"
    
    if not os.path.exists(v3_path):
        print("❌ Dossier data/v3 introuvable")
        return
    
    # Grouper par difficulté
    quizzes_by_difficulty = defaultdict(list)
    
    files = [f for f in os.listdir(v3_path) if f.endswith('.json')]
    
    for filename in files:
        filepath = os.path.join(v3_path, filename)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            for quiz in data.get('quizzes', []):
                difficulty_num = quiz.get('difficulty', 3)
                difficulty_level_name = convert_difficulty_to_level_name(difficulty_num)
                
                # Transformer le quiz au nouveau format simplifié
                transformed_quiz = {
                    "id": quiz.get('id'),
                    "title": quiz.get('title'),
                    "theme": quiz.get('theme'),
                    "difficulty": difficulty_num,  # Difficulté simple de 1 à 6
                    "answers": []
                }
                
                # Transformer les réponses avec le nouveau champ hint
                for answer in quiz.get('answers', []):
                    transformed_answer = {
                        "name": answer.get('name'),
                        "nationality": answer.get('nationality'),
                        "hint": answer.get('hint', '')  # Nouveau champ hint pour les indices
                    }
                    transformed_quiz["answers"].append(transformed_answer)
                
                quizzes_by_difficulty[difficulty_level_name].append(transformed_quiz)
                
        except Exception as e:
            print(f"❌ Erreur lors de la transformation de {filename}: {e}")
    
    # Créer les fichiers finaux
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    for difficulty_level_name, quizzes in quizzes_by_difficulty.items():
        # Réassigner les IDs de manière séquentielle
        for i, quiz in enumerate(quizzes, 1):
            quiz["id"] = i
        
        # Format de sortie simplifié
        output_data = {
            "generated_at": datetime.now().isoformat(),
            "total_quizzes": len(quizzes),
            "quizzes": quizzes
        }
        
        filename = f"CONVERTED_V3_{timestamp}_{difficulty_level_name}.json"
        filepath = os.path.join("data", filename)
        
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(output_data, f, indent=2, ensure_ascii=False)
            print(f"✅ Créé: {filepath} ({len(quizzes)} quizzes)")
        except Exception as e:
            print(f"❌ Erreur lors de l'écriture de {filepath}: {e}")

def main():
    """Fonction principale."""
    print("🔍 Analyse de la structure v3...")
    analyze_v3_structure()
    
    print(f"\n{'='*50}")
    print("🔄 Transformation des quiz...")
    transform_quizzes()
    
    print(f"\n✅ Transformation terminée!")

if __name__ == "__main__":
    main()