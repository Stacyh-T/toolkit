#!/bin/bash

# ============================================================
#   GITHUB TOOLS INSTALLER
#   Clone les outils non disponibles via apt
# ============================================================

TOOLS_DIR="$HOME/tools"

ok()   { echo -e "\033[0;32m[✓]\033[0m $1"; }
skip() { echo -e "\033[0;36m[~]\033[0m $1"; }
fail() { echo -e "\033[0;31m[✗]\033[0m $1"; }
step() { echo -e "\n\033[0;36m[*]\033[0m $1"; }

clone_tool() {
  local name="$1"
  local url="$2"
  local dest="$TOOLS_DIR/$name"

  if [ -d "$dest" ]; then
    local changes
    changes=$(git -C "$dest" pull -q 2>&1)
    if echo "$changes" | grep -q "Already up to date"; then
      skip "$name (déjà à jour — ignoré)"
    else
      ok "$name (mis à jour)"
    fi
  else
    if git clone --depth=1 "$url" "$dest" &>/dev/null; then
      ok "$name (installé)"
    else
      fail "$name (échec clone — vérifie l'URL ou ta connexion)"
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
clone_tool "PEASS-ng"          "https://github.com/peass-ng/PEASS-ng"
clone_tool "pwncat"            "https://github.com/calebstewart/pwncat"
clone_tool "evil-winrm"        "https://github.com/Hackplayers/evil-winrm"
clone_tool "mimikatz"          "https://github.com/gentilkiwi/mimikatz"
clone_tool "crackmapexec"      "https://github.com/byt3bl33d3r/CrackMapExec"

# ── PIVOTING & TUNNELING ──────────────────────────────────────
step "Pivoting & Tunneling"
clone_tool "chisel"            "https://github.com/jpillora/chisel"
clone_tool "ligolo-ng"         "https://github.com/nicocha30/ligolo-ng"
clone_tool "proxychains-ng"    "https://github.com/rofl0r/proxychains-ng"
clone_tool "sshuttle"          "https://github.com/sshuttle/sshuttle"

# ── REVERSE SHELLS ────────────────────────────────────────────
step "Reverse Shells"
clone_tool "revshells"         "https://github.com/0dayCTF/reverse-shell-generator"

# ── FORENSICS ────────────────────────────────────────────────
step "Forensics"
clone_tool "plaso"             "https://github.com/log2timeline/plaso"

ok "Clonage GitHub terminé. Outils dans : $TOOLS_DIR"
