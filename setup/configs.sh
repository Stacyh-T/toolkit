#!/bin/bash

# ============================================================
#   CONFIGS SETUP
#   Applique les dotfiles (.zshrc, tmux) au vrai utilisateur
# ============================================================

REAL_USER="${REAL_USER:-${SUDO_USER:-$USER}}"
REAL_HOME="${REAL_HOME:-$(getent passwd "$REAL_USER" | cut -d: -f6)}"
TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGS_DIR="$TOOLKIT_DIR/configs"

ok()   { echo -e "\033[0;32m[✓]\033[0m $1"; }
warn() { echo -e "\033[1;33m[!]\033[0m $1"; }
step() { echo -e "\n\033[0;36m[*]\033[0m $1"; }

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [ -f "$dest" ] && [ ! -L "$dest" ]; then
    cp "$dest" "${dest}.bak"
    warn "Backup créé : ${dest}.bak"
  fi

  ln -sf "$src" "$dest" && ok "$dest → $src"
  chown -h "$REAL_USER":"$REAL_USER" "$dest"
}

step "Application des configs pour $REAL_USER ($REAL_HOME)"

# Zsh (défaut sur Kali)
if [ -f "$CONFIGS_DIR/.zshrc" ]; then
  backup_and_link "$CONFIGS_DIR/.zshrc" "$REAL_HOME/.zshrc"
fi

# Bash
if [ -f "$CONFIGS_DIR/.bashrc" ]; then
  backup_and_link "$CONFIGS_DIR/.bashrc" "$REAL_HOME/.bashrc"
fi

# Tmux
if [ -f "$CONFIGS_DIR/tmux.conf" ]; then
  backup_and_link "$CONFIGS_DIR/tmux.conf" "$REAL_HOME/.tmux.conf"
fi

step "Rechargement du shell pour $REAL_USER"
# On recharge en tant que le vrai user
if [ -n "$SUDO_USER" ]; then
  su - "$REAL_USER" -c "source $REAL_HOME/.zshrc 2>/dev/null || source $REAL_HOME/.bashrc 2>/dev/null"
  ok "Shell rechargé pour $REAL_USER"
else
  source "$REAL_HOME/.zshrc" 2>/dev/null && ok "zshrc rechargé"
fi

ok "Configs appliquées dans $REAL_HOME"
