#!/bin/bash
set -e

clear
echo "🔥 ShadowCraft Pterodactyl Panel Installer"

read -p "🌐 Enter your domain (panel.example.com): " DOMAIN

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
apt update
apt install -y curl ca-certificates gnupg unzip git tar sudo lsb-release software-properties-common

OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')

if [[ "$OS" == "ubuntu" ]]; then
    add-apt-repository -y ppa:ondrej/php
elif [[ "$OS" == "debian" ]]; then
    curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury-php.gpg
    echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/sury-php.list
fi

# Redis repo
curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis.gpg
echo "deb [signed-by=/usr/share/keyrings/redis.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" > /etc/apt/sources.list.d/redis.list

apt update

# =========================
# INSTALL PACKAGES
# =========================
apt install -y php${PHP_VERSION} php${PHP_VERSION}-{cli,fpm,mysql,mbstring,xml,zip,curl,gd,bcmath} mariadb-server nginx redis-server

# Composer
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# =========================
# DOWNLOAD PANEL
# =========================
mkdir -p /var/www/pterodactyl
cd /var/www/pterodactyl

curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
tar -xzvf panel.tar.gz

chmod -R 755 storage bootstrap/cache

# =========================
# DATABASE
# =========================
mariadb -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';"
mariadb -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'127.0.0.1';"
mariadb -e "FLUSH PRIVILEGES;"

# =========================
# ENV CONFIG
# =========================
cp .env.example .env

sed -i "s|APP_URL=.*|APP_URL=https://${DOMAIN}|g" .env
sed -i "s|DB_DATABASE=.*|DB_DATABASE=${DB_NAME}|g" .env
sed -i "s|DB_USERNAME=.*|DB_USERNAME=${DB_USER}|g" .env
sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=${DB_PASS}|g" .env

# =========================
# INSTALL
# =========================
COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader

php artisan key:generate --force
php artisan migrate --seed --force

chown -R www-data:www-data /var/www/pterodactyl

# =========================
# CRON
# =========================
(crontab -l 2>/dev/null; echo "* * * * * php /var/www/pterodactyl/artisan schedule:run > /dev/null 2>&1") | crontab -

# =========================
# SSL (SELF-SIGNED)
# =========================
mkdir -p /etc/certs/panel
openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
-subj "/CN=${DOMAIN}" \
-keyout /etc/certs/panel/privkey.pem \
-out /etc/certs/panel/fullchain.pem

# =========================
# NGINX
# =========================
cat > /etc/nginx/sites-available/pterodactyl.conf <<EOF
server {
    listen 80;
    server_name ${DOMAIN};
    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl http2;
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

ln -sf /etc/nginx/sites-available/pterodactyl.conf /etc/nginx/sites-enabled/pterodactyl.conf
nginx -t && systemctl restart nginx

# =========================
# QUEUE
# =========================
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
# CREATE ADMIN USER 
# =========================
cd /var/wwww/pterodactyl
php artisan p:user:make

# =========================
# FINAL
# =========================
echo ""
echo "=================================="
echo "✅ PANEL INSTALLED SUCCESSFULLY"
echo "🚀 POWERED BY ShadowCraftMC"
echo "🌐 URL: https://${DOMAIN}"
echo "=================================="
