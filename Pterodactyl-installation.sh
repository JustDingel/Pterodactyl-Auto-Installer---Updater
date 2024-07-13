#!/bin/bash

VERSION="0.0.1"

# Github-URL zu den Skripten
BASE_URL="https://raw.githubusercontent.com/JustDingel/Pterodactyl-Auto-Installer---Updater/dev"

# Farben definieren
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Automatic installation for Pterodactyl.${NC}"
echo -e "${YELLOW}Checking Operating System...${NC}"

# Extrahieren der Betriebssystemversion
osversion=$(grep '^PRETTY_NAME' /etc/os-release | cut -d '=' -f2 | tr -d '"')

if [[ $osversion == *"Ubuntu 22.04.3 LTS"* ]]; then
    echo -e "${GREEN}Ubuntu 22.04.3 LTS found. Installation script starting...${NC}"
    
    # ASCII-Art
    echo -e "${GREEN}  _____  _                     _            _         _   _____           _        _ _       _   _             ${NC}"
    echo -e "${GREEN} |  __ \\| |                   | |          | |       | | |_   _|         | |      | | |     | | (_)            ${NC}"
    echo -e "${GREEN} | |__) | |_ ___ _ __ ___   __| | __ _  ___| |_ _   _| |   | |  _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __  ${NC}"
    echo -e "${GREEN} |  ___/| __/ _ \\ '__/ _ \\ / _\` |/ _\` |/ __| __| | | | |   | | | '_ \\/ __| __/ _\` | | |/ _\` | __| |/ _ \\| '_ \\ ${NC}"
    echo -e "${GREEN} | |    | ||  __/ | | (_) | (_| | (_| | (__| |_| |_| | |  _| |_| | | \\__ \\ || (_| | | | (_| | |_| | (_) | | | |${NC}"
    echo -e "${GREEN} |_|     \\__\\___|_|  \\___/ \\__,_|\\__,_|\\___|\\__|\\__, |_| |_____|_| |_|___/\\__\\__,_|_|_|\\__,_|\\__|_|\\___/|_| |_|${NC}"
    echo -e "${GREEN}                                                 __/ |                                                         ${NC}"
    echo -e "${GREEN}                                                |___/                                                          ${NC}"
    echo -e "${GREEN}_______________________________________________________________________________________________________________${NC}"
    echo -e "${YELLOW}DISCLAIMER: This script is not associated with the official Pterodactyl Project.${NC}"
    echo -e "${GREEN}What should be installed?:${NC}"
    echo -e "${GREEN}1. Panel${NC}"
    echo -e "${GREEN}2. Panel & auto updater${NC}"
    echo -e "${GREEN}3. Wings${NC}"
    echo -e "${GREEN}4. Wings & auto updater${NC}"
    echo -e "${GREEN}5. Panel & Wings${NC}"
    echo -e "${GREEN}6. Panel & Wings with auto updater${NC}"

    # Eingabeüberprüfung
    while true; do
        read -p "Choose [1-6]: " choice
        if [[ -z "$choice" ]]; then
            echo -e "${RED}Input is required${NC}"
        elif [[ ! "$choice" =~ ^[1-6]$ ]]; then
            echo -e "${RED}Invalid option${NC}"
        else
            if [[ $choice == 1 ]]; then
                echo -e "${GREEN}Panel installation.${NC}"
                mkdir -p Pterodactyl_Installer/installers
                echo -e "${YELLOW}Downloading installation script...${NC}"
                curl -o Pterodactyl_Installer/installers/install_panel.sh "$BASE_URL/installers/install_panel.sh"
                chmod +x ./Pterodactyl_Installer/installers/*.sh
                echo -e "${GREEN}Download complete!${NC}"
                ./Pterodactyl_Installer/installers/install_panel.sh
                break
                ;;
            elif [[ $choice == 2 ]]; then
                echo -e "${GREEN}Panel & auto updater installation.${NC}"
            elif [[ $choice == 3 ]]; then
                echo -e "${GREEN}Wings installation.${NC}"
            elif [[ $choice == 4 ]]; then
                echo -e "${GREEN}Wings & auto updater installation.${NC}"
            elif [[ $choice == 5 ]]; then
                echo -e "${GREEN}Panel & Wings updater installation.${NC}"
            elif [[ $choice == 6 ]]; then
                echo -e "${GREEN}Panel & Wings with auto updater updater installation.${NC}"
            fi
            echo -e "${GREEN}Ihre Wahl: $choice${NC}"
            break
        fi
    done

else
    echo -e "${RED}Wrong Operating System. Only ${GREEN}Ubuntu 22.04.3 LTS${RED} is supported by this script.${NC}"
fi

# Warte auf Benutzereingabe, bevor das Skript endet
read -p "Press any key to exit..."
