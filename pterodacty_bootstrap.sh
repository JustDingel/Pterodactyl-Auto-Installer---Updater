#!/bin/bash

VERSION="0.0.1"

# Github-URL zu den Skripten
BASE_URL="https://raw.githubusercontent.com/JustDingel/Pterodactyl-Auto-Installer---Updater/dev"
BASE_DIR="./Pterodactyl_Installer"

# Farben definieren
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color

# Funktion zum Herunterladen einer Datei mit Fortschrittsbalken
download_with_progress() {
    url=$1
    destination=$2
    description=$3

    dialog --title "Downloading $description" --gauge "Please wait..." 8 50 < <(
        curl -# -o "$destination" "$url" 2>&1 | 
        awk '{print int($1/($1+$2) * 100)}' 
    )
}

# Funktion zum Anzeigen einer Fehlermeldung
show_error() {
    dialog --title "Error" --msgbox "$1" 8 40
}

# Funktion zum Anzeigen einer Bestätigung
show_message() {
    dialog --title "Message" --msgbox "$1" 8 40
}

# Funktion zur Auswahl der Installation
choose_installation() {
    CHOICE=$(dialog --clear \
                    --backtitle "Pterodactyl Installation" \
                    --title "Installationsmenü" \
                    --menu "Wählen Sie eine Option:" \
                    15 50 6 \
                    1 "Panel installieren" \
                    2 "Panel & Auto-Updater installieren" \
                    3 "Wings installieren" \
                    4 "Wings & Auto-Updater installieren" \
                    5 "Panel & Wings installieren" \
                    6 "Panel & Wings mit Auto-Updater installieren" \
                    2>&1 >/dev/tty)

    case $CHOICE in
        1)
            echo "Panel installation"
            download_with_progress "$BASE_URL/installers/install_panel.sh" "$BASE_DIR/installers/install_panel.sh" "Panel Installer"
            chmod +x "$BASE_DIR/installers/install_panel.sh"
            sudo "$BASE_DIR/installers/install_panel.sh"
            ;;
        2)
            echo "Panel & Auto-Updater installation"
            # Weitere Installationsschritte hier
            ;;
        3)
            echo "Wings installation"
            # Weitere Installationsschritte hier
            ;;
        4)
            echo "Wings & Auto-Updater installation"
            # Weitere Installationsschritte hier
            ;;
        5)
            echo "Panel & Wings installation"
            # Weitere Installationsschritte hier
            ;;
        6)
            echo "Panel & Wings mit Auto-Updater installation"
            # Weitere Installationsschritte hier
            ;;
        *)
            show_error "Ungültige Auswahl"
            ;;
    esac
}

# Überprüfen des Betriebssystems
check_os() {
    osversion=$(grep '^PRETTY_NAME' /etc/os-release | cut -d '=' -f2 | tr -d '"')

    if [[ $osversion == *"Ubuntu 22.04.4 LTS"* ]]; then
        show_message "Ubuntu 22.04.4 LTS gefunden. Installation startet..."
    else
        show_error "Falsches Betriebssystem. Nur Ubuntu 22.04.4 LTS wird unterstützt."
        exit 1
    fi
}

# Hauptprogramm
check_os
mkdir -p "$BASE_DIR/installers"
choose_installation

# Warte auf Benutzereingabe, bevor das Skript endet
dialog --title "Fertig" --msgbox "Installation abgeschlossen. Drücken Sie eine Taste, um zu beenden." 6 40
clear
