#!/bin/bash
set -e

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

print() {
    echo -e "${GREEN}[*] $1${NC}"
}

success() {
    echo -e "${GREEN}[✓] $1${NC}"
}

error() {
    echo -e "${RED}[✗] $1${NC}"
}

pause() {
    echo ""
    read -p "Press Enter to return..." 
}

# Banner
banner() {
clear
echo -e "${BLUE}"
echo "   ██████╗██╗      ██████╗ ██╗   ██╗██████╗ "
echo "  ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗"
echo "  ██║     ██║     ██║   ██║██║   ██║██║  ██║"
echo "  ██║     ██║     ██║   ██║██║   ██║██║  ██║"
echo "  ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝"
echo "   ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ "
echo -e "${NC}"
echo -e "${YELLOW}        ShadowCraft Cloudflare Manager${NC}"
echo ""
}

install_cf() {
print "Installing Cloudflared..."

sudo mkdir -p --mode=0755 /usr/share/keyrings

curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
| sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" \
| sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null

sudo apt-get update -y >/dev/null 2>&1
sudo apt-get install -y cloudflared >/dev/null 2>&1

if command -v cloudflared >/dev/null 2>&1; then
    success "Cloudflared installed!"
else
    error "Install failed!"
fi
}

login_cf() {
print "Paste your Cloudflare token"
echo ""

read -p "Token: " CF_TOKEN

if [[ -z "$CF_TOKEN" ]]; then
    error "Token cannot be empty!"
    return
fi

print "Starting tunnel..."

# Run tunnel using token
cloudflared tunnel --no-autoupdate run --token "$CF_TOKEN" &
sleep 2

success "Tunnel started!"
echo ""
echo -e "${YELLOW}👉 Now your site is accessible via Cloudflare Tunnel${NC}"
}

# ===== MENU =====
while true; do
banner

echo -e "${YELLOW}1) Install Cloudflared${NC}"
echo -e "${CYAN}2) login tunnel${NC}"
echo -e "${RED}0) Back${NC}"
echo ""

read -p "Select option: " choice

case $choice in
    1) install_cf ;;
    2) login_cf ;;
    0) break ;;
    *) echo -e "${RED}Invalid option!${NC}" ;;
esac

pause
done
