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

clear
echo -e "${CYAN}==== PTERODACTYL WINGS INSTALLER ==== ${RESET}"

# =========================
# RAM CHECK (IMPORTANT)
# =========================
RAM=$(free -m | awk '/Mem:/ {print $2}')
if [ "$RAM" -lt 1500 ]; then
    echo -e "${RED}⚠️ WARNING: Low RAM (${RAM}MB). Wings may crash!${RESET}"
fi

# =========================
# DOCKER INSTALL
# =========================
if command -v docker &> /dev/null; then
    echo -e "${GREEN}[✔] Docker already installed${RESET}"
else
    echo -e "${YELLOW}Installing Docker...${RESET}"
    curl -sSL https://get.docker.com | bash
    systemctl enable --now docker
    echo -e "${GREEN}[✔] Docker installed${RESET}"
fi

# =========================
# INSTALL WINGS
# =========================
echo -e "${YELLOW}Installing Wings...${RESET}"
mkdir -p /etc/pterodactyl

ARCH=$(uname -m)
[ "$ARCH" == "x86_64" ] && ARCH="amd64" || ARCH="arm64"

curl -L -o /usr/local/bin/wings \
https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$ARCH

chmod +x /usr/local/bin/wings
echo -e "${GREEN}[✔] Wings installed${RESET}"

# =========================
# SERVICE
# =========================
echo -e "${YELLOW}Creating service...${RESET}"

cat > /etc/systemd/system/wings.service <<EOF
[Unit]
Description=Pterodactyl Wings
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
ExecStart=/usr/local/bin/wings
Restart=always
RestartSec=5s
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wings

# =========================
# FIREWALL FIX
# =========================
echo -e "${YELLOW}Opening ports...${RESET}"
ufw allow 8080 || true
ufw allow 2022 || true

# =========================
# SSL (OPTIONAL)
# =========================
mkdir -p /etc/certs/wing
openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
-subj "/CN=Wings" \
-keyout /etc/certs/wing/privkey.pem \
-out /etc/certs/wing/fullchain.pem

# =========================
# AUTO CONFIG
# =========================
echo ""
read -p "Auto configure Wings? (y/n): " AUTO

if [[ "$AUTO" =~ ^[Yy]$ ]]; then

    read -p "UUID: " UUID
    read -p "Token ID: " TOKEN_ID
    read -p "Token: " TOKEN
    read -p "Panel URL: " REMOTE

    cat > /etc/pterodactyl/config.yml <<CFG
debug: false
uuid: ${UUID}
token_id: ${TOKEN_ID}
token: ${TOKEN}

api:
  host: 0.0.0.0
  port: 8080
  ssl:
    enabled: false

system:
  data: /var/lib/pterodactyl/volumes
  sftp:
    bind_port: 2022

allowed_mounts: []
remote: '${REMOTE}'
CFG

    echo -e "${GREEN}[✔] Config saved${RESET}"
fi

# =========================
# START SERVICE
# =========================
echo -e "${YELLOW}Starting Wings...${RESET}"

systemctl restart wings || true
sleep 2

if systemctl is-active --quiet wings; then
    echo -e "${GREEN}[✔] Wings is running${RESET}"
else
    echo -e "${RED}[!] Wings failed to start${RESET}"
    echo "Check logs:"
    echo "journalctl -u wings -f"
fi

# =========================
# DONE
# =========================
echo ""
echo -e "${GREEN}===== INSTALL COMPLETE =====${RESET}"
echo -e "${CYAN}Start:${RESET} systemctl start wings"
echo -e "${CYAN}Status:${RESET} systemctl status wings"
echo -e "${CYAN}Logs:${RESET} journalctl -u wings -f"
