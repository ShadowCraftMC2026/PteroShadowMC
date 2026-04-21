#!/bin/bash

set -e

# =========================
# COLORS
# =========================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# =========================
# BANNER
# =========================
clear
cat << "EOF"
 ____    _   _      _      ____     ___   __        __   ____   ____       _      _____   _____ 
/ ___|  | | | |    / \    |  _ \   / _ \  \ \      / /  / ___| |  _ \     / \    |  ___| |_   _|
\___ \  | |_| |   / _ \   | | | | | | | |  \ \ /\ / /  | |     | |_) |   / _ \   | |_      | |  
 ___) | |  _  |  / ___ \  | |_| | | |_| |   \ V  V /   | |___  |  _ <   / ___ \  |  _|     | |  
|____/  |_| |_| /_/   \_\ |____/   \___/     \_/\_/     \____| |_| \_\ /_/   \_\ |_|       |_|  
                     🔥ShadowCraftMC PTERODACTYL INSTALLITION 
                                  ⚡ powered by ShadowCraftMC 💣
EOF

echo -e "${CYAN}        Pterodactyl Automation Hub v1.0${NC}"
echo "======================================================"
echo ""

# =========================
# FUNCTIONS (INSTALLERS)
# =========================

run_script() {
    local url=$1

    echo -e "${YELLOW}>>> Downloading script...${NC}"

    curl -fsSL "$url" -o /tmp/shadow_script.sh

    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Download failed!${NC}"
        return
    fi

    chmod +x /tmp/shadow_script.sh
    bash /tmp/shadow_script.sh
}

# =========================
# MENU
# =========================
while true; do
    echo ""
    echo "================= MENU ================="
    echo "1) Panel Install"
    echo "2) Wings Install"
    echo "3) Update Panel"
    echo "4) Uninstall System"
    echo "5) Blueprint Installer"
    echo "6) Cloudflare Setup"
    echo "7) Theme Installer"
    echo "8) Information"
    echo "0) Exit"
    echo "========================================"
    echo ""

    read -rp "Select option: " opt

    case $opt in

        1)
            run_script "https://raw.githubusercontent.com/pterodactylService/PteroShadow/refs/heads/main/cd/panel.sh"
            ;;

        2)
            run_script "https://raw.githubusercontent.com/pterodactylService/PteroShadow/refs/heads/main/cd/wings.sh"
            ;;

        3)
            run_script "https://raw.githubusercontent.com/pterodactylService/PteroShadow/refs/heads/main/cd/up.sh"
            ;;

        4)
            run_script "https://raw.githubusercontent.com/pterodactylService/PteroShadow/refs/heads/main/cd/uninstall.sh"
            ;;

        5)
            run_script "https://raw.githubusercontent.com/pterodactylService/PteroShadow/refs/heads/main/cd/blueprint.sh"
            ;;

        6)
            run_script "https://raw.githubusercontent.com/pterodactylService/PteroShadow/refs/heads/main/cd/cloudflare.sh"
            ;;

        7)
            run_script "https://raw.githubusercontent.com/pterodactylService/PteroShadow/refs/heads/main/cd/th.sh"
            ;;

        8)
            clear
            echo "======================================"
            echo " ShadowCraftMC Automation System"
            echo "--------------------------------------"
            echo " Panel / Wings Installer"
            echo " Auto Update System"
            echo " Blueprint Support"
            echo " Cloudflare Integration"
            echo " Theme Engine"
            echo "======================================"
            ;;

        0)
            echo -e "${GREEN}Exiting ShadowCraftMC 🔥 thanks for using ...${NC}"
            exit 0
            ;;

        *)
            echo -e "${RED}❌ Invalid option${NC}"
            ;;
    esac

    echo ""
    read -rp "Press Enter to continue..."
    clear
done
