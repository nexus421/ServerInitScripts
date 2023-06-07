#!/bin/bash

# Funktion zum Installieren von htop
install_htop() {
    echo "Installiere htop..."
    sudo apt update
    sudo apt install -y htop
    echo "htop wurde erfolgreich installiert."
}

# Hauptskript
read -p "Möchten Sie htop installieren? (ja/nein): " install_htop_choice

if [ "$install_htop_choice" = "ja" ]; then
    install_htop
else
    echo "htop wird nicht installiert."
fi
