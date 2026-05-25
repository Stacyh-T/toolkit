#!/bin/bash

# ============================================================
#   CONFIGS SETUP
#   Applique les dotfiles (bashrc, zshrc, tmux)
# ============================================================

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
}

step "Application des configs"

# Zsh (défaut sur Kali)
if [ -f "$CONFIGS_DIR/.zshrc" ]; then
  backup_and_link "$CONFIGS_DIR/.zshrc" "$HOME/.zshrc"
fi

# Bash
if [ -f "$CONFIGS_DIR/.bashrc" ]; then
  backup_and_link "$CONFIGS_DIR/.bashrc" "$HOME/.bashrc"
fi

# Tmux
if [ -f "$CONFIGS_DIR/tmux.conf" ]; then
  backup_and_link "$CONFIGS_DIR/tmux.conf" "$HOME/.tmux.conf"
fi

step "Rechargement du shell"
if [ -n "$ZSH_VERSION" ]; then
  source "$HOME/.zshrc" 2>/dev/null && ok "zshrc rechargé"
else
  source "$HOME/.bashrc" 2>/dev/null && ok "bashrc rechargé"
fi

ok "Configs appliquées."
