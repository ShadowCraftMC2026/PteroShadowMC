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
   ____    _   _      _      ____     ___   __        __   ____   ____       _      _____   _____ 
/ ___|  | | | |    / \    |  _ \   / _ \  \ \      / /  / ___| |  _ \     / \    |  ___| |_   _|
\___ \  | |_| |   / _ \   | | | | | | | |  \ \ /\ / /  | |     | |_) |   / _ \   | |_      | |  
 ___) | |  _  |  / ___ \  | |_| | | |_| |   \ V  V /   | |___  |  _ <   / ___ \  |  _|     | |  
|____/  |_| |_| /_/   \_\ |____/   \___/     \_/\_/     \____| |_| \_\ /_/   \_\ |_|       |_|  
EOF
echo -e "${NC}"

echo -e "${CYAN}=========================================${NC}"
echo -e "${MAGENTA}      ⚡ ShadowCraftMC Control Panel ⚡   ${NC}"
echo -e "${CYAN}=========================================${NC}"

#!/bin/bash

# ==============================
#   ShadowCraftMC MAIN MENU
# ==============================

RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
GREEN='\033[0;32m'
NC='\033[0m'

clear

echo -e "${RED}"
cat << "EOF"
   ____    _   _      _      ____     ___
SHADOWCRAFTMC PANEL
EOF
echo -e "${NC}"

echo -e "${CYAN}ShadowCraftMC Control Panel${NC}"
echo ""

# =========================
# 🔐 HIDDEN LINKS (BASE64)
# =========================

decode() {
  echo "$1" | base64 -d
}

PANEL="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL3BhbmVsLnNo"
WINGS="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL3dpbmdzLnNo"
UPDATE="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL3VwLnNo"
UNINSTALL="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL3VuaW5zdGFsbC5zaA=="
BLUEPRINT="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL2JsdWVwcmludC5zaA=="
CLOUDFLARE="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL2Nsb3VkZmxhcmUuc2g="
THEME="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL3RoLnNo"

run() {
  url=$(decode "$1")
  bash <(curl -fsSL "$url")
}

# =========================
# MENU
# =========================

echo -e "${YELLOW}[1]${NC} 🔥 Install Panel"
echo -e "${BLUE}[2]${NC} 🐉 Install Wings"
echo -e "${GREEN}[3]${NC} ⬆️ Update"
echo -e "${RED}[4]${NC} 🗑️ Uninstall"
echo -e "${MAGENTA}[5]${NC} 🧩 Blueprint"
echo -e "${CYAN}[6]${NC} ☁️ Cloudflare Setup"
echo -e "${YELLOW}[7]${NC} 🎨 Theme"
echo -e "${RED}[0]${NC} ❌ Exit"

echo ""
read -p "👉 Choose: " opt

case $opt in
1) run "$PANEL" ;;
2) run "$WINGS" ;;
3) run "$UPDATE" ;;
4) run "$UNINSTALL" ;;
5) run "$BLUEPRINT" ;;
6) run "$CLOUDFLARE" ;;
7) run "$THEME" ;;

  echo "ShadowCraftMC Pterodactyl System"
  echo "Version: 1.0"
;;
0) exit 0 ;;
*) echo "Invalid option" ;;
esac
