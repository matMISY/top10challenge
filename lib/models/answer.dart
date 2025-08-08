import 'package:flutter/material.dart';
import '../utils/country_flags.dart';

class Answer {
  final String name;
  final String nationality;
  final String hint;

  Answer({
    required this.name,
    required this.nationality,
    this.hint = '',
  });

  /// Retourne le widget drapeau correspondant à la nationalité
  Widget getFlagWidget({double size = 20}) => CountryFlags.getFlagWidget(nationality, size: size);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nationality': nationality,
      'hint': hint,
    };
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      name: json['name'],
      nationality: json['nationality'],
      hint: json['hint'] ?? '',
    );
  }

  /// Constructeur pour créer un Answer à partir d'un String simple
  /// (pour la compatibilité avec les niveaux existants)
  factory Answer.fromString(String name) {
    return Answer(
      name: name,
      nationality: '', // Pas de nationalité pour les anciens niveaux
      hint: '', // Pas d'indice pour les anciens niveaux
    );
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Answer && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}