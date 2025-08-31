import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/tier.dart';

extension TierLocalizations on Tier {
  /// Retourne le nom localisé du tier selon la langue actuelle.
  String getLocalizedName(BuildContext context) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations == null) {
        return name;
      }

      // Extraire le numéro du nom français "Palier X"
      final match = RegExp(r'Palier (\d+)').firstMatch(name);
      if (match != null) {
        final number = match.group(1);
        return localizations.tier(number!);
      }

      return name; // Fallback au nom français si pas de match
    } catch (e) {
      // En cas d'erreur, retourner le nom français
      return name;
    }
  }

  /// Retourne la description localisée du tier selon la langue actuelle.
  String getLocalizedDescription(BuildContext context) {
    try {
      final localizations = AppLocalizations.of(context);
      if (localizations == null) {
        return description;
      }

      // Mapper les descriptions françaises vers les clés de traduction
      switch (description) {
        case 'Niveaux faciles':
          return localizations.easyLevels;
        case 'Niveaux moyens':
          return localizations.mediumLevels;
        case 'Niveaux difficiles':
          return localizations.hardLevels;
        case 'Niveaux très difficiles':
          return localizations.veryHardLevels;
        default:
          return description; // Fallback à la description française
      }
    } catch (e) {
      // En cas d'erreur, retourner la description française
      return description;
    }
  }
}