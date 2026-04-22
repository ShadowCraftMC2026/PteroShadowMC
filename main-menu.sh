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
 ███████╗ ██╗  ██╗  █████╗  ██████╗   ██████╗  ██╗    ██╗
 ██╔════╝ ██║  ██║ ██╔══██╗ ██╔══██╗ ██╔═══██╗ ██║    ██║
 ███████╗ ███████║ ███████║ ██║  ██║ ██║   ██║ ██║ █╗ ██║
 ╚════██║ ██╔══██║ ██╔══██║ ██║  ██║ ██║   ██║ ██║███╗██║
 ███████║ ██║  ██║ ██║  ██║ ██████╔╝ ╚██████╔╝ ╚███╔███╔╝
 ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═════╝   ╚═════╝   ╚══╝╚══╝            

                      MADE BY  S H A D O W  ⚡
EOF
echo -e "${NC}"

echo -e "${CYAN}=========================================${NC}"
echo -e "${MAGENTA}      ⚡ ShadowCraftMC Control Panel ⚡   ${NC}"
echo -e "${CYAN}=========================================${NC}"

# 
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
TAILSCALE="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL3Y0LnNo"
DATABASE="aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1NoYWRvd0NyYWZ0TUMyMDI2L1B0ZXJvU2hhZG93TUMvcmVmcy9oZWFkcy9tYWluL2NkL2RhdGFiYXNlLnNo"

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
echo -e "${RED}[4]${NC} 🗑️ Uninstall All"
echo -e "${MAGENTA}[5]${NC} 🧩 Blueprint"
echo -e "${CYAN}[6]${NC} ☁️ Cloudflare Setup"
echo -e "${YELLOW}[7]${NC} 🎨 Nebula Theme"
echo -e "${BLUE}[8]${NC} 🔐 Tailscale"
echo -e "${BLUE}[9]${NC} 🫆 Databse"
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
8) run "$TAILSCALE" ;;
9) run "$DATABASE" ;;
10)
  echo -e "${BLUE}"
  echo "ShadowCraftMC System"
  echo "Made for Pterodactyl automation"
  echo "Version: 1.0"
  echo -e "${NC}"
;;
0) 
  echo -e "${RED}Exiting 💣 Thanks For Using...${NC}"
  exit 0
;;
*)
  echo -e "${RED}Invalid option!${NC}"
;;
esac
