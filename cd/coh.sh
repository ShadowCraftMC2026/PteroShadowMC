#!/bin/bash
set -e

# Colors
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
NC="\033[0m"

print() { echo -e "${YELLOW}⏳ $1...${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }

# Banner
clear
echo -e "${BLUE}"
echo "   ██████╗ ██████╗  ██████╗██╗  ██╗██████╗ ██╗████████╗"
echo "  ██╔════╝██╔═══██╗██╔════╝██║ ██╔╝██╔══██╗██║╚══██╔══╝"
echo "  ██║     ██║   ██║██║     █████╔╝ ██████╔╝██║   ██║   "
echo "  ██║     ██║   ██║██║     ██╔═██╗ ██╔═══╝ ██║   ██║   "
echo "  ╚██████╗╚██████╔╝╚██████╗██║  ██╗██║     ██║   ██║   "
echo "   ╚═════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝     ╚═╝   ╚═╝   "
echo -e "${NC}"
echo -e "${YELLOW}        Shadow Cockpit Installer${NC}"
echo ""

print "Updating system"
sudo apt update -y && sudo apt upgrade -y
success "System updated"

# Install Cockpit core
print "Installing Cockpit"
sudo apt install -y cockpit
success "Cockpit installed"

# Safe modules (only ones that exist on most systems)
print "Installing core modules"

MODULES=(
cockpit-machines
cockpit-storaged
cockpit-networkmanager
cockpit-packagekit
cockpit-accounts
cockpit-system
cockpit-bridge
cockpit-ws
)

for module in "${MODULES[@]}"; do
    if apt-cache show "$module" >/dev/null 2>&1; then
        sudo apt install -y "$module"
        success "$module installed"
    else
        echo -e "${RED}⚠️ $module not available, skipped${NC}"
    fi
done

# Enable service
print "Starting Cockpit"
sudo systemctl enable --now cockpit.socket
success "Cockpit started"

# Firewall
print "Opening port 9090"
sudo ufw allow 9090/tcp || true
success "Port 9090 opened"

# Cleanup
print "Cleaning system"
sudo apt autoremove -y
success "Cleanup done"

# Final
IP=$(hostname -I | awk '{print $1}')

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Cockpit Installed Successfully${NC}"
echo -e "${GREEN}🌐 URL: https://${IP}:9090${NC}"
echo -e "${GREEN}👤 Login: server user credentials${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
