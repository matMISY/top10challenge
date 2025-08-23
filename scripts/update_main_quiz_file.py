#!/usr/bin/env python3
"""
Script pour ajouter les titleKey au fichier principal quiz_custom_order.json
et regénérer toutes les traductions manquantes.
"""

import json
import re
import unicodedata
from pathlib import Path
from slugify import slugify

class MainQuizUpdater:
    def __init__(self, data_dir: str = "data"):
        self.data_dir = Path(data_dir)
        self.main_file = self.data_dir / "quiz_custom_order.json"
        
        # Même système de génération de clés que dans le DataLoaderService
        self.translations = {
            # Structure
            "TOP 10": "TOP 10",
            "du": "of",
            "de": "of",
            "des": "of",
            "les": "the",
            "le": "the", 
            "la": "the",
            "en": "in",
            "dans": "in",
            "par": "by",
            "et": "and",
            "plus": "most",
            "moins": "least",
            
            # Ballon d'Or
            "Ballon d'Or": "Ballon d'Or",
            
            # Positions/Rôles
            "buteurs": "scorers",
            "buteur": "scorer",
            "passeurs": "assist providers", 
            "passeur": "assist provider",
            "gardiens": "goalkeepers",
            "gardien": "goalkeeper",
            "défenseurs": "defenders",
            "défenseur": "defender",
            "milieux": "midfielders",
            "milieu": "midfielder",
            "attaquants": "forwards",
            "attaquant": "forward",
            "joueurs": "players",
            "joueur": "player",
            
            # Statistiques
            "prolifiques": "prolific",
            "buts": "goals",
            "passes": "assists",
            "minutes": "minutes",
            "ratio": "ratio",
            "jeunes": "young",
            "prodiges": "prodigies",
            
            # Compétitions
            "Coupe du Monde": "World Cup",
            "Euro": "Euro",
            "Premier League": "Premier League",
            "Liga": "La Liga",
            "Ligue 1": "Ligue 1",
            "Serie A": "Serie A",
            "Bundesliga": "Bundesliga",
            "Champions League": "Champions League",
            "Ligue des Champions": "Champions League",
            
            # Clubs
            "grands clubs": "big clubs",
            "européens": "European",
            "européennes": "European",
            
            # Transferts
            "transferts": "transfers",
            "transfert": "transfer",
            "coûteux": "expensive",
            "sortants": "outgoing",
            "entrants": "incoming",
            
            # Nationalités communes
            "france": "French",
            "portugal": "Portuguese",
            "espagne": "Spanish",
            "italie": "Italian",
            "allemagne": "German",
            "angleterre": "English",
            "brésil": "Brazilian",
            "argentine": "Argentinian",
            
            # Équipes communes
            "Arsenal": "Arsenal",
            "Barcelona": "Barcelona",
            "Bayern Munich": "Bayern Munich",
            "Chelsea": "Chelsea",
            "Inter Milan": "Inter Milan",
            "Liverpool": "Liverpool",
            "Man City": "Man City",
            "Man Utd": "Man United",
            "PSG": "PSG",
            "Real Madrid": "Real Madrid",
        }
        
        # Patterns de reconnaissance
        self.patterns = [
            # Ballon d'Or
            (r"TOP 10 du Ballon d'Or (\d{4})", "TOP 10 Ballon d'Or {year}"),
            
            # Buteurs par compétition/ligue
            (r"TOP 10 des buteurs de (.+?) en (\d{4})", "TOP 10 {competition} scorers in {year}"),
            (r"TOP 10 des buteurs (.+?) dans les grands clubs européens en (.+)", "TOP 10 {nationality} scorers in European big clubs in {period}"),
            (r"TOP 10 des buteurs de (.+)", "TOP 10 {competition} scorers"),
            
            # Passeurs
            (r"TOP 10 des passeurs de (.+?) en (.+)", "TOP 10 {competition} assist providers in {period}"),
            (r"TOP 10 des passeurs de (.+)", "TOP 10 {team} assist providers"),
            
            # Transferts
            (r"TOP 10 des transferts les plus coûteux (.+?) en (.+?) \((.+?)\)", "TOP 10 most expensive {type} transfers in {period} ({league})"),
            (r"TOP 10 des transferts les plus coûteux en (.+?) \((.+?)\)", "TOP 10 most expensive transfers in {year} ({league})"),
            
            # Joueurs prolifiques
            (r"TOP 10 des joueurs (.+?) les plus prolifiques \((.+?)\) en (.+)", "TOP 10 most prolific {nationality} players ({stats}) in {period}"),
            
            # Autres
            (r"TOP 10 (.+)", "TOP 10 {rest}"),
        ]

    def generate_title_key(self, title: str) -> str:
        """Génère une clé de traduction à partir d'un titre français (même logique que DataLoaderService)."""
        # Supprimer les accents et caractères spéciaux
        key = title.lower()
        key = re.sub(r'[àáâãäå]', 'a', key)
        key = re.sub(r'[èéêë]', 'e', key)
        key = re.sub(r'[ìíîï]', 'i', key)
        key = re.sub(r'[òóôõö]', 'o', key)
        key = re.sub(r'[ùúûü]', 'u', key)
        key = re.sub(r'[ç]', 'c', key)
        key = re.sub(r'[ñ]', 'n', key)
        key = re.sub(r'[^a-z0-9\\s]', '', key)  # Supprimer tout sauf lettres, chiffres et espaces
        key = re.sub(r'\\s+', '_', key)  # Remplacer espaces par underscore
        key = re.sub(r'^top_10_des?_', 'quiz_', key)  # Raccourcir
        key = re.sub(r'^top_10_du_', 'quiz_', key)
        key = key.replace('ballon_d_or', 'ballondor')
        key = key.replace('dans_les_grands_clubs_europeens', 'bigclubs')
        key = key.replace('les_plus_couteux', 'expensive')
        key = key.replace('les_plus_prolifiques', 'prolific')
        
        # Limiter la longueur en gardant les parties importantes
        parts = key.split('_')
        if len(parts) > 8:
            key = '_'.join(parts[:8])
        
        return f'quizTitle_{key}'

    def translate_title(self, french_title: str) -> str:
        """Traduit un titre français vers l'anglais."""
        # Essayer les patterns spécialisés d'abord
        for pattern, template in self.patterns:
            match = re.match(pattern, french_title)
            if match:
                groups = match.groups()
                placeholders = re.findall(r'\\{(\\w+)\\}', template)
                replacements = {}
                
                for i, placeholder in enumerate(placeholders):
                    if i < len(groups):
                        value = groups[i]
                        
                        # Traductions spéciales par type de placeholder
                        if placeholder in ['competition', 'league', 'team']:
                            value = self.translate_word(value)
                        elif placeholder == 'nationality':
                            value = self.translate_word(value.lower())
                        elif placeholder == 'type':
                            if 'sortants' in value:
                                value = 'outgoing'
                            elif 'entrants' in value:
                                value = 'incoming'
                            else:
                                value = self.translate_word(value)
                        elif placeholder == 'stats':
                            value = value.replace('buts', 'goals').replace('passes', 'assists')
                        elif placeholder == 'rest':
                            words = value.split()
                            translated_words = [self.translate_word(word) for word in words]
                            value = ' '.join(translated_words)
                        
                        replacements[placeholder] = value
                
                # Appliquer les remplacements
                result = template
                for placeholder, value in replacements.items():
                    result = result.replace(f'{{{placeholder}}}', value)
                
                return result
        
        # Traduction mot par mot si aucun pattern ne correspond
        words = french_title.split()
        translated_words = [self.translate_word(word) for word in words]
        return ' '.join(translated_words)

    def translate_word(self, word: str) -> str:
        """Traduit un mot français vers l'anglais."""
        word_lower = word.lower()
        if word_lower in self.translations:
            return self.translations[word_lower]
        
        if word in self.translations:
            return self.translations[word]
            
        return word

    def update_main_file(self):
        """Ajoute les titleKey au fichier principal et sauvegarde."""
        print("🔄 Chargement du fichier principal...")
        
        with open(self.main_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        print(f"📊 {data['total_quizzes']} quiz trouvés")
        
        # Traiter chaque quiz
        updated_count = 0
        new_translations = {}
        
        for i, quiz in enumerate(data['quizzes']):
            title = quiz['title']
            
            # Générer la titleKey
            title_key = self.generate_title_key(title)
            quiz['titleKey'] = title_key
            
            # Générer la traduction anglaise
            english_title = self.translate_title(title)
            new_translations[title_key] = {
                'fr': title,
                'en': english_title
            }
            
            updated_count += 1
            
            if i % 50 == 0:
                print(f"   Traité {i}/{data['total_quizzes']} quiz...")
        
        print(f"✅ {updated_count} quiz mis à jour avec titleKey")
        
        # Sauvegarder le fichier principal mis à jour
        with open(self.main_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"💾 Fichier principal sauvegardé: {self.main_file}")
        
        # Sauvegarder les nouvelles traductions
        translations_dir = Path("translations")
        translations_dir.mkdir(exist_ok=True)
        
        fr_translations = {k: v['fr'] for k, v in new_translations.items()}
        en_translations = {k: v['en'] for k, v in new_translations.items()}
        
        with open(translations_dir / "quiz_titles_main_fr.json", 'w', encoding='utf-8') as f:
            json.dump(fr_translations, f, ensure_ascii=False, indent=2)
        
        with open(translations_dir / "quiz_titles_main_en.json", 'w', encoding='utf-8') as f:
            json.dump(en_translations, f, ensure_ascii=False, indent=2)
        
        print(f"📁 Nouvelles traductions sauvegardées:")
        print(f"   - {len(fr_translations)} traductions françaises")
        print(f"   - {len(en_translations)} traductions anglaises")
        
        # Afficher quelques exemples
        print("\\n📝 Exemples de traductions générées:")
        for i, (key, trans) in enumerate(list(new_translations.items())[:5]):
            print(f"   {key}: '{trans['fr']}' → '{trans['en']}'")
        
        return updated_count, new_translations

if __name__ == "__main__":
    try:
        updater = MainQuizUpdater()
        count, translations = updater.update_main_file()
        print(f"\\n🎉 Mise à jour terminée ! {count} quiz traités.")
    except Exception as e:
        print(f"❌ Erreur: {e}")