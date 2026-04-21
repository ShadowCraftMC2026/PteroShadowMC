#!/bin/bash
set -e

# ======================
# FUNCTIONS
# ======================

cleanup_nginx() {
    echo ">>> Removing Nginx configuration..."

    rm -f /etc/nginx/sites-enabled/pterodactyl.conf 2>/dev/null || true
    rm -f /etc/nginx/sites-available/pterodactyl.conf 2>/dev/null || true
    rm -f /etc/nginx/conf.d/pterodactyl.conf 2>/dev/null || true

    if systemctl list-units --type=service | grep -q nginx; then
        systemctl restart nginx 2>/dev/null || true
        echo "✅ Nginx reloaded"
    fi
}

uninstall_panel() {
    echo ">>> Stopping Panel..."

    systemctl stop pteroq 2>/dev/null || true
    systemctl disable pteroq 2>/dev/null || true
    rm -f /etc/systemd/system/pteroq.service
    systemctl daemon-reload

    echo ">>> Removing cron..."
    crontab -l 2>/dev/null | grep -v 'artisan schedule:run' | crontab - 2>/dev/null || true

    echo ">>> Removing files..."
    rm -rf /var/www/pterodactyl

    echo ">>> Removing database..."

    mysql -u root -e "DROP DATABASE IF EXISTS panel;" 2>/dev/null || true
    mysql -u root -e "DROP USER IF EXISTS 'pterodactyl'@'127.0.0.1';" 2>/dev/null || true
    mysql -u root -e "DROP USER IF EXISTS 'pterodactyl'@'localhost';" 2>/dev/null || true
    mysql -u root -e "FLUSH PRIVILEGES;" 2>/dev/null || true

    cleanup_nginx

    echo "✅ Panel removed"
}

uninstall_wings() {
    echo ">>> Stopping Wings..."

    systemctl stop wings 2>/dev/null || true
    systemctl disable wings 2>/dev/null || true
    rm -f /etc/systemd/system/wings.service
    systemctl daemon-reload

    echo ">>> Removing Wings files..."
    rm -rf /etc/pterodactyl
    rm -rf /var/lib/pterodactyl
    rm -rf /var/log/pterodactyl
    rm -f /usr/local/bin/wings

    echo "✅ Wings removed"
}

uninstall_both() {
    uninstall_panel
    uninstall_wings
    echo "✅ Everything removed"
}

# ======================
# BANNER (SHADOW)
# ======================
clear
echo "====================================="
echo "   ███████╗██╗  ██╗ █████╗ ██████╗ "
echo "   ██╔════╝██║  ██║██╔══██╗██╔══██╗"
echo "   ███████╗███████║███████║██║  ██║"
echo "   ╚════██║██╔══██║██╔══██║██║  ██║"
echo "   ███████║██║  ██║██║  ██║██████╔╝"
echo "   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ "
echo "         Shadow Uninstaller"
echo "====================================="

# ======================
# ROOT CHECK
# ======================
if [[ "$EUID" -ne 0 ]]; then
    echo "❌ Run as root"
    exit 1
fi

# ======================
# MENU
# ======================

while true; do
    echo ""
    echo "1) Remove Panel"
    echo "2) Remove Wings"
    echo "3) Remove Both"
    echo "0) Exit"
    echo ""

    read -rp "Choose: " choice

    case $choice in
        1) uninstall_panel ;;
        2) uninstall_wings ;;
        3) uninstall_both ;;
        0) echo "Bye Shadow"; exit 0 ;;
        *) echo "❌ Invalid option" ;;
    esac

    echo ""
    read -rp "Press Enter..."
done
