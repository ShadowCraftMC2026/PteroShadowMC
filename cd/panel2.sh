#!/bin/bash
set -e

# COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN} $1 ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_success() { echo -e "${GREEN}✔ $1${NC}"; }
print_error() { echo -e "${RED}✖ $1${NC}"; }
print_info() { echo -e "${YELLOW}➜ $1${NC}"; }

clear
echo -e "${CYAN}🔥 ShadowCraft Pterodactyl Installer${NC}\n"

read -p "🌐 Domain (panel.example.com): " DOMAIN
[ -z "$DOMAIN" ] && print_error "Domain required" && exit 1

# =========================
# VARIABLES
# =========================
DB_NAME="panel"
DB_USER="pterodactyl"
DB_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
PHP_VERSION="8.3"

# =========================
# DEPENDENCIES
# =========================
print_header "INSTALLING DEPENDENCIES"

apt update -y
apt install -y curl gnupg unzip git lsb-release software-properties-common

OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')

if [[ "$OS" == "ubuntu" ]]; then
    add-apt-repository -y ppa:ondrej/php
else
    curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/php.gpg
    echo "deb [signed-by=/usr/share/keyrings/php.gpg] https://packages.sury.org/php/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/php.list
fi

apt update -y

# =========================
# SERVICES
# =========================
print_header "INSTALLING SERVICES"

apt install -y php${PHP_VERSION} php${PHP_VERSION}-{cli,fpm,mysql,mbstring,xml,zip,curl,gd,bcmath} \
mariadb-server nginx redis-server

# Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

print_success "Services installed"

# =========================
# PANEL DOWNLOAD
# =========================
print_header "DOWNLOADING PANEL"

mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl

curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzf panel.tar.gz

chmod -R 755 storage bootstrap/cache

print_success "Panel downloaded"

# =========================
# DATABASE
# =========================
print_header "DATABASE SETUP"

mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'127.0.0.1';"
mariadb -e "FLUSH PRIVILEGES;"

print_success "Database ready"

# =========================
# ENV CONFIG
# =========================
print_header "CONFIGURING ENV"

cp .env.example .env

sed -i "s|APP_URL=.*|APP_URL=https://${DOMAIN}|g" .env
sed -i "s|DB_DATABASE=.*|DB_DATABASE=${DB_NAME}|g" .env
sed -i "s|DB_USERNAME=.*|DB_USERNAME=${DB_USER}|g" .env
sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=${DB_PASS}|g" .env

# =========================
# INSTALL PANEL
# =========================
print_header "INSTALLING PANEL"

COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
php artisan key:generate --force
php artisan migrate --seed --force

chown -R www-data:www-data /var/www/pterodactyl

print_success "Panel installed"

# =========================
# CRON
# =========================
print_header "SETTING CRON"

(crontab -l 2>/dev/null; echo "* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1") | crontab -

# =========================
# QUEUE SERVICE
# =========================
print_header "SETTING QUEUE"

cat > /etc/systemd/system/pteroq.service <<EOF
[Unit]
Description=Pterodactyl Queue Worker
After=redis-server.service

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --sleep=3 --tries=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now redis-server pteroq.service

# =========================
# SSL (SELF SIGNED)
# =========================
print_header "SSL SETUP"

mkdir -p /etc/certs/panel

openssl req -new -newkey rsa:2048 -nodes -x509 -days 365 \
-subj "/CN=${DOMAIN}" \
-keyout /etc/certs/panel/privkey.pem \
-out /etc/certs/panel/fullchain.pem

# =========================
# NGINX
# =========================
print_header "NGINX CONFIG"

cat > /etc/nginx/sites-available/pterodactyl.conf <<EOF
server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name ${DOMAIN};

    root /var/www/pterodactyl/public;
    index index.php;

    ssl_certificate /etc/certs/panel/fullchain.pem;
    ssl_certificate_key /etc/certs/panel/privkey.pem;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php${PHP_VERSION}-fpm.sock;
    }
}
EOF

ln -sf /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

print_success "Nginx ready"

# =========================
# AUTO ADMIN USER
# =========================
print_header "CREATING ADMIN USER"

cd /var/www/pterodactyl

ADMIN_EMAIL="admin@${DOMAIN}"
ADMIN_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)

php artisan p:user:make \
--email="$ADMIN_EMAIL" \
--username="admin" \
--name-first="Admin" \
--name-last="User" \
--password="$ADMIN_PASS" \
--admin=1 || true

# =========================
# SAVE INFO
# =========================
echo "URL: https://${DOMAIN}" > /root/panel-info.txt
echo "DB_USER: ${DB_USER}" >> /root/panel-info.txt
echo "DB_PASS: ${DB_PASS}" >> /root/panel-info.txt
echo "ADMIN_EMAIL: ${ADMIN_EMAIL}" >> /root/panel-info.txt
echo "ADMIN_PASS: ${ADMIN_PASS}" >> /root/panel-info.txt

# =========================
# FINAL
# =========================
print_header "DONE"

echo -e "${GREEN}✔ PANEL INSTALLED SUCCESSFULLY${NC}"
echo -e "${CYAN}🌐 URL: https://${DOMAIN}${NC}"
echo -e "${YELLOW}📁 Credentials saved: /root/panel-info.txt${NC}"
echo ""
echo -e "${RED}⚠ Use real SSL in production later${NC}"
