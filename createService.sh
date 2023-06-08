#!/bin/bash

# Funktion zum Erstellen eines Systemd-Service
create_systemd_service() {
    read -p "Geben Sie den Namen des Programms ein: " program_name
    read -p "Geben Sie den Pfad zur ausführbaren Datei des Programms ein: " program_path

    service_content="[Unit]
Description=Service for $program_name
After=network.target

[Service]
ExecStart=$program_path
Restart=always
RestartSec=3
User=$USER

[Install]
WantedBy=default.target"

    # Service-Datei erstellen
    sudo echo "$service_content" > "/etc/systemd/system/$program_name.service"

    # Systemd neu laden und Service aktivieren
    sudo systemctl daemon-reload
    sudo systemctl enable $program_name.service
    sudo systemctl start $program_name.service

    ./log.sh "Der Service $program_name wurde erfolgreich erstellt und aktiviert unter /etc/systemd/system/$program_name.service." 1

    echo "Erstelle Service-Skript..."
    create_service_script "$program_name.service"
}

create_service_script() {
    service_name=$1

    echo "#!/bin/bash" > "service_options_$service_name.sh"
    echo "" >> "service_options_$service_name.sh"
    echo "case \$1 in" >> "service_options_$service_name.sh"
    echo "    start)" >> "service_options_$service_name.sh"
    echo "        sudo service $service_name start" >> "service_options_$service_name.sh"
    echo "        ;;" >> "service_options_$service_name.sh"
    echo "    stop)" >> "service_options_$service_name.sh"
    echo "        sudo service $service_name stop" >> "service_options_$service_name.sh"
    echo "        ;;" >> "service_options_$service_name.sh"
    echo "    restart)" >> "service_options_$service_name.sh"
    echo "        sudo service $service_name restart" >> "service_options_$service_name.sh"
    echo "        ;;" >> "service_options_$service_name.sh"
    echo "    status)" >> "service_options_$service_name.sh"
    echo "        sudo service $service_name status" >> "service_options_$service_name.sh"
    echo "        ;;" >> "service_options_$service_name.sh"
    echo "    *)" >> "service_options_$service_name.sh"
    echo "        echo \"Ungültige Option: \$1\"" >> "service_options_$service_name.sh"
    echo "        exit 1" >> "service_options_$service_name.sh"
    echo "        ;;" >> "service_options_$service_name.sh"
    echo "esac" >> "service_options_$service_name.sh"

    chmod +x "service_options_$service_name.sh"
    ./log.sh "Service-Skript service_options_$service_name.sh erstellt." 1
}

# Hauptskript
read -p "Möchten Sie einen Systemd-Service erstellen? (ja/nein): " create_service_choice

if [ "$create_service_choice" = "ja" ]; then
    create_systemd_service
else
    echo "Es wird kein Systemd-Service erstellt."
fi
