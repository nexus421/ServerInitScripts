#!/bin/bash

# Überprüfen, ob der Text-Parameter vorhanden ist
if [ -z "$1" ]; then
    echo "Parameter required. Can't log nothing."
    exit 1
fi

# Text-Parameter speichern
text="$1"

# Überprüfen, ob der Ausgabe-Parameter vorhanden ist und einen gültigen Wert hat
if [ -n "$2" ] && { [ "$2" = "true" ] || [ "$2" = "1" ]; }; then
    echo "$text"
fi

# Datum und Uhrzeit im gewünschten Format speichern
timestamp=$(date +"%d.%m.%Y %H:%M")

# Dateiname
filename="creationScripts.log"

# Text an die Datei anhängen
echo "[$timestamp]: $text" >> "$filename"