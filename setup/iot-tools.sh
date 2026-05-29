#!/bin/bash
# ============================================================
# iot-tools.sh — Module IoT & WiFi (optionnel)
# toolkit v1.1
# ============================================================
# ⚠️  Module optionnel — à lancer séparément
#     sudo bash setup/iot-tools.sh
# ============================================================

set -e

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
TOOLS="$REAL_HOME/tools"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

mkdir -p "$TOOLS"

install_apt() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo -e "  ${YELLOW}[~]${NC} $pkg déjà installé"
    else
        apt install -y "$pkg" 2>/dev/null && \
            echo -e "  ${GREEN}[✓]${NC} $pkg" || \
            echo -e "  ${RED}[✗]${NC} Échec : $pkg"
    fi
}

clone_tool() {
    local name="$1"
    local repo="$2"
    if [ -d "$TOOLS/$name" ]; then
        echo -e "  ${YELLOW}[~]${NC} $name déjà cloné"
    else
        git clone --depth=1 "$repo" "$TOOLS/$name" 2>/dev/null && \
            echo -e "  ${GREEN}[✓]${NC} $name cloné" || \
            echo -e "  ${RED}[✗]${NC} Échec : $name"
    fi
}

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Module IoT & WiFi — v1.1               ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""

apt update -qq

# ─────────────────────────────────────────────
# WiFi — Capture & Cracking
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] WiFi — Capture & Cracking${NC}"
install_apt aircrack-ng
install_apt hcxdumptool
install_apt hcxtools          # hcxpcapngtool inclus
install_apt hostapd
install_apt dnsmasq

# ─────────────────────────────────────────────
# MQTT & Protocoles IoT
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] MQTT & Protocoles IoT${NC}"
install_apt mosquitto
install_apt mosquitto-clients

# ─────────────────────────────────────────────
# BLE & Bluetooth
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] BLE & Bluetooth${NC}"
install_apt bluetooth
install_apt bluez              # hcitool, gatttool inclus
install_apt ubertooth

# ─────────────────────────────────────────────
# Réseau IoT
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Réseau IoT${NC}"
install_apt bettercap
install_apt arp-scan

# ─────────────────────────────────────────────
# Hardware / Embedded
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Hardware / Embedded${NC}"
install_apt picocom
install_apt minicom
install_apt screen
install_apt openocd
install_apt binwalk

# ─────────────────────────────────────────────
# ESP32 / MicroPython
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] ESP32 / MicroPython${NC}"
pip install esptool --break-system-packages && \
    echo -e "  ${GREEN}[✓]${NC} esptool installé" || \
    echo -e "  ${RED}[✗]${NC} Échec esptool"

# ─────────────────────────────────────────────
# RouterSploit — Exploitation routeurs
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] RouterSploit${NC}"
if [ ! -d "$TOOLS/routersploit" ]; then
    git clone --depth=1 "https://github.com/threat9/routersploit" "$TOOLS/routersploit"
    pip install -r "$TOOLS/routersploit/requirements.txt" --break-system-packages
    echo -e "  ${GREEN}[✓]${NC} RouterSploit installé"
else
    echo -e "  ${YELLOW}[~]${NC} RouterSploit déjà installé"
fi

# ─────────────────────────────────────────────
# Résumé
# ─────────────────────────────────────────────
echo ""
echo -e "${GREEN}[✓] Module IoT & WiFi installé.${NC}"
echo -e "\n${YELLOW}Outils disponibles :${NC}"
echo "  WiFi    : aircrack-ng, hcxdumptool, hcxpcapngtool, hostapd, dnsmasq"
echo "  MQTT    : mosquitto, mosquitto_pub, mosquitto_sub"
echo "  BLE     : hcitool, gatttool, ubertooth"
echo "  Réseau  : bettercap, arp-scan"
echo "  HW      : picocom, minicom, screen, openocd, binwalk"
echo "  ESP32   : esptool"
echo "  Exploit : routersploit (\$TOOLS/routersploit)"
