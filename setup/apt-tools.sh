#!/bin/bash
# ============================================================
# apt-tools.sh — Installation des outils via apt
# toolkit v1.1
# ============================================================

set -e

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

install_apt() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo -e "  ${YELLOW}[~]${NC} $pkg déjà installé"
    else
        echo -e "  ${GREEN}[+]${NC} Installation de $pkg..."
        apt install -y "$pkg" 2>/dev/null && \
            echo -e "  ${GREEN}[✓]${NC} $pkg installé" || \
            echo -e "  ${RED}[✗]${NC} Échec : $pkg"
    fi
}

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Installation des outils apt — v1.1     ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""

apt update -qq

# ─────────────────────────────────────────────
# Recon & OSINT
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Recon & OSINT${NC}"
install_apt nmap
install_apt amass
install_apt dnsenum
install_apt whatweb
install_apt exiftool
install_apt sherlock
install_apt maltego

# ─────────────────────────────────────────────
# Web
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Web${NC}"
install_apt burpsuite
install_apt zaproxy
install_apt ffuf
install_apt gobuster
install_apt feroxbuster
install_apt nikto
install_apt curl
install_apt dirb
install_apt wfuzz
install_apt sqlmap
install_apt wafw00f

# ─────────────────────────────────────────────
# Réseau & Enumération
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Réseau & Enumération${NC}"
install_apt netcat-traditional
install_apt hydra
install_apt enum4linux
install_apt nbtscan
install_apt onesixtyone
install_apt snmp
install_apt macchanger
install_apt wireshark
install_apt tcpdump
install_apt ncat

# ─────────────────────────────────────────────
# Bases de données
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Bases de données${NC}"
install_apt default-mysql-client
install_apt postgresql-client

# ─────────────────────────────────────────────
# Passwords & Brute Force
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Passwords & Brute Force${NC}"
install_apt hashcat
install_apt john
install_apt crunch
install_apt medusa
install_apt ncrack

# ─────────────────────────────────────────────
# Reverse Engineering — Analyse statique
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Reverse Engineering${NC}"
install_apt gdb
install_apt binutils         # readelf, objdump, strings, nm, file
install_apt strace
install_apt ltrace
install_apt binwalk
install_apt upx-ucl

# ─────────────────────────────────────────────
# Exploitation
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Exploitation${NC}"
install_apt metasploit-framework

# ─────────────────────────────────────────────
# Utils
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Utils${NC}"
install_apt tmux
install_apt git
install_apt python3-pip
install_apt jq
install_apt wget
install_apt unzip
install_apt golang-go
install_apt ruby
install_apt gem

echo ""
echo -e "${GREEN}[✓] Installation apt terminée.${NC}"
