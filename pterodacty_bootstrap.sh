#!/bin/bash

# Funktion zur Überprüfung der Root-Rechte
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Dieses Skript muss als Root ausgeführt werden."
        exit 1
    fi
}

# Funktion zur Installation von Abhängigkeiten
install_dependencies() {
    apt update
    apt install -y curl
}

# Hauptfunktion
main() {
    check_root
    install_dependencies

    echo "Lade Pterodactyl Installations-Skript herunter..."
    curl -sSL https://raw.githubusercontent.com/JustDingel/Pterodactyl-Auto-Installer---Updater/dev/pterodactyl_install.sh -o ./pterodactyl_install.sh
    chmod +x pterodactyl_install.sh

    echo "Starte Installation..."
    ./pterodactyl_install.sh
}

main