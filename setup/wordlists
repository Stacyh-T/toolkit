#!/bin/bash

# ============================================================
#   WORDLISTS SETUP
#   Télécharge et organise les wordlists essentielles
# ============================================================

WORDLISTS_DIR="$HOME/wordlists"

ok()   { echo -e "\033[0;32m[✓]\033[0m $1"; }
fail() { echo -e "\033[0;31m[✗]\033[0m $1"; }
step() { echo -e "\n\033[0;36m[*]\033[0m $1"; }

mkdir -p "$WORDLISTS_DIR"/{passwords,directories,usernames,subdomains,fuzzing}

# ── SECLISTS ─────────────────────────────────────────────────
step "Installation de SecLists"
if [ -d "$WORDLISTS_DIR/seclists" ]; then
  ok "SecLists déjà présent — mise à jour"
  git -C "$WORDLISTS_DIR/seclists" pull -q
else
  git clone --depth=1 https://github.com/danielmiessler/SecLists \
    "$WORDLISTS_DIR/seclists" && ok "SecLists" || fail "SecLists"
fi

# ── ROCKYOU ──────────────────────────────────────────────────
step "RockYou"
ROCKYOU="/usr/share/wordlists/rockyou.txt"
if [ -f "$ROCKYOU" ]; then
  ln -sf "$ROCKYOU" "$WORDLISTS_DIR/passwords/rockyou.txt"
  ok "rockyou.txt (lien symbolique depuis /usr/share/wordlists)"
elif [ -f "$ROCKYOU.gz" ]; then
  gunzip -k "$ROCKYOU.gz"
  ln -sf "$ROCKYOU" "$WORDLISTS_DIR/passwords/rockyou.txt"
  ok "rockyou.txt (décompressé)"
else
  fail "rockyou.txt introuvable"
fi

# ── LIENS SYMBOLIQUES PRATIQUES ──────────────────────────────
step "Création des liens symboliques utiles"

# Directories
ln -sf "$WORDLISTS_DIR/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt" \
  "$WORDLISTS_DIR/directories/medium.txt" && ok "directories/medium.txt"

ln -sf "$WORDLISTS_DIR/seclists/Discovery/Web-Content/directory-list-2.3-big.txt" \
  "$WORDLISTS_DIR/directories/big.txt" && ok "directories/big.txt"

ln -sf "$WORDLISTS_DIR/seclists/Discovery/Web-Content/common.txt" \
  "$WORDLISTS_DIR/directories/common.txt" && ok "directories/common.txt"

# Subdomains
ln -sf "$WORDLISTS_DIR/seclists/Discovery/DNS/subdomains-top1million-5000.txt" \
  "$WORDLISTS_DIR/subdomains/top5000.txt" && ok "subdomains/top5000.txt"

# Usernames
ln -sf "$WORDLISTS_DIR/seclists/Usernames/top-usernames-shortlist.txt" \
  "$WORDLISTS_DIR/usernames/common.txt" && ok "usernames/common.txt"

# Fuzzing
ln -sf "$WORDLISTS_DIR/seclists/Fuzzing/fuzz-Bo0oM.txt" \
  "$WORDLISTS_DIR/fuzzing/fuzz.txt" && ok "fuzzing/fuzz.txt"

echo ""
ok "Wordlists prêtes dans : $WORDLISTS_DIR"
echo ""
echo "  Accès rapide :"
echo "    passwords/rockyou.txt"
echo "    directories/medium.txt"
echo "    subdomains/top5000.txt"
echo "    seclists/  (tout SecLists)"
