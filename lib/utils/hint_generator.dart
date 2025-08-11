import '../models/answer.dart';

class HintGenerator {
  /// Génère le contenu de l'indice selon le niveau
  static HintData generateHint(Answer answer, int hintLevel) {
    switch (hintLevel) {
      case 1:
        return HintData(
          level: 1,
          hint: answer.hint.isEmpty ? _generateInitials(answer.name) : answer.hint,
          structure: null,
        );
      case 2:
        return HintData(
          level: 2,
          hint: answer.hint.isEmpty ? _generateInitials(answer.name) : answer.hint,
          structure: _generateNameStructure(answer.name),
        );
      case 3:
        return HintData(
          level: 3,
          hint: answer.hint.isEmpty ? _generateInitials(answer.name) : answer.hint,
          structure: _generatePartialLetters(answer.name),
        );
      default:
        return HintData(
          level: 0,
          hint: null,
          structure: null,
        );
    }
  }
  
  /// Génère les initiales d'un nom (ex: "Kylian Mbappé" -> "K.M.")
  static String _generateInitials(String name) {
    return name
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join('.');
  }
  
  /// Génère la structure du nom (underscores, plus compact)
  static String _generateNameStructure(String name) {
    return name.split('').map((char) {
      if (char == ' ' || char == '-' || char == '\'') {
        return char;
      }
      return '_';
    }).join(''); // Plus d'espace entre les caractères pour plus de compacité
  }
  
  /// Génère les lettres partielles (1 sur 3, première toujours visible)
  static String _generatePartialLetters(String name) {
    final result = StringBuffer();
    bool firstLetter = true;
    
    for (int i = 0; i < name.length; i++) {
      final char = name[i];
      
      // Conserver les espaces et caractères spéciaux
      if (char == ' ' || char == '-' || char == '\'') {
        result.write(char);
      } 
      // Toujours montrer la première lettre de chaque mot
      else if (firstLetter || i == 0 || name[i - 1] == ' ' || name[i - 1] == '-') {
        result.write(char);
        firstLetter = false;
      }
      // Montrer une lettre sur 3
      else if (i % 3 == 0) {
        result.write(char);
      }
      // Masquer les autres lettres
      else {
        result.write('_');
      }
      
      // Pas d'espacement supplémentaire pour plus de compacité
      // Les espaces naturels du nom sont conservés
    }
    
    return result.toString();
  }
  
  /// Retourne le texte du bouton selon le niveau actuel
  static String getButtonText(int currentLevel, int hintPoints, {bool isLevelCompleted = false}) {
    if (isLevelCompleted) {
      switch (currentLevel) {
        case 0:
          return '💡 Indice (gratuit)';
        case 1:
          return '💡 Plus d\'aide (gratuit)';
        case 2:
          return '💡 Encore plus (gratuit)';
        case 3:
          return 'Tous les indices utilisés';
        default:
          return '💡 Indice (gratuit)';
      }
    } else {
      switch (currentLevel) {
        case 0:
          return '💡 Indice (3 pts)';
        case 1:
          return '💡 Plus d\'aide (4 pts)';
        case 2:
          return '💡 Encore plus (5 pts)';
        case 3:
          return 'Tous les indices utilisés';
        default:
          return '💡 Indice';
      }
    }
  }
  
  /// Vérifie si le bouton d'indice doit être activé
  static bool canUseHint(int currentLevel, int hintPoints, {bool isLevelCompleted = false}) {
    if (currentLevel >= 3) return false;
    
    // Si le niveau est complété, les indices sont gratuits
    if (isLevelCompleted) return true;
    
    final costs = [3, 4, 5];
    final nextCost = costs[currentLevel];
    
    return hintPoints >= nextCost;
  }
}

/// Classe pour stocker les données d'indice
class HintData {
  final int level;
  final String? hint;
  final String? structure;
  
  HintData({
    required this.level,
    this.hint,
    this.structure,
  });
}