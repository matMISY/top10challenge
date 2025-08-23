#!/usr/bin/env python3
"""
Script ultime pour corriger les dernières incohérences identifiées manuellement.
"""

import json
import re
from pathlib import Path

def ultimate_translation_fix():
    """Corrige les dernières incohérences identifiées manuellement."""
    
    base_dir = Path(__file__).parent.parent
    en_arb_path = base_dir / "lib/l10n/app_en.arb"
    
    with open(en_arb_path, 'r', encoding='utf-8') as f:
        en_arb = json.load(f)
    
    corrections = 0
    
    for key, value in en_arb.items():
        if key.startswith('quizTitle_'):
            original = value
            
            # 1. Corriger les structures "players with most minutes for X in Y"
            value = re.sub(r'players with most minutes for ([^i\s]+) in (\d{4})', r'\1 players with most minutes in \2', value)
            
            # 2. Corriger "Liga " sans "La" dans certains contextes
            if 'Liga scorers' in value and 'La Liga scorers' not in value:
                value = value.replace('Liga scorers', 'La Liga scorers')
                
            # Si des corrections ont été faites
            if value != original:
                en_arb[key] = value
                corrections += 1
                print(f"Corrigé: {key}")
                print(f"  Avant: {original}")
                print(f"  Après: {value}")
                print()
    
    # Sauvegarder
    with open(en_arb_path, 'w', encoding='utf-8') as f:
        json.dump(en_arb, f, ensure_ascii=False, indent=2)
    
    print(f"✅ {corrections} traductions ultimes corrigées")
    return corrections

if __name__ == "__main__":
    ultimate_translation_fix()