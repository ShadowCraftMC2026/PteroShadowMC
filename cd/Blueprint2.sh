#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN} $1 ${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

print_status() { echo -e "${YELLOW}⏳ $1...${NC}"; }
print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

animate_progress() {
    local pid=$1
    local delay=0.1
    local spin='|/-\'
    while ps a | awk '{print $1}' | grep -q "$pid"; do
        printf " [%c]  " "$spin"
        spin=${spin#?}${spin%${spin#?}}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# 🔥 SHADOW ASCII
welcome_animation() {
    clear
    echo -e "${CYAN}"
    echo "  ███████╗██╗  ██╗ █████╗ ██████╗  ██████╗ ██╗    ██╗"
    echo "  ██╔════╝██║  ██║██╔══██╗██╔══██╗██╔═══██╗██║    ██║"
    echo "  ███████╗███████║███████║██║  ██║██║   ██║██║ █╗ ██║"
    echo "  ╚════██║██╔══██║██╔══██║██║  ██║██║   ██║██║███╗██║"
    echo "  ███████║██║  ██║██║  ██║██████╔╝╚██████╔╝╚███╔███╔╝"
    echo "  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚══╝╚══╝ "
    echo -e "${NC}"
    echo -e "${CYAN}        Shadow Blueprint Installer${NC}"
    sleep 2
}

# ✅ INSTALL
install_shadow() {
    print_header "FRESH INSTALLATION (SHADOW)"

    [ "$EUID" -ne 0 ] && { print_error "Run as root"; return 1; }

    print_status "Installing Node.js 20"

    apt-get install -y ca-certificates curl gnupg > /dev/null 2>&1 &
    animate_progress $!

    mkdir -p /etc/apt/keyrings
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
    gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list

    apt update > /dev/null 2>&1 &
    animate_progress $!

    apt install -y nodejs > /dev/null 2>&1 &
    animate_progress $!
    print_success "Node installed"

    # Yarn
    npm i -g yarn > /dev/null 2>&1 &
    animate_progress $!
    print_success "Yarn installed"

    cd /var/www/pterodactyl || return 1

    yarn > /dev/null 2>&1 &
    animate_progress $!

    apt install -y zip unzip git curl wget > /dev/null 2>&1

    print_header "DOWNLOADING BLUEPRINT"

    wget "$(curl -s https://api.github.com/repos/BlueprintFramework/framework/releases/latest \
    | grep browser_download_url | cut -d '"' -f 4)" -O release.zip

    unzip -o release.zip > /dev/null 2>&1

    if [ ! -f blueprint.sh ]; then
        print_error "blueprint.sh not found"
        return 1
    fi

    chmod +x blueprint.sh
    bash blueprint.sh
}

# ✅ REINSTALL
reinstall_shadow() {
    print_header "REINSTALL SHADOW"
    blueprint -rerun-install
}

# ✅ UPDATE
update_shadow() {
    print_header "UPDATE SHADOW"
    blueprint -upgrade
    print_success "Updated"
}

# MENU
show_menu() {
    clear
    echo -e "${CYAN}==== SHADOW BLUEPRINT MENU ====${NC}"
    echo "1) Install"
    echo "2) Reinstall"
    echo "3) Update"
    echo "0) Exit"
}

# MAIN
welcome_animation

while true; do
    show_menu
    read -r choice
    case $choice in
        1) install_shadow ;;
        2) reinstall_shadow ;;
        3) update_shadow ;;
        0) exit ;;
        *) print_error "Invalid option" ;;
    esac
    read -p "Press Enter..."
done
