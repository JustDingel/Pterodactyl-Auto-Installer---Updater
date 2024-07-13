#!/bin/bash
echo -e "${YELLOW}Panel installation starting...${NC}"
echo -e "${YELLOW}Add "add-apt-repository" command${NC}"
sudo apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
echo -e "${YELLOW}Add additional repositories for PHP, Redis, and MariaDB${NC}"
sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
echo -e "${YELLOW}Add Redis official APT repository${NC}"
sudo curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg -y
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
echo -e "${YELLOW}Update repositories list${NC}"
sudo apt update
echo -e "${YELLOW}Install Dependencies${NC}"
sudo apt -y install php8.1 php8.1-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server nginx tar unzip git redis-server -y -qq
echo -e "${YELLOW}Installing Composer${NC}"
sudo curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
echo -e "${YELLOW}create Pterodactyl folder${NC}"
sudo mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl