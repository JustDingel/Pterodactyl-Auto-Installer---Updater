#!/bin/bash


echo -e "${YELLOW}Panel installation starting...${NC}"

# Software properties und cURL installieren
echo -e "${YELLOW}Installing required packages...${NC}"
sudo apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg > /dev/null 2>&1

# PHP Repository hinzufügen
echo -e "${YELLOW}Adding PHP repository...${NC}"
sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1

# Redis Repository hinzufügen
echo -e "${YELLOW}Adding Redis repository...${NC}"
# Vorhandene Keyring-Datei löschen, wenn sie existiert
if [ -f /usr/share/keyrings/redis-archive-keyring.gpg ]; then
    sudo rm /usr/share/keyrings/redis-archive-keyring.gpg
fi
sudo curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg > /dev/null 2>&1
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list > /dev/null 2>&1

# Repositories aktualisieren
echo -e "${YELLOW}Updating package list...${NC}"
sudo apt update -y -qq > /dev/null 2>&1

# Abhängigkeiten installieren
echo -e "${YELLOW}Installing dependencies...${NC}"
sudo apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server -y -qq > /dev/null 2>&1

# Composer installieren
echo -e "${YELLOW}Installing Composer...${NC}"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer > /dev/null 2>&1

# Pterodactyl-Ordner erstellen
echo -e "${YELLOW}Creating Pterodactyl folder...${NC}"
sudo mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl

echo -e "${YELLOW}Installation completed successfully!${NC}"
