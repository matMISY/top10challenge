# Custom Quiz Order Integration

The custom quiz order has been applied and saved to `data/quiz_custom_order.json`.

## Integration with DataLoaderService

To use the custom order in your Flutter app, you have several options:

### Option 1: Direct File Replacement (Recommended)
Replace the existing quiz loading logic in `DataLoaderService._loadLevelsByDifficulty()`:

```dart
// Add this method to DataLoaderService
static Future<List<Level>> _loadCustomOrderedQuizzes() async {
  try {
    final String jsonString = await rootBundle.loadString('data/quiz_custom_order.json');
    final Map<String, dynamic> data = jsonDecode(jsonString);
    
    if (!data['custom_order_applied']) {
      debugPrint('Warning: Custom order not applied to quiz data');
    }
    
    final List<dynamic> quizzes = data['quizzes'] as List<dynamic>;
    List<Level> levels = [];
    
    for (int i = 0; i < quizzes.length; i++) {
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
    }
    
    debugPrint('Loaded ${levels.length} quizzes in custom order');
    return levels;
  } catch (e) {
    debugPrint('Error loading custom ordered quizzes: $e');
    // Fallback to original loading method
    return [];
  }
}
```

### Option 2: Modify loadAllQuizzesWithTiers()
Update the method to use custom order when available:

```dart
// In loadAllQuizzesWithTiers(), replace the difficulty loading section:
List<Level> allLevels = await _loadCustomOrderedQuizzes();
if (allLevels.isEmpty) {
  // Fallback to original method
  final difficultyFiles = await _loadLevelsByDifficulty();
  for (final difficultyGroup in difficultyFiles) {
    allLevels.addAll(difficultyGroup);
  }
}
```

### Option 3: Configuration Flag
Add a configuration option to switch between custom and default ordering:

```dart
static bool useCustomOrder = true; // Add this to DataLoaderService

// Then in loadAllQuizzesWithTiers():
List<Level> allLevels = [];
if (useCustomOrder) {
  allLevels = await _loadCustomOrderedQuizzes();
}

if (allLevels.isEmpty) {
  // Use original loading method as fallback
  // ... existing code
}
```

## Important Notes

1. **Remove Deterministic Shuffling**: When using custom order, skip the `_shuffleDeterministic()` calls
2. **Tier Assignment**: The custom data includes `tier_id` and `position_in_tier` fields
3. **Backup**: Original files have been backed up before applying changes
4. **Validation**: All N/A quizzes have been validated and accounted for

## Testing

After integration:
1. Verify quiz order matches the configuration from quiz_organizer.html
2. Check that tier assignments are correct
3. Ensure all quiz data (answers, hints, etc.) is preserved
4. Test tier unlocking and progression logic

Generated: 2025-08-13 00:27:24
