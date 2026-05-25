#!/bin/bash

# ============================================================
#   GITHUB TOOLS INSTALLER
#   Clone les outils non disponibles via apt
# ============================================================

TOOLS_DIR="$HOME/tools"

ok()   { echo -e "\033[0;32m[✓]\033[0m $1"; }
fail() { echo -e "\033[0;31m[✗]\033[0m $1"; }
step() { echo -e "\n\033[0;36m[*]\033[0m $1"; }

clone_tool() {
  local name="$1"
  local url="$2"
  local dest="$TOOLS_DIR/$name"

  if [ -d "$dest" ]; then
    ok "$name déjà présent — mise à jour"
    git -C "$dest" pull -q
  else
    if git clone --depth=1 "$url" "$dest" &>/dev/null; then
      ok "$name"
    else
      fail "$name (échec clone)"
    fi
  fi
}

mkdir -p "$TOOLS_DIR"
step "Clonage des outils dans $TOOLS_DIR"

# ── RECON & OSINT ────────────────────────────────────────────
step "Recon & OSINT"
clone_tool "spiderfoot"        "https://github.com/smicallef/spiderfoot"
clone_tool "datasploit"        "https://github.com/DataSploit/datasploit"
clone_tool "photon"            "https://github.com/s0md3v/Photon"
clone_tool "social-analyzer"   "https://github.com/qeeqbox/social-analyzer"

# ── WEB SECURITY ─────────────────────────────────────────────
step "Web Security"
clone_tool "xsstrike"          "https://github.com/s0md3v/XSStrike"
clone_tool "brutexss"          "https://github.com/rajeshmajumdar/BruteXSS"
clone_tool "gopherus"          "https://github.com/tarunkant/Gopherus"
clone_tool "drupwn"            "https://github.com/immunIT/drupwn"
clone_tool "droopescan"        "https://github.com/SamJoan/droopescan"

# ── NETWORK ──────────────────────────────────────────────────
step "Network"
clone_tool "impacket"          "https://github.com/fortra/impacket"
clone_tool "smtp-user-enum"    "https://github.com/cytopia/smtp-user-enum"
clone_tool "svmap"             "https://github.com/EnableSecurity/sipvicious"

# ── POST-EXPLOITATION ────────────────────────────────────────
step "Post-Exploitation"
clone_tool "bashfuscator"      "https://github.com/Bashfuscator/Bashfuscator"

# ── FORENSICS ────────────────────────────────────────────────
step "Forensics"
clone_tool "plaso"             "https://github.com/log2timeline/plaso"

ok "Clonage GitHub terminé. Outils dans : $TOOLS_DIR"
