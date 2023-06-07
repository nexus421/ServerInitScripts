#!/bin/bash

# Funktion zum Installieren von Nginx
install_nginx() {
    echo "Installiere Nginx..."
    sudo apt update
    sudo apt install -y nginx
    echo "Nginx wurde erfolgreich installiert."
}

# Funktion zum Einrichten des Proxys
setup_proxy() {
    echo "Hiermit kann die Weiterleitung von einer Domain auf einen (lokalen) Webser eingerichtet werden. Diese kann später mittels Certbot auch abgesichert werden."
    read -p "Servernamen/Domain (example.com): " server_name
    read -p "Ziel für den Proxy-Pass (http://localhost:1234): " proxy_pass_target

    # Proxy-Konfiguration erstellen
    proxy_config="
    server {
        server_name $server_name;

        location / {
            proxy_pass $proxy_pass_target;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
        }
    }"

    # Konfigurationsdatei für den neuen Server aktualisieren
    #sudo sed -i "/# Default server configuration/ a $proxy_config" /etc/nginx/nginx.conf
    echo "$proxy_config" | sudo tee -a "/etc/nginx/$server_name" >/dev/null
    ./log.sh "Proxy zu Nginx hinzugefügt. Domain = $server_name, Ziel = $proxy_pass_target, at /etc/nginx/$server_name" 1
    echo "Nginx wird nun neu gestartet."
    sudo nginx -t
    sudo service restart nginx
}

# Hauptskript
read -p "Möchten Sie Nginx installieren? (ja/nein): " install_nginx_choice

if [ "$install_nginx_choice" = "ja" ]; then
    install_nginx
else
    echo "Nginx wird nicht installiert."
fi

if [ -x "$(command -v nginx)" ]; then
    read -p "Möchten Sie einen Proxy einrichten? (ja/nein): " setup_proxy_choice
    if [ "$setup_proxy_choice" = "ja" ]; then
        setup_proxy
    fi
else
    echo "Nginx ist nicht installiert. Das Skript wird beendet."
fi
