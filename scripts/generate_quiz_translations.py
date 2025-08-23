#!/usr/bin/env python3
"""
Script intelligent pour générer automatiquement les clés et traductions
des titres de quiz depuis les fichiers JSON.
"""

import json
import re
import os
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Set
from slugify import slugify
import unicodedata

class QuizTranslationGenerator:
    def __init__(self, data_dir: str = "data", output_dir: str = "translations"):
        self.data_dir = Path(data_dir)
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True)
        
        # Dictionnaire de traductions pour les mots/expressions courantes
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
    
    def clean_key(self, text: str) -> str:
        """Convertit un texte en clé utilisable pour les traductions."""
        # Supprimer les accents
        text = unicodedata.normalize('NFD', text)
        text = ''.join(char for char in text if unicodedata.category(char) != 'Mn')
        
        # Remplacer certains caractères spéciaux
        text = text.replace("'", "").replace("'", "")
        text = re.sub(r'[^\w\s-]', '', text)
        text = re.sub(r'[-\s]+', '_', text)
        
        # Utiliser slugify pour une clé propre
        return slugify(text, separator='_').lower()
    
    def translate_word(self, word: str) -> str:
        """Traduit un mot français vers l'anglais."""
        word_lower = word.lower()
        if word_lower in self.translations:
            return self.translations[word_lower]
        
        # Essayer de traduire les équipes/ligues directement
        if word in self.translations:
            return self.translations[word]
            
        return word
    
    def translate_title(self, french_title: str) -> str:
        """Traduit un titre français vers l'anglais en utilisant les patterns et dictionnaire."""
        
        # Essayer les patterns spécialisés d'abord
        for pattern, template in self.patterns:
            match = re.match(pattern, french_title)
            if match:
                groups = match.groups()
                # Créer un dictionnaire de remplacement basé sur le template
                placeholders = re.findall(r'\{(\w+)\}', template)
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
                            # Traduire "buts+passes" en "goals+assists"
                            value = value.replace('buts', 'goals').replace('passes', 'assists')
                        elif placeholder == 'rest':
                            # Traduire le reste mot par mot
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
        translated_words = []
        
        for word in words:
            translated_words.append(self.translate_word(word))
        
        return ' '.join(translated_words)
    
    def generate_key(self, title: str, quiz_id: int = None) -> str:
        """Génère une clé unique pour un titre."""
        base_key = self.clean_key(title)
        
        # Raccourcir certaines clés longues communes
        base_key = base_key.replace('top_10_des_', 'quiz_')
        base_key = base_key.replace('top_10_du_', 'quiz_')
        base_key = base_key.replace('top_10_', 'quiz_')
        base_key = base_key.replace('ballon_d_or', 'ballondor')
        base_key = base_key.replace('dans_les_grands_clubs_europeens', 'bigclubs')
        base_key = base_key.replace('les_plus_couteux', 'expensive')
        base_key = base_key.replace('les_plus_prolifiques', 'prolific')
        
        # Limiter la longueur
        if len(base_key) > 50:
            parts = base_key.split('_')
            if len(parts) > 6:
                base_key = '_'.join(parts[:6])
        
        return f"quizTitle_{base_key}"
    
    def extract_all_titles(self) -> Dict[str, Tuple[str, str]]:
        """Extrait tous les titres des fichiers JSON et génère les traductions."""
        all_titles = {}
        
        json_files = list(self.data_dir.glob("*.json"))
        json_files.extend(list(self.data_dir.glob("**/*.json")))
        
        for json_file in json_files:
            if json_file.name.startswith('quiz_') and json_file.suffix == '.json':
                try:
                    with open(json_file, 'r', encoding='utf-8') as f:
                        data = json.load(f)
                    
                    quizzes = data.get('quizzes', [])
                    for quiz in quizzes:
                        title = quiz.get('title', '')
                        if title and title not in all_titles:
                            key = self.generate_key(title, quiz.get('id'))
                            translation = self.translate_title(title)
                            all_titles[title] = (key, translation)
                            
                except Exception as e:
                    print(f"Erreur lors de la lecture de {json_file}: {e}")
        
        return all_titles
    
    def generate_arb_entries(self, titles_data: Dict[str, Tuple[str, str]]) -> Tuple[Dict[str, str], Dict[str, str]]:
        """Génère les entrées pour les fichiers .arb français et anglais."""
        fr_entries = {}
        en_entries = {}
        
        for french_title, (key, english_title) in titles_data.items():
            fr_entries[key] = french_title
            en_entries[key] = english_title
        
        return fr_entries, en_entries
    
    def save_translations(self, fr_entries: Dict[str, str], en_entries: Dict[str, str]):
        """Sauvegarde les traductions dans des fichiers."""
        
        # Sauvegarder en JSON pour inspection
        with open(self.output_dir / "quiz_titles_fr.json", 'w', encoding='utf-8') as f:
            json.dump(fr_entries, f, ensure_ascii=False, indent=2)
        
        with open(self.output_dir / "quiz_titles_en.json", 'w', encoding='utf-8') as f:
            json.dump(en_entries, f, ensure_ascii=False, indent=2)
        
        # Sauvegarder au format .arb
        with open(self.output_dir / "quiz_titles_fr.arb", 'w', encoding='utf-8') as f:
            json.dump(fr_entries, f, ensure_ascii=False, indent=2)
        
        with open(self.output_dir / "quiz_titles_en.arb", 'w', encoding='utf-8') as f:
            json.dump(en_entries, f, ensure_ascii=False, indent=2)
    
    def run(self):
        """Exécute le processus complet de génération."""
        print("🔍 Extraction des titres depuis les fichiers JSON...")
        titles_data = self.extract_all_titles()
        
        print(f"📊 {len(titles_data)} titres uniques trouvés")
        
        print("🌐 Génération des traductions...")
        fr_entries, en_entries = self.generate_arb_entries(titles_data)
        
        print("💾 Sauvegarde des fichiers de traduction...")
        self.save_translations(fr_entries, en_entries)
        
        print(f"✅ Fichiers générés dans {self.output_dir}/")
        print("   - quiz_titles_fr.json/arb (français)")
        print("   - quiz_titles_en.json/arb (anglais)")
        
        # Afficher quelques exemples
        print("\n📝 Exemples de traductions générées:")
        for i, (french_title, (key, english_title)) in enumerate(list(titles_data.items())[:10]):
            print(f"   {key}: '{french_title}' → '{english_title}'")
        
        if len(titles_data) > 10:
            print(f"   ... et {len(titles_data) - 10} autres")

if __name__ == "__main__":
    try:
        generator = QuizTranslationGenerator()
        generator.run()
    except ImportError as e:
        print("❌ Module manquant. Installez python-slugify:")
        print("   pip install python-slugify")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Erreur: {e}")
        sys.exit(1)