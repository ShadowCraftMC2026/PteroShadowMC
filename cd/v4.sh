#!/bin/bash

# Benar ASCII Art Banner
cat << "EOF"
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ ____  _               _               @
@/ ___|| |__   __ _  __| | _____      __@
@\___ \| '_ \ / _` |/ _` |/ _ \ \ /\ / /@
@ ___) | | | | (_| | (_| | (_) \ V  V / @
@|____/|_| |_|\__,_|\__,_|\___/ \_/\_/  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
EOF

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale service

# Attempt auto-connect using placeholder key
sudo tailscale up 

echo "Tailscale setup attempted. Login."
