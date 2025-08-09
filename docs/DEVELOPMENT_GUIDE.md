# Top 10 Challenge - Development Guide

## Table of Contents
1. [Getting Started](#getting-started)
2. [Development Setup](#development-setup)
3. [Project Configuration](#project-configuration)
4. [Adding New Quizzes](#adding-new-quizzes)
5. [Modifying Game Logic](#modifying-game-logic)
6. [UI Development](#ui-development)
7. [Testing](#testing)
8. [Building & Deployment](#building--deployment)
9. [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

- **Flutter SDK**: 3.6.0 or higher
- **Dart SDK**: 3.6.0 or higher
- **Android Studio** or **VSCode** with Flutter extensions
- **Xcode** (for iOS development on macOS)
- **Git** for version control

### Initial Setup

1. **Clone the repository**:
```bash
git clone https://github.com/yourusername/top10challenge.git
cd top10challenge
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Verify setup**:
```bash
flutter doctor
```

4. **Run the app**:
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run on Chrome (web)
flutter run -d chrome
```

## Development Setup

### IDE Configuration

#### Visual Studio Code
1. Install extensions:
   - Flutter
   - Dart
   - Awesome Flutter Snippets

2. Recommended settings (`.vscode/settings.json`):
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "dart.lineLength": 120
}
```

#### Android Studio
1. Install Flutter plugin
2. Configure Flutter SDK path
3. Enable format on save

### Environment Variables

Create a `.env` file for local development:
```env
# AdMob IDs (use test IDs for development)
ADMOB_APP_ID_ANDROID=ca-app-pub-3940256099942544~3347511713
ADMOB_APP_ID_IOS=ca-app-pub-3940256099942544~1458002511
ADMOB_REWARDED_AD_ANDROID=ca-app-pub-3940256099942544/5224354917
ADMOB_REWARDED_AD_IOS=ca-app-pub-3940256099942544/1712485313
```

### Debug Configuration

Enable debug features in `lib/utils/debug_config.dart`:

```dart
class DebugConfig {
  // Development mode flags
  static const bool isDevelopment = true;
  
  // Debug features
  static const bool enableRevealAnswers = true;   // Show answer button
  static const bool enableSkipLevel = true;       // Skip level button
  static const bool unlimitedLives = true;        // No life loss
  static const bool fastLifeRecovery = true;      // 1-minute recovery
  static const bool showDebugInfo = true;         // Debug overlay
  
  // Feature flags
  static const bool hideDailyChallenge = true;    // Hide unfinished features
  static const bool enableAds = false;            // Disable ads in dev
}
```

## Project Configuration

### App Configuration

#### Android (`android/app/build.gradle`)
```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.top10challenge"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 3
        versionName "2.0.0"
    }
    
    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt')
        }
        debug {
            applicationIdSuffix ".debug"
            versionNameSuffix "-DEBUG"
        }
    }
}
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>CFBundleDisplayName</key>
<string>Top10 Challenge</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.top10challenge</string>
<key>CFBundleShortVersionString</key>
<string>2.0.0</string>
<key>CFBundleVersion</key>
<string>3</string>
```

### Dependencies Management

#### Adding new packages:
```bash
# Add dependency
flutter pub add package_name

# Add dev dependency
flutter pub add --dev package_name

# Update dependencies
flutter pub upgrade
```

#### Current key dependencies:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1          # State management
  shared_preferences: ^2.2.2 # Local storage
  google_mobile_ads: ^5.0.0  # Monetization
  flag: ^7.0.0              # Country flags
  google_fonts: ^6.1.0       # Typography
```

## Adding New Quizzes

### Quiz Data Format

Create a new quiz file in `data/v3/`:

```json
{
  "generated_at": "2025-08-09T10:00:00.000000",
  "total_quizzes": 10,
  "quizzes": [
    {
      "id": 1,
      "title": "TOP 10 Premier League 2024/25",
      "theme": "Premier League",
      "difficulty": 2,
      "hint": "Meilleurs buteurs de la saison",
      "answers": [
        {
          "name": "Erling Haaland",
          "nationality": "norvège",
          "hint": "Manchester City"
        },
        {
          "name": "Mohamed Salah",
          "nationality": "egypte",
          "hint": "Liverpool"
        }
        // ... 8 more answers
      ]
    }
  ]
}
```

### Quiz Generation Script

Create a Python script to generate quiz data:

```python
#!/usr/bin/env python3
import json
from datetime import datetime

def create_quiz(title, theme, difficulty, hint, answers):
    return {
        "id": 1,
        "title": title,
        "theme": theme,
        "difficulty": difficulty,
        "hint": hint,
        "answers": answers
    }

def create_answer(name, nationality, hint=None):
    answer = {
        "name": name,
        "nationality": nationality
    }
    if hint:
        answer["hint"] = hint
    return answer

# Generate quiz data
quiz = create_quiz(
    title="TOP 10 Example",
    theme="Example",
    difficulty=2,
    hint="Example hint",
    answers=[
        create_answer("Player 1", "france", "PSG"),
        # Add more answers
    ]
)

# Save to file
output = {
    "generated_at": datetime.now().isoformat(),
    "total_quizzes": 1,
    "quizzes": [quiz]
}

filename = f"data/v3/top10_example_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
with open(filename, 'w', encoding='utf-8') as f:
    json.dump(output, f, ensure_ascii=False, indent=2)
```

### Nationality Codes

Use these country codes for the `nationality` field:

```dart
// From lib/utils/country_flags.dart
'france' → 🇫🇷
'bresil' → 🇧🇷
'argentine' → 🇦🇷
'allemagne' → 🇩🇪
'espagne' → 🇪🇸
'angleterre' → 🏴󐁧󐁢󐁥󐁮󐁧󐁿
'portugal' → 🇵🇹
'pays-bas' → 🇳🇱
'belgique' → 🇧🇪
'italie' → 🇮🇹
// ... see full list in country_flags.dart
```

### Difficulty Guidelines

| Difficulty | Points | Description | Example Categories |
|------------|--------|-------------|-------------------|
| 1 | 1 | Very Easy | Current season top scorers |
| 2 | 2 | Easy | Recent transfer records |
| 3 | 3 | Medium | Historical statistics |
| 4 | 4 | Hard | Specific competition records |
| 5 | 5 | Very Hard | Obscure statistics |
| 6 | 6 | Expert | Multiple criteria combinations |
| 7 | 7 | Master | Ultra-specific records |

## Modifying Game Logic

### Adding New Game Features

#### Example: Adding a Power-Up System

1. **Create the model** (`lib/models/power_up.dart`):
```dart
class PowerUp {
  final String id;
  final String name;
  final String description;
  final int cost;
  final Function(GameState) effect;
  
  PowerUp({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.effect,
  });
}
```

2. **Update GameState** (`lib/models/game_state.dart`):
```dart
class GameState {
  // ... existing fields
  final List<PowerUp> availablePowerUps;
  final List<String> activePowerUps;
  
  // ... update copyWith and serialization
}
```

3. **Add to GameService** (`lib/services/game_service.dart`):
```dart
Future<bool> usePowerUp(String powerUpId) async {
  final state = await getGameState();
  final powerUp = getPowerUpById(powerUpId);
  
  if (state.totalPoints >= powerUp.cost) {
    // Apply power-up effect
    powerUp.effect(state);
    
    // Deduct points
    final newState = state.copyWith(
      totalPoints: state.totalPoints - powerUp.cost,
      activePowerUps: [...state.activePowerUps, powerUpId],
    );
    
    await saveGameState(newState);
    return true;
  }
  return false;
}
```

4. **Update GameProvider** (`lib/providers/game_provider.dart`):
```dart
Future<void> activatePowerUp(String powerUpId) async {
  final success = await _gameService.usePowerUp(powerUpId);
  if (success) {
    await loadGameData();
    notifyListeners();
  }
}
```

### Modifying Existing Features

#### Changing Life Recovery Time

In `lib/services/game_service.dart`:
```dart
class GameService {
  // Change from 30 minutes to 15 minutes
  static const int lifeRecoveryMinutes = 15; // was 30
  
  Duration getTimeUntilNextLife() {
    // ... implementation
  }
}
```

#### Modifying Points System

In `lib/models/level.dart`:
```dart
class Level {
  // Custom points calculation
  int get pointsReward {
    // Base points on difficulty
    int basePoints = difficulty;
    
    // Bonus for specific categories
    if (category == 'Champions League') {
      basePoints += 2;
    }
    
    return basePoints;
  }
}
```

## UI Development

### Creating New Screens

#### Screen Template
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});
  
  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Container(
            // Your UI here
          );
        },
      ),
    );
  }
}
```

### Creating Custom Widgets

#### Reusable Component Template
```dart
class CustomWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  
  const CustomWidget({
    super.key,
    required this.title,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          style: theme.textTheme.titleMedium,
        ),
      ),
    );
  }
}
```

### Theme Customization

Update `lib/main.dart`:
```dart
ThemeData customTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2C5F5D),
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.baloo2TextTheme().copyWith(
      headlineLarge: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      // Customize other text styles
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    // Add more theme customizations
  );
}
```

## Testing

### Unit Tests

Create test files in `test/`:

```dart
// test/services/game_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:top10_challenge/services/game_service.dart';

void main() {
  group('GameService', () {
    late GameService gameService;
    
    setUp(() {
      gameService = GameService();
    });
    
    test('should recover life after 30 minutes', () async {
      // Arrange
      final state = GameState(lives: 3);
      await gameService.saveGameState(state);
      
      // Act
      final canRecover = await gameService.canRecoverLife();
      
      // Assert
      expect(canRecover, isTrue);
    });
    
    test('should not exceed max lives', () async {
      // Test implementation
    });
  });
}
```

### Widget Tests

```dart
// test/widgets/answer_slot_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:top10_challenge/widgets/answer_slot.dart';

void main() {
  testWidgets('AnswerSlot shows player name when found', 
    (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnswerSlot(
            index: 1,
            answer: Answer(
              name: 'Test Player',
              nationality: 'france',
            ),
            isFound: true,
          ),
        ),
      ),
    );
    
    // Verify
    expect(find.text('Test Player'), findsOneWidget);
    expect(find.text('🇫🇷'), findsOneWidget);
  });
}
```

### Integration Tests

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:top10_challenge/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete quiz flow', (WidgetTester tester) async {
    // Launch app
    await tester.pumpWidget(const Top10ChallengeApp());
    await tester.pumpAndSettle();
    
    // Navigate to tier selection
    await tester.tap(find.text('Jouer'));
    await tester.pumpAndSettle();
    
    // Select first tier
    await tester.tap(find.text('Palier 1'));
    await tester.pumpAndSettle();
    
    // Select first level
    await tester.tap(find.text('Niveau 1'));
    await tester.pumpAndSettle();
    
    // Enter an answer
    await tester.enterText(
      find.byType(TextField),
      'Player Name',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    
    // Verify feedback
    // ... more test steps
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/game_service_test.dart

# Run with coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Run integration tests
flutter test integration_test/app_test.dart
```

## Building & Deployment

### Android Build

#### Debug Build
```bash
flutter build apk --debug
```

#### Release Build
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release

# Build with split APKs
flutter build apk --split-per-abi --release
```

#### Signing Configuration

Create `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=/path/to/your/keystore.jks
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? 
              file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### iOS Build

#### Setup
1. Open Xcode:
```bash
open ios/Runner.xcworkspace
```

2. Configure signing in Xcode
3. Select your development team
4. Configure bundle identifier

#### Build
```bash
# Build for iOS
flutter build ios --release

# Build IPA
flutter build ipa --release
```

### Web Build

```bash
# Build for web
flutter build web --release

# Build with specific renderer
flutter build web --web-renderer canvaskit --release

# Serve locally
python3 -m http.server 8000 --directory build/web
```

### Version Management

Update version in `pubspec.yaml`:
```yaml
version: 2.0.0+3  # version+buildNumber
```

Platform-specific:
- Android: Updates `versionName` and `versionCode`
- iOS: Updates `CFBundleShortVersionString` and `CFBundleVersion`

## Troubleshooting

### Common Issues

#### 1. Build Failures

**Problem**: Build fails with dependency errors
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter build apk
```

**Problem**: iOS build fails with pod errors
```bash
# Solution: Update pods
cd ios
pod deintegrate
pod install
cd ..
flutter build ios
```

#### 2. State Management Issues

**Problem**: State not updating
```dart
// Ensure notifyListeners() is called
void updateState() {
  _someValue = newValue;
  notifyListeners(); // Don't forget this!
}
```

**Problem**: Infinite rebuilds
```dart
// Avoid calling setState in build
@override
Widget build(BuildContext context) {
  // DON'T do this:
  // setState(() {}); 
  
  return Container();
}
```

#### 3. Performance Issues

**Problem**: Laggy scrolling
```dart
// Use ListView.builder for long lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

**Problem**: Memory leaks
```dart
// Dispose controllers and listeners
@override
void dispose() {
  _controller.dispose();
  _timer?.cancel();
  super.dispose();
}
```

### Debug Tools

#### Flutter Inspector
- View widget tree
- Debug layout issues
- Performance overlay

#### Debug Console Commands
```bash
# Hot reload
r

# Hot restart
R

# Debug paint
p

# Performance overlay
P

# Quit
q
```

#### Logging
```dart
import 'package:flutter/foundation.dart';

// Use debugPrint for development
debugPrint('Debug message');

// Conditional logging
if (kDebugMode) {
  print('Only in debug mode');
}

// Detailed logging
debugPrint('Loading quiz: ${quiz.title}');
debugPrint('Answers: ${quiz.answers.length}');
```

### Performance Profiling

```bash
# Run in profile mode
flutter run --profile

# Use DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

## Best Practices

### Code Style

1. **Follow Dart conventions**:
   - Use `lowerCamelCase` for variables
   - Use `UpperCamelCase` for classes
   - Use `_` prefix for private members

2. **Organize imports**:
```dart
// Dart imports first
import 'dart:async';
import 'dart:convert';

// Package imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Project imports
import '../models/level.dart';
import '../services/game_service.dart';
```

3. **Use const constructors**:
```dart
const MyWidget(); // Good
MyWidget(); // Avoid when possible
```

### Git Workflow

1. **Branch naming**:
   - `feature/add-quiz-timer`
   - `bugfix/fix-life-recovery`
   - `refactor/improve-search`

2. **Commit messages**:
```bash
# Good
git commit -m "Add timer to quiz gameplay"
git commit -m "Fix life recovery calculation"

# Bad
git commit -m "Fixed stuff"
git commit -m "Update"
```

3. **Pull request template**:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Refactoring

## Testing
- [ ] Unit tests pass
- [ ] Manual testing completed

## Screenshots
(if applicable)
```

## Resources

### Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Provider Package](https://pub.dev/packages/provider)
- [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads)

### Tools
- [Flutter DevTools](https://docs.flutter.dev/development/tools/devtools)
- [DartPad](https://dartpad.dev/)
- [JSON to Dart](https://javiercbk.github.io/json_to_dart/)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Discord](https://discord.gg/flutter)