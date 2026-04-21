#!/bin/bash
set -e

# =========================
# COLORS
# =========================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

# =========================
# ROOT CHECK
# =========================
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Run as root!${RESET}"
    exit 1
fi

# =========================
# BANNER
# =========================
banner() {
clear
echo -e "${RED}"
cat << "EOF"
 ____  _               _               
/ ___|| |__   __ _  __| | _____      __
\___ \| '_ \ / _` |/ _` |/ _ \ \ /\ / /
 ___) | | | | (_| | (_| | (_) \ V  V / 
|____/|_| |_|\__,_|\__,_|\___/ \_/\_/   

        >>> ShadowCraft Blueprint Installer <<<
EOF
echo -e "${RESET}"
}

# =========================
# SAFE PAUSE
# =========================
pause() {
echo ""
read -p "Press Enter to return to menu..."
}

# =========================
# INSTALL FUNCTION
# =========================
install_blueprint() {
echo -e "${CYAN}>>> Starting Fresh Install...${RESET}"

DISTRO=$(lsb_release -cs)

apt update
apt install -y curl gnupg ca-certificates unzip git wget

mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x $DISTRO main" > /etc/apt/sources.list.d/nodesource.list

apt update
apt install -y nodejs

npm install -g yarn

cd /var/www/pterodactyl || {
    echo -e "${RED}Pterodactyl not installed!${RESET}"
    pause
    return
}

yarn

echo -e "${YELLOW}Downloading Blueprint...${RESET}"

wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest \
| grep browser_download_url | cut -d '"' -f 4)" -O blueprint.zip

unzip -o blueprint.zip

if [ ! -f "blueprint.sh" ]; then
    echo -e "${RED}blueprint.sh not found!${RESET}"
    pause
    return
fi

chmod +x blueprint.sh
bash blueprint.sh

pause
}

# =========================
# REINSTALL
# =========================
reinstall_blueprint() {
echo -e "${CYAN}>>> Reinstalling...${RESET}"

if command -v blueprint &> /dev/null; then
    blueprint -rerun-install
else
    echo -e "${RED}Blueprint command not found!${RESET}"
fi

pause
}

# =========================
# UPDATE
# =========================
update_blueprint() {
echo -e "${CYAN}>>> Updating...${RESET}"

if command -v blueprint &> /dev/null; then
    blueprint -upgrade
    echo -e "${GREEN}Update complete!${RESET}"
else
    echo -e "${RED}Blueprint not installed!${RESET}"
fi

pause
}

# =========================
# MENU
# =========================
while true; do
banner

echo -e "${YELLOW}1) Install Blueprint${RESET}"
echo -e "${CYAN}2) Reinstall${RESET}"
echo -e "${GREEN}3) Update${RESET}"
echo -e "${RED}0) Back to Main Menu${RESET}"
echo ""

read -p "Select option: " choice

case $choice in
    1) install_blueprint ;;
    2) reinstall_blueprint ;;
    3) update_blueprint ;;
    0) continue ;;   # ❗ չի դուրս գալիս, վերադառնում է menu
    *) echo -e "${RED}Invalid option!${RESET}"; pause ;;
esac

done
