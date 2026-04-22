#!/bin/bash

set -e

clear
echo "🔥 ShadowCraftMC Database Setup"
echo ""

read -p "Do you want to continue? (y/n): " c
[[ "$c" != "y" ]] && echo "Cancelled" && exit 0

echo ""
echo "🔐 Enter MySQL root password:"
read -s ROOT_PASS

# =========================
# VARIABLES
# =========================
DB_NAME="panel"
DB_USER="pterodactyl"
DB_PASS=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)

# =========================
# CREATE DB
# =========================
echo ""
echo "⚙️ Creating database..."

mysql -u root -p"$ROOT_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'127.0.0.1' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'127.0.0.1';
FLUSH PRIVILEGES;
EOF

echo ""
echo "======================================"
echo "✅ DATABASE CREATED SUCCESSFULLY"
echo "======================================"
echo ""
echo "📌 YOUR DATABASE NAME"
echo "➡️  ${DB_NAME}"
echo ""
echo "📌 YOUR DATABASE USERNAME"
echo "➡️  ${DB_USER}"
echo ""
echo "📌 YOUR STRONG PASSWORD"
echo "➡️  ${DB_PASS}"
echo ""
echo "======================================"

# save
echo "DB_NAME=${DB_NAME}" > /root/db-info.txt
echo "DB_USER=${DB_USER}" >> /root/db-info.txt
echo "DB_PASS=${DB_PASS}" >> /root/db-info.txt
