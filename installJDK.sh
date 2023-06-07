#!/bin/bash

# Funktion zum Installieren des JDK
install_jdk() {
    read -p "Welche JDK-Version möchten Sie installieren? (1-4):
    1. Amazon Corretto 17
    2. Amazon Corretto 11
    3. OpenJDK 17
    4. OpenJDK 18
    Ihre Auswahl: " jdk_choice

    case $jdk_choice in
        1)
            ./log.sh "Installiere Amazon Corretto 17..." 1
            wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - 
 	sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
	sudo apt-get update; sudo apt-get install -y java-17-amazon-corretto-jdk
            ;;
        2)
            ./log.sh "Installiere Amazon Corretto 11..." 1
wget -O- https://apt.corretto.aws/corretto.key | sudo apt-key add - 
 	sudo add-apt-repository 'deb https://apt.corretto.aws stable main'
            sudo apt-get update; sudo apt-get install -y java-11-amazon-corretto-jdk
            ;;
        3)
            ./log.sh "Installiere OpenJDK 17..." 1
            sudo apt update
            sudo apt install -y openjdk-17-jdk
            ;;
        4)
            ./log.sh "Installiere OpenJDK 18..." 1
            sudo apt update
            sudo apt install -y openjdk-18-jdk
            ;;
        *)
            echo "Ungültige Auswahl. Das Skript wird beendet."
            exit 1
            ;;
    esac

    ./log.sh "Das JDK wurde erfolgreich installiert." 1
}

if ! command -v java &> /dev/null; then
    echo "Java is not installed."
else
    # Get Java version
    java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

    if [[ -n "$java_version" ]]; then
        echo "Java version installed: $java_version"
    else
        echo "Unable to determine Java version."
    fi
fi

echo

# Hauptskript
read -p "Möchten Sie ein JDK installieren? (ja/nein): " install_jdk_choice

if [ "$install_jdk_choice" = "ja" ]; then
    install_jdk
    java -version
else
    echo "Das JDK wird nicht installiert."
fi
