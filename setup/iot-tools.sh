#!/bin/bash
# ============================================================
# iot-tools.sh — Module IoT & WiFi (optionnel)
# toolkit v1.1
# ============================================================
# ⚠️  Module optionnel — à lancer séparément
#     sudo bash setup/iot-tools.sh
# ============================================================

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
TOOLS="$REAL_HOME/tools"

RED='\033[0;31m'; GREEN='\033[1;35m'; YELLOW='\033[0;35m'; CYAN='\033[1;34m'; NC='\033[0m'

step() { echo -e "\n${CYAN}[*] ── $1 ──${NC}"; }
ok()   { echo -e "  ${GREEN}[✓]${NC} $1"; }
warn() { echo -e "  ${YELLOW}[!]${NC} $1"; }
fail() { echo -e "  ${RED}[✗]${NC} $1"; }
info() { echo -e "  ${CYAN}[>]${NC} $1"; }

mkdir -p "$TOOLS"

install_apt() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo -e "  \033[0;36m[~]\033[0m $pkg déjà installé — ignoré."
    else
        info "Installation de $pkg..."
        apt-get install -y "$pkg" &>/dev/null && ok "$pkg installé" || fail "Échec : $pkg"
    fi
}

clone_tool() {
    local name="$1"
    local repo="$2"
    local dest="$TOOLS/$name"
    if [ -d "$dest" ]; then
        info "Mise à jour de $name..."
        git -C "$dest" pull -q && ok "$name mis à jour" || warn "$name — échec du pull"
    else
        info "Clonage de $name..."
        git clone --depth=1 "$repo" "$dest" -q \
            && ok "$name cloné dans $dest" \
            && chown -R "$REAL_USER":"$REAL_USER" "$dest" \
            || fail "Échec du clonage de $name"
    fi
}

pipx_install() {
    local pkg="$1"
    if su - "$REAL_USER" -c "pipx list 2>/dev/null" | grep -q "$pkg"; then
        echo -e "  \033[0;36m[~]\033[0m $pkg déjà installé via pipx — ignoré."
    else
        info "pipx install $pkg..."
        su - "$REAL_USER" -c "pipx install $pkg" \
            && ok "$pkg installé" \
            || warn "$pkg — échec de l'installation via pipx"
    fi
}

venv_install_req() {
    local tool_name="$1"
    local tool_dir="$TOOLS/$tool_name"
    local req_file="$tool_dir/requirements.txt"
    local venv_dir="$tool_dir/.venv"

    info "Création d'un venv isolé pour $tool_name..."
    python3 -m venv "$venv_dir" 2>/dev/null \
        && ok "venv créé dans $venv_dir" \
        || { fail "Échec création venv pour $tool_name"; return; }

    info "Installation des dépendances de $tool_name dans le venv..."
    "$venv_dir/bin/pip" install -r "$req_file" -q 2>/dev/null \
        && ok "Dépendances de $tool_name installées" \
        || warn "$tool_name — certaines dépendances ont échoué (ignoré)"

    chown -R "$REAL_USER":"$REAL_USER" "$venv_dir"
}

echo ""
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "${CYAN}   Module IoT & WiFi — toolkit v1.1       ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo ""

apt-get update -qq

# ─────────────────────────────────────────────
# WiFi — Capture & Cracking
# ─────────────────────────────────────────────
step "WiFi — Capture & Cracking"
install_apt aircrack-ng
install_apt hcxdumptool
install_apt hcxtools
install_apt hostapd
install_apt dnsmasq

# ─────────────────────────────────────────────
# MQTT & Protocoles IoT
# ─────────────────────────────────────────────
step "MQTT & Protocoles IoT"
install_apt mosquitto
install_apt mosquitto-clients

# ─────────────────────────────────────────────
# BLE & Bluetooth
# ─────────────────────────────────────────────
step "BLE & Bluetooth"
install_apt bluetooth
install_apt bluez
install_apt ubertooth

# ─────────────────────────────────────────────
# Réseau IoT
# ─────────────────────────────────────────────
step "Réseau IoT"
install_apt bettercap
install_apt arp-scan

# ─────────────────────────────────────────────
# Hardware / Embedded
# ─────────────────────────────────────────────
step "Hardware / Embedded"
install_apt picocom
install_apt minicom
install_apt screen
install_apt openocd
install_apt binwalk

# ─────────────────────────────────────────────
# ESP32 / MicroPython — pipx
# ─────────────────────────────────────────────
step "ESP32 / MicroPython"
pipx_install esptool

# ─────────────────────────────────────────────
# RouterSploit — venv isolé
# ─────────────────────────────────────────────
step "RouterSploit"
clone_tool "routersploit" "https://github.com/threat9/routersploit"

if [ -f "$TOOLS/routersploit/requirements.txt" ]; then
    venv_install_req "routersploit"
    ok "RouterSploit → lancer avec : $TOOLS/routersploit/.venv/bin/python rsf.py"
fi

# ─────────────────────────────────────────────
# Résumé
# ─────────────────────────────────────────────
echo ""
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  [✓] Module IoT & WiFi installé.         ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}  Outils disponibles :${NC}"
echo "  WiFi    : aircrack-ng, hcxdumptool, hcxpcapngtool, hostapd, dnsmasq"
echo "  MQTT    : mosquitto, mosquitto_pub, mosquitto_sub"
echo "  BLE     : hcitool, gatttool, ubertooth"
echo "  Réseau  : bettercap, arp-scan"
echo "  HW      : picocom, minicom, screen, openocd, binwalk"
echo "  ESP32   : esptool (pipx)"
echo "  Exploit : routersploit → $TOOLS/routersploit/.venv/bin/python rsf.py"
echo ""#!/bin/bash
# ============================================================
# iot-tools.sh — Module IoT & WiFi (optionnel)
# toolkit v1.1
# ============================================================
# ⚠️  Module optionnel — à lancer séparément
#     sudo bash setup/iot-tools.sh
# ============================================================

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)
TOOLS="$REAL_HOME/tools"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

step() { echo -e "\n${YELLOW}[*] ── $1 ──${NC}"; }
ok()   { echo -e "  ${GREEN}[✓]${NC} $1"; }
warn() { echo -e "  ${YELLOW}[!]${NC} $1"; }
fail() { echo -e "  ${RED}[✗]${NC} $1"; }
info() { echo -e "  ${YELLOW}[>]${NC} $1"; }

mkdir -p "$TOOLS"

install_apt() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo -e "  \033[0;36m[~]\033[0m $pkg déjà installé — ignoré."
    else
        info "Installation de $pkg..."
        apt-get install -y "$pkg" &>/dev/null && ok "$pkg installé" || fail "Échec : $pkg"
    fi
}

clone_tool() {
    local name="$1"
    local repo="$2"
    local dest="$TOOLS/$name"
    if [ -d "$dest" ]; then
        info "Mise à jour de $name..."
        git -C "$dest" pull -q && ok "$name mis à jour" || warn "$name — échec du pull"
    else
        info "Clonage de $name..."
        git clone --depth=1 "$repo" "$dest" -q \
            && ok "$name cloné dans $dest" \
            && chown -R "$REAL_USER":"$REAL_USER" "$dest" \
            || fail "Échec du clonage de $name"
    fi
}

pip_install() {
    local pkg="$1"
    info "pip install $pkg..."
    pip install "$pkg" \
        --break-system-packages \
        --ignore-installed \
        -q 2>/dev/null \
        && ok "$pkg installé" \
        || warn "$pkg — certaines dépendances déjà gérées par apt (ignoré)"
}

pip_install_req() {
    local req_file="$1"
    local tool_name="$2"
    info "Installation des dépendances de $tool_name..."
    pip install -r "$req_file" \
        --break-system-packages \
        --ignore-installed \
        -q 2>/dev/null \
        && ok "Dépendances de $tool_name installées" \
        || warn "$tool_name — certaines dépendances déjà gérées par apt (ignoré)"
}

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Module IoT & WiFi — toolkit v1.1       ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""

apt-get update -qq

# ─────────────────────────────────────────────
# WiFi — Capture & Cracking
# ─────────────────────────────────────────────
step "WiFi — Capture & Cracking"
install_apt aircrack-ng
install_apt hcxdumptool
install_apt hcxtools
install_apt hostapd
install_apt dnsmasq

# ─────────────────────────────────────────────
# MQTT & Protocoles IoT
# ─────────────────────────────────────────────
step "MQTT & Protocoles IoT"
install_apt mosquitto
install_apt mosquitto-clients

# ─────────────────────────────────────────────
# BLE & Bluetooth
# ─────────────────────────────────────────────
step "BLE & Bluetooth"
install_apt bluetooth
install_apt bluez
install_apt ubertooth

# ─────────────────────────────────────────────
# Réseau IoT
# ─────────────────────────────────────────────
step "Réseau IoT"
install_apt bettercap
install_apt arp-scan

# ─────────────────────────────────────────────
# Hardware / Embedded
# ─────────────────────────────────────────────
step "Hardware / Embedded"
install_apt picocom
install_apt minicom
install_apt screen
install_apt openocd
install_apt binwalk

# ─────────────────────────────────────────────
# ESP32 / MicroPython
# ─────────────────────────────────────────────
step "ESP32 / MicroPython"
pip_install esptool

# ─────────────────────────────────────────────
# RouterSploit
# ─────────────────────────────────────────────
step "RouterSploit"
clone_tool "routersploit" "https://github.com/threat9/routersploit"

if [ -f "$TOOLS/routersploit/requirements.txt" ]; then
    pip_install_req "$TOOLS/routersploit/requirements.txt" "RouterSploit"
fi

# ─────────────────────────────────────────────
# Résumé
# ─────────────────────────────────────────────
echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  [✓] Module IoT & WiFi installé.         ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}  Outils disponibles :${NC}"
echo "  WiFi    : aircrack-ng, hcxdumptool, hcxpcapngtool, hostapd, dnsmasq"
echo "  MQTT    : mosquitto, mosquitto_pub, mosquitto_sub"
echo "  BLE     : hcitool, gatttool, ubertooth"
echo "  Réseau  : bettercap, arp-scan"
echo "  HW      : picocom, minicom, screen, openocd, binwalk"
echo "  ESP32   : esptool"
echo "  Exploit : routersploit → $TOOLS/routersploit/rsf.py"
echo ""
