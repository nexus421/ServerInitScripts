#!/bin/bash

# Funktion zum Erstellen eines neuen Benutzers mit Passwort und optionalen sudo-Berechtigungen
create_user() {
    read -p "Geben Sie den Benutzernamen für den neuen Benutzer ein: " username

    # Überprüfen, ob der Benutzername bereits existiert
    if id "$username" >/dev/null 2>&1; then
        echo "Fehler: Der Benutzername existiert bereits." >&2
        exit 1
    fi

    read -s -p "Geben Sie ein Passwort für den Benutzer $username ein: " password
    echo

    read -s -p "Bestätigen Sie das Passwort für den Benutzer $username: " password_confirm
    echo

    # Überprüfen, ob das eingegebene Passwort übereinstimmt
    if [ "$password" != "$password_confirm" ]; then
        echo "Fehler: Die Passwörter stimmen nicht überein." >&2
        exit 1
    fi

    sudo adduser --disabled-password --gecos "" "$username"
    echo "$username:$password" | sudo chpasswd
    echo "Der Benutzer $username wurde erfolgreich erstellt."

    read -p "Soll der Benutzer $username sudo-Berechtigungen erhalten? (ja/nein): " sudo_access

    if [ "$sudo_access" = "ja" ]; then
        sudo usermod -aG sudo "$username"
        echo "Der Benutzer $username hat nun sudo-Berechtigungen."
    fi

    ./log.sh "Benutzer $username erstellt. Sudo: $sudo_access"
}

# Neue Benutzer erstellen
read -p "Möchten Sie neue Benutzer erstellen? (ja/nein): " create_users

if [ "$create_users" = "ja" ]; then
    while true; do
        create_user

        read -p "Möchten Sie einen weiteren Benutzer erstellen? (ja/nein): " continue_create

        if [ "$continue_create" != "ja" ]; then
            break
        fi
    done
fi
