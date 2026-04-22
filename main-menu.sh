#!/bin/bash

# ==========================================
#   ShadowCraftMC MAIN MENU (Color Edition)
# ==========================================

# COLORS (256-bit Palette for better look)
R1='\033[38;5;196m' # Red
R2='\033[38;5;202m' # Orange-Red
Y1='\033[38;5;226m' # Yellow
G1='\033[38;5;118m' # Light Green
G2='\033[38;5;46m'  # Bright Green
CYAN='\033[38;5;51m'
MAG='\033[38;5;201m'
BLUE='\033[38;5;39m'
NC='\033[0m' # No Color

clear

# ===== ASCII BANNER (Gradient SHADOW) =====
echo -e "${R1} ███████╗ ██╗  ██╗  █████╗  ██████╗   ██████╗  ██╗    ██╗"
echo -e "${R2} ██╔════╝ ██║  ██║ ██╔══██╗ ██╔══██╗ ██╔═══██╗ ██║    ██║"
echo -e "${Y1} ███████╗ ███████║ ███████║ ██║  ██║ ██║   ██║ ██║ █╗ ██║"
echo -e "${G1} ╚════██║ ██╔══██║ ██╔══██║ ██║  ██║ ██║   ██║ ██║███╗██║"
echo -e "${G2} ███████║ ██║  ██║ ██║  ██║ ██████╔╝ ╚██████╔╝ ╚███╔███╔╝"
echo -e "${G2} ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═════╝   ╚═════╝   ╚══╝╚══╝"

echo -e "                      ${Y1}MADE BY  ${R1}S H A D O W  ⚡${NC}"
echo -e ""
echo -e "${CYAN}=================================================${NC}"
echo -e "${MAG}         ⚡ ShadowCraftMC Control Panel ⚡        ${NC}"
echo -e "${CYAN}=================================================${NC}"

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

echo -e "${Y1}[1]${NC} 🔥 Install Panel"
echo -e "${BLUE}[2]${NC} 🐉 Install Wings"
echo -e "${G2}[3]${NC} ⬆️ Update"
echo -e "${R1}[4]${NC} 🗑️ Uninstall All"
echo -e "${MAG}[5]${NC} 🧩 Blueprint"
echo -e "${CYAN}[6]${NC} ☁️ Cloudflare Setup"
echo -e "${Y1}[7]${NC} 🎨 Nebula Theme"
echo -e "${BLUE}[8]${NC} 🔐 Tailscale"
echo -e "${BLUE}[9]${NC} 🫆 Database"
echo -e "${R1}[0]${NC} ❌ Exit"

echo ""
echo -ne "${G2}👉 Choose: ${NC}"
read opt

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
  echo -e "${R1}Exiting 💣 Thanks For Using...${NC}"
  exit 0
;;
*)
  echo -e "${R1}Invalid option!${NC}"
;;
esac
