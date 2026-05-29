#!/bin/bash
# ============================================================
# git-tools.sh — Installation des outils via GitHub
# toolkit v1.1
# ============================================================

set -e

REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(eval echo "~$REAL_USER")
TOOLS="$REAL_HOME/tools"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

mkdir -p "$TOOLS"

clone_tool() {
    local name="$1"
    local repo="$2"
    if [ -d "$TOOLS/$name" ]; then
        echo -e "  ${YELLOW}[~]${NC} $name déjà cloné — mise à jour..."
        git -C "$TOOLS/$name" pull -q 2>/dev/null || true
    else
        echo -e "  ${GREEN}[+]${NC} Clonage de $name..."
        git clone --depth=1 "$repo" "$TOOLS/$name" 2>/dev/null && \
            echo -e "  ${GREEN}[✓]${NC} $name cloné" || \
            echo -e "  ${RED}[✗]${NC} Échec : $name"
    fi
}

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}   Installation GitHub tools — v1.1       ${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "  Dossier cible : ${YELLOW}$TOOLS${NC}\n"

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
clone_tool "holehe"          "https://github.com/megadose/holehe"
clone_tool "trufflehog"      "https://github.com/trufflesecurity/trufflehog"

# Go tools
echo -e "  ${GREEN}[+]${NC} Installation de phoneinfroga (Go)..."
go install github.com/sundowndev/phoneinfoga/v2/cmd/phoneinfoga@latest 2>/dev/null && \
    echo -e "  ${GREEN}[✓]${NC} phoneinfroga installé" || \
    echo -e "  ${RED}[✗]${NC} Échec phoneinfroga"

echo -e "  ${GREEN}[+]${NC} Installation de waybackurls (Go)..."
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
clone_tool "pwncat"          "https://github.com/calebstewart/pwncat"
clone_tool "evil-winrm"      "https://github.com/Hackplayers/evil-winrm"
clone_tool "mimikatz"        "https://github.com/gentilkiwi/mimikatz"
clone_tool "crackmapexec"    "https://github.com/byt3bl33d3r/CrackMapExec"
clone_tool "bashfuscator"    "https://github.com/Bashfuscator/Bashfuscator"

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

echo ""
echo -e "${GREEN}[✓] Clonage GitHub terminé.${NC}"
echo -e "${YELLOW}[!] Étapes post-installation requises :${NC}"
cat << 'EOF'
  cd ~/tools/impacket       && pip install . --break-system-packages
  cd ~/tools/pwndbg         && ./setup.sh
  cd ~/tools/bashfuscator   && pip install . --break-system-packages
  pip install pwncat-cs crackmapexec sshuttle plaso --break-system-packages
  gem install evil-winrm
  cd ~/tools/chisel         && go build .
  cd ~/tools/ligolo-ng/cmd/proxy  && go build .
  cd ~/tools/proxychains-ng && ./configure && make && make install
EOF
