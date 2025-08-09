#!/usr/bin/env python3
import json
import random
import os

def load_quizzes_from_file(file_path):
    """Load quizzes from a JSON file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Handle different JSON structures
        if 'quizzes' in data:
            quizzes = data['quizzes']
        elif 'data' in data:
            quizzes = data['data']
        else:
            quizzes = data
        
        return quizzes
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading {file_path}: {e}")
        return []

def shuffle_deterministic(items, seed=42):
    """Shuffle list deterministically using Fisher-Yates algorithm with fixed seed"""
    shuffled = items.copy()
    rng = random.Random(seed)
    
    # Fisher-Yates shuffle algorithm
    for i in range(len(shuffled) - 1, 0, -1):
        j = rng.randint(0, i)
        shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
    
    return shuffled

def main():
    # Files organized by difficulty (in ascending order)
    difficulty_files = [
        # Easy (difficulty 1-2)
        ['data/quiz_facile.json'],
        
        # Medium (difficulty 3)
        ['data/quiz_moyen.json'],
        
        # Hard (difficulty 4)
        ['data/quiz_difficile.json'],
        
        # Very hard (difficulty 5)
        ['data/quiz_tres_difficile.json'],
    ]
    
    all_levels = []
    
    # Load by difficulty order
    for difficulty_level, file_list in enumerate(difficulty_files, 1):
        difficulty_levels = []
        
        for file_name in file_list:
            file_path = os.path.join(os.getcwd(), file_name)
            quizzes = load_quizzes_from_file(file_path)
            
            if quizzes:
                print(f"Loaded {len(quizzes)} quizzes from {file_name} (difficulty {difficulty_level})")
                
                # Extract quiz data
                for quiz in quizzes:
                    quiz_data = {
                        'title': quiz.get('title', ''),
                        'difficulty': difficulty_level,
                        'category': quiz.get('theme', quiz.get('category', ''))
                    }
                    difficulty_levels.append(quiz_data)
                
                # Shuffle this difficulty level deterministically
                shuffled_levels = shuffle_deterministic(difficulty_levels)
                all_levels.extend(shuffled_levels)
                difficulty_levels.clear()  # Reset for next file
    
    # Write ordered quiz titles to text file
    with open('quiz_titles_ordered.txt', 'w', encoding='utf-8') as f:
        f.write("Quiz titles in app order (deterministic shuffle with seed 42):\n")
        f.write("=" * 60 + "\n\n")
        
        for i, quiz in enumerate(all_levels, 1):
            tier_id = ((i - 1) // 5) + 1
            position_in_tier = ((i - 1) % 5) + 1
            f.write(f"{i:3d}. {quiz['title']} (Palier {tier_id}, Position {position_in_tier}, Difficulté {quiz['difficulty']})\n")
    
    print(f"\nTotal quizzes loaded: {len(all_levels)}")
    print("Quiz titles written to: quiz_titles_ordered.txt")

if __name__ == "__main__":
    main()