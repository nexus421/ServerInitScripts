#!/bin/bash

# Funktion zum Installieren von UFW
install_ufw() {
    echo "Installiere UFW..."
    sudo apt update
    sudo apt install -y ufw
    echo "UFW wurde erfolgreich installiert."
}

# Funktion zum Ermitteln und Freigeben des aktuellen SSH-Ports
allow_ssh_port() {
    current_port_raw=$(sudo grep -E "^#?Port [0-9]+" /etc/ssh/sshd_config)
    current_ssh_port=$(echo "$current_port_raw" | grep -Eo "[0-9]+")

    if [[ -n $current_ssh_port ]]; then
        echo "Aktueller SSH-Port: $current_ssh_port"
        read -p "Möchten Sie den aktuellen SSH-Port ($current_ssh_port) freigeben? (ja/nein): " allow_ssh_choice
        if [ "$allow_ssh_choice" = "ja" ]; then
            sudo ufw allow $current_ssh_port
            ./log.sh "Der SSH-Port $current_ssh_port wurde freigegeben." 1
        fi
    else
        echo "Es wurde kein SSH-Port gefunden."
    fi
}

# Funktion zum Freigeben weiterer Ports
allow_additional_ports() {
    read -p "Möchten Sie weitere Ports freigeben? (ja/nein): " allow_additional_choice
    if [ "$allow_additional_choice" = "ja" ]; then
        while true; do
            read -p "Geben Sie den Port ein, den Sie freigeben möchten (oder 'fertig' zum Beenden): " port
            if [ "$port" = "fertig" ]; then
                break
            else
                sudo ufw allow $port/tcp
                ./log.sh "Der Port $port wurde für TCP freigegeben." 1
            fi
        done
    fi
}

# Hauptskript
read -p "Möchten Sie UFW installieren? (ja/nein): " install_ufw_choice

if [ "$install_ufw_choice" = "ja" ]; then
    install_ufw
else
    echo "UFW wird nicht installiert."
fi

if [ -x "$(command -v ufw)" ]; then
    allow_ssh_port
    allow_additional_ports
    sudo ufw enable
    sudo ufw reload
    echo "Enabled UFW."
else
    echo "UFW ist nicht installiert. Das Skript wird beendet."
fi
