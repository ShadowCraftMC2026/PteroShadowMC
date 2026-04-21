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
echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN} $1 ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_status() { echo -e "${YELLOW}⏳ $1...${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

clear
echo -e "${CYAN}🔥 ShadowCraft Pterodactyl Installer${NC}\n"

read -p "🌐 Domain (panel.example.com): " DOMAIN
[ -z "$DOMAIN" ] && { print_error "Domain required"; exit 1; }

# VARIABLES
DB_NAME="panel"
DB_USER="pterodactyl"
DB_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
PHP_VERSION="8.3"

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

print_status "Installing services"
apt install -y php${PHP_VERSION} php${PHP_VERSION}-{cli,fpm,mysql,mbstring,xml,zip,curl,gd,bcmath} mariadb-server nginx redis-server
print_success "Services installed"

print_header "INSTALLING COMPOSER"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
print_success "Composer installed"

print_header "DOWNLOADING PANEL"

mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl

curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzf panel.tar.gz
chmod -R 755 storage bootstrap/cache

print_success "Panel downloaded"

print_header "DATABASE SETUP"

mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'127.0.0.1';"

print_success "Database ready"

print_header "CONFIGURING ENV"

cp .env.example .env

sed -i "s|APP_URL=.*|APP_URL=https://${DOMAIN}|g" .env
sed -i "s|DB_DATABASE=.*|DB_DATABASE=${DB_NAME}|g" .env
sed -i "s|DB_USERNAME=.*|DB_USERNAME=${DB_USER}|g" .env
sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=${DB_PASS}|g" .env

print_success "Env configured"

print_header "INSTALLING PANEL"

COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
php artisan key:generate --force
php artisan migrate --seed --force

chown -R www-data:www-data /var/www/pterodactyl

print_success "Panel installed"

print_header "NGINX + SSL"

mkdir -p /etc/certs/panel
openssl req -new -newkey rsa:2048 -nodes -x509 -days 365 \
-subj "/CN=${DOMAIN}" \
-keyout /etc/certs/panel/key.pem \
-out /etc/certs/panel/cert.pem

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

    ssl_certificate /etc/certs/panel/cert.pem;
    ssl_certificate_key /etc/certs/panel/key.pem;

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

print_header "FINAL"

echo ""
echo "🌐 URL: https://${DOMAIN}"
echo "👤 Create admin:"
echo "cd /var/www/pterodactyl && php artisan p:user:make"
echo "🔑 DB PASS: ${DB_PASS}"
echo ""
echo "⚠️ Replace SSL with real certificate for production"
