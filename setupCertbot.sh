#!/bin/bash

# Funktion zum Installieren von Certbot
install_certbot() {
    echo "Installiere Certbot..."
    sudo apt update
    sudo apt install -y snapd
    sudo snap install -y core
    sudo snap refresh core
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
    echo "Certbot wurde erfolgreich installiert."
}

# Funktion zum Einrichten von Zertifikaten für Nginx
setup_nginx_certificates() {
    echo "Einrichten von Zertifikaten für Nginx..."
    sudo certbot --nginx
    echo "Die Zertifikate für Nginx wurden erfolgreich eingerichtet."
}

# Hauptskript
read -p "Möchten Sie Certbot installieren? (ja/nein): " install_certbot_choice

if [ "$install_certbot_choice" = "ja" ]; then
    install_certbot
else
    echo "Certbot wird nicht installiert."
fi


    read -p "Möchten Sie direkt Zertifikate für Nginx einrichten? (ja/nein): " setup_nginx_cert_choice
    if [ "$setup_nginx_cert_choice" = "ja" ]; then
        setup_nginx_certificates
    fi
