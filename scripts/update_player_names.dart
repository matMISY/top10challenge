import 'dart:io';
import 'dart:convert';

void main() async {
  await updatePlayerNames();
}

Future<void> updatePlayerNames() async {
  print('🔄 Mise à jour des noms de joueurs...');
  
  // Lire le fichier all_player_names.json existant
  final allPlayersFile = File('all_player_names.json');
  Map<String, dynamic> allPlayersData;
  Set<String> existingPlayers = <String>{};
  
  if (await allPlayersFile.exists()) {
    final content = await allPlayersFile.readAsString();
    allPlayersData = json.decode(content);
    existingPlayers = Set<String>.from(allPlayersData['player_names'] ?? []);
    print('📋 ${existingPlayers.length} joueurs existants trouvés');
  } else {
    allPlayersData = {
      'generated_at': DateTime.now().toString().substring(0, 19),
      'total_players': 0,
      'source': 'Quiz data extraction',
      'player_names': []
    };
    print('📄 Création d\'un nouveau fichier all_player_names.json');
  }
  
  // Lire tous les fichiers de quiz dans le dossier data et data/v3
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
  
  Set<String> newPlayers = <String>{};
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
                if (playerName.isNotEmpty && !existingPlayers.contains(playerName)) {
                  newPlayers.add(playerName);
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
  
  if (newPlayers.isNotEmpty) {
    // Fusionner les anciens et nouveaux joueurs
    final allPlayers = <String>{};
    allPlayers.addAll(existingPlayers);
    allPlayers.addAll(newPlayers);
    
    // Trier alphabétiquement
    final sortedPlayers = allPlayers.toList()..sort();
    
    // Mettre à jour les données
    allPlayersData['generated_at'] = DateTime.now().toString().substring(0, 19);
    allPlayersData['total_players'] = sortedPlayers.length;
    allPlayersData['player_names'] = sortedPlayers;
    allPlayersData['last_quiz_scan'] = {
      'date': DateTime.now().toString().substring(0, 19),
      'files_processed': quizFiles.length,
      'total_quizzes': totalQuizzes,
      'new_players_added': newPlayers.length
    };
    
    // Sauvegarder le fichier mis à jour
    final encoder = JsonEncoder.withIndent('  ');
    await allPlayersFile.writeAsString(encoder.convert(allPlayersData));
    
    print('✅ ${newPlayers.length} nouveaux joueurs ajoutés');
    print('📊 Total: ${sortedPlayers.length} joueurs');
    print('📁 ${quizFiles.length} fichiers traités, ${totalQuizzes} quiz analysés');
  } else {
    print('✅ Aucun nouveau joueur trouvé');
    print('📊 Total: ${existingPlayers.length} joueurs déjà présents');
  }
  
  print('🎉 Mise à jour terminée!');
}