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
    echo "Installiere notwendige Abhängigkeiten..."
    apt update
    apt install -y curl wget
}

# Hauptfunktion
main() {
    check_root
    install_dependencies

    echo "Lade Pterodactyl Installations-Skript herunter..."
    wget https://raw.githubusercontent.com/JustDingel/Pterodactyl-Auto-Installer---Updater/dev/pterodactyl_install.sh -O pterodactyl_install.sh

    if [ $? -ne 0 ]; then
        echo "Fehler beim Herunterladen des Installationsskripts. Bitte überprüfen Sie Ihre Internetverbindung und die GitHub-URL."
        exit 1
    fi

    chmod +x pterodactyl_install.sh

    if [ ! -x pterodactyl_install.sh ]; then
        echo "Fehler beim Setzen der Ausführungsrechte für das Installationsskript."
        exit 1
    fi

    echo "Starte Installation..."
    ./pterodactyl_install.sh

    if [ $? -ne 0 ]; then
        echo "Es gab ein Problem bei der Ausführung des Installationsskripts."
        exit 1
    fi
}

main