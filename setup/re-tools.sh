#!/bin/bash
# ============================================================
# re-tools.sh — Module Reverse Engineering (optionnel)
# toolkit v1.1
# ============================================================
# ⚠️  Module optionnel — Ghidra pèse ~1 Go
#     Lancer séparément : sudo bash setup/re-tools.sh
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

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Module Reverse Engineering — v1.1      ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""

apt update -qq

# ─────────────────────────────────────────────
# Analyse statique CLI (inclus dans binutils)
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Analyse statique CLI${NC}"
install_apt gdb
install_apt binutils       # readelf, objdump, strings, nm, file
install_apt strace
install_apt ltrace
install_apt binwalk
install_apt upx-ucl

# ─────────────────────────────────────────────
# pwndbg — extension GDB pour CTF
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] pwndbg (extension GDB)${NC}"
if [ ! -d "$TOOLS/pwndbg" ]; then
    echo -e "  ${GREEN}[+]${NC} Clonage de pwndbg..."
    git clone --depth=1 "https://github.com/pwndbg/pwndbg" "$TOOLS/pwndbg"
    cd "$TOOLS/pwndbg" && ./setup.sh
    echo -e "  ${GREEN}[✓]${NC} pwndbg installé"
else
    echo -e "  ${YELLOW}[~]${NC} pwndbg déjà installé"
fi

# ─────────────────────────────────────────────
# pwntools — framework Python exploit dev
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] pwntools${NC}"
pip install pwntools --break-system-packages && \
    echo -e "  ${GREEN}[✓]${NC} pwntools installé" || \
    echo -e "  ${RED}[✗]${NC} Échec pwntools"

# checksec
pip install checksec --break-system-packages 2>/dev/null || \
    apt install checksec -y 2>/dev/null || true
echo -e "  ${GREEN}[✓]${NC} checksec installé"

# ─────────────────────────────────────────────
# Ghidra — Désassembleur/Décompilateur NSA
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Ghidra (~1 Go)${NC}"
echo -e "  ${YELLOW}[?]${NC} Installer Ghidra ? (nécessite Java + ~1 Go) [y/N] "
read -r choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    # Prérequis Java
    install_apt openjdk-17-jdk

    GHIDRA_VERSION="11.3.1"
    GHIDRA_DATE="20250219"
    GHIDRA_ZIP="ghidra_${GHIDRA_VERSION}_PUBLIC_${GHIDRA_DATE}.zip"
    GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_VERSION}_build/${GHIDRA_ZIP}"

    if [ ! -d "$TOOLS/ghidra_${GHIDRA_VERSION}_PUBLIC" ]; then
        echo -e "  ${GREEN}[+]${NC} Téléchargement de Ghidra ${GHIDRA_VERSION}..."
        wget -q --show-progress "$GHIDRA_URL" -O "/tmp/${GHIDRA_ZIP}"
        unzip -q "/tmp/${GHIDRA_ZIP}" -d "$TOOLS/"
        rm "/tmp/${GHIDRA_ZIP}"
        # Alias pour le bon répertoire
        ln -sfn "$TOOLS/ghidra_${GHIDRA_VERSION}_PUBLIC" "$TOOLS/ghidra"
        echo -e "  ${GREEN}[✓]${NC} Ghidra installé dans $TOOLS/ghidra"
    else
        echo -e "  ${YELLOW}[~]${NC} Ghidra déjà installé"
    fi
else
    echo -e "  ${YELLOW}[-]${NC} Ghidra ignoré."
fi

# ─────────────────────────────────────────────
# Résumé
# ─────────────────────────────────────────────
echo ""
echo -e "${GREEN}[✓] Module RE installé.${NC}"
echo -e "\n${YELLOW}Outils disponibles :${NC}"
echo "  gdb, readelf, objdump, strings, nm, strace, ltrace"
echo "  binwalk, upx, pwndbg, pwntools, checksec"
[[ "$choice" =~ ^[Yy]$ ]] && echo "  ghidra → \$TOOLS/ghidra/ghidraRun"
