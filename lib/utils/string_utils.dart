/// Utilitaires pour la manipulation des chaînes de caractères
class StringUtils {
  /// Normalise une chaîne en supprimant les accents et diacritiques
  static String normalizeString(String input) {
    if (input.isEmpty) return input;
    
    // Tableau de correspondance pour les caractères accentués
    const Map<String, String> accentMap = {
      // Lettres avec accents aigus
      'á': 'a', 'à': 'a', 'â': 'a', 'ä': 'a', 'ã': 'a', 'å': 'a',
      'Á': 'A', 'À': 'A', 'Â': 'A', 'Ä': 'A', 'Ã': 'A', 'Å': 'A',
      
      // Lettres E avec accents
      'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
      'É': 'E', 'È': 'E', 'Ê': 'E', 'Ë': 'E',
      
      // Lettres I avec accents
      'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
      'Í': 'I', 'Ì': 'I', 'Î': 'I', 'Ï': 'I',
      
      // Lettres O avec accents
      'ó': 'o', 'ò': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
      'Ó': 'O', 'Ò': 'O', 'Ô': 'O', 'Ö': 'O', 'Õ': 'O',
      
      // Lettres U avec accents
      'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
      'Ú': 'U', 'Ù': 'U', 'Û': 'U', 'Ü': 'U',
      
      // Autres caractères spéciaux
      'ñ': 'n', 'Ñ': 'N',
      'ç': 'c', 'Ç': 'C',
      'š': 's', 'Š': 'S',
      'ž': 'z', 'Ž': 'Z',
      'ý': 'y', 'Ý': 'Y',
      'ř': 'r', 'Ř': 'R',
      'č': 'c', 'Č': 'C',
      'ď': 'd', 'Ď': 'D',
      'ť': 't', 'Ť': 'T',
      'ľ': 'l', 'Ľ': 'L',
      'ň': 'n', 'Ň': 'N',
      
      // Caractères slaves
      'ć': 'c', 'Ć': 'C',
      'đ': 'd', 'Đ': 'D',
      'ł': 'l', 'Ł': 'L',
      'ś': 's', 'Ś': 'S',
      'ź': 'z', 'Ź': 'Z',
      'ż': 'z', 'Ż': 'Z',
    };
    
    String result = input;
    accentMap.forEach((accented, normal) {
      result = result.replaceAll(accented, normal);
    });
    
    return result.toLowerCase().trim();
  }
  
  /// Compare deux chaînes en ignorant les accents et la casse
  static bool matchesIgnoringAccents(String text1, String text2) {
    final normalized1 = normalizeString(text1);
    final normalized2 = normalizeString(text2);
    
    return normalized1.contains(normalized2) || normalized2.contains(normalized1);
  }
  
  /// Vérifie si une chaîne commence par une autre en ignorant les accents
  static bool startsWithIgnoringAccents(String text, String prefix) {
    final normalizedText = normalizeString(text);
    final normalizedPrefix = normalizeString(prefix);
    
    return normalizedText.startsWith(normalizedPrefix);
  }
}