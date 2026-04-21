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

# Banner
clear
echo -e "${BLUE}"
echo "   ██████╗██╗      ██████╗ ██╗   ██╗██████╗ "
echo "  ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗"
echo "  ██║     ██║     ██║   ██║██║   ██║██║  ██║"
echo "  ██║     ██║     ██║   ██║██║   ██║██║  ██║"
echo "  ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝"
echo "   ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ "
echo -e "${NC}"
echo -e "${YELLOW}        Shadow Cloudflare Installer${NC}"
echo ""

print "Starting Cloudflared Installation..."

# 1. Keyrings
print "Creating keyrings directory"
sudo mkdir -p --mode=0755 /usr/share/keyrings

# 2. GPG Key
print "Adding Cloudflare GPG key"
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
| sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# 3. Repo
print "Adding Cloudflare repository"
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main" \
| sudo tee /etc/apt/sources.list.d/cloudflared.list >/dev/null

# 4. Install
print "Installing cloudflared"
sudo apt-get update -y >/dev/null 2>&1
sudo apt-get install -y cloudflared >/dev/null 2>&1

# 5. Verify
if command -v cloudflared >/dev/null 2>&1; then
    success "Cloudflared installed successfully!"

    echo ""
    echo -e "${YELLOW}Next step:${NC}"
    echo "Run: cloudflared tunnel login"
else
    error "Installation failed"
    exit 1
fi
