#!/bin/bash

# ==============================
#   ShadowCraftMC MAIN MENU
# ==============================

# COLORS
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
NC='\033[0m'

clear

# ===== ASCII BANNER =====
echo -e "${RED}"
cat << "EOF"
 ____    _   _      _      ____     ___   __        __   ____   ____       _      _____   _____   __  __    ____ 
/ ___|  | | | |    / \    |  _ \   / _ \  \ \      / /  / ___| |  _ \     / \    |  ___| |_   _| |  \/  |  / ___|
\___ \  | |_| |   / _ \   | | | | | | | |  \ \ /\ / /  | |     | |_) |   / _ \   | |_      | |   | |\/| | | |    
 ___) | |  _  |  / ___ \  | |_| | | |_| |   \ V  V /   | |___  |  _ <   / ___ \  |  _|     | |   |  |  | | | |___ 
|____/  |_| |_| /_/   \_\ |____/   \___/     \_/\_/     \____| |_| \_\ /_/   \_\ |_|       |_|   |_|  |_|  \____|
EOF
echo -e "${NC}"

echo -e "${CYAN}=========================================${NC}"
echo -e "${MAGENTA}      ⚡ ShadowCraftMC Control Panel ⚡   ${NC}"
echo -e "${CYAN}=========================================${NC}"

echo -e ""
echo -e "${YELLOW}[1]${NC} 🔥 Install Pterodactyl Panel"
echo -e "${BLUE}[2]${NC} 🐉 Install Wings"
echo -e "${GREEN}[3]${NC} ⬆️  Update System"
echo -e "${RED}[4]${NC} 🗑️  Uninstall System"
echo -e "${MAGENTA}[5]${NC} 🧩 Blueprint Installer"
echo -e "${CYAN}[6]${NC} ☁️  Cloudflare Setup"
echo -e "${YELLOW}[7]${NC} 🎨 Theme Installer"
echo -e "${BLUE}[8]${NC} ℹ️  Information"
echo -e "${RED}[0]${NC} ❌ Exit"

echo ""
read -p "👉 Choose option: " opt

case $opt in

1)
echo -e "${GREEN}Installing Panel...${NC}"
bash <(curl -s https://ptero.pixelzone.qzz.io/panel.sh)
;;

2)
echo -e "${GREEN}Installing Wings...${NC}"
bash <(curl -s https://ptero.pixelzone.qzz.io/wings.sh)
;;

3)
echo -e "${GREEN}Updating...${NC}"
bash <(curl -s https://ptero.pixelzone.qzz.io/update.sh)
;;

4)
echo -e "${RED}Uninstalling...${NC}"
bash <(curl -s https://ptero.pixelzone.qzz.io/uninstall.sh)
;;

5)
echo -e "${MAGENTA}Blueprint...${NC}"
bash <(curl -s https://ptero.pixelzone.qzz.io/blueprint.sh)
;;

6)
echo -e "${CYAN}Cloudflare Setup...${NC}"
bash <(curl -s https://ptero.pixelzone.qzz.io/cloudflare.sh)
;;

7)
echo -e "${YELLOW}Theme Installer...${NC}"
bash <(curl -s https://ptero.pixelzone.qzz.io/th.sh)
;;

8)
echo -e "${BLUE}"
echo "ShadowCraftMC System"
echo "Made for Pterodactyl automation"
echo "Version: 1.0"
echo -e "${NC}"
;;

0)
echo -e "${RED}Exiting...${NC}"
exit 0
;;

*)
echo -e "${RED}Invalid option!${NC}"
;;

esac
