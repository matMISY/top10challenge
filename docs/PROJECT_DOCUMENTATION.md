# Top 10 Challenge - Complete Project Documentation

## Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Core Components](#core-components)
4. [Quiz System](#quiz-system)
5. [Key Features](#key-features)
6. [Development Guide](#development-guide)
7. [API Reference](#api-reference)
8. [Recommendations](#recommendations)

## Project Overview

### What is Top 10 Challenge?

Top 10 Challenge is a football-themed mobile quiz application built with Flutter. Players test their knowledge by finding the top 10 players in various football categories including transfers, goal scorers, assists, and more.

### Main Features

- **Interactive Football Quizzes**: Find the top 10 players in different categories
- **Tier-Based Progression System**: 30+ tiers with 5 levels each
- **Lives & Hints System**: Strategic gameplay with limited lives and hints
- **Rewarded Advertisements**: Watch ads to gain extra lives
- **Auto-Save Progress**: Resume quizzes where you left off
- **Intelligent Search**: Auto-completion with 2400+ player names
- **Multi-language Support**: Player nationalities with flag displays

### Technology Stack

- **Framework**: Flutter 3.6.0+
- **State Management**: Provider pattern
- **Local Storage**: SharedPreferences
- **Monetization**: Google Mobile Ads
- **UI Components**: Material Design 3 with custom theming
- **Typography**: Google Fonts (Baloo2)
- **Internationalization**: Flag package for country flags

## Architecture

### Design Pattern

The application follows a clean architecture pattern with clear separation of concerns:

```
┌─────────────────────────────────────┐
│         Presentation Layer          │
│     (Screens & Widgets)             │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         State Management            │
│     (Provider & GameProvider)       │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│         Business Logic              │
│     (Services & Controllers)        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│          Data Layer                 │
│   (Models & Local Storage)          │
└─────────────────────────────────────┘
```

### Project Structure

```
lib/
├── data/
│   └── players_database.dart       # Static player names database
├── models/
│   ├── answer.dart                 # Answer model with nationality
│   ├── game_state.dart             # Game state management
│   ├── level.dart                  # Level/Quiz model
│   ├── player.dart                 # Player model
│   └── tier.dart                   # Tier grouping model
├── providers/
│   └── game_provider.dart          # Main state provider
├── screens/
│   ├── daily_challenge_screen.dart # Daily challenge (deprecated)
│   ├── game_screen.dart            # Main quiz gameplay
│   ├── home_screen.dart            # App home screen
│   ├── level_map_screen.dart       # Level selection map
│   ├── tier_levels_screen.dart     # Levels within a tier
│   └── tier_selection_screen.dart  # Tier selection screen
├── services/
│   ├── ads_service.dart            # Advertisement management
│   ├── data_loader_service.dart    # Quiz data loading
│   ├── game_service.dart           # Game logic & persistence
│   ├── migration_service.dart      # Data migration utilities
│   └── search_service.dart         # Player search functionality
├── utils/
│   ├── country_flags.dart          # Country to flag emoji mapping
│   └── debug_config.dart           # Debug configuration flags
├── widgets/
│   ├── answer_slot.dart            # Answer display widget
│   └── search_input.dart           # Search input widget
└── main.dart                        # Application entry point
```

## Core Components

### Models

#### Level Model (`lib/models/level.dart`)
Represents a single quiz with the following properties:
- `id`: Unique identifier
- `title`: Quiz title (e.g., "TOP 10 Buteurs Ligue 1 2023/24")
- `hint`: Additional hint for the quiz
- `category`: Theme category
- `answers`: List of Answer objects (10 players)
- `difficulty`: 1-7 scale affecting points and rewards
- `tierId`: Parent tier identifier
- `positionInTier`: Position within tier (1-5)
- `pointsReward`: Points earned on completion

#### Answer Model (`lib/models/answer.dart`)
Represents a quiz answer with:
- `name`: Player name
- `nationality`: Country code for flag display
- `hint`: Optional hint (e.g., club name)

#### Tier Model (`lib/models/tier.dart`)
Groups 5 levels together:
- `id`: Tier identifier (1-30+)
- `name`: Display name (e.g., "Palier 1")
- `description`: Tier description
- `levelIds`: Array of 5 level IDs
- `isUnlocked`: Unlock status
- `unlockCost`: Points required to unlock

#### GameState Model (`lib/models/game_state.dart`)
Manages overall game progression:
- `lives`: Current lives (max 5)
- `hints`: Available hints
- `totalPoints`: Accumulated points
- `completedLevels`: List of completed level IDs
- `unlockedTiers`: List of unlocked tier IDs
- `lastLifeLostTime`: Timestamp for life recovery
- `lastAdWatchTime`: Timestamp for ad cooldown

### Services

#### GameService (`lib/services/game_service.dart`)
Core game logic and persistence:
- Level completion tracking
- Points management
- Life recovery system (30-minute timer)
- Progress saving/loading
- Tier unlocking logic

#### DataLoaderService (`lib/services/data_loader_service.dart`)
Handles quiz data loading:
- Loads quiz data from JSON files
- Deterministic shuffling (seed: 42)
- Tier configuration loading
- Support for both v3 and legacy formats

#### AdsService (`lib/services/ads_service.dart`)
Manages rewarded advertisements:
- Google AdMob integration
- Rewarded video ads for extra lives
- 2-minute cooldown between ads
- Production ad unit IDs configured

#### SearchService (`lib/services/search_service.dart`)
Intelligent player search:
- Fuzzy matching algorithm
- Accent-insensitive search
- Auto-completion from 2400+ player database
- Similarity scoring for best matches

### Providers

#### GameProvider (`lib/providers/game_provider.dart`)
Main state management:
- Centralizes game state
- Manages life recovery timers
- Handles level completion
- Coordinates between services
- UI update notifications

### Screens

#### HomeScreen
Main entry point with:
- Lives display with recovery timer
- Total points display
- Navigation to tier selection
- Settings access (future feature)

#### TierSelectionScreen
Displays all 30+ tiers:
- Visual progression indicators
- Lock/unlock status
- Points required for locked tiers
- Completion percentage per tier

#### TierLevelsScreen
Shows 5 levels within a tier:
- Level cards with difficulty indicators
- Completion status (green checkmark)
- Points reward display
- Direct navigation to gameplay

#### GameScreen
Main quiz gameplay:
- 10 answer slots
- Search input with auto-completion
- Lives and hints display
- Progress auto-save
- Victory/defeat modals

## Quiz System

### Data Format

Quiz data is stored in JSON format under `data/v3/`:

```json
{
  "generated_at": "2025-08-08T23:58:18",
  "total_quizzes": 29,
  "quizzes": [
    {
      "id": 1,
      "title": "TOP 10 du Ballon d'Or 2024",
      "theme": "Ballon d'Or",
      "difficulty": 1,
      "hint": "Pour chaque joueur, renseigner son club",
      "answers": [
        {
          "name": "Rodri",
          "nationality": "espagne",
          "hint": "Man City"
        }
      ]
    }
  ]
}
```

### Quiz Loading Process

1. **Initialization**: DataLoaderService loads all quiz files
2. **Shuffling**: Deterministic shuffle ensures consistent order
3. **Tier Assignment**: Quizzes grouped into tiers of 5
4. **Difficulty Mapping**: Points assigned based on difficulty
5. **State Restoration**: Previous progress loaded from SharedPreferences

### Scoring System

- **Points per level**: Equal to difficulty (1-7 points)
- **Hints earned**: Difficulty value on completion
- **Lives gained**: +1 life per completed level
- **Tier unlock**: Automatic when points threshold reached

### Lives System

- **Maximum lives**: 5
- **Life recovery**: 1 life every 30 minutes
- **Extra lives**: Watch rewarded ad (2-minute cooldown)
- **Life loss**: Wrong answer (except already found)

## Key Features

### Tier-Based Progression

The game features 30+ tiers with carefully balanced progression:

- **Tier 1**: Free (0 points) - Tutorial levels
- **Tier 2**: 4 points - Early game
- **Tier 3**: 11 points - Building knowledge
- **Tier 30**: 851 points - Ultimate challenge

Each tier contains 5 levels with increasing difficulty, creating natural progression milestones.

### Advertisement Integration

Rewarded ads provide gameplay benefits:
- **Reward**: +1 life instantly
- **Cooldown**: 2 minutes between ads
- **Integration**: Google AdMob
- **Fallback**: Graceful handling if ads fail

### Hint System

Strategic hint usage:
- **Starting hints**: 3
- **Earn more**: Complete levels
- **Usage**: Reveals one correct answer
- **Cost**: 1 hint per use

### Auto-Save System

Seamless progress preservation:
- **Level progress**: Saved after each correct answer
- **Game state**: Persisted on app pause/close
- **Migration support**: Handles data format updates
- **Recovery**: Resume exactly where left off

## Development Guide

### Adding New Quiz Content

1. **Create Quiz JSON File**:
```bash
# Create new quiz file in data/v3/
touch data/v3/top10_new_category_$(date +%Y%m%d_%H%M%S).json
```

2. **Format Quiz Data**:
```json
{
  "generated_at": "2025-08-09T12:00:00",
  "total_quizzes": 10,
  "quizzes": [
    {
      "id": 1,
      "title": "TOP 10 Your Category",
      "theme": "Category",
      "difficulty": 2,
      "hint": "Hint text",
      "answers": [
        {
          "name": "Player Name",
          "nationality": "country_code",
          "hint": "Club/Year"
        }
      ]
    }
  ]
}
```

3. **Update Data Loader**:
- Files are automatically detected from `data/v3/` directory
- No code changes needed for new quiz files

### Building and Deployment

#### Debug Build
```bash
flutter run --debug
```

#### Release Build (Android)
```bash
# Generate release APK
flutter build apk --release

# Output location
# build/app/outputs/flutter-apk/app-release.apk
```

#### Release Build (iOS)
```bash
# Generate iOS build
flutter build ios --release

# Open in Xcode for signing
open ios/Runner.xcworkspace
```

### Debug Configuration

Enable debug features in `lib/utils/debug_config.dart`:

```dart
class DebugConfig {
  static const bool enableRevealAnswers = false;  // Show all answers
  static const bool enableSkipLevel = false;      // Skip to next level
  static const bool unlimitedLives = false;       // Infinite lives
  static const bool fastLifeRecovery = false;     // 1-minute recovery
}
```

### Testing Guidelines

#### Unit Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/game_service_test.dart
```

#### Integration Tests
```bash
# Run integration tests
flutter test integration_test/app_test.dart
```

### Common Development Tasks

#### Update Player Database
```bash
# Run the update script
dart scripts/update_player_names.dart
```

#### Analyze Quiz Distribution
```bash
# Check quiz variety and balance
python analyze_quiz_variety.py
```

#### Extract Quiz Titles
```bash
# Generate ordered quiz list
python extract_quiz_order.py > quiz_titles_ordered.txt
```

## API Reference

### GameProvider Methods

```dart
// Level Management
Future<void> completeLevel(int levelId)
Future<void> unlockTier(int tierId)
Future<bool> canUnlockTier(int tierId)

// Lives Management
void loseLife()
Future<void> recoverLife()
bool canWatchAdForLife()
Future<void> watchAdForLife()

// Hints Management
bool useHint()
void addHints(int amount)

// State Management
Future<void> loadGameData()
Future<void> saveGameState()
void resetGame()
```

### GameService Methods

```dart
// Progress Tracking
Future<void> saveFoundAnswersForLevel(int levelId, List<String> answers)
Future<List<String>> getFoundAnswersForLevel(int levelId)
Future<void> clearFoundAnswersForLevel(int levelId)

// State Persistence
Future<void> saveGameState(GameState state)
Future<GameState> getGameState()
Future<void> saveLevels(List<Level> levels)
Future<List<Level>> getLevels()
```

### SearchService Methods

```dart
// Search Operations
String? getCorrectAnswer(String input, List<String> availableAnswers)
List<String> getSuggestions(String query)
double calculateSimilarity(String s1, String s2)
String normalizeString(String input)
```

## Recommendations

### Performance Optimizations

1. **Image Optimization**
   - Implement lazy loading for tier selection screen
   - Cache processed flag emojis
   - Optimize background image size

2. **Data Loading**
   - Implement pagination for large quiz sets
   - Add quiz data compression
   - Cache parsed JSON data

3. **Memory Management**
   - Dispose controllers properly
   - Implement widget recycling in lists
   - Reduce rebuild frequency with selective consumers

### Code Quality Improvements

1. **Architecture**
   - Implement Repository pattern for data access
   - Add dependency injection (get_it)
   - Create dedicated use cases for business logic

2. **Testing**
   - Add comprehensive unit tests (target 80% coverage)
   - Implement widget tests for critical UI components
   - Add integration tests for user journeys

3. **Error Handling**
   - Implement global error boundary
   - Add crash reporting (Firebase Crashlytics)
   - Improve error messages for users

### Feature Enhancements

1. **Social Features**
   - Add leaderboards
   - Implement friend challenges
   - Share quiz results

2. **Gameplay Variety**
   - Add timed challenges
   - Implement daily quizzes
   - Create special event quizzes

3. **Monetization**
   - Add premium tier (no ads)
   - Implement in-app purchases for hints
   - Create cosmetic customizations

4. **User Experience**
   - Add onboarding tutorial
   - Implement achievement system
   - Add haptic feedback
   - Create sound effects and music

### Technical Debt

1. **Refactoring Priorities**
   - Extract magic numbers to constants
   - Reduce GameProvider complexity
   - Standardize error handling patterns

2. **Documentation**
   - Add inline code documentation
   - Create API documentation
   - Document deployment process

3. **Configuration**
   - Externalize configuration values
   - Add environment-specific configs
   - Implement feature flags

### Security Considerations

1. **Data Protection**
   - Encrypt sensitive local storage
   - Implement certificate pinning
   - Add tamper detection

2. **Ad Safety**
   - Validate ad content
   - Implement ad frequency capping
   - Add parental controls

## Conclusion

Top 10 Challenge is a well-structured Flutter application with solid foundations for a football quiz game. The tier-based progression system, combined with lives and hints mechanics, creates engaging gameplay. The codebase is organized and maintainable, with clear separation of concerns and good use of Flutter best practices.

Key strengths include the deterministic quiz ordering, comprehensive player database, and smooth progression system. Areas for improvement include adding more test coverage, implementing social features, and optimizing performance for larger datasets.

The application is production-ready with minor enhancements recommended for long-term scalability and user engagement.