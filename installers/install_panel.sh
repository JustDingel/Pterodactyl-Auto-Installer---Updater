#!/bin/bash

# Farben definieren
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export NC='\033[0m' # No Color


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
    echo -e "${GREEN}Enter MySQL root user [Default: $DEFAULT_MYSQL_USER]: ${NC}"
    read -s -p "" MYSQL_USER
    MYSQL_USER=${MYSQL_USER:-$DEFAULT_MYSQL_USER}
    echo
    check_input "$MYSQL_USER" && break
done

# MySQL root Passwort abfragen
DEFAULT_MYSQL_PASSWORD=" "
while true; do
    echo -e "${GREEN}Enter MySQL root password [Default: $DEFAULT_MYSQL_PASSWORD]: ${NC}"
    read -s -p "" MYSQL_PASSWORD
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-$DEFAULT_MYSQL_PASSWORD}
    echo
    check_input "$MYSQL_PASSWORD" && break
done

# Pterodactyl Benutzer und Passwort abfragen
DEFAULT_PTERODACTYL_USER="pterodactyl"
while true; do
    echo -e "${GREEN}Enter username for Pterodactyl [Default: $DEFAULT_PTERODACTYL_USER]: ${NC}"
    read -p " " PTERODACTYL_USER
    DATABASE_USER=${PTERODACTYL_USER:-$DEFAULT_PTERODACTYL_USER}
    check_input "$DATABASE_USER" && break
done

DEFAULT_PTERODACTYL_PASSWORD="pteropassword"
while true; do
    echo -e "${YELLOW}// Change this out of security concerns!${NC}"
    echo -e "${GREEN}Enter password for Pterodactyl [Default: $DEFAULT_PTERODACTYL_PASSWORD]: ${NC}"
    read -s -p " " PTERODACTYL_PASSWORD
    DATABASE_PASSWORD=${PTERODACTYL_PASSWORD:-$DEFAULT_PTERODACTYL_PASSWORD}
    check_input "$DATABASE_PASSWORD" && break
done

# Datenbankname abfragen
DEFAULT_DATABASE_NAME="panel"
while true; do
    echo -e "${GREEN}Enter database name for Pterodactyl [Default: $DEFAULT_DATABASE_NAME]: ${NC}"
    read -p " " DATABASE_NAME
    DATABASE_NAME=${DATABASE_NAME:-$DEFAULT_DATABASE_NAME}
    check_input "$DATABASE_NAME" && break
done

# Datenbank IP abfragen
DEFAULT_DATABASE_IP="127.0.0.1"
while true; do
    echo -e "${GREEN}Enter database IP for Pterodactyl [Default: $DEFAULT_DATABASE_IP]: ${NC}"
    read -p " " DATABASE_IP
    DATABASE_IP=${DATABASE_IP:-$DEFAULT_DATABASE_IP}
    check_input "$DATABASE_IP" && break
done

DEFAULT_DATABASE_PORT="3306"
while true; do
    echo -e "${GREEN}Enter database Port for Pterodactyl [Default: $DEFAULT_DATABASE_PORT]: ${NC}"
    read -p " " DATABASE_PORT
    DATABASE_PORT=${DATABASE_PORT:-$DEFAULT_DATABASE_PORT}
    check_input "$DATABASE_PORT" && break
done

DEFAULT_AUTHOR_EMAIL="example@example.com"
while true; do
    echo -e "${YELLOW}// Provide the email address that eggs exported by this Panel should be from. This should be a valid email address.${NC}"
    echo -e "${GREEN}Enter Email adress for Pterodactyl [Default: $DEFAULT_AUTHOR_EMAIL]: ${NC}"
    read -p " " AUTHOR_EMAIL
    AUTHOR_EMAILT=${AUTHOR_EMAIL:-$DEFAULT_AUTHOR_EMAIL}
    check_input "$AUTHOR_EMAIL" && break
done

DEFAULT_APPLICATION_URL="http://panel.example.com"
while true; do
    echo -e "${YELLOW}// The application URL MUST begin with https:// or http:// depending on if you are using SSL or not. If you do not${NC}"
    echo -e "${YELLOW}// include the scheme your emails and other content will link to the wrong location.${NC}"
    echo -e "${GREEN}Enter Application URL or IP adress [Default: $DEFAULT_APPLICATION_URL]: ${NC}"
    read -p " " APPLICATION_URL
    APPLICATION_URL=${APPLICATION_URL:-$DEFAULT_APPLICATION_URL}
    check_input "$APPLICATION_URL" && break
done

DEFAULT_APPLICATION_TIMEZONE="Europe/Berlin"
while true; do
    echo -e "${YELLOW}// The timezone should match one of PHP's supported timezones. If you are unsure, please reference https://php.net/manual/en/timezones.php.${NC}"
    echo -e "${GREEN}Enter Zimezone [Default: $DEFAULT_APPLICATION_TIMEZONE]: ${NC}"
    read -p " " APPLICATION_TIMEZONE
    APPLICATION_TIMEZONE=${APPLICATION_TIMEZONE:-$DEFAULT_APPLICATION_TIMEZONE}
    check_input "$APPLICATION_TIMEZONE" && break
done

DEFAULT_APPLICATION_CACHE="redis"
while true; do
    echo -e "${YELLOW}Cache Driver${NC}"
    echo -e "${GREEN}redis (recommended)${NC}"
    echo -e "${GREEN}memcache${NC}"
    echo -e "${GREEN}filesystem${NC}"
    echo -e "${GREEN}Enter Application Cache method [Default: $DEFAULT_APPLICATION_CACHE]: ${NC}"
    read -p " " APPLICATION_CACHE
    APPLICATION_CACHE=${APPLICATION_CACHE:-$DEFAULT_APPLICATION_CACHE}
    check_input "$APPLICATION_CACHE" && break
done

DEFAULT_APPLICATION_SESSION="redis"
while true; do
    echo -e "${YELLOW}Session Driver${NC}"
    echo -e "${GREEN}redis (recommended)${NC}"
    echo -e "${GREEN}memcache${NC}"
    echo -e "${GREEN}mysql database${NC}"
    echo -e "${GREEN}filesystem${NC}"
    echo -e "${GREEN}cookies${NC}"
    echo -e "${GREEN}Enter how the sessions should be stored [Default: $DEFAULT_APPLICATION_SESSION]: ${NC}"
    read -p " " APPLICATION_SESSION
    APPLICATION_SESSION=${APPLICATION_SESSION:-$DEFAULT_APPLICATION_SESSION}
    check_input "$APPLICATION_SESSION" && break
done

DEFAULT_APPLICATION_QUEUE="redis"
while true; do
    echo -e "${YELLOW}Cache Driver${NC}"
    echo -e "${GREEN}redis (recommended)${NC}"
    echo -e "${GREEN}mysql database${NC}"
    echo -e "${GREEN}sync${NC}"
    echo -e "${GREEN}Enter how the application queue should work [Default: $DEFAULT_APPLICATION_QUEUE]: ${NC}"
    read -p " " APPLICATION_QUEUE
    APPLICATION_QUEUE=${APPLICATION_QUEUE:-$DEFAULT_APPLICATION_QUEUE}
    check_input "$APPLICATION_QUEUE" && break
done

DEFAULT_APPLICATION_UI="yes"
while true; do
    echo -e "${GREEN}Enable UI based settings editor? [Default: $DEFAULT_APPLICATION_UI]: ${NC}"
    read -p " " APPLICATION_UI
    APPLICATION_UI=${APPLICATION_UI:-$DEFAULT_APPLICATION_UI}
    check_input "$APPLICATION_UI" && break
done

DEFAULT_APPLICATION_TELEMETRY="yes"
while true; do
    echo -e "${GREEN}Enable sending anonymous telemetry data? (yes/no) [Default: $DEFAULT_APPLICATION_TELEMETRY]: ${NC}"
    read -p " " APPLICATION_TELEMETRY
    APPLICATION_TELEMETRY=${APPLICATION_TELEMETRY:-$DEFAULT_APPLICATION_TELEMETRY}
    check_input "$APPLICATION_TELEMETRY" && break
done

DEFAULT_REDIS_IP="127.0.0.1"
while true; do
    echo -e "${YELLOW}! [NOTE] You've selected the Redis driver for one or more options, please provide valid connection information below.${NC}"
    echo -e "${YELLOW}!        In most cases you can use the defaults provided unless you have modified your setup.${NC}"
    echo -e "${GREEN}Enter Redis IP [Default: $DEFAULT_REDIS_IP]: ${NC}"
    read -p " " REDIS_IP
    REDIS_IP=${REDIS_IP:-$DEFAULT_REDIS_IP}
    check_input "$REDIS_IP" && break
done

DEFAULT_REDIS_PASSWORD=" "
while true; do
    echo -e "${YELLOW}// By default a Redis server instance has no password as it is running locally and inaccessible to the outside world.${NC}"
    echo -e "${YELLOW}// If this is the case, simply hit enter without entering a value.${NC}"
    echo -e "${GREEN}Enter Redis Password [Default: $DEFAULT_REDIS_PASSWORD]: ${NC}"
    read -p " " REDIS_PASSWORD
    REDIS_PASSWORD=${REDIS_PASSWORD:-$DEFAULT_REDIS_PASSWORD}
    check_input "$REDIS_PASSWORD" && break
done

DEFAULT_REDIS_PORT="6379"
while true; do
    echo -e "${GREEN}Enter Redis Port [Default: $DEFAULT_REDIS_PORT]: ${NC}"
    read -p " " REDIS_PORT
    REDIS_PORT=${REDIS_PORT:-$DEFAULT_REDIS_PORT}
    check_input "$REDIS_PORT" && break
done

DEFAULT_USER_ADMIN="yes"
while true; do
    echo -e "${GREEN}Is this user an administrator? (yes/no) [Default: $DEFAULT_USER_ADMIN]: ${NC}"
    read -p " " USER_ADMIN
    USER_ADMIN=${USER_ADMIN:-$DEFAULT_USER_ADMIN}
    check_input "$USER_ADMIN" && break
done

DEFAULT_USER_EMAIL="example@example.com"
while true; do
    echo -e "${GREEN}Enter a valid email adress [Default: $DEFAULT_USER_EMAIL]: ${NC}"
    read -p " " USER_EMAIL
    USER_EMAIL=${USER_EMAIL:-$DEFAULT_USER_EMAIL}
    check_input "$USER_EMAIL" && break
done

DEFAULT_USER_NAME="ExampleMan42"
while true; do
    echo -e "${GREEN}Enter a username [Default: $DEFAULT_USER_NAME]: ${NC}"
    read -p " " USER_NAME
    USER_NAME=${USER_NAME:-$DEFAULT_USER_NAME}
    check_input "$USER_NAME" && break
done

DEFAULT_USER_FIRST="Max"
while true; do
    echo -e "${GREEN}Enter your First Name [Default: $DEFAULT_USER_FIRST]: ${NC}"
    read -p " " USER_FIRST
    USER_FIRST=${USER_FIRST:-$DEFAULT_USER_FIRST}
    check_input "$USER_FIRST" && break
done

DEFAULT_USER_LAST="Mustermann"
while true; do
    echo -e "${GREEN}Enter your Last Name [Default: $DEFAULT_USER_LAST]: ${NC}"
    read -p " " USER_LAST
    USER_LAST=${USER_LAST:-$DEFAULT_USER_LAST}
    check_input "$USER_LAST" && break
done

DEFAULT_USER_PASSWORD=""
while true; do
    echo -e "${YELLOW}Passwords must be at least 8 characters in length and contain at least one capital letter and number.${NC}"
    echo -e "${GREEN}Enter Password [Default: $DEFAULT_USER_PASSWORD]: ${NC}"
    read -p " " USER_PASSWORD
    USER_PASSWORD=${USER_PASSWORD:-$DEFAULT_USER_PASSWORD}
    check_input "$USER_PASSWORD" && break
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
GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DATABASE_USER'@'$DATABASE_IP' WITH GRANT OPTION;
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Database and User configuration completed successfully!${NC}"
else
    echo -e "${RED}Something went wrong in the installation please read the error message. ${NC}"
fi

echo -e "${YELLOW}Copy .env file...${NC}"
cp .env.example .env
echo -e "${YELLOW}install core dependencies...${NC}"
yes | composer install --no-dev --optimize-autoloader > /dev/null 2>&1
echo -e "${YELLOW}generate a new application encryption key...${NC}"
sudo php artisan key:generate --force > /dev/null 2>&1

echo -e "${YELLOW}Configure environment settings${NC}"
cat <<EOF > .env.setup
$AUTHOR_EMAIL
$APPLICATION_URL
$APPLICATION_TIMEZONE
$APPLICATION_CACHE
$APPLICATION_SESSION
$APPLICATION_QUEUE
$APPLICATION_UI
$APPLICATION_TELEMETRY
$REDIS_IP
$REDIS_PASSWORD
$REDIS_PORT
EOF
sudo php artisan p:environment:setup < .env.setup > /dev/null 2>&1

echo -e "${YELLOW}Configure database settings${NC}"
cat <<EOF > .env.database
$DATABASE_IP
$DATABASE_PORT
$DATABASE_NAME
$DATABASE_USER
$DATABASE_PASSWORD
EOF
sudo php artisan p:environment:database < .env.database > /dev/null 2>&1

echo -e "${YELLOW}Migrating base data to database${NC}"
sudo php artisan migrate --seed --force

echo -e "${YELLOW}Creating User Admin account${NC}"
cat <<EOF > .env.user
$USER_ADMIN
$USER_EMAIL
$USER_NAME
$USER_FIRST
$USER_LAST
$USER_PASSWORD
EOF

php artisan p:user:make < .env.user > /dev/null 2>&1

rm .env.setup .env.database .env.user > /dev/null 2>&1

echo -e "${YELLOW}Setting permissions${NC}"
sudo chown -R www-data:www-data /var/www/pterodactyl/*

CRON_JOB="* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1"
(crontab -l 2>/dev/null | grep -Fq "$CRON_JOB") || (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

read -r -d '' PTEROQ_SERVICE_CONTENT << EOM
# Pterodactyl Queue Worker File
# ----------------------------------

[Unit]
Description=Pterodactyl Queue Worker
After=redis-server.service

[Service]
# On some systems the user and group might be different.
# Some systems use 'apache' or 'nginx' as the user and group.
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOM

echo -e "${YELLOW}Creating pteroq.service file...${NC}"
echo "$PTEROQ_SERVICE_CONTENT" | sudo tee /etc/systemd/system/pteroq.service > /dev/null
echo -e "${GREEN}pteroq.service file has been created successfully in /etc/systemd/system!${NC}"
echo -e "${YELLOW}Enabling redis-server...${NC}"
sudo systemctl enable --now redis-server
echo -e "${YELLOW}Enabling pteroq.service...${NC}"
sudo systemctl enable --now pteroq.service
echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "${YELLOW}Installing Webserver...${NC}"

if [[ $APPLICATION_URL == http://* ]]; then
    echo -e "${YELLOW}HTTP detected. Proceeding without SSL...${NC}"
    # Hier die Schritte für HTTP ohne SSL einfügen
elif [[ $APPLICATION_URL == https://* ]]; then
    echo -e "${YELLOW}HTTPS detected. Proceeding with SSL...${NC}"
    # Hier die Schritte für HTTPS mit SSL einfügen
else
    echo -e "${RED}Invalid input. Please make sure to include http:// or https:// in the domain.${NC}"
    exit 1
fi

domain_without_protocol=$(echo $APPLICATION_URL | sed -e 's#^http://##' -e 's#^https://##')

sudo rm /etc/nginx/sites-enabled/default

read -r -d '' PTEROQ_NGINX_SERVICE << EOM

server {
    # Replace the example <domain> with your domain name or IP address
    listen 80;
    server_name $domain_without_protocol;


    root /var/www/pterodactyl/public;
    index index.html index.htm index.php;
    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/pterodactyl.app-error.log error;

    # allow larger file uploads and longer script runtimes
    client_max_body_size 100m;
    client_body_timeout 120s;

    sendfile off;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param HTTP_PROXY "";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOM
echo -e "${YELLOW}Creating pteroqdactyl.conf file...${NC}"
echo "$PTEROQ_NGINX_SERVICE" | sudo tee /etc/nginx/sites-available/pterodactyl.conf > /dev/null
echo -e "${YELLOW}Symlink file...${NC}"
sudo ln -s /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf
echo -e "${YELLOW}Restarting Nginx...${NC}"
sudo systemctl restart nginx
echo -e "${GREEN}Panel installation successfully${NC}"