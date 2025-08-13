import 'dart:io';
import 'dart:convert';

void main() async {
  await normalizePlayerNames();
}

Future<void> normalizePlayerNames() async {
  print('🔄 Normalisation des noms de joueurs...');
  
  // Règles de normalisation - forme la plus claire
  final Map<RegExp, String> normalizationRules = {
    // Jr. -> Junior (avec ou sans point, avec ou sans espace)
    RegExp(r'\bJr\.?\s*$', caseSensitive: false): 'Junior',
    // Sr. -> Senior (avec ou sans point, avec ou sans espace)  
    RegExp(r'\bSr\.?\s*$', caseSensitive: false): 'Senior',
  };
  
  // Traiter tous les fichiers de quiz
  await _normalizeQuizFiles(normalizationRules);
  
  // Régénérer le fichier all_player_names.json
  print('🔄 Régénération du fichier all_player_names.json...');
  await Process.run('dart', ['scripts/update_player_names.dart']);
  
  print('🎉 Normalisation terminée!');
}

Future<void> _normalizeQuizFiles(Map<RegExp, String> rules) async {
  final List<String> directories = ['data', 'data/v3'];
  int totalFiles = 0;
  int totalChanges = 0;
  
  for (final dirPath in directories) {
    final dir = Directory(dirPath);
    if (!await dir.exists()) continue;
    
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        final changes = await _normalizeFile(entity, rules);
        totalChanges += changes;
        totalFiles++;
        
        if (changes > 0) {
          print('✅ ${entity.path.split('/').last}: $changes changements');
        }
      }
    }
  }
  
  print('📊 $totalFiles fichiers traités, $totalChanges changements au total');
}

Future<int> _normalizeFile(File file, Map<RegExp, String> rules) async {
  try {
    final content = await file.readAsString();
    final data = json.decode(content);
    int changes = 0;
    
    // Normaliser selon le format du fichier
    if (data['quizzes'] != null) {
      // Format v3
      final quizzes = data['quizzes'] as List;
      for (final quiz in quizzes) {
        if (quiz['answers'] != null) {
          final answers = quiz['answers'] as List;
          for (final answer in answers) {
            if (answer['name'] != null) {
              final originalName = answer['name'].toString();
              final normalizedName = _applyRules(originalName, rules);
              if (normalizedName != originalName) {
                answer['name'] = normalizedName;
                changes++;
                print('  📝 "$originalName" → "$normalizedName"');
              }
            }
          }
        }
      }
    } else if (data['data'] != null) {
      // Format ancien
      final quizzes = data['data'] as List;
      for (final quiz in quizzes) {
        if (quiz['answers'] != null) {
          final answers = quiz['answers'] as List;
          for (final answer in answers) {
            if (answer['name'] != null) {
              final originalName = answer['name'].toString();
              final normalizedName = _applyRules(originalName, rules);
              if (normalizedName != originalName) {
                answer['name'] = normalizedName;
                changes++;
                print('  📝 "$originalName" → "$normalizedName"');
              }
            }
          }
        }
      }
    }
    
    // Sauvegarder si des changements ont été effectués
    if (changes > 0) {
      final encoder = JsonEncoder.withIndent('  ');
      await file.writeAsString(encoder.convert(data));
    }
    
    return changes;
    
  } catch (e) {
    print('⚠️  Erreur lors du traitement de ${file.path}: $e');
    return 0;
  }
}

String _applyRules(String name, Map<RegExp, String> rules) {
  String result = name.trim();
  
  for (final rule in rules.entries) {
    if (rule.key.hasMatch(result)) {
      result = result.replaceAll(rule.key, rule.value);
    }
  }
  
  return result;
}