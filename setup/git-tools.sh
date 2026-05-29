#!/bin/bash
# ============================================================
# git-tools.sh — Installation des outils via GitHub
# toolkit v1.1
# ============================================================

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
TOOLS="$REAL_HOME/tools"

RED='\033[0;31m'; GREEN='\033[1;35m'; YELLOW='\033[0;35m'; CYAN='\033[1;34m'; NC='\033[0m'

mkdir -p "$TOOLS"

clone_tool() {
    local name="$1"
    local repo="$2"
    if [ -d "$TOOLS/$name" ]; then
        echo -e "  \033[0;36m[~]\033[0m $name déjà cloné — mise à jour..."
        git -C "$TOOLS/$name" pull -q 2>/dev/null || true
    else
        echo -e "  ${CYAN}[+]${NC} Clonage de $name..."
        git clone --depth=1 "$repo" "$TOOLS/$name" 2>/dev/null && \
            echo -e "  ${GREEN}[✓]${NC} $name cloné" || \
            echo -e "  ${RED}[✗]${NC} Échec : $name"
    fi
}

pipx_install() {
    local pkg="$1"
    if su - "$REAL_USER" -c "pipx list 2>/dev/null" | grep -q "$pkg"; then
        echo -e "  \033[0;36m[~]\033[0m $pkg déjà installé via pipx"
    else
        echo -e "  ${CYAN}[+]${NC} pipx install $pkg..."
        su - "$REAL_USER" -c "pipx install $pkg" \
            && echo -e "  ${GREEN}[✓]${NC} $pkg installé" \
            || echo -e "  ${RED}[✗]${NC} Échec : $pkg"
    fi
}

pipx_install_local() {
    local name="$1"
    local tool_dir="$TOOLS/$name"
    if su - "$REAL_USER" -c "pipx list 2>/dev/null" | grep -q "$name"; then
        echo -e "  \033[0;36m[~]\033[0m $name déjà installé via pipx"
    else
        echo -e "  ${CYAN}[+]${NC} pipx install $name (local)..."
        su - "$REAL_USER" -c "pipx install $tool_dir" \
            && echo -e "  ${GREEN}[✓]${NC} $name installé" \
            || echo -e "  ${RED}[✗]${NC} Échec : $name"
    fi
}

echo ""
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "${CYAN}   Installation GitHub tools — v1.1       ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "  Dossier cible : ${YELLOW}$TOOLS${NC}\n"

# ─────────────────────────────────────────────
# Vérification des dépendances
# ─────────────────────────────────────────────
echo -e "${YELLOW}[*] Vérification des dépendances...${NC}"

if ! command -v go &>/dev/null; then
    echo -e "  ${CYAN}[+]${NC} Go non installé — installation..."
    apt-get update -qq
    apt-get install -y golang-go -qq && \
        echo -e "  ${GREEN}[✓]${NC} golang-go installé" || \
        echo -e "  ${RED}[✗]${NC} Échec installation golang-go"
else
    echo -e "  \033[0;36m[~]\033[0m Go déjà installé ($(go version | awk '{print $3}'))"
fi

if ! command -v pipx &>/dev/null; then
    echo -e "  ${CYAN}[+]${NC} pipx non installé — installation..."
    apt-get install -y pipx -qq && \
        su - "$REAL_USER" -c "pipx ensurepath" &>/dev/null && \
        echo -e "  ${GREEN}[✓]${NC} pipx installé" || \
        echo -e "  ${RED}[✗]${NC} Échec installation pipx"
else
    echo -e "  \033[0;36m[~]\033[0m pipx déjà installé"
fi

if ! command -v git &>/dev/null; then
    echo -e "  ${CYAN}[+]${NC} git non installé — installation..."
    apt-get install -y git -qq && \
        echo -e "  ${GREEN}[✓]${NC} git installé" || \
        echo -e "  ${RED}[✗]${NC} Échec installation git"
else
    echo -e "  \033[0;36m[~]\033[0m git déjà installé"
fi

# ─────────────────────────────────────────────
# Recon & OSINT
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Recon & OSINT${NC}"
clone_tool "spiderfoot"      "https://github.com/smicallef/spiderfoot"
clone_tool "datasploit"      "https://github.com/DataSploit/datasploit"
clone_tool "photon"          "https://github.com/s0md3v/Photon"
clone_tool "social-analyzer" "https://github.com/qeeqbox/social-analyzer"

# ─────────────────────────────────────────────
# OSINT — Identités & Fuites
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] OSINT — Identités & Fuites${NC}"
pipx_install holehe
clone_tool "trufflehog"      "https://github.com/trufflesecurity/trufflehog"

# Go tools
echo -e "  ${CYAN}[+]${NC} Installation de phoneinfroga (Go)..."
go install github.com/sundowndev/phoneinfoga/v2/cmd/phoneinfoga@latest 2>/dev/null && \
    echo -e "  ${GREEN}[✓]${NC} phoneinfroga installé" || \
    echo -e "  ${RED}[✗]${NC} Échec phoneinfroga"

echo -e "  ${CYAN}[+]${NC} Installation de waybackurls (Go)..."
go install github.com/tomnomnom/waybackurls@latest 2>/dev/null && \
    echo -e "  ${GREEN}[✓]${NC} waybackurls installé" || \
    echo -e "  ${RED}[✗]${NC} Échec waybackurls"

# ─────────────────────────────────────────────
# Web
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Web${NC}"
clone_tool "xsstrike"        "https://github.com/s0md3v/XSStrike"
clone_tool "brutexss"        "https://github.com/rajeshmajumdar/BruteXSS"
clone_tool "gopherus"        "https://github.com/tarunkant/Gopherus"
clone_tool "drupwn"          "https://github.com/immunIT/drupwn"
clone_tool "droopescan"      "https://github.com/SamJoan/droopescan"

# ─────────────────────────────────────────────
# Réseau
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Réseau${NC}"
clone_tool "impacket"        "https://github.com/fortra/impacket"
clone_tool "smtp-user-enum"  "https://github.com/cytopia/smtp-user-enum"
clone_tool "sipvicious"      "https://github.com/EnableSecurity/sipvicious"

# ─────────────────────────────────────────────
# Post-Exploitation
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Post-Exploitation${NC}"
clone_tool "PEASS-ng"        "https://github.com/peass-ng/PEASS-ng"
clone_tool "evil-winrm"      "https://github.com/Hackplayers/evil-winrm"
clone_tool "mimikatz"        "https://github.com/gentilkiwi/mimikatz"
clone_tool "bashfuscator"    "https://github.com/Bashfuscator/Bashfuscator"

# pwncat via pipx
pipx_install pwncat-cs

# CrackMapExec via pipx
pipx_install crackmapexec

# Impacket via pipx
pipx_install_local "impacket"

# ─────────────────────────────────────────────
# Post-Exploitation — PrivEsc Windows
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] PrivEsc Windows${NC}"
clone_tool "GodPotato"       "https://github.com/BeichenDream/GodPotato"
clone_tool "PrintSpoofer"    "https://github.com/itm4n/PrintSpoofer"
clone_tool "JuicyPotato"     "https://github.com/ohpe/juicy-potato"

# ─────────────────────────────────────────────
# Pivoting & Tunneling
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Pivoting & Tunneling${NC}"
clone_tool "chisel"          "https://github.com/jpillora/chisel"
clone_tool "ligolo-ng"       "https://github.com/nicocha30/ligolo-ng"
clone_tool "proxychains-ng"  "https://github.com/rofl0r/proxychains-ng"
clone_tool "sshuttle"        "https://github.com/sshuttle/sshuttle"

# sshuttle via pipx
pipx_install sshuttle

# ─────────────────────────────────────────────
# Reverse Engineering
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Reverse Engineering${NC}"
clone_tool "pwndbg"          "https://github.com/pwndbg/pwndbg"

# ─────────────────────────────────────────────
# Reverse Shells
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Reverse Shells${NC}"
clone_tool "revshells"       "https://github.com/0dayCTF/reverse-shell-generator"

# ─────────────────────────────────────────────
# Forensics
# ─────────────────────────────────────────────
echo -e "\n${YELLOW}[*] Forensics${NC}"
clone_tool "autopsy"         "https://github.com/sleuthkit/autopsy"
clone_tool "volatility3"     "https://github.com/volatilityfoundation/volatility3"
clone_tool "plaso"           "https://github.com/log2timeline/plaso"

# plaso via pipx
pipx_install plaso

echo ""
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}[✓] Clonage GitHub terminé.               ${NC}"
echo -e "${CYAN}══════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}[!] Étapes post-installation requises :${NC}"
cat << 'EOF'
  cd ~/tools/pwndbg         && ./setup.sh
  cd ~/tools/bashfuscator   && pipx install .
  gem install evil-winrm
  cd ~/tools/chisel         && go build .
  cd ~/tools/ligolo-ng/cmd/proxy  && go build .
  cd ~/tools/proxychains-ng && ./configure && make && make install
EOF
