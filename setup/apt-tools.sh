#!/bin/bash

# ============================================================
#   APT TOOLS INSTALLER
#   Installe tous les outils disponibles via apt
# ============================================================

ok()   { echo -e "\033[0;32m[✓]\033[0m $1"; }
skip() { echo -e "\033[0;36m[~]\033[0m $1"; }
fail() { echo -e "\033[0;31m[✗]\033[0m $1"; }
step() { echo -e "\n\033[0;36m[*]\033[0m $1"; }

install_apt() {
  local tool="$1"
  # Vérifie si la commande est déjà disponible sur le système
  if command -v "$tool" &>/dev/null; then
    skip "$tool (déjà installé — ignoré)"
    return
  fi
  # Vérifie aussi via dpkg pour les paquets sans binaire du même nom
  if dpkg -s "$tool" &>/dev/null 2>&1; then
    skip "$tool (déjà installé via dpkg — ignoré)"
    return
  fi
  if apt-get install -y "$tool" &>/dev/null; then
    ok "$tool installé"
  else
    fail "$tool (échec — vérifie manuellement)"
  fi
}

step "Mise à jour des paquets..."
apt-get update -qq

# ── RECON & OSINT ────────────────────────────────────────────
step "Recon & OSINT"
install_apt nmap
install_apt amass
install_apt recon-ng
install_apt maltego
install_apt sherlock
install_apt dnsenum
install_apt whatweb
install_apt exiftool

# ── WEB SECURITY ─────────────────────────────────────────────
step "Web Security"
install_apt ffuf
install_apt gobuster
install_apt feroxbuster
install_apt nikto
install_apt curl
install_apt dirb
install_apt wfuzz
install_apt sqlmap
install_apt wafw00f

# ── NETWORK ──────────────────────────────────────────────────
step "Network"
install_apt netcat-traditional
install_apt hydra
install_apt enum4linux
install_apt nbtscan
install_apt onesixtyone
install_apt snmpwalk
install_apt macchanger
install_apt wireshark
install_apt tcpdump

# ── PASSWORDS & CRACKING ─────────────────────────────────────
step "Password Cracking"
install_apt hashcat
install_apt john
install_apt crunch

# ── EXPLOIT & POST-EXPLOITATION ──────────────────────────────
step "Exploit & Post-Exploitation"
install_apt metasploit-framework
install_apt netcat-traditional

# ── FORENSICS ────────────────────────────────────────────────
step "Forensics"
install_apt autopsy
install_apt volatility3

# ── UTILS ────────────────────────────────────────────────────
step "Utilitaires"
install_apt tmux
install_apt git
install_apt python3-pip
install_apt jq
install_apt wget
install_apt unzip

ok "Installation apt terminée."
