#!/usr/bin/env python3
"""
Quiz Order Application Script

This script applies the custom quiz order configuration from quiz_organizer.html
to the Flutter app by creating a consolidated JSON file that overrides the 
deterministic shuffling in DataLoaderService.

Usage:
    python apply_quiz_order.py [--config-file config.json] [--output output.json] [--backup]

Workflow:
    1. Use quiz_organizer.html to arrange quizzes in desired order
    2. Export configuration as quiz_order_config.json
    3. Run this script to apply the custom order
    4. Integrate the generated file with your Flutter DataLoaderService

Features:
- Reads quiz_order_config.json from the quiz organizer tool
- Loads all original quiz JSON files (quiz_facile.json, quiz_moyen.json, etc.)
- Handles duplicate quiz IDs across files by using first occurrence
- Creates a single consolidated quiz file in the exact custom order
- Validates all quizzes are accounted for (no duplicates or missing)
- Reports comprehensive statistics (quizzes per tier, difficulty distribution, themes)
- Automatically backs up original files before making changes
- Generates output that DataLoaderService can easily use
- Creates detailed integration instructions for Flutter implementation

Input Format (quiz_order_config.json):
    {
      "quiz_order": [
        {
          "quiz_id": 1,
          "title": "TOP 10 du Ballon d'Or 2024",
          "tier": 1,
          "position": 1,
          "original_difficulty": 1
        },
        ...
      ]
    }

Output:
    - Custom ordered JSON file with all quiz data preserved
    - Integration instructions (CUSTOM_ORDER_INTEGRATION.md)
    - Backup of original files
    - Comprehensive statistics and validation report
"""

import json
import os
import sys
import argparse
import shutil
from datetime import datetime
from typing import Dict, List, Any, Optional, Tuple
from collections import defaultdict, Counter


class QuizOrderApplicator:
    """Main class for applying custom quiz order configuration."""
    
    def __init__(self, config_file: str = "quiz_order_config.json", 
                 output_file: str = "data/quiz_custom_order.json",
                 backup: bool = True):
        self.config_file = config_file
        self.output_file = output_file
        self.backup = backup
        self.data_dir = "data"
        self.original_files = [
            "quiz_facile.json",
            "quiz_moyen.json", 
            "quiz_difficile.json",
            "quiz_tres_difficile.json"
        ]
        
    def load_quiz_order_config(self) -> Dict[str, Any]:
        """Load the quiz order configuration from the organizer tool."""
        try:
            with open(self.config_file, 'r', encoding='utf-8') as f:
                config = json.load(f)
                
            if 'quiz_order' not in config:
                raise ValueError("Configuration file must contain 'quiz_order' key")
                
            print(f"✓ Loaded quiz order configuration with {len(config['quiz_order'])} quizzes")
            return config
            
        except FileNotFoundError:
            print(f"❌ Configuration file '{self.config_file}' not found")
            print("Please export the configuration from quiz_organizer.html first")
            sys.exit(1)
        except json.JSONDecodeError as e:
            print(f"❌ Error parsing configuration file: {e}")
            sys.exit(1)
        except Exception as e:
            print(f"❌ Error loading configuration: {e}")
            sys.exit(1)
    
    def load_original_quizzes(self) -> Dict[str, Dict[str, Any]]:
        """Load all quizzes from the original JSON files, indexed by a composite key."""
        all_quizzes = {}
        quiz_by_id = {}
        total_loaded = 0
        duplicate_count = 0
        
        for filename in self.original_files:
            filepath = os.path.join(self.data_dir, filename)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    
                # Handle different JSON structures
                if 'quizzes' in data:
                    quizzes = data['quizzes']
                elif 'data' in data:
                    quizzes = data['data']
                else:
                    quizzes = data if isinstance(data, list) else [data]
                
                for quiz in quizzes:
                    quiz_id = quiz.get('id')
                    if quiz_id is None:
                        print(f"⚠️  Warning: Quiz without ID found in {filename}")
                        continue
                    
                    # Create composite key: id + title to handle duplicates
                    title = quiz.get('title', '')
                    composite_key = f"{quiz_id}_{hash(title) % 10000:04d}"
                    
                    # Track duplicates but keep the first occurrence for each ID
                    if quiz_id in quiz_by_id:
                        duplicate_count += 1
                        if duplicate_count <= 5:  # Only show first few warnings
                            print(f"⚠️  Warning: Duplicate quiz ID {quiz_id} found ('{title[:50]}...')")
                        elif duplicate_count == 6:
                            print(f"⚠️  Warning: More duplicate IDs found, suppressing further warnings...")
                    else:
                        quiz_by_id[quiz_id] = quiz
                    
                    # Also store by composite key for uniqueness
                    all_quizzes[composite_key] = quiz
                    total_loaded += 1
                    
                print(f"✓ Loaded {len(quizzes)} quizzes from {filename}")
                
            except FileNotFoundError:
                print(f"⚠️  Warning: File {filepath} not found, skipping")
            except json.JSONDecodeError as e:
                print(f"❌ Error parsing {filepath}: {e}")
                sys.exit(1)
            except Exception as e:
                print(f"❌ Error loading {filepath}: {e}")
                sys.exit(1)
        
        if duplicate_count > 0:
            print(f"⚠️  Found {duplicate_count} duplicate quiz IDs across files")
            print(f"✓ Using first occurrence of each unique ID")
        
        print(f"✓ Total loaded: {total_loaded} quizzes ({len(quiz_by_id)} unique IDs)")
        return quiz_by_id
    
    def validate_quiz_order(self, quiz_order: List[Dict[str, Any]], 
                          original_quizzes: Dict[int, Dict[str, Any]]) -> Tuple[bool, List[str]]:
        """Validate that the quiz order configuration is complete and correct."""
        errors = []
        
        # Check for missing quizzes in configuration
        configured_ids = {quiz['quiz_id'] for quiz in quiz_order}
        original_ids = set(original_quizzes.keys())
        
        missing_in_config = original_ids - configured_ids
        extra_in_config = configured_ids - original_ids
        
        if missing_in_config:
            errors.append(f"Missing quiz IDs in configuration: {sorted(missing_in_config)}")
            
        if extra_in_config:
            errors.append(f"Extra quiz IDs in configuration (not found in original files): {sorted(extra_in_config)}")
        
        # Check for duplicate quiz IDs in configuration
        id_counts = Counter(quiz['quiz_id'] for quiz in quiz_order)
        duplicates = {quiz_id: count for quiz_id, count in id_counts.items() if count > 1}
        if duplicates:
            errors.append(f"Duplicate quiz IDs in configuration: {duplicates}")
        
        # Check for missing required fields
        required_fields = ['quiz_id', 'title', 'tier', 'position']
        for i, quiz in enumerate(quiz_order):
            missing_fields = [field for field in required_fields if field not in quiz]
            if missing_fields:
                errors.append(f"Quiz at index {i} missing required fields: {missing_fields}")
        
        return len(errors) == 0, errors
    
    def create_ordered_quiz_data(self, quiz_order: List[Dict[str, Any]], 
                               original_quizzes: Dict[int, Dict[str, Any]]) -> Dict[str, Any]:
        """Create the final ordered quiz data structure."""
        
        ordered_quizzes = []
        
        for config_quiz in quiz_order:
            quiz_id = config_quiz['quiz_id']
            original_quiz = original_quizzes[quiz_id]
            
            # Create the ordered quiz, preserving all original data
            ordered_quiz = original_quiz.copy()
            
            # Update with tier and position information from configuration
            ordered_quiz.update({
                'tier_id': config_quiz['tier'],
                'position_in_tier': config_quiz['position'],
                'custom_order': True  # Flag to indicate this uses custom ordering
            })
            
            ordered_quizzes.append(ordered_quiz)
        
        # Create the final structure
        result = {
            "generated_at": datetime.now().isoformat() + "Z",
            "custom_order_applied": True,
            "total_quizzes": len(ordered_quizzes),
            "source_files": self.original_files,
            "config_file": self.config_file,
            "quizzes": ordered_quizzes
        }
        
        return result
    
    def backup_original_files(self) -> None:
        """Create backups of original quiz files."""
        if not self.backup:
            return
            
        backup_dir = os.path.join(self.data_dir, f"backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}")
        os.makedirs(backup_dir, exist_ok=True)
        
        backed_up = 0
        for filename in self.original_files:
            src = os.path.join(self.data_dir, filename)
            if os.path.exists(src):
                dst = os.path.join(backup_dir, filename)
                shutil.copy2(src, dst)
                backed_up += 1
        
        print(f"✓ Created backups of {backed_up} files in {backup_dir}")
    
    def generate_statistics(self, quiz_order: List[Dict[str, Any]], 
                          original_quizzes: Dict[int, Dict[str, Any]]) -> None:
        """Generate and display statistics about the quiz order."""
        print("\n📊 Quiz Order Statistics:")
        print("=" * 50)
        
        # Tiers distribution
        tier_counts = defaultdict(int)
        difficulty_counts = defaultdict(int)
        
        for config_quiz in quiz_order:
            tier_counts[config_quiz['tier']] += 1
            
            # Get original difficulty
            quiz_id = config_quiz['quiz_id']
            original_quiz = original_quizzes[quiz_id]
            difficulty = original_quiz.get('difficulty', 'unknown')
            difficulty_counts[difficulty] += 1
        
        print(f"Total quizzes: {len(quiz_order)}")
        print(f"Number of tiers: {len(tier_counts)}")
        
        print("\nQuizzes per tier:")
        for tier in sorted(tier_counts.keys()):
            print(f"  Tier {tier}: {tier_counts[tier]} quizzes")
        
        print("\nDifficulty distribution:")
        for difficulty in sorted(difficulty_counts.keys()):
            print(f"  Difficulty {difficulty}: {difficulty_counts[difficulty]} quizzes")
        
        # Theme distribution (if available)
        theme_counts = defaultdict(int)
        for config_quiz in quiz_order:
            quiz_id = config_quiz['quiz_id']
            original_quiz = original_quizzes[quiz_id]
            theme = original_quiz.get('theme', original_quiz.get('category', 'unknown'))
            theme_counts[theme] += 1
        
        if theme_counts:
            print(f"\nTop 10 themes:")
            for theme, count in sorted(theme_counts.items(), key=lambda x: x[1], reverse=True)[:10]:
                print(f"  {theme}: {count} quizzes")
    
    def save_ordered_quizzes(self, ordered_data: Dict[str, Any]) -> None:
        """Save the ordered quiz data to the output file."""
        # Ensure output directory exists
        output_dir = os.path.dirname(self.output_file)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir, exist_ok=True)
        
        try:
            with open(self.output_file, 'w', encoding='utf-8') as f:
                json.dump(ordered_data, f, ensure_ascii=False, indent=2)
            
            file_size = os.path.getsize(self.output_file) / 1024  # Size in KB
            print(f"✓ Ordered quiz data saved to '{self.output_file}' ({file_size:.1f} KB)")
            
        except Exception as e:
            print(f"❌ Error saving ordered quiz data: {e}")
            sys.exit(1)
    
    def create_dataloader_integration_instructions(self) -> None:
        """Create instructions for integrating with DataLoaderService."""
        instructions_file = "CUSTOM_ORDER_INTEGRATION.md"
        
        instructions = f"""# Custom Quiz Order Integration

The custom quiz order has been applied and saved to `{self.output_file}`.

## Integration with DataLoaderService

To use the custom order in your Flutter app, you have several options:

### Option 1: Direct File Replacement (Recommended)
Replace the existing quiz loading logic in `DataLoaderService._loadLevelsByDifficulty()`:

```dart
// Add this method to DataLoaderService
static Future<List<Level>> _loadCustomOrderedQuizzes() async {{
  try {{
    final String jsonString = await rootBundle.loadString('{self.output_file}');
    final Map<String, dynamic> data = jsonDecode(jsonString);
    
    if (!data['custom_order_applied']) {{
      debugPrint('Warning: Custom order not applied to quiz data');
    }}
    
    final List<dynamic> quizzes = data['quizzes'] as List<dynamic>;
    List<Level> levels = [];
    
    for (int i = 0; i < quizzes.length; i++) {{
      final quiz = quizzes[i] as Map<String, dynamic>;
      
      final List<dynamic> answersJson = quiz['answers'] as List<dynamic>;
      final List<Answer> answers = answersJson
          .map((answerJson) => Answer.fromJson(answerJson as Map<String, dynamic>))
          .toList();
      
      final level = Level(
        id: quiz['id'] as int? ?? (i + 1),
        title: quiz['title'] as String,
        hint: quiz['hint'] as String? ?? '',
        category: (quiz['theme'] ?? quiz['category']) as String,
        answers: answers,
        difficulty: quiz['difficulty'] as int,
        isUnlocked: false,
        isCompleted: false,
        tierId: quiz['tier_id'] as int,
        positionInTier: quiz['position_in_tier'] as int,
        pointsReward: quiz['difficulty'] as int,
      );
      
      levels.add(level);
    }}
    
    debugPrint('Loaded ${{levels.length}} quizzes in custom order');
    return levels;
  }} catch (e) {{
    debugPrint('Error loading custom ordered quizzes: $e');
    // Fallback to original loading method
    return [];
  }}
}}
```

### Option 2: Modify loadAllQuizzesWithTiers()
Update the method to use custom order when available:

```dart
// In loadAllQuizzesWithTiers(), replace the difficulty loading section:
List<Level> allLevels = await _loadCustomOrderedQuizzes();
if (allLevels.isEmpty) {{
  // Fallback to original method
  final difficultyFiles = await _loadLevelsByDifficulty();
  for (final difficultyGroup in difficultyFiles) {{
    allLevels.addAll(difficultyGroup);
  }}
}}
```

### Option 3: Configuration Flag
Add a configuration option to switch between custom and default ordering:

```dart
static bool useCustomOrder = true; // Add this to DataLoaderService

// Then in loadAllQuizzesWithTiers():
List<Level> allLevels = [];
if (useCustomOrder) {{
  allLevels = await _loadCustomOrderedQuizzes();
}}

if (allLevels.isEmpty) {{
  // Use original loading method as fallback
  // ... existing code
}}
```

## Important Notes

1. **Remove Deterministic Shuffling**: When using custom order, skip the `_shuffleDeterministic()` calls
2. **Tier Assignment**: The custom data includes `tier_id` and `position_in_tier` fields
3. **Backup**: Original files have been backed up before applying changes
4. **Validation**: All {len(quiz_order) if 'quiz_order' in locals() else 'N/A'} quizzes have been validated and accounted for

## Testing

After integration:
1. Verify quiz order matches the configuration from quiz_organizer.html
2. Check that tier assignments are correct
3. Ensure all quiz data (answers, hints, etc.) is preserved
4. Test tier unlocking and progression logic

Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
"""
        
        try:
            with open(instructions_file, 'w', encoding='utf-8') as f:
                f.write(instructions)
            print(f"✓ Integration instructions saved to '{instructions_file}'")
        except Exception as e:
            print(f"⚠️  Warning: Could not save integration instructions: {e}")
    
    def run(self) -> None:
        """Execute the complete quiz order application process."""
        print("🚀 Quiz Order Applicator")
        print("=" * 50)
        
        # Step 1: Load configuration
        print("\n1. Loading quiz order configuration...")
        config = self.load_quiz_order_config()
        quiz_order = config['quiz_order']
        
        # Step 2: Load original quizzes  
        print("\n2. Loading original quiz files...")
        original_quizzes = self.load_original_quizzes()
        
        # Step 3: Validate configuration
        print("\n3. Validating quiz order configuration...")
        is_valid, errors = self.validate_quiz_order(quiz_order, original_quizzes)
        
        if not is_valid:
            print("❌ Validation failed:")
            for error in errors:
                print(f"   • {error}")
            sys.exit(1)
        else:
            print("✓ Configuration validation passed")
        
        # Step 4: Backup original files
        if self.backup:
            print("\n4. Creating backups...")
            self.backup_original_files()
        
        # Step 5: Create ordered quiz data
        print("\n5. Creating ordered quiz data...")
        ordered_data = self.create_ordered_quiz_data(quiz_order, original_quizzes)
        
        # Step 6: Generate statistics
        self.generate_statistics(quiz_order, original_quizzes)
        
        # Step 7: Save ordered data
        print("\n6. Saving ordered quiz data...")
        self.save_ordered_quizzes(ordered_data)
        
        # Step 8: Create integration instructions
        print("\n7. Creating integration instructions...")
        self.create_dataloader_integration_instructions()
        
        print("\n✅ Quiz order application completed successfully!")
        print(f"Next step: Integrate '{self.output_file}' with your Flutter app using the instructions in CUSTOM_ORDER_INTEGRATION.md")


def main():
    """Main entry point with command line argument parsing."""
    parser = argparse.ArgumentParser(
        description="Apply custom quiz order configuration to Flutter app",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python apply_quiz_order.py
  python apply_quiz_order.py --config-file my_config.json
  python apply_quiz_order.py --output data/my_custom_order.json --no-backup
        """
    )
    
    parser.add_argument(
        '--config-file', '-c',
        default='quiz_order_config.json',
        help='Path to the quiz order configuration file (default: quiz_order_config.json)'
    )
    
    parser.add_argument(
        '--output', '-o', 
        default='data/quiz_custom_order.json',
        help='Output file path for the ordered quiz data (default: data/quiz_custom_order.json)'
    )
    
    parser.add_argument(
        '--no-backup',
        action='store_true',
        help='Skip creating backups of original files'
    )
    
    parser.add_argument(
        '--backup-dir',
        help='Custom backup directory (default: data/backup_TIMESTAMP)'
    )
    
    args = parser.parse_args()
    
    # Create and run the applicator
    applicator = QuizOrderApplicator(
        config_file=args.config_file,
        output_file=args.output,
        backup=not args.no_backup
    )
    
    try:
        applicator.run()
    except KeyboardInterrupt:
        print("\n\n❌ Operation cancelled by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()