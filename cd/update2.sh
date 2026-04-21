#!/usr/bin/env bash
set -e

# ======================
# COLORS
# ======================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ======================
# UI
# ======================
header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN} $1 ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

ok() { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠️ $1${NC}"; }
err() { echo -e "${RED}❌ $1${NC}"; }

# ======================
# BANNER (SHADOW)
# ======================
clear
echo "========================================"
echo "   ███████╗██╗  ██╗ █████╗ ██████╗     "
echo "   ██╔════╝██║  ██║██╔══██╗██╔══██╗    "
echo "   ███████╗███████║███████║██║  ██║    "
echo "   ╚════██║██╔══██║██╔══██║██║  ██║    "
echo "   ███████║██║  ██║██║  ██║██████╔╝    "
echo "   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝     "
echo "        Shadow Panel Updater           "
echo "========================================"

# ======================
# ROOT CHECK
# ======================
[[ "$EUID" -ne 0 ]] && err "Run as root" && exit 1

# ======================
# PATH
# ======================
PANEL="/var/www/pterodactyl"

[[ ! -d "$PANEL" ]] && err "Panel not found" && exit 1

cd "$PANEL"

# ======================
# MAINTENANCE MODE
# ======================
header "MAINTENANCE MODE"
php artisan down || true
ok "Maintenance enabled"

# ======================
# BACKUP (IMPORTANT)
# ======================
header "BACKUP"
cp .env .env.backup || true
ok "Backup created"

# ======================
# DOWNLOAD SAFE
# ======================
header "DOWNLOADING UPDATE"

curl -L -o panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz

if [ ! -f panel.tar.gz ]; then
    err "Download failed"
    php artisan up || true
    exit 1
fi

tar --strip-components=1 -xzf panel.tar.gz
rm -f panel.tar.gz

ok "Update extracted"

# ======================
# PERMISSIONS FIX
# ======================
header "PERMISSIONS"

chown -R www-data:www-data storage bootstrap/cache || true
chmod -R 775 storage bootstrap/cache || true

ok "Permissions fixed"

# ======================
# COMPOSER
# ======================
header "COMPOSER"

composer install --no-dev --optimize-autoloader --no-interaction || true

ok "Dependencies installed"

# ======================
# CACHE CLEAR
# ======================
header "CACHE"

php artisan view:clear || true
php artisan config:clear || true
php artisan cache:clear || true

ok "Cache cleared"

# ======================
# MIGRATION
# ======================
header "DATABASE"

php artisan migrate --force || true

ok "Migration done"

# ======================
# QUEUE
# ======================
header "QUEUE"

php artisan queue:restart || true

ok "Queue restarted"

# ======================
# FINISH
# ======================
header "FINAL STEP"

php artisan up || true

ok "Panel back online"

echo ""
echo "🎉 Shadow update completed successfully!"
