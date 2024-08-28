#!/bin/bash

# Farben für die Ausgabe
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Funktion zur Überprüfung der Root-Rechte
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Dieses Skript muss als Root ausgeführt werden.${NC}"
        exit 1
    fi
}

# Funktion zur Installation von Abhängigkeiten
install_dependencies() {
    echo -e "${YELLOW}Installiere notwendige Abhängigkeiten...${NC}"
    apt update
    apt install -y software-properties-common curl apt-transport-https ca-certificates gnupg
}

# Funktion zur Installation des Panels
install_panel() {
    echo -e "${YELLOW}Installiere Pterodactyl Panel...${NC}"
    
    # Füge PHP-Repository hinzu
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
    
    # Füge MariaDB-Repository hinzu
    curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
    
    # Aktualisiere Paketlisten
    apt update
    
    # Installiere PHP 8.1 und seine Erweiterungen
    apt install -y php8.1 php8.1-{cli,gd,mysql,pdo,mbstring,tokenizer,bcmath,xml,fpm,curl,zip}
    
    # Installiere weitere notwendige Pakete
    apt install -y mariadb-server nginx tar unzip git redis-server
    
    # Installiere Composer
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    
    # Lade Pterodactyl herunter
    mkdir -p /var/www/pterodactyl
    cd /var/www/pterodactyl
    curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
    tar -xzvf panel.tar.gz
    chmod -R 755 storage/* bootstrap/cache/
    
    # Konfiguriere Pterodactyl
    cp .env.example .env
    composer install --no-dev --optimize-autoloader
    php artisan key:generate --force
    
    echo -e "${GREEN}Pterodactyl Panel wurde installiert.${NC}"
    echo -e "${YELLOW}Bitte konfigurieren Sie die .env-Datei manuell und führen Sie dann 'php artisan p:environment:setup' und 'php artisan p:environment:database' aus.${NC}"
}

# Funktion zur Installation der Wings
install_wings() {
    echo -e "${YELLOW}Installiere Pterodactyl Wings...${NC}"
    
    # Installiere Docker
    curl -sSL https://get.docker.com/ | CHANNEL=stable bash
    
    # Lade Wings herunter
    mkdir -p /etc/pterodactyl
    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
    chmod u+x /usr/local/bin/wings
    
    # Erstelle systemd Service-Datei
    cat <<EOF > /etc/systemd/system/wings.service
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
LimitNOFILE=4096
PIDFile=/var/run/wings/daemon.pid
ExecStart=/usr/local/bin/wings
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target
EOF

    # Aktiviere und starte Wings
    systemctl enable --now wings
    
    echo -e "${GREEN}Pterodactyl Wings wurden installiert.${NC}"
    echo -e "${YELLOW}Bitte konfigurieren Sie die config.yml-Datei in /etc/pterodactyl/ manuell.${NC}"
}

# Funktion zur Konfiguration der Firewall
setup_firewall() {
    echo -e "${YELLOW}Konfiguriere Firewall...${NC}"
    
    apt install -y ufw
    ufw allow ssh
    ufw allow http
    ufw allow https
    ufw --force enable
    
    echo -e "${GREEN}Firewall wurde konfiguriert.${NC}"
}

# Funktion zur Generierung eines SSL-Zertifikats
generate_ssl() {
    echo -e "${YELLOW}Generiere SSL-Zertifikat...${NC}"
    
    apt install -y certbot python3-certbot-nginx
    
    read -p "Geben Sie Ihre Domain ein: " domain
    certbot --nginx -d $domain
    
    echo -e "${GREEN}SSL-Zertifikat wurde generiert.${NC}"
}

# Funktion zur Konfiguration der Datenbank
configure_database() {
    echo -e "${YELLOW}Konfiguriere Datenbank...${NC}"
    
    read -s -p "Geben Sie ein Root-Passwort für MariaDB ein: " rootpass
    echo
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$rootpass';"
    
    read -p "Geben Sie einen Namen für die Pterodactyl-Datenbank ein: " dbname
    read -p "Geben Sie einen Benutzernamen für die Pterodactyl-Datenbank ein: " dbuser
    read -s -p "Geben Sie ein Passwort für den Pterodactyl-Datenbankbenutzer ein: " dbpass
    echo
    
    mysql -u root -p$rootpass -e "CREATE DATABASE $dbname;"
    mysql -u root -p$rootpass -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"
    mysql -u root -p$rootpass -e "FLUSH PRIVILEGES;"
    
    echo -e "${GREEN}Datenbank wurde konfiguriert.${NC}"
}

# Funktion zum Einrichten von Cronjobs
setup_cronjobs() {
    echo -e "${YELLOW}Richte Cronjobs ein...${NC}"
    
    (crontab -l 2>/dev/null; echo "* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1") | crontab -
    
    echo -e "${GREEN}Cronjobs wurden eingerichtet.${NC}"
}

# Hauptmenü
main_menu() {
    while true; do
        echo -e "\n${YELLOW}=== Pterodactyl Installations-Menü ===${NC}"
        echo "1) Installiere Pterodactyl Panel"
        echo "2) Installiere Pterodactyl Wings"
        echo "3) Konfiguriere Firewall"
        echo "4) Generiere SSL-Zertifikat"
        echo "5) Konfiguriere Datenbank"
        echo "6) Richte Cronjobs ein"
        echo "7) Führe alle Schritte aus"
        echo "8) Beenden"
        
        read -p "Wählen Sie eine Option: " choice
        case $choice in
            1) install_panel ;;
            2) install_wings ;;
            3) setup_firewall ;;
            4) generate_ssl ;;
            5) configure_database ;;
            6) setup_cronjobs ;;
            7)
                install_panel
                install_wings
                setup_firewall
                generate_ssl
                configure_database
                setup_cronjobs
                ;;
            8) exit 0 ;;
            *) echo -e "${RED}Ungültige Auswahl${NC}" ;;
        esac
    done
}

# Hauptprogramm
check_root
install_dependencies
main_menu