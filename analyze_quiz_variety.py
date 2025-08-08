#!/usr/bin/env python3
"""
Script pour analyser la variété des quiz disponibles dans le projet Top10Challenge.
Analyse les thèmes, compétitions, types de questions et distribution temporelle.
"""

import json
import os
from collections import Counter, defaultdict
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

def main():
    """Fonction principale."""
    print("🔍 ANALYSE DE LA VARIÉTÉ DES QUIZ")
    print("=" * 60)
    
    # Chargement des fichiers
    quiz_files = load_quiz_files()
    if not quiz_files:
        return
    
    # Extraction de tous les quiz
    all_quizzes = []
    for data in quiz_files.values():
        all_quizzes.extend(data.get('quizzes', []))
    
    if not all_quizzes:
        print("❌ Aucun quiz trouvé")
        return
    
    # Analyses
    analyze_themes(all_quizzes)
    analyze_competitions(all_quizzes)
    analyze_question_types(all_quizzes)
    analyze_temporal_distribution(all_quizzes)
    analyze_difficulty_distribution(all_quizzes)
    analyze_answer_variety(all_quizzes)
    
    # Rapport final
    generate_summary_report(quiz_files, all_quizzes)

if __name__ == "__main__":
    main()