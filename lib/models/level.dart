import 'answer.dart';

class Level {
  final int id;
  final String title;
  final String hint;
  final String category;
  final List<Answer> answers;
  final int difficulty;
  final bool isUnlocked;
  final bool isCompleted;

  Level({
    required this.id,
    required this.title,
    required this.hint,
    required this.category,
    required this.answers,
    required this.difficulty,
    this.isUnlocked = false,
    this.isCompleted = false,
  });

  /// Retourne les noms des réponses sous forme de liste de String
  /// (pour la compatibilité avec le code existant)
  List<String> get answerNames => answers.map((answer) => answer.name).toList();

  Level copyWith({
    int? id,
    String? title,
    String? hint,
    String? category,
    List<Answer>? answers,
    int? difficulty,
    bool? isUnlocked,
    bool? isCompleted,
  }) {
    return Level(
      id: id ?? this.id,
      title: title ?? this.title,
      hint: hint ?? this.hint,
      category: category ?? this.category,
      answers: answers ?? this.answers,
      difficulty: difficulty ?? this.difficulty,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hint': hint,
      'category': category,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'difficulty': difficulty,
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
    };
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    final answersJson = json['answers'] as List<dynamic>;
    List<Answer> parsedAnswers;
    
    // Vérifier si les réponses sont des objets ou des strings
    if (answersJson.isNotEmpty && answersJson.first is Map<String, dynamic>) {
      // Nouveau format: objets avec name et nationality
      parsedAnswers = answersJson
          .map((answerJson) => Answer.fromJson(answerJson as Map<String, dynamic>))
          .toList();
    } else {
      // Ancien format: liste de strings
      parsedAnswers = answersJson
          .map((answerString) => Answer.fromString(answerString as String))
          .toList();
    }
    
    return Level(
      id: json['id'],
      title: json['title'],
      hint: json['hint'],
      category: json['category'],
      answers: parsedAnswers,
      difficulty: json['difficulty'],
      isUnlocked: json['isUnlocked'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}