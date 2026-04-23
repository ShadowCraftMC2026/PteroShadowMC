#!/bin/bash

# ==========================================
#   ShadowCraftMC MAIN MENU (Rainbow Edition)
# ==========================================

# Գույների սահմանում
NC='\033[0m'
R1='\033[38;5;196m'
Y1='\033[38;5;226m'
G1='\033[38;5;46m'
CYAN='\033[38;5;51m'
MAG='\033[38;5;201m'
BLUE='\033[38;5;39m'

# Rainbow գույների զանգված անիմացիայի համար
rainbow_colors=(196 202 208 214 220 226 190 154 118 82 46 47 48 49 50 51 45 39 33 27 21 57 93 129 165 201)

clear

# ===== RAINBOW ANIMATION START =====
# Այս հատվածը ստեղծում է շարժվող գույների էֆեկտը
for i in {1..20}; do
  tput cup 0 0 # Վերադառնալ սկզբին առանց էկրանը թարթելու
  color_code=${rainbow_colors[$RANDOM % ${#rainbow_colors[@]}]}
  color="\033[38;5;${color_code}m"
  
  echo -e "${color} ███████╗ ██╗  ██╗  █████╗  ██████╗   ██████╗  ██╗    ██╗"
  echo -e "${color} ██╔════╝ ██║  ██║ ██╔══██╗ ██╔══██╗ ██╔═══██╗ ██║    ██║"
  echo -e "${color} ███████╗ ███████║ ███████║ ██║  ██║ ██║   ██║ ██║ █╗ ██║"
  echo -e "${color} ╚════██║ ██╔══██║ ██╔══██║ ██║  ██║ ██║   ██║ ██║███╗██║"
  echo -e "${color} ███████║ ██║  ██║ ██║  ██║ ██████╔╝ ╚██████╔╝ ╚███╔███╔╝"
  echo -e "${color} ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═════╝   ╚═════╝   ╚══╝╚══╝"
  echo -e "                      MADE BY  S H A D O W  ⚡${NC}"
  sleep 0.05
done

# Հիմնական ստատիկ բանները (Gradient տեսքով) մենյուի համար
clear
echo -e "${R1} ███████╗ ██╗  ██╗  █████╗  ██████╗   ██████╗  ██╗    ██╗"
echo -e "${R1} ██╔════╝ ██║  ██║ ██╔══██╗ ██╔══██╗ ██╔═══██╗ ██║    ██║"
echo -e "${Y1} ███████╗ ███████║ ███████║ ██║  ██║ ██║   ██║ ██║ █╗ ██║"
echo -e "${G1} ╚════██║ ██╔══██║ ██╔══██║ ██║  ██║ ██║   ██║ ██║███╗██║"
echo -e "${G1} ███████║ ██║  ██║ ██║  ██║ ██████╔╝ ╚██████╔╝ ╚███╔███╔╝"
echo -e "${G1} ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═════╝   ╚═════╝   ╚══╝╚══╝"
echo -e "                      ${Y1}MADE BY  ${R1}S H A D O W  ⚡${NC}"
echo -e ""
echo -e "${CYAN}=================================================${NC}"
echo -e "${MAG}         ⚡ ShadowCraftMC Control Panel ⚡        ${NC}"
echo -e "${CYAN}=================================================${NC}"

# =========================
# 🔐 HIDDEN LINKS (BASE64)
# =========================
decode() { echo "$1" | base64 -d; }

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
echo -e "${G1}[3]${NC} ⬆️ Update"
echo -e "${R1}[4]${NC} 🗑️ Uninstall All"
echo -e "${MAG}[5]${NC} 🧩 Blueprint"
echo -e "${CYAN}[6]${NC} ☁️ Cloudflare Setup"
echo -e "${Y1}[7]${NC} 🎨 Nebula Theme"
echo -e "${BLUE}[8]${NC} 🔐 Tailscale"
echo -e "${BLUE}[9]${NC} 🫆 Database"
echo -e "${R1}[0]${NC} ❌ Exit"

echo ""
echo -ne "${G1}👉 Choose: ${NC}"
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
  echo -e "${BLUE}ShadowCraftMC System v1.0${NC}"
  echo "Made for Pterodactyl automation"
;;
0) 
  echo -e "${R1}Exiting 💣 Thanks For Using...${NC}"
  exit 0
;;
*)
  echo -e "${R1}Invalid option!${NC}"
;;
esac
