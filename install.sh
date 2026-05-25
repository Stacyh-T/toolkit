#!/bin/bash

# ============================================================
#   TOOLKIT INSTALLER
#   Compatible: Kali Linux / Parrot OS
#   Usage: ./install.sh
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Taille moyenne par outil (ajustable) ─────────────────────
AVG_APT_MB=25       # Mo moyen par outil apt
AVG_GITHUB_MB=20    # Mo moyen par repo GitHub cloné
SIZE_WORDLISTS=1200 # Fixe : SecLists (~1Go) + rockyou (~200Mo)
SIZE_CONFIGS=1      # Fixe : dotfiles, négligeable

# ── Calcul dynamique selon le contenu des scripts ────────────
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
  echo ""
}

step() { echo -e "\n${CYAN}[*]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
fail() { echo -e "${RED}[✗]${NC} $1"; }

# ── Résumé tailles (dynamique) ───────────────────────────────
show_size_summary() {
  local available_mb
  available_mb=$(df -m "$HOME" | awk 'NR==2 {print $4}')
  local available_gb=$(( available_mb / 1024 ))
  local total=$(( SIZE_APT + SIZE_GITHUB + SIZE_WORDLISTS + SIZE_CONFIGS ))
  local total_gb=$(( total / 1024 ))

  echo -e "${CYAN}  ┌──────────────────────────────────────────────────┐${NC}"
  echo -e "${CYAN}  │            Taille estimée du toolkit             │${NC}"
  echo -e "${CYAN}  ├────────────────────────────────┬─────────────────┤${NC}"
  echo -e "${CYAN}  │${NC}  Outils apt   (${NB_APT} outils x ${AVG_APT_MB}Mo)   ${CYAN}│${NC} ${YELLOW}~${SIZE_APT} Mo${NC}          ${CYAN}│${NC}"
  echo -e "${CYAN}  │${NC}  Outils GitHub (${NB_GITHUB} repos x ${AVG_GITHUB_MB}Mo)    ${CYAN}│${NC} ${YELLOW}~${SIZE_GITHUB} Mo${NC}          ${CYAN}│${NC}"
  echo -e "${CYAN}  │${NC}  Wordlists (SecLists + rockyou)  ${CYAN}│${NC} ${YELLOW}~${SIZE_WORDLISTS} Mo${NC}         ${CYAN}│${NC}"
  echo -e "${CYAN}  │${NC}  Configs (dotfiles)              ${CYAN}│${NC} ${YELLOW}~${SIZE_CONFIGS} Mo${NC}           ${CYAN}│${NC}"
  echo -e "${CYAN}  ├────────────────────────────────┼─────────────────┤${NC}"
  echo -e "${CYAN}  │${NC}  ${GREEN}TOTAL${NC}                           ${CYAN}│${NC} ${GREEN}~${total} Mo (~${total_gb} Go)${NC}  ${CYAN}│${NC}"
  echo -e "${CYAN}  ├────────────────────────────────┼─────────────────┤${NC}"
  echo -e "${CYAN}  │${NC}  Disponible sur $HOME          ${CYAN}│${NC} ${GREEN}~${available_mb} Mo (~${available_gb} Go)${NC}${CYAN}│${NC}"
  echo -e "${CYAN}  └────────────────────────────────┴─────────────────┘${NC}"
  echo ""
}

# ── Vérification espace disque ───────────────────────────────
check_disk_space() {
  local required_mb="$1"
  local label="$2"
  local available_mb
  available_mb=$(df -m "$HOME" | awk 'NR==2 {print $4}')
  local available_gb=$(( available_mb / 1024 ))
  local required_gb=$(( required_mb / 1024 ))

  echo ""
  echo -e "${CYAN}  ┌─────────────────────────────────────────┐${NC}"
  echo -e "${CYAN}  │         Vérification espace disque      │${NC}"
  echo -e "${CYAN}  ├─────────────────────────────────────────┤${NC}"
  echo -e "${CYAN}  │${NC} Composants  : ${YELLOW}${label}${NC}"
  echo -e "${CYAN}  │${NC} Requis      : ${YELLOW}~${required_mb} Mo (~${required_gb} Go)${NC}"
  echo -e "${CYAN}  │${NC} Disponible  : ${GREEN}${available_mb} Mo (~${available_gb} Go)${NC} sur $HOME"
  echo -e "${CYAN}  └─────────────────────────────────────────┘${NC}"
  echo ""

  if [ "$available_mb" -lt "$required_mb" ]; then
    fail "Espace insuffisant ! Il te faut ~${required_mb} Mo mais tu n'as que ${available_mb} Mo."
    fail "Libère de l'espace ou choisis une installation partielle."
    exit 1
  elif [ "$available_mb" -lt $(( required_mb * 2 )) ]; then
    warn "Espace limite. L'installation devrait passer mais c'est juste."
    read -rp "  Continuer quand même ? [o/N] : " confirm
    [[ "$confirm" =~ ^[oO]$ ]] || exit 0
  else
    ok "Espace suffisant. On continue."
  fi
}

check_root() {
  if [ "$EUID" -ne 0 ]; then
    warn "Certaines installations nécessitent sudo."
    warn "Relance avec: sudo ./install.sh"
    echo ""
  fi
}

run_step() {
  local label="$1"
  local script="$2"
  step "$label"
  if bash "$TOOLKIT_DIR/$script"; then
    ok "$label terminé"
  else
    fail "$label a échoué — vérifie $script"
  fi
}

# ── MAIN ─────────────────────────────────────────────────────
banner
check_root
show_size_summary

echo "  Que veux-tu installer ?"
echo ""
echo -e "  [1] Tout (recommandé)            ${YELLOW}~$(( SIZE_APT + SIZE_GITHUB + SIZE_WORDLISTS + SIZE_CONFIGS )) Mo${NC}"
echo -e "  [2] Outils apt seulement         ${YELLOW}~${SIZE_APT} Mo${NC}  (${NB_APT} outils)"
echo -e "  [3] Outils GitHub seulement      ${YELLOW}~${SIZE_GITHUB} Mo${NC}  (${NB_GITHUB} repos)"
echo -e "  [4] Wordlists seulement          ${YELLOW}~${SIZE_WORDLISTS} Mo${NC}"
echo -e "  [5] Configs seulement            ${YELLOW}~${SIZE_CONFIGS} Mo${NC}"
echo ""
read -rp "  Choix [1-5] : " choice

# Vérification espace selon le choix
case $choice in
  1) check_disk_space $(( SIZE_APT + SIZE_GITHUB + SIZE_WORDLISTS + SIZE_CONFIGS )) "apt + GitHub + wordlists + configs" ;;
  2) check_disk_space "$SIZE_APT"       "outils apt ($NB_APT outils)" ;;
  3) check_disk_space "$SIZE_GITHUB"    "outils GitHub ($NB_GITHUB repos)" ;;
  4) check_disk_space "$SIZE_WORDLISTS" "wordlists" ;;
  5) check_disk_space "$SIZE_CONFIGS"   "configs" ;;
  *) fail "Choix invalide."; exit 1 ;;
esac

# Lancement des scripts
case $choice in
  1)
    run_step "Installation outils apt"    "setup/apt-tools.sh"
    run_step "Clonage outils GitHub"      "setup/git-tools.sh"
    run_step "Téléchargement wordlists"   "setup/wordlists.sh"
    run_step "Application des configs"    "setup/configs.sh"
    ;;
  2) run_step "Installation outils apt"   "setup/apt-tools.sh" ;;
  3) run_step "Clonage outils GitHub"     "setup/git-tools.sh" ;;
  4) run_step "Téléchargement wordlists"  "setup/wordlists.sh" ;;
  5) run_step "Application des configs"   "setup/configs.sh"   ;;
esac

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Toolkit prêt. Bonne chasse. 🎯${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
