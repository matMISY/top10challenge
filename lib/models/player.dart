import '../utils/string_utils.dart';

class Player {
  final String name;
  final String? nationality;
  final String? club;
  final String? position;
  final List<String> aliases;

  Player({
    required this.name,
    this.nationality,
    this.club,
    this.position,
    this.aliases = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nationality': nationality,
      'club': club,
      'position': position,
      'aliases': aliases,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'],
      nationality: json['nationality'],
      club: json['club'],
      position: json['position'],
      aliases: List<String>.from(json['aliases'] ?? []),
    );
  }

  bool matches(String input) {
    // Utiliser la normalisation qui supprime les accents
    if (StringUtils.matchesIgnoringAccents(name, input)) {
      return true;
    }
    
    return aliases.any((alias) => StringUtils.matchesIgnoringAccents(alias, input));
  }
}