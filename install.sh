#!/bin/bash

# ============================================================
#   TOOLKIT INSTALLER
#   Compatible: Kali Linux / Parrot OS
#   Usage: sudo ./install.sh
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Résolution du vrai utilisateur ───────────────────────────
# Si lancé via sudo → récupère le user réel
# Si lancé directement → utilise $USER
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

export REAL_USER
export REAL_HOME

# ── Taille moyenne par outil (ajustable) ─────────────────────
AVG_APT_MB=25
AVG_GITHUB_MB=20
SIZE_WORDLISTS=1200
SIZE_CONFIGS=1

# ── Calcul dynamique ─────────────────────────────────────────
NB_APT=$(grep -c "install_apt" "$TOOLKIT_DIR/setup/apt-tools.sh" 2>/dev/null || echo 0)
NB_GITHUB=$(grep -c "clone_tool" "$TOOLKIT_DIR/setup/git-tools.sh" 2>/dev/null || echo 0)
SIZE_APT=$(( NB_APT * AVG_APT_MB ))
SIZE_GITHUB=$(( NB_GITHUB * AVG_GITHUB_MB ))

# ── Fonctions affichage ──────────────────────────────────────
banner() {
  echo -e "${CYAN}"
  echo "  ████████╗ ██████╗  ██████╗ ██╗     ██╗  ██╗██╗████████╗"
  echo "     ██╔══╝██╔═══██╗██╔═══██╗██║     ██║ ██╔╝██║╚══██╔══╝"
  echo "     ██║   ██║   ██║██║   ██║██║     █████╔╝ ██║   ██║   "
  echo "     ██║   ██║   ██║██║   ██║██║     ██╔═██╗ ██║   ██║   "
  echo "     ██║   ╚██████╔╝╚██████╔╝███████╗██║  ██╗██║   ██║   "
  echo "     ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝   "
  echo -e "${NC}"
  echo -e "${YELLOW}  Cybersecurity Toolkit Installer — Kali/Parrot${NC}"
  echo -e "${CYAN}  Utilisateur détecté : ${GREEN}$REAL_USER${NC} ${CYAN}(home: ${GREEN}$REAL_HOME${NC}${CYAN})${NC}"
  echo ""
}

step() { echo -e "\n${CYAN}[*] ========================================${NC}\n${CYAN}[*] ÉTAPE : $1${NC}\n${CYAN}[*] ========================================${NC}"; }
ok()   { echo -e "${GREEN}[✓] Succès : $1${NC}"; }
warn() { echo -e "${YELLOW}[!] Avertissement : $1${NC}"; }
fail() { echo -e "${RED}[✗] Erreur : $1${NC}"; }
info() { echo -e "${YELLOW}[>] $1${NC}"; }

# ── Résumé espace disque ─────────────────────────────────────
show_size_summary() {
  local available_mb
  available_mb=$(df -m "$REAL_HOME" | awk 'NR==2 {print $4}')
  local available_gb=$(( available_mb / 1024 ))
  local total=$(( SIZE_APT + SIZE_GITHUB + SIZE_WORDLISTS + SIZE_CONFIGS ))
  local total_gb=$(( total / 1024 ))

  local l_apt=$(printf "%-30s" "Outils apt   (${NB_APT} x ${AVG_APT_MB}Mo)")
  local v_apt=$(printf "%-22s" "~${SIZE_APT} Mo")
  local l_git=$(printf "%-30s" "Outils GitHub (${NB_GITHUB} x ${AVG_GITHUB_MB}Mo)")
  local v_git=$(printf "%-22s" "~${SIZE_GITHUB} Mo")
  local l_wrd=$(printf "%-30s" "Wordlists (SecLists+rockyou)")
  local v_wrd=$(printf "%-22s" "~${SIZE_WORDLISTS} Mo")
  local l_cfg=$(printf "%-30s" "Configs (dotfiles)")
  local v_cfg=$(printf "%-22s" "~${SIZE_CONFIGS} Mo")
  local l_tot=$(printf "%-30s" "TOTAL")
  local v_tot=$(printf "%-22s" "~${total} Mo (~${total_gb} Go)")
  local l_dis=$(printf "%-30s" "Disponible sur $REAL_HOME")
  local v_dis=$(printf "%-22s" "~${available_mb} Mo (~${available_gb} Go)")

  echo -e "${CYAN}  ┌─────────────────────────────────────────────────────────┐${NC}"
  echo -e "${CYAN}  │                Taille estimée du toolkit                │${NC}"
  echo -e "${CYAN}  ├────────────────────────────────┬────────────────────────┤${NC}"
  echo -e "${CYAN}  │${NC} ${l_apt} ${CYAN}│${NC} ${YELLOW}${v_apt}${NC} ${CYAN}│${NC}"
  echo -e "${CYAN}  │${NC} ${l_git} ${CYAN}│${NC} ${YELLOW}${v_git}${NC} ${CYAN}│${NC}"
  echo -e "${CYAN}  │${NC} ${l_wrd} ${CYAN}│${NC} ${YELLOW}${v_wrd}${NC} ${CYAN}│${NC}"
  echo -e "${CYAN}  │${NC} ${l_cfg} ${CYAN}│${NC} ${YELLOW}${v_cfg}${NC} ${CYAN}│${NC}"
  echo -e "${CYAN}  ├────────────────────────────────┼────────────────────────┤${NC}"
  echo -e "${CYAN}  │${NC} ${GREEN}${l_tot}${NC} ${CYAN}│${NC} ${GREEN}${v_tot}${NC} ${CYAN}│${NC}"
  echo -e "${CYAN}  ├────────────────────────────────┼────────────────────────┤${NC}"
  echo -e "${CYAN}  │${NC} ${l_dis} ${CYAN}│${NC} ${GREEN}${v_dis}${NC} ${CYAN}│${NC}"
  echo -e "${CYAN}  └────────────────────────────────┴────────────────────────┘${NC}"
  echo ""
}

# ── Vérification espace disque ───────────────────────────────
check_disk_space() {
  local required_mb="$1"
  local available_mb
  available_mb=$(df -m "$REAL_HOME" | awk 'NR==2 {print $4}')

  if [ "$available_mb" -lt "$required_mb" ]; then
    fail "Espace insuffisant ! Requis : ~${required_mb} Mo — Disponible : ${available_mb} Mo."
    fail "Libère de l'espace ou choisis une installation partielle."
    exit 1
  elif [ "$available_mb" -lt $(( required_mb * 2 )) ]; then
    warn "Espace limite (~${available_mb} Mo disponible pour ~${required_mb} Mo requis)."
    read -rp "  Continuer quand même ? [o/N] : " confirm
    [[ "$confirm" =~ ^[oO]$ ]] || exit 0
  else
    ok "Espace suffisant (${available_mb} Mo disponible)."
  fi
}

check_root() {
  if [ "$EUID" -ne 0 ]; then
    warn "Certaines installations nécessitent sudo."
    warn "Relance avec: sudo ./install.sh"
    echo ""
  fi
}

# ── Installation par catégorie (apt) ─────────────────────────
install_category_apt() {
  local category="$1"
  local tools=("${@:2}")
  step "Installation APT — $category"
  for tool in "${tools[@]}"; do
    if command -v "$tool" &>/dev/null || dpkg -s "$tool" &>/dev/null 2>&1; then
      echo -e "\033[0;36m[~]\033[0m L'outil '$tool' est déjà installé — ignoré."
    else
      info "Installation de '$tool' via APT..."
      apt-get install -y "$tool"
      if [ $? -eq 0 ]; then
        ok "'$tool' installé avec succès."
      else
        fail "Échec de l'installation pour '$tool'."
      fi
    fi
  done
}

# ── Installation par catégorie (GitHub) ──────────────────────
install_category_github() {
  local category="$1"
  shift
  local pairs=("$@")
  step "Installation GitHub — $category"
  for pair in "${pairs[@]}"; do
    local name="${pair%%|*}"
    local url="${pair##*|}"
    local dest="$REAL_HOME/tools/$name"
    mkdir -p "$REAL_HOME/tools"
    if [ -d "$dest" ]; then
      info "Vérification des mises à jour pour '$name'..."
      git -C "$dest" pull
      if [ $? -eq 0 ]; then
        ok "'$name' mis à jour ou déjà à jour."
      else
        fail "Erreur lors du pull pour '$name'."
      fi
    else
      info "Clonage de '$name' depuis $url..."
      git clone --depth=1 "$url" "$dest"
      if [ $? -eq 0 ]; then
        ok "'$name' cloné dans $dest."
        chown -R "$REAL_USER":"$REAL_USER" "$dest"
      else
        fail "Échec du clonage pour '$name'."
      fi
    fi
  done
}

run_step() {
  local label="$1"
  local script="$2"
  step "$label"
  if bash "$TOOLKIT_DIR/$script"; then
    ok "Script $label terminé."
  else
    fail "Le script $label a échoué — vérifie $script"
  fi
}

# ── Menu principal ────────────────────────────────────────────
main_menu() {
  echo -e "${BOLD}  Que veux-tu installer ?${NC}"
  echo ""
  echo -e "  [1] ${GREEN}Tout${NC}                    ~$(( SIZE_APT + SIZE_GITHUB + SIZE_WORDLISTS + SIZE_CONFIGS )) Mo"
  echo -e "  [2] ${CYAN}Par catégorie${NC}           Choisir les thèmes"
  echo -e "  [3] ${YELLOW}Wordlists${NC}               ~${SIZE_WORDLISTS} Mo"
  echo -e "  [4] ${YELLOW}Configs${NC}                 ~${SIZE_CONFIGS} Mo  (.zshrc, tmux)"
  echo ""
  read -rp "  Choix [1-4] : " choice
  echo ""

  case $choice in
    1)
      check_disk_space $(( SIZE_APT + SIZE_GITHUB + SIZE_WORDLISTS + SIZE_CONFIGS ))
      install_all
      run_step "Wordlists"  "setup/wordlists.sh"
      run_step "Configs"    "setup/configs.sh"
      ;;
    2) category_menu ;;
    3)
      check_disk_space "$SIZE_WORDLISTS"
      run_step "Wordlists" "setup/wordlists.sh"
      ;;
    4)
      check_disk_space "$SIZE_CONFIGS"
      run_step "Configs" "setup/configs.sh"
      ;;
    *) fail "Choix invalide."; exit 1 ;;
  esac
}

# ── Menu par catégorie ────────────────────────────────────────
category_menu() {
  echo -e "${BOLD}  Choisis les catégories à installer :${NC}"
  echo -e "  ${CYAN}(plusieurs choix possibles, ex: 1 3 5)${NC}"
  echo ""
  echo "  [1]  Recon & OSINT"
  echo "  [2]  Web Security"
  echo "  [3]  Network"
  echo "  [4]  Password Cracking"
  echo "  [5]  Post-Exploitation"
  echo "  [6]  Pivoting & Tunneling"
  echo "  [7]  Forensics"
  echo "  [8]  Exploit (Metasploit)"
  echo "  [9]  Utilitaires (tmux, git, jq…)"
  echo "  [0]  Wordlists + Configs"
  echo ""
  read -rp "  Tes choix : " -a choices
  echo ""

  info "Mise à jour des dépôts APT..."
  apt-get update

  for c in "${choices[@]}"; do
    case $c in
      1) install_recon ;;
      2) install_web ;;
      3) install_network ;;
      4) install_passwords ;;
      5) install_postexploit ;;
      6) install_pivoting ;;
      7) install_forensics ;;
      8) install_exploit ;;
      9) install_utils ;;
      0)
        run_step "Wordlists" "setup/wordlists.sh"
        run_step "Configs"   "setup/configs.sh"
        ;;
      *) warn "Catégorie '$c' inconnue — ignorée" ;;
    esac
  done
}

# ── Définition des catégories ─────────────────────────────────

install_recon() {
  install_category_apt "Recon & OSINT" \
    nmap amass recon-ng maltego sherlock dnsenum whatweb exiftool
  install_category_github "Recon & OSINT" \
    "spiderfoot|https://github.com/smicallef/spiderfoot" \
    "datasploit|https://github.com/DataSploit/datasploit" \
    "photon|https://github.com/s0md3v/Photon" \
    "social-analyzer|https://github.com/qeeqbox/social-analyzer"
}

install_web() {
  install_category_apt "Web Security" \
    burpsuite zaproxy ffuf gobuster feroxbuster nikto curl dirb wfuzz sqlmap wafw00f
  install_category_github "Web Security" \
    "xsstrike|https://github.com/s0md3v/XSStrike" \
    "brutexss|https://github.com/rajeshmajumdar/BruteXSS" \
    "gopherus|https://github.com/tarunkant/Gopherus" \
    "drupwn|https://github.com/immunIT/drupwn" \
    "droopescan|https://github.com/SamJoan/droopescan"
}

install_network() {
  install_category_apt "Network" \
    netcat-traditional hydra enum4linux nbtscan onesixtyone snmp macchanger wireshark tcpdump
  install_category_github "Network" \
    "impacket|https://github.com/fortra/impacket" \
    "smtp-user-enum|https://github.com/cytopia/smtp-user-enum" \
    "svmap|https://github.com/EnableSecurity/sipvicious"
}

install_passwords() {
  install_category_apt "Password Cracking" \
    hashcat john crunch
}

install_postexploit() {
  install_category_github "Post-Exploitation" \
    "PEASS-ng|https://github.com/peass-ng/PEASS-ng" \
    "pwncat|https://github.com/calebstewart/pwncat" \
    "evil-winrm|https://github.com/Hackplayers/evil-winrm" \
    "mimikatz|https://github.com/gentilkiwi/mimikatz" \
    "crackmapexec|https://github.com/byt3bl33d3r/CrackMapExec" \
    "bashfuscator|https://github.com/Bashfuscator/Bashfuscator"
}

install_pivoting() {
  install_category_github "Pivoting & Tunneling" \
    "chisel|https://github.com/jpillora/chisel" \
    "ligolo-ng|https://github.com/nicocha30/ligolo-ng" \
    "proxychains-ng|https://github.com/rofl0r/proxychains-ng" \
    "sshuttle|https://github.com/sshuttle/sshuttle"
}

install_forensics() {
  install_category_github "Forensics" \
    "autopsy|https://github.com/sleuthkit/autopsy" \
    "volatility3|https://github.com/volatilityfoundation/volatility3" \
    "plaso|https://github.com/log2timeline/plaso"
}

install_exploit() {
  install_category_apt "Exploit" \
    metasploit-framework
}

install_utils() {
  install_category_apt "Utilitaires" \
    tmux git python3-pip jq wget unzip
}

install_all() {
  info "Mise à jour des dépôts APT..."
  apt-get update
  install_recon
  install_web
  install_network
  install_passwords
  install_postexploit
  install_pivoting
  install_forensics
  install_exploit
  install_utils
}

# ── MAIN ─────────────────────────────────────────────────────
banner
check_root
show_size_summary
main_menu

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Toolkit prêt.${NC}"
echo -e "${GREEN}  Outils dans : $REAL_HOME/tools/${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
