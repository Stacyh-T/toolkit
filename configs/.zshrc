# ============================================================
#   .zshrc — Cybersecurity Toolkit
#   Kali Linux / Parrot OS
# ============================================================

# ── PATHS ────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/tools:$PATH"
export WORDLISTS="$HOME/wordlists"
export TOOLS="$HOME/tools"

# ── ALIASES GÉNÉRAUX ─────────────────────────────────────────
alias ll='ls -lah --color=auto'
alias cls='clear'
alias myip='curl -s ifconfig.me && echo'
alias localip="ip -br a | grep UP | awk '{print \$3}'"

# ── ALIASES RECON ─────────────────────────────────────────────
alias nmap-quick='nmap -sV -sC -T4'
alias nmap-full='nmap -sV -sC -p- -T4'
alias nmap-udp='nmap -sU -T4'
alias nmap-vuln='nmap --script vuln'

# ── ALIASES WEB ───────────────────────────────────────────────
alias ffuf-dir='ffuf -u TARGET/FUZZ -w $WORDLISTS/directories/medium.txt -fc 404'
alias ffuf-sub='ffuf -u http://TARGET -H "Host: FUZZ.TARGET" -w $WORDLISTS/subdomains/top5000.txt -ac'
alias gobuster-dir='gobuster dir -w $WORDLISTS/directories/medium.txt'

# ── ALIASES PASSWORDS ─────────────────────────────────────────
alias john-rock='john --wordlist=$WORDLISTS/passwords/rockyou.txt'
alias hashcat-rock='hashcat -a 0 -w 3'

# ── ALIASES UTILS ─────────────────────────────────────────────
alias serve='python3 -m http.server 8080'
alias listen='nc -lvnp'

# ── FONCTIONS UTILES ──────────────────────────────────────────

# Créer le dossier de travail pour une cible
target() {
  local name="${1:-target}"
  mkdir -p "$name"/{recon,web,exploit,loot,notes}
  echo "[*] Workspace créé : $name/"
  cd "$name"
}

# Scan nmap rapide + sauvegarde automatique
quickscan() {
  local ip="$1"
  local out="${2:-scan}"
  echo "[*] Scan de $ip..."
  nmap -sV -sC -T4 "$ip" -oA "$out"
  echo "[✓] Résultats dans $out.*"
}

# Lancer un listener netcat
nc-listen() {
  local port="${1:-4444}"
  echo "[*] En écoute sur le port $port..."
  nc -lvnp "$port"
}

# Encoder en base64
b64e() { echo -n "$1" | base64; }
b64d() { echo -n "$1" | base64 -d; }

# URL encode
urlencode() { python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"; }

# ── PROMPT ────────────────────────────────────────────────────
PROMPT='%F{red}[%f%F{yellow}%n%f%F{red}@%f%F{cyan}%m%f%F{red}]%f %F{green}%~%f %# '
