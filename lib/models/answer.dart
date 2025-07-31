import 'package:flutter/material.dart';
import '../utils/country_flags.dart';

class Answer {
  final String name;
  final String nationality;

  Answer({
    required this.name,
    required this.nationality,
  });

  /// Retourne le widget drapeau correspondant à la nationalité
  Widget getFlagWidget({double size = 20}) => CountryFlags.getFlagWidget(nationality, size: size);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nationality': nationality,
    };
  }

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      name: json['name'],
      nationality: json['nationality'],
    );
  }

  /// Constructeur pour créer un Answer à partir d'un String simple
  /// (pour la compatibilité avec les niveaux existants)
  factory Answer.fromString(String name) {
    return Answer(
      name: name,
      nationality: '', // Pas de nationalité pour les anciens niveaux
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