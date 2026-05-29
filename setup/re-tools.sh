#!/bin/bash
# ============================================================
# re-tools.sh — Module Reverse Engineering (optionnel)
# toolkit v1.1
# ============================================================
# ⚠️  Module optionnel — Ghidra pèse ~1 Go
#     Lancer séparément : sudo bash setup/re-tools.sh
# ============================================================

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
TOOLS="$REAL_HOME/tools"

RED='\033[0;31m'; GREEN='\033[1;35m'; YELLOW='\033[0;35m'; CYAN='\033[1;34m'; NC='\033[0m'

mkdir -p "$TOOLS"

install_apt() {
    local pkg="$1"
    if dpkg -s "$pkg" &>/dev/null; then
        echo -e "  \033[0;36m[~]\033[0m $pkg déjà installé"
    else
        apt install -y "$pkg" 2>/dev/null && \
            echo -e "  ${GREEN}[✓]${NC} $pkg" || \
            echo -e "  ${RED}[✗]${NC} Échec : $pkg"
    fi
}

pipx_install() {
    local pkg="$1"
    if pipx list 2>/dev/null | grep -q "$pkg"; then
        echo -e "  \033[0;36m[~]\033[0m $pkg déjà installé via pipx"
    else
        echo -e "  ${CYAN}[+]${NC} pipx install $pkg..."
        su - "$REAL_USER" -c "pipx install $pkg" \
            && echo -e "  ${GREEN}[✓]${NC} $pkg installé" \
            || echo -e "  ${RED}[✗]${NC} Échec : $pkg"
    fi
}

echo ""
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "${CYAN}   Module Reverse Engineering — v1.1      ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo ""

apt update -qq

# ─────────────────────────────────────────────
# Analyse statique CLI
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
    echo -e "  ${CYAN}[+]${NC} Clonage de pwndbg..."
    git clone --depth=1 "https://github.com/pwndbg/pwndbg" "$TOOLS/pwndbg"
    cd "$TOOLS/pwndbg" && ./setup.sh
    echo -e "  ${GREEN}[✓]${NC} pwndbg installé"
else
    echo -e "  \033[0;36m[~]\033[0m pwndbg déjà installé"
fi

# ─────────────────────────────────────────────
# pwntools — framework Python exploit dev (pipx)
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] pwntools${NC}"
pipx_install pwntools

# ─────────────────────────────────────────────
# checksec (pipx — ou apt si disponible)
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] checksec${NC}"
if dpkg -s checksec &>/dev/null; then
    echo -e "  \033[0;36m[~]\033[0m checksec déjà installé via apt"
else
    pipx_install checksec
fi

# ─────────────────────────────────────────────
# Ghidra — Désassembleur/Décompilateur NSA
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Ghidra (~1 Go)${NC}"
echo -e "  ${YELLOW}[?]${NC} Installer Ghidra ? (nécessite Java + ~1 Go) [y/N] "
read -r choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    install_apt openjdk-17-jdk

    GHIDRA_VERSION="11.3.1"
    GHIDRA_DATE="20250219"
    GHIDRA_ZIP="ghidra_${GHIDRA_VERSION}_PUBLIC_${GHIDRA_DATE}.zip"
    GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_VERSION}_build/${GHIDRA_ZIP}"

    if [ ! -d "$TOOLS/ghidra_${GHIDRA_VERSION}_PUBLIC" ]; then
        echo -e "  ${CYAN}[+]${NC} Téléchargement de Ghidra ${GHIDRA_VERSION}..."
        wget -q --show-progress "$GHIDRA_URL" -O "/tmp/${GHIDRA_ZIP}"
        unzip -q "/tmp/${GHIDRA_ZIP}" -d "$TOOLS/"
        rm "/tmp/${GHIDRA_ZIP}"
        ln -sfn "$TOOLS/ghidra_${GHIDRA_VERSION}_PUBLIC" "$TOOLS/ghidra"
        echo -e "  ${GREEN}[✓]${NC} Ghidra installé dans $TOOLS/ghidra"
    else
        echo -e "  \033[0;36m[~]\033[0m Ghidra déjà installé"
    fi
else
    echo -e "  ${YELLOW}[-]${NC} Ghidra ignoré."
fi

# ─────────────────────────────────────────────
# Résumé
# ─────────────────────────────────────────────
echo ""
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  [✓] Module RE installé.                 ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}  Outils disponibles :${NC}"
echo "  gdb, readelf, objdump, strings, nm, strace, ltrace"
echo "  binwalk, upx, pwndbg, pwntools (pipx), checksec (pipx)"
[[ "$choice" =~ ^[Yy]$ ]] && echo "  ghidra → \$TOOLS/ghidra/ghidraRun"
