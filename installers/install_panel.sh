#!/bin/bash

# Farben definieren
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color

MYSQL_USER="root"
MYSQL_PASSWORD=" "

# Funktion zur Überprüfung der Eingabe
function check_input() {
    if [ -z "$1" ]; then
        echo -e "${RED}Eingabe darf nicht leer sein. Bitte erneut eingeben.${NC}"
        return 1
    fi
    return 0
}

echo -e "${YELLOW}Panel installation starting...${NC}"

echo -e "${GREEN}Database installation${NC}"

DEFAULT_MYSQL_USER="root"
while true; do
    read -s -p "Enter MySQL root user [Default: $DEFAULT_MYSQL_USER]: " MYSQL_USER
    MYSQL_USER=${MYSQL_USER:-$DEFAULT_MYSQL_USER}
    echo
    check_input "$MYSQL_USER" && break
done

# MySQL root Passwort abfragen
DEFAULT_MYSQL_PASSWORD=" "
while true; do
    read -s -p "Enter MySQL root password [Default: $DEFAULT_MYSQL_PASSWORD]: " MYSQL_PASSWORD
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-$DEFAULT_MYSQL_PASSWORD}
    echo
    check_input "$MYSQL_PASSWORD" && break
done

# Pterodactyl Benutzer und Passwort abfragen
DEFAULT_PTERODACTYL_USER="pterodactyl"
while true; do
    read -p "Enter username for Pterodactyl [Default: $DEFAULT_PTERODACTYL_USER]: " PTERODACTYL_USER
    DATABASE_USER=${PTERODACTYL_USER:-$DEFAULT_PTERODACTYL_USER}
    check_input "$DATABASE_USER" && break
done

DEFAULT_PTERODACTYL_PASSWORD="pteropassword"
while true; do
    read -s -p "Enter password for Pterodactyl [Default: $DEFAULT_PTERODACTYL_PASSWORD]: " PTERODACTYL_PASSWORD
    DATABASE_PASSWORD=${PTERODACTYL_PASSWORD:-$DEFAULT_PTERODACTYL_PASSWORD}
    echo
    check_input "$DATABASE_PASSWORD" && break
done

# Datenbankname abfragen
DEFAULT_DATABASE_NAME="panel"
while true; do
    read -p "Enter database name for Pterodactyl [Default: $DEFAULT_DATABASE_NAME]: " DATABASE_NAME
    DATABASE_NAME=${DATABASE_NAME:-$DEFAULT_DATABASE_NAME}
    check_input "$DATABASE_NAME" && break
done

# Datenbank IP abfragen
DEFAULT_DATABASE_IP="127.0.0.1"
while true; do
    read -p "Enter database IP for Pterodactyl [Default: $DEFAULT_DATABASE_IP]: " DATABASE_IP
    DATABASE_IP=${DATABASE_IP:-$DEFAULT_DATABASE_IP}
    check_input "$DATABASE_IP" && break
done

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

echo -e "${YELLOW}Downloading Pterodactyl files.${NC}"
curl -# -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
echo -e "${YELLOW}Unpack Pterodactyl files..${NC}"
tar -xzvf panel.tar.gz > /dev/null 2>&1
echo -e "${YELLOW}Change permissions for Pterodactyl files...${NC}"
chmod -R 755 storage/* bootstrap/cache/

echo -e "${YELLOW}Setting up Database...${NC}"
# MySQL-Befehle ausführen
sudo mysql -u $MYSQL_USER -p"$MYSQL_PASSWORD" <<EOF
CREATE USER '$DATABASE_USER'@'$DATABASE_IP' IDENTIFIED BY '$DATABASE_PASSWORD';
CREATE DATABASE $DATABASE_NAME;
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$PTERODACTYL_USER'@'$DATABASE_IP' WITH GRANT OPTION;
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}MySQL Benutzer und Datenbank erfolgreich erstellt.${NC}"
else
    echo -e "${RED}Fehler bei der Erstellung des MySQL Benutzers und der Datenbank.${NC}"
fi

echo -e "${GREEN}Database and User installation completed successfully!${NC}"


echo -e "${GREEN}Installation completed successfully!${NC}"
