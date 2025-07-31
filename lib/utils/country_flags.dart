import 'package:flutter/material.dart';
import 'package:flag/flag.dart';

class CountryFlags {
  static const Map<String, String> _countryToCode = {
    // Europe (English + French names)
    'france': 'FR',
    'spain': 'ES',
    'portugal': 'PT',
    'italy': 'IT',
    'germany': 'DE',
    'england': 'GB',
    'netherlands': 'NL',
    'belgium': 'BE',
    'croatia': 'HR',
    'sweden': 'SE',
    'norway': 'NO',
    'denmark': 'DK',
    'poland': 'PL',
    'pologne': 'PL',
    'czech republic': 'CZ',
    'tchéquie': 'CZ',
    'austria': 'AT',
    'autriche': 'AT',
    'switzerland': 'CH',
    'suisse': 'CH',
    'ukraine': 'UA',
    'serbia': 'RS',
    'serbie': 'RS',
    'bosnia and herzegovina': 'BA',
    'bosnie-herzégovine': 'BA',
    'hungary': 'HU',
    'hongrie': 'HU',
    'slovenia': 'SI',
    'slovénie': 'SI',
    'slovakia': 'SK',
    'greece': 'GR',
    'grèce': 'GR',
    'turkey': 'TR',
    'turquie': 'TR',
    'russia': 'RU',
    'georgia': 'GE',
    'wales': 'GB',
    'pays de galles': 'GB',
    'scotland': 'GB',
    'écosse': 'GB',
    'ireland': 'IE',
    'irlande': 'IE',
    'northern ireland': 'GB',
    'albania': 'AL',
    'albanie': 'AL',
    'armenia': 'AM',
    'arménie': 'AM',
    'iceland': 'IS',
    'islande': 'IS',
    'montenegro': 'ME',
    'monténégro': 'ME',
    'kosovo': 'XK',
    'north macedonia': 'MK',
    'macédoine du nord': 'MK',
    'danemark': 'DK',
    
    // Amérique du Sud
    'brazil': 'BR',
    'argentina': 'AR',
    'uruguay': 'UY',
    'colombia': 'CO',
    'chile': 'CL',
    'chili': 'CL',
    'peru': 'PE',
    'ecuador': 'EC',
    'venezuela': 'VE',
    'paraguay': 'PY',
    'bolivia': 'BO',
    
    // Amérique du Nord
    'united states': 'US',
    'usa': 'US',
    'états-unis': 'US',
    'mexico': 'MX',
    'mexique': 'MX',
    'canada': 'CA',
    
    // Afrique
    'morocco': 'MA',
    'algeria': 'DZ',
    'tunisia': 'TN',
    'egypt': 'EG',
    'senegal': 'SN',
    'nigeria': 'NG',
    'cameroon': 'CM',
    'ivory coast': 'CI',
    'ghana': 'GH',
    'south africa': 'ZA',
    'mali': 'ML',
    'burkina faso': 'BF',
    'democratic republic of congo': 'CD',
    'rd congo': 'CD',
    'congo': 'CG',
    'angola': 'AO',
    'kenya': 'KE',
    'gabon': 'GA',
    'guinea': 'GN',
    'guinée': 'GN',
    'sierra leone': 'SL',
    'benin': 'BJ',
    'bénin': 'BJ',
    'togo': 'TG',
    'cape verde': 'CV',
    'cap-vert': 'CV',
    'central african republic': 'CF',
    'république centrafricaine': 'CF',
    
    // Asie
    'japan': 'JP',
    'japon': 'JP',
    'south korea': 'KR',
    'china': 'CN',
    'iran': 'IR',
    'saudi arabia': 'SA',
    'qatar': 'QA',
    'united arab emirates': 'AE',
    'australia': 'AU',
    'new zealand': 'NZ',
    'nouvelle-zélande': 'NZ',
    'india': 'IN',
    'thailand': 'TH',
    'vietnam': 'VN',
    'philippines': 'PH',
    'indonesia': 'ID',
    'malaysia': 'MY',
    'singapore': 'SG',
    'uzbekistan': 'UZ',
    
    // Amérique Centrale et Caraïbes
    'israel': 'IL',
    'lebanon': 'LB',
    'jamaica': 'JM',
    'jamaïque': 'JM',
    'costa rica': 'CR',
    'panama': 'PA',
    'honduras': 'HN',
    'guatemala': 'GT',
    'el salvador': 'SV',
    'nicaragua': 'NI',
    'dominican republic': 'DO',
    'république dominicaine': 'DO',
    'trinidad and tobago': 'TT',
    'trinité-et-tobago': 'TT',
    'martinique': 'MQ',
  };

  /// Retourne un widget drapeau pour un pays donné
  /// Exemple: 'france' → Widget avec drapeau français
  static Widget getFlagWidget(String country, {double size = 20}) {
    final normalizedCountry = country.toLowerCase().trim();
    
    // Cas spéciaux pour les nations du Royaume-Uni avec drapeaux personnalisés
    if (normalizedCountry == 'england') {
      return Container(
        width: size,
        height: size * 0.67,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: CustomPaint(
          painter: EnglandFlagPainter(),
          size: Size(size, size * 0.67),
        ),
      );
    }
    
    if (normalizedCountry == 'scotland' || normalizedCountry == 'écosse') {
      return Container(
        width: size,
        height: size * 0.67,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: CustomPaint(
          painter: ScotlandFlagPainter(),
          size: Size(size, size * 0.67),
        ),
      );
    }
    
    if (normalizedCountry == 'wales' || normalizedCountry == 'pays de galles') {
      return Container(
        width: size,
        height: size * 0.67,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),
        child: CustomPaint(
          painter: WalesFlagPainter(),
          size: Size(size, size * 0.67),
        ),
      );
    }
    
    final countryCode = _countryToCode[normalizedCountry];
    
    if (countryCode == null) {
      return Container(
        width: size,
        height: size * 0.67, // Ratio standard des drapeaux
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Icon(Icons.flag, size: 12, color: Colors.grey),
      );
    }
    
    return Flag.fromString(
      countryCode,
      height: size * 0.67,
      width: size,
      fit: BoxFit.cover,
    );
  }

  /// Vérifie si un pays est supporté
  static bool isSupported(String country) {
    final normalizedCountry = country.toLowerCase().trim();
    return _countryToCode.containsKey(normalizedCountry);
  }

  /// Retourne la liste de tous les pays supportés
  static List<String> getSupportedCountries() {
    return _countryToCode.keys.toList();
  }
}

/// Peintre pour le drapeau de l'Angleterre (croix de Saint-Georges)
class EnglandFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Fond blanc
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Croix rouge
    paint.color = const Color(0xFFCE1124);
    final crossWidth = size.height * 0.2;
    
    // Barre horizontale
    canvas.drawRect(
      Rect.fromLTWH(0, (size.height - crossWidth) / 2, size.width, crossWidth),
      paint,
    );
    
    // Barre verticale
    canvas.drawRect(
      Rect.fromLTWH((size.width - crossWidth) / 2, 0, crossWidth, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Peintre pour le drapeau de l'Écosse (croix de Saint-André)
class ScotlandFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Fond bleu
    paint.color = const Color(0xFF005EB8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    
    // Croix blanche en diagonale
    paint.color = Colors.white;
    paint.strokeWidth = size.height * 0.15;
    
    // Diagonale de haut-gauche à bas-droite
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );
    
    // Diagonale de haut-droite à bas-gauche
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Peintre pour le drapeau du Pays de Galles (dragon rouge)
class WalesFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Fond vert (moitié inférieure)
    paint.color = const Color(0xFF00B04F);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2),
      paint,
    );
    
    // Fond blanc (moitié supérieure)
    paint.color = Colors.white;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height / 2),
      paint,
    );
    
    // Dragon rouge simplifié (cercle rouge au centre)
    paint.color = const Color(0xFFCE1124);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height * 0.15,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}