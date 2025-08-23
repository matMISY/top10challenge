#!/bin/bash

# Script de build automatisé pour Play Store
# Usage: ./build-playstore.sh

set -e

echo "🚀 Build automatisé pour Play Store - Top10 Challenge"
echo "=================================================="

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifications préliminaires
log_info "Vérification des prérequis..."

if [ ! -f "android/key.properties" ]; then
    log_error "Fichier android/key.properties manquant!"
    exit 1
fi

if [ ! -f "android/app/upload-keystore.jks" ]; then
    log_error "Keystore upload-keystore.jks manquant!"
    exit 1
fi

log_info "Prérequis OK ✓"

# Nettoyage
log_info "Nettoyage des builds précédents..."
flutter clean
flutter pub get

# Génération des icônes et splash screens
log_info "Génération des assets..."
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create

# Build de l'APK signé
log_info "Build APK signé pour production..."
flutter build apk --release --target-platform android-arm,android-arm64,android-x64

# Build de l'App Bundle (recommandé pour Play Store)
log_info "Build App Bundle signé pour Play Store..."
flutter build appbundle --release

# Vérification des fichiers générés
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
AAB_PATH="build/app/outputs/bundle/release/app-release.aab"

if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(stat -f%z "$APK_PATH" 2>/dev/null || stat -c%s "$APK_PATH" 2>/dev/null)
    log_info "APK généré: $APK_PATH ($(echo $APK_SIZE | numfmt --to=iec-i)B)"
else
    log_warn "APK non trouvé à: $APK_PATH"
fi

if [ -f "$AAB_PATH" ]; then
    AAB_SIZE=$(stat -f%z "$AAB_PATH" 2>/dev/null || stat -c%s "$AAB_PATH" 2>/dev/null)
    log_info "App Bundle généré: $AAB_PATH ($(echo $AAB_SIZE | numfmt --to=iec-i)B)"
else
    log_warn "App Bundle non trouvé à: $AAB_PATH"
fi

# Copie vers le dossier release avec version
VERSION=$(grep "version:" pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
BUILD_NUMBER=$(grep "version:" pubspec.yaml | cut -d'+' -f2)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [ -f "$APK_PATH" ]; then
    cp "$APK_PATH" "release/top10challenge-v${VERSION}-${TIMESTAMP}.apk"
    log_info "APK copié vers: release/top10challenge-v${VERSION}-${TIMESTAMP}.apk"
fi

if [ -f "$AAB_PATH" ]; then
    cp "$AAB_PATH" "release/top10challenge-v${VERSION}-${TIMESTAMP}.aab"
    log_info "App Bundle copié vers: release/top10challenge-v${VERSION}-${TIMESTAMP}.aab"
fi

echo ""
log_info "🎉 Build terminé avec succès!"
echo "=================================================="
log_info "Version: $VERSION (build $BUILD_NUMBER)"
log_info "Fichiers prêts pour Play Store:"
if [ -f "$AAB_PATH" ]; then
    log_info "  📦 App Bundle: release/top10challenge-v${VERSION}-${TIMESTAMP}.aab"
fi
if [ -f "$APK_PATH" ]; then
    log_info "  📱 APK: release/top10challenge-v${VERSION}-${TIMESTAMP}.apk"
fi
log_info "  🖼️  Icône Play Store: assets/launcher_icons/android/playstore-icon.png"
log_info "  📝 Descriptions: playstore-metadata/"
echo ""
log_info "Prochaines étapes:"
log_info "1. Connectez-vous à Google Play Console"
log_info "2. Uploadez l'App Bundle (.aab)"
log_info "3. Complétez les métadonnées avec les fichiers dans playstore-metadata/"
log_info "4. Ajoutez des captures d'écran"
log_info "5. Soumettez pour révision"
echo ""