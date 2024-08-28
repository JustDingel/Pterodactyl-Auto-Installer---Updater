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
    apt install -y dialog curl wget software-properties-common apt-transport-https ca-certificates gnupg
}

# Funktion zur Installation des Panels
install_panel() {
    dialog --infobox "Installiere Pterodactyl Panel..." 10 50
    
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
    
    dialog --msgbox "Pterodactyl Panel wurde installiert. Bitte konfigurieren Sie die .env-Datei manuell und führen Sie dann 'php artisan p:environment:setup' und 'php artisan p:environment:database' aus." 10 60
}

# Funktion zur Installation der Wings
install_wings() {
    dialog --infobox "Installiere Pterodactyl Wings..." 10 50
    
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
    
    dialog --msgbox "Pterodactyl Wings wurden installiert. Bitte konfigurieren Sie die config.yml-Datei in /etc/pterodactyl/ manuell." 10 60
}

# Funktion zur Konfiguration der Firewall
setup_firewall() {
    dialog --infobox "Konfiguriere Firewall..." 10 50
    
    apt install -y ufw
    ufw allow ssh
    ufw allow http
    ufw allow https
    ufw --force enable
    
    dialog --msgbox "Firewall wurde konfiguriert." 10 50
}

# Funktion zur Generierung eines SSL-Zertifikats
generate_ssl() {
    apt install -y certbot python3-certbot-nginx
    
    domain=$(dialog --inputbox "Geben Sie Ihre Domain ein:" 10 60 3>&1 1>&2 2>&3)
    
    dialog --infobox "Generiere SSL-Zertifikat für $domain..." 10 50
    certbot --nginx -d $domain
    
    dialog --msgbox "SSL-Zertifikat wurde generiert." 10 50
}

# Funktion zur Konfiguration der Datenbank
configure_database() {
    rootpass=$(dialog --passwordbox "Geben Sie ein Root-Passwort für MariaDB ein:" 10 60 3>&