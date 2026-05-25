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

check_root() {
  if [ "$EUID" -ne 0 ]; then
    warn "Certaines installations nécessitent sudo."
    warn "Relance avec: sudo ./install.sh"
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

# ── MAIN ────────────────────────────────────────────────────
banner
check_root

echo "Que veux-tu installer ?"
echo "  [1] Tout (recommandé)"
echo "  [2] Outils apt seulement"
echo "  [3] Outils GitHub seulement"
echo "  [4] Wordlists seulement"
echo "  [5] Configs (bashrc/zshrc/tmux) seulement"
echo ""
read -rp "Choix [1-5] : " choice

case $choice in
  1)
    run_step "Installation outils apt"        "setup/apt-tools.sh"
    run_step "Clonage outils GitHub"          "setup/git-tools.sh"
    run_step "Téléchargement wordlists"       "setup/wordlists.sh"
    run_step "Application des configs"        "setup/configs.sh"
    ;;
  2) run_step "Installation outils apt"       "setup/apt-tools.sh" ;;
  3) run_step "Clonage outils GitHub"         "setup/git-tools.sh" ;;
  4) run_step "Téléchargement wordlists"      "setup/wordlists.sh" ;;
  5) run_step "Application des configs"       "setup/configs.sh"   ;;
  *) fail "Choix invalide."; exit 1 ;;
esac

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}  Toolkit prêt${NC}"
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo ""
