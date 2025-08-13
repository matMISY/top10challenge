import 'dart:io';
import 'dart:convert';

void main() async {
  await rebuildPlayerNames();
}

Future<void> rebuildPlayerNames() async {
  print('🔄 Reconstruction complète des noms de joueurs...');
  
  // Créer une nouvelle liste vide
  Map<String, dynamic> allPlayersData = {
    'generated_at': DateTime.now().toString().substring(0, 19),
    'total_players': 0,
    'source': 'Quiz data extraction (rebuilt)',
    'player_names': []
  };
  
  // Lire tous les fichiers de quiz dans data/ et data/v3/
  final dataDir = Directory('data');
  final v3Dir = Directory('data/v3');
  
  final quizFiles = <File>[];
  
  // Fichiers dans data/
  await for (final entity in dataDir.list()) {
    if (entity is File && entity.path.endsWith('.json')) {
      quizFiles.add(entity);
    }
  }
  
  // Fichiers dans data/v3/ si le dossier existe
  if (await v3Dir.exists()) {
    await for (final entity in v3Dir.list()) {
      if (entity is File && entity.path.endsWith('.json')) {
        quizFiles.add(entity);
      }
    }
  }
  
  Set<String> allPlayers = <String>{};
  int totalQuizzes = 0;
  
  for (final file in quizFiles) {
    try {
      print('📖 Lecture de ${file.path.split('/').last}...');
      final content = await file.readAsString();
      final quizData = json.decode(content);
      
      // Support des deux formats : data/quizzes (v3) et data/data (ancien)
      List<dynamic>? quizzes;
      if (quizData['quizzes'] != null) {
        quizzes = quizData['quizzes'] as List;  // Format v3
      } else if (quizData['data'] != null) {
        quizzes = quizData['data'] as List;     // Format ancien
      }
      
      if (quizzes != null) {
        totalQuizzes += quizzes.length;
        
        for (final quiz in quizzes) {
          if (quiz['answers'] != null) {
            final answers = quiz['answers'] as List;
            for (final answer in answers) {
              if (answer['name'] != null) {
                final playerName = answer['name'].toString().trim();
                if (playerName.isNotEmpty) {
                  allPlayers.add(playerName);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('⚠️  Erreur lors de la lecture de ${file.path}: $e');
    }
  }
  
  // Trier alphabétiquement
  final sortedPlayers = allPlayers.toList()..sort();
  
  // Mettre à jour les données
  allPlayersData['total_players'] = sortedPlayers.length;
  allPlayersData['player_names'] = sortedPlayers;
  allPlayersData['last_quiz_scan'] = {
    'date': DateTime.now().toString().substring(0, 19),
    'files_processed': quizFiles.length,
    'total_quizzes': totalQuizzes,
    'unique_players': sortedPlayers.length
  };
  
  // Sauvegarder le fichier reconstruit
  final allPlayersFile = File('all_player_names.json');
  final encoder = JsonEncoder.withIndent('  ');
  await allPlayersFile.writeAsString(encoder.convert(allPlayersData));
  
  print('✅ Liste reconstruite avec ${sortedPlayers.length} joueurs uniques');
  print('📁 ${quizFiles.length} fichiers traités, ${totalQuizzes} quiz analysés');
  print('🎉 Reconstruction terminée!');
}