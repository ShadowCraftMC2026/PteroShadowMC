#!/usr/bin/env bash
set -e

# ===========================
# BANNER (SHADOW)
# ===========================
clear
echo "==============================================="
echo "        ███████╗██╗  ██╗ █████╗ ██████╗       "
echo "        ██╔════╝██║  ██║██╔══██╗██╔══██╗      "
echo "        ███████╗███████║███████║██║  ██║      "
echo "        ╚════██║██╔══██║██╔══██║██║  ██║      "
echo "        ███████║██║  ██║██║  ██║██████╔╝      "
echo "        ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝       "
echo "            Shadow Panel Updater              "
echo "==============================================="
echo ""

# ===========================
# CONFIG
# ===========================
PANEL_DIR="/var/www/pterodactyl"

# ===========================
# CHECK DIRECTORY
# ===========================
echo ">>> Checking panel directory..."

if [ ! -d "$PANEL_DIR" ]; then
    echo "❌ Panel directory not found!"
    exit 1
fi

cd "$PANEL_DIR"

# ===========================
# MAINTENANCE MODE
# ===========================
echo "⚙️ Enabling maintenance mode..."
php artisan down || true

# ===========================
# BACKUP (IMPORTANT FIX)
# ===========================
echo "💾 Creating backup..."
cp .env .env.backup || true

# ===========================
# DOWNLOAD LATEST RELEASE
# ===========================
echo "⬇️ Downloading latest release..."

curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz \
| tar --strip-components=1 -xzv

# ===========================
# PERMISSIONS (FIXED)
# ===========================
echo "🔑 Fixing permissions..."

chown -R www-data:www-data storage bootstrap/cache || true
chmod -R 775 storage bootstrap/cache || true

# ===========================
# COMPOSER (SAFE)
# ===========================
echo "📦 Installing dependencies..."

composer install --no-dev --optimize-autoloader --no-interaction || true

# ===========================
# CACHE CLEAR
# ===========================
echo "🧹 Clearing cache..."

php artisan view:clear || true
php artisan config:clear || true
php artisan cache:clear || true

# ===========================
# MIGRATIONS
# ===========================
echo "📂 Running migrations..."

php artisan migrate --force || true

# ===========================
# QUEUE RESTART
# ===========================
echo "♻️ Restarting queue..."

php artisan queue:restart || true

# ===========================
# MAINTENANCE OFF
# ===========================
echo "✅ Bringing panel back online..."

php artisan up || true

# ===========================
# DONE
# ===========================
echo ""
echo "==============================================="
echo "🎉 Shadow Panel Update Completed!"
echo "==============================================="
