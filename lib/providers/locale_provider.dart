import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  
  Locale _locale = const Locale('fr'); // Default to French
  
  Locale get locale => _locale;
  
  bool get isFrench => _locale.languageCode == 'fr';
  bool get isEnglish => _locale.languageCode == 'en';
  
  LocaleProvider() {
    _loadSavedLocale();
  }
  
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_localeKey) ?? 'fr';
      _locale = Locale(savedLocaleCode);
      notifyListeners();
    } catch (e) {
      // En cas d'erreur, garder le français par défaut
      _locale = const Locale('fr');
    }
  }
  
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      // En cas d'erreur de sauvegarde, continuer quand même
      debugPrint('Erreur lors de la sauvegarde de la locale: $e');
    }
  }
  
  Future<void> toggleLocale() async {
    final newLocale = _locale.languageCode == 'fr' 
        ? const Locale('en') 
        : const Locale('fr');
    await setLocale(newLocale);
  }
}