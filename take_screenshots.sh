#!/bin/bash

# Script pour prendre des captures d'écran iOS aux bonnes dimensions
DEVICE_ID="A562DB24-859C-4076-99EE-7B3C2D394782"
OUTPUT_DIR="/Users/eloijahan/Documents/projets perso/Pélerinage/P-l-MSM/screenshots/ios"

echo "📱 Prise de captures d'écran pour l'App Store..."
echo ""

# Fonction pour prendre une capture
take_screenshot() {
    local name=$1
    echo "📸 Capture: $name"
    xcrun simctl io $DEVICE_ID screenshot "$OUTPUT_DIR/$name.png"
    sleep 1
}

# Instructions interactives
echo "🎯 Instructions :"
echo "1. Navigue vers la page ACCUEIL et appuie sur ENTRÉE"
read -p ""
take_screenshot "01_accueil"

echo "2. Navigue vers PROGRAMME et appuie sur ENTRÉE"
read -p ""
take_screenshot "02_programme"

echo "3. Navigue vers CHANTS et appuie sur ENTRÉE"
read -p ""
take_screenshot "03_chants"

echo "4. Ouvre un CHANT et appuie sur ENTRÉE"
read -p ""
take_screenshot "04_chant_detail"

echo "5. Navigue vers MÉDITATIONS et appuie sur ENTRÉE"
read -p ""
take_screenshot "05_meditations"

echo ""
echo "✅ Captures terminées !"
echo "📁 Emplacement: $OUTPUT_DIR"
echo ""

# Vérifier les dimensions
echo "🔍 Vérification des dimensions..."
for img in "$OUTPUT_DIR"/*.png; do
    dims=$(sips -g pixelWidth -g pixelHeight "$img" | grep -E "pixelWidth|pixelHeight" | awk '{print $2}' | tr '\n' 'x' | sed 's/x$//')
    echo "$(basename "$img"): ${dims}px"
done
