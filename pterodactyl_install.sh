#!/bin/bash

# Funktion zur Selbstaktualisierung des Skripts
self_update() {
    echo "Prüfe auf Updates..."
    wget https://raw.githubusercontent.com/IHR_BENUTZERNAME/IHR_REPOSITORY/main/pterodactyl_install.sh -O /tmp/pterodactyl_install.sh
    if ! cmp -s "/tmp/pterodactyl_install.sh" "$0"; then
        echo "Update verfügbar. Aktualisiere..."
        cp /tmp/pterodactyl_install.sh "$0"
        chmod +x "$0"
        echo "Skript wurde aktualisiert. Bitte starten Sie es erneut."
        exit 0
    else
        echo "Skript ist auf dem neuesten Stand."
    fi
    rm /tmp/pterodactyl_install.sh
}

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
    apt install -y dialog curl wget
}

# Funktion zum Anzeigen des Hauptmenüs
show_main_menu() {
    dialog --clear --title "Pterodactyl Installations-GUI" \
    --menu "Wählen Sie eine Option:" 15 60 5 \
    1 "Installiere Pterodactyl Panel" \
    2 "Installiere Pterodactyl Wings" \
    3 "Systemeinstellungen konfigurieren" \
    4 "Auf Updates prüfen" \
    5 "Beenden" 2>"${INPUT}"

    menuitem=$(<"${INPUT}")

    case $menuitem in
        1) install_panel ;;
        2) install_wings ;;
        3) configure_system ;;
        4) self_update ;;
        5) exit 0 ;;
    esac
}

# [Der Rest des Skripts bleibt unverändert...]

# Hauptprogramm
INPUT=$(mktemp /tmp/menu.sh.XXXXXX)
OUTPUT=$(mktemp /tmp/output.sh.XXXXXX)

trap "rm -f $OUTPUT; rm -f $INPUT; exit" SIGHUP SIGINT SIGTERM

check_root
install_dependencies

while true
do
    show_main_menu
done