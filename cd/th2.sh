#!/bin/bash

# ==============================
# 🔥 Shadow Colors
# ==============================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ==============================
# UI FUNCTIONS
# ==============================
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN} $1 ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_status() { echo -e "${YELLOW}⏳ $1...${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

# ==============================
# ASCII BANNER (SHADOW)
# ==============================
clear
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}"
echo "   ███████╗██╗  ██╗ █████╗ ██████╗ "
echo "   ██╔════╝██║  ██║██╔══██╗██╔══██╗"
echo "   ███████╗███████║███████║██║  ██║"
echo "   ╚════██║██╔══██║██╔══██║██║  ██║"
echo "   ███████║██║  ██║██║  ██║██████╔╝"
echo "   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ "
echo -e "${NC}"
echo -e "${CYAN}         Shadow Blueprint Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

sleep 1

# ==============================
# ROOT CHECK
# ==============================
if [ "$EUID" -ne 0 ]; then
    print_error "Run as root (sudo)"
    exit 1
fi

# ==============================
# TARGET
# ==============================
TARGET_DIR="/var/www/pterodactyl"
TEMP_REPO="/tmp/shadow-blueprint"

print_header "STARTING INSTALLATION"

# ==============================
# CLEAN TEMP
# ==============================
rm -rf "$TEMP_REPO"

# ==============================
# CLONE REPO
# ==============================
print_status "Cloning repository"

git clone https://github.com/nobita586/ak-nobita-bot.git "$TEMP_REPO" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    print_error "Git clone failed"
    exit 1
fi

print_success "Repository cloned"

# ==============================
# FILE CHECK
# ==============================
SOURCE_FILE="$TEMP_REPO/src/nebula.blueprint"

if [ ! -f "$SOURCE_FILE" ]; then
    print_error "nebula.blueprint not found"
    rm -rf "$TEMP_REPO"
    exit 1
fi

# ==============================
# MOVE FILE
# ==============================
mkdir -p "$TARGET_DIR"

mv "$SOURCE_FILE" "$TARGET_DIR/nebula.blueprint"

print_success "Blueprint moved"

# ==============================
# CLEANUP
# ==============================
rm -rf "$TEMP_REPO"

# ==============================
# RUN BLUEPRINT
# ==============================
print_header "EXECUTING BLUEPRINT"

cd "$TARGET_DIR"

if command -v blueprint >/dev/null 2>&1; then
    print_status "Running blueprint"

    blueprint -i nebula.blueprint

    if [ $? -eq 0 ]; then
        print_success "Blueprint executed successfully"
    else
        print_error "Blueprint execution failed"
        exit 1
    fi
else
    print_error "Blueprint not installed"
    echo "Install with:"
    echo "curl -sSL https://blueprintjs.dev/install.sh | bash"
    exit 1
fi

# ==============================
# DONE
# ==============================
print_header "COMPLETE"

echo -e "${GREEN}🎉 Shadow Blueprint installed successfully!${NC}"
echo -e "${CYAN}📁 Location: $TARGET_DIR/nebula.blueprint${NC}"
echo -e "${YELLOW}🚀 Check your panel now${NC}"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}       Shadow Hosting System${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

read -p "Press Enter to exit..."
