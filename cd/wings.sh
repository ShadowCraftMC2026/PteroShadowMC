#!/bin/bash
set -e

# =========================
# COLORS
# =========================
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
RESET='\033[0m'

echo -e "${CYAN}[*] Starting Pterodactyl Wings setup...${RESET}"

# =========================
# 1. Docker Install
# =========================
if command -v docker &> /dev/null; then
    echo -e "${GREEN}[✔] Docker already installed${RESET}"
else
    echo -e "${YELLOW}[*] Installing Docker...${RESET}"
    curl -sSL https://get.docker.com/ | CHANNEL=stable bash
    systemctl enable --now docker
    echo -e "${GREEN}[✔] Docker installed${RESET}"
fi

# =========================
# 2. GRUB (optional fix)
# =========================
GRUB_FILE="/etc/default/grub"
if [ -f "$GRUB_FILE" ]; then
    echo -e "${YELLOW}[*] Updating GRUB (swapaccount)...${RESET}"
    sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="swapaccount=1"/' $GRUB_FILE || true
    update-grub || true
fi

# =========================
# 3. Install Wings
# =========================
echo -e "${YELLOW}[*] Installing Wings...${RESET}"
mkdir -p /etc/pterodactyl

ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
else
    ARCH="arm64"
fi

curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$ARCH"
chmod +x /usr/local/bin/wings

echo -e "${GREEN}[✔] Wings installed${RESET}"

# =========================
# 4. Wings Service
# =========================
echo -e "${YELLOW}[*] Creating Wings service...${RESET}"

tee /etc/systemd/system/wings.service > /dev/null <<EOF
[Unit]
Description=Pterodactyl Wings Daemon
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

echo -e "${GREEN}[✔] Service created${RESET}"

# =========================
# 5. SSL (optional)
# =========================
echo -e "${YELLOW}[*] Generating self-signed SSL...${RESET}"
mkdir -p /etc/certs/wing
cd /etc/certs/wing

openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 \
-subj "/C=NA/ST=NA/L=NA/O=NA/CN=Wing" \
-keyout privkey.pem -out fullchain.pem

echo -e "${GREEN}[✔] SSL generated${RESET}"

# =========================
# 6. Helper command
# =========================
tee /usr/local/bin/wing > /dev/null <<'EOF'
#!/bin/bash
echo "Start Wings:"
echo "  sudo systemctl start wings"
echo ""
echo "Check status:"
echo "  systemctl status wings"
EOF

chmod +x /usr/local/bin/wing

# =========================
# 7. Auto Config
# =========================
echo ""
read -p "Auto configure Wings now? (y/n): " AUTO

if [[ "$AUTO" =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}[*] Enter panel data...${RESET}"

    read -p "UUID: " UUID
    read -p "Token ID: " TOKEN_ID
    read -p "Token: " TOKEN
    read -p "Panel URL: " REMOTE

    mkdir -p /etc/pterodactyl

    tee /etc/pterodactyl/config.yml > /dev/null <<CFG
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

    echo -e "${GREEN}[✔] Config created${RESET}"

    systemctl start wings

    echo -e "${GREEN}[✔] Wings started${RESET}"
else
    echo -e "${YELLOW}[!] Skipped config${RESET}"
fi

# =========================
# DONE
# =========================
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${GREEN} ✔ Wings installation completed! ${RESET}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${CYAN}Run:${RESET} systemctl start wings"
echo -e "${CYAN}Status:${RESET} systemctl status wings"
echo ""
