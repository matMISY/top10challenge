#!/bin/bash

# Script de release automatisé pour Top10Challenge
# Incrémente la version, build l'APK release et l'upload sur GitHub avec un tag

set -e  # Arrête le script en cas d'erreur

# Couleurs pour les logs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Démarrage du processus de release...${NC}"

# Vérifier que nous sommes sur la branche main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}❌ Erreur: Vous devez être sur la branche 'main' pour faire une release${NC}"
    exit 1
fi

# Vérifier que le working directory est propre
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}❌ Erreur: Le working directory n'est pas propre. Commitez vos changements avant de faire une release${NC}"
    exit 1
fi

# Récupérer la version actuelle depuis pubspec.yaml
CURRENT_VERSION=$(grep "^version:" pubspec.yaml | cut -d' ' -f2)
echo -e "${YELLOW}📋 Version actuelle: $CURRENT_VERSION${NC}"

# Extraire les composants de la version (ex: 1.0.1+2)
VERSION_NAME=$(echo $CURRENT_VERSION | cut -d'+' -f1)
BUILD_NUMBER=$(echo $CURRENT_VERSION | cut -d'+' -f2)

# Demander le type d'incrémentation
echo -e "${YELLOW}🔢 Quel type d'incrémentation souhaitez-vous?${NC}"
echo "1) Patch (ex: 1.0.1 -> 1.0.2)"
echo "2) Minor (ex: 1.0.1 -> 1.1.0)"
echo "3) Major (ex: 1.0.1 -> 2.0.0)"
echo "4) Build number seulement (ex: 1.0.1+2 -> 1.0.1+3)"
read -p "Votre choix (1-4): " CHOICE

# Incrémenter selon le choix
IFS='.' read -ra VERSION_PARTS <<< "$VERSION_NAME"
MAJOR=${VERSION_PARTS[0]}
MINOR=${VERSION_PARTS[1]}
PATCH=${VERSION_PARTS[2]}

case $CHOICE in
    1)
        PATCH=$((PATCH + 1))
        BUILD_NUMBER=$((BUILD_NUMBER + 1))
        ;;
    2)
        MINOR=$((MINOR + 1))
        PATCH=0
        BUILD_NUMBER=$((BUILD_NUMBER + 1))
        ;;
    3)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        BUILD_NUMBER=$((BUILD_NUMBER + 1))
        ;;
    4)
        BUILD_NUMBER=$((BUILD_NUMBER + 1))
        ;;
    *)
        echo -e "${RED}❌ Choix invalide${NC}"
        exit 1
        ;;
esac

NEW_VERSION_NAME="$MAJOR.$MINOR.$PATCH"
NEW_VERSION="$NEW_VERSION_NAME+$BUILD_NUMBER"

echo -e "${GREEN}✅ Nouvelle version: $NEW_VERSION${NC}"

# Confirmation
read -p "Voulez-vous continuer avec cette version? (y/N): " CONFIRM
if [[ $CONFIRM != "y" && $CONFIRM != "Y" ]]; then
    echo -e "${YELLOW}⏹️  Release annulée${NC}"
    exit 0
fi

# Mettre à jour pubspec.yaml
echo -e "${YELLOW}📝 Mise à jour de pubspec.yaml...${NC}"
sed -i "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml

# Créer un commit pour la nouvelle version
echo -e "${YELLOW}💾 Création du commit de version...${NC}"
git add pubspec.yaml
git commit -m "🔖 Bump version to $NEW_VERSION"

# Créer le tag
echo -e "${YELLOW}🏷️  Création du tag v$NEW_VERSION_NAME...${NC}"
git tag "v$NEW_VERSION_NAME"

# Pousser les changements et le tag
echo -e "${YELLOW}📤 Push des changements et du tag...${NC}"
git push origin main
git push origin "v$NEW_VERSION_NAME"

# Nettoyer les builds précédents
echo -e "${YELLOW}🧹 Nettoyage des builds précédents...${NC}"
flutter clean

# Récupérer les dépendances
echo -e "${YELLOW}📦 Installation des dépendances...${NC}"
flutter pub get

# Construire l'APK release
echo -e "${YELLOW}🏗️  Construction de l'APK release...${NC}"
flutter build apk --release

# Vérifier que l'APK a été créé
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ ! -f "$APK_PATH" ]; then
    echo -e "${RED}❌ Erreur: L'APK n'a pas été trouvé à $APK_PATH${NC}"
    exit 1
fi

# Renommer l'APK avec la version
NEW_APK_NAME="top10challenge-v$NEW_VERSION_NAME.apk"
cp "$APK_PATH" "release/$NEW_APK_NAME"

echo -e "${GREEN}✅ APK créé: release/$NEW_APK_NAME${NC}"

# Créer une release GitHub
echo -e "${YELLOW}🚀 Création de la release GitHub...${NC}"

# Générer les notes de release depuis les derniers commits
LAST_TAG=$(git describe --tags --abbrev=0 HEAD~1 2>/dev/null || echo "")
if [ -z "$LAST_TAG" ]; then
    RELEASE_NOTES="Première release de Top10Challenge"
else
    RELEASE_NOTES="## Changements depuis $LAST_TAG

$(git log --pretty=format:"- %s" $LAST_TAG..HEAD)

## Installation
Téléchargez et installez le fichier APK ci-dessous sur votre appareil Android."
fi

# Créer la release avec gh CLI
gh release create "v$NEW_VERSION_NAME" \
    "release/$NEW_APK_NAME" \
    --title "Top10Challenge v$NEW_VERSION_NAME" \
    --notes "$RELEASE_NOTES" \
    --latest

echo -e "${GREEN}🎉 Release v$NEW_VERSION_NAME créée avec succès!${NC}"
echo -e "${GREEN}📱 APK disponible: release/$NEW_APK_NAME${NC}"
echo -e "${GREEN}🌐 Release GitHub: https://github.com/$(gh repo view --json owner,name -q '.owner.login + "/" + .name')/releases/tag/v$NEW_VERSION_NAME${NC}"

echo -e "${GREEN}✨ Processus de release terminé avec succès! ✨${NC}"