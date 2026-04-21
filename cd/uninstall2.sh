#!/bin/bash

set -e

# ======================
# COLORS
# ======================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ======================
# UI FUNCTIONS
# ======================
header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN} $1 ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

ok() { echo -e "${GREEN}✅ $1${NC}"; }
warn() { echo -e "${MAGENTA}⚠️ $1${NC}"; }
err() { echo -e "${RED}❌ $1${NC}"; }

# ======================
# CONFIRM
# ======================
confirm() {
    echo -e "${YELLOW}$1${NC}"
    read -rp "Are you sure? (y/N): " r
    [[ "$r" =~ ^[Yy]$ ]] || return 1
    return 0
}

# ======================
# MENU
# ======================
show_menu() {
    clear
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}   SHADOW UNINSTALLER SYSTEM   ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "1) Remove Panel"
    echo "2) Remove Wings"
    echo "3) Remove Both"
    echo "0) Exit"
    echo ""
}

# ======================
# PANEL REMOVE
# ======================
remove_panel() {
    header "REMOVING PANEL"

    confirm "This will delete Pterodactyl Panel completely" || return

    systemctl stop pteroq 2>/dev/null || true
    systemctl disable pteroq 2>/dev/null || true
    rm -f /etc/systemd/system/pteroq.service
    systemctl daemon-reload

    rm -rf /var/www/pterodactyl

    mysql -u root -e "DROP DATABASE IF EXISTS panel;" 2>/dev/null || true
    mysql -u root -e "DROP USER IF EXISTS 'pterodactyl'@'127.0.0.1';" 2>/dev/null || true
    mysql -u root -e "FLUSH PRIVILEGES;" 2>/dev/null || true

    rm -f /etc/nginx/sites-enabled/pterodactyl.conf 2>/dev/null || true
    rm -f /etc/nginx/sites-available/pterodactyl.conf 2>/dev/null || true
    systemctl restart nginx 2>/dev/null || true

    ok "Panel removed"
}

# ======================
# WINGS REMOVE
# ======================
remove_wings() {
    header "REMOVING WINGS"

    confirm "This will delete Wings completely" || return

    systemctl stop wings 2>/dev/null || true
    systemctl disable wings 2>/dev/null || true
    rm -f /etc/systemd/system/wings.service
    systemctl daemon-reload

    rm -rf /etc/pterodactyl
    rm -rf /var/lib/pterodactyl
    rm -rf /var/log/pterodactyl
    rm -f /usr/local/bin/wings

    ok "Wings removed"
}

# ======================
# BOTH
# ======================
remove_both() {
    header "REMOVING ALL"

    confirm "This will remove PANEL + WINGS completely" || return

    remove_panel
    remove_wings

    ok "Everything removed"
}

# ======================
# BANNER (SHADOW)
# ======================
clear
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}"
echo "   ███████╗██╗  ██╗ █████╗ ██████╗ "
echo "   ██╔════╝██║  ██║██╔══██╗██╔══██╗"
echo "   ███████╗███████║███████║██║  ██║"
echo "   ╚════██║██╔══██║██╔══██║██║  ██║"
echo "   ███████║██║  ██║██║  ██║██████╔╝"
echo "   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ "
echo -e "${NC}"
echo -e "${CYAN}     Shadow Pterodactyl Uninstaller${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sleep 1

# ======================
# ROOT CHECK
# ======================
[[ "$EUID" -ne 0 ]] && err "Run as root" && exit 1

# ======================
# LOOP MENU
# ======================
while true; do
    show_menu
    read -rp "Choose option [0-3]: " opt

    case $opt in
        1) remove_panel ;;
        2) remove_wings ;;
        3) remove_both ;;
        0) echo "Bye Shadow"; exit 0 ;;
        *) err "Invalid option" ;;
    esac

    echo ""
    read -rp "Press Enter..."
done
