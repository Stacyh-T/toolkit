# ⚡ toolkit

> Mon environnement de cybersécurité portable — Kali Linux / Parrot OS.
---

## 🚀 Installation rapide

```bash
# Prérequis
git --version
ping -c 3 github.com
df -h ~               # prévoir ~3 Go libres minimum

# Installation
git clone https://github.com/Stacyh-T/toolkit.git ~/toolkit
cd ~/toolkit
chmod +x install.sh setup/*.sh scripts/*.sh
sudo ./install.sh

# Ouvre un nouveau terminal pour activer l'environnement
```

> 💡 Le script détecte automatiquement ton utilisateur réel — tout s'installe dans `/home/tonuser/` même lancé avec `sudo`.

---

## 📂 Structure

```
toolkit/
├── install.sh                  # Script principal (menu interactif)
├── setup/
│   ├── apt-tools.sh            # Outils via apt (~800 Mo)
│   ├── git-tools.sh            # Outils via GitHub → ~/tools/
│   ├── wordlists.sh            # Wordlists → ~/wordlists/
│   └── configs.sh              # Dotfiles + ~/.zshenv
├── configs/
│   ├── .zshrc                  # Aliases, fonctions, prompt custom
│   └── tmux.conf               # Config tmux
├── scripts/
│   ├── revshell.sh             # Générateur de reverse shells (CLI)
│   ├── recon/                  # Scripts de recon perso
│   ├── web/                    # Scripts web perso
│   └── utils/                  # Utilitaires divers
└── wordlists/
    └── README.md               # Références wordlists
```

> ⚠️ `~/tools/` et `~/wordlists/` sont créés sur ta machine — ils ne sont pas dans ce repo.

---

## 🛠️ Ce qui est installé

### Via apt

| Catégorie | Outils |
|---|---|
| Recon & OSINT | nmap, amass, recon-ng, maltego, sherlock, dnsenum, whatweb, exiftool |
| Web | burpsuite, zaproxy, ffuf, gobuster, feroxbuster, nikto, curl, dirb, wfuzz, sqlmap, wafw00f |
| Network | netcat, hydra, enum4linux, nbtscan, onesixtyone, snmp, macchanger, wireshark, tcpdump |
| Databases | mysql-client, postgresql-client |
| Passwords | hashcat, john, crunch |
| Exploit | metasploit-framework |
| Utils | tmux, git, python3-pip, jq, wget, unzip |

### Via GitHub → `~/tools/`

| Catégorie | Outil | Repo |
|---|---|---|
| Recon & OSINT | Spiderfoot | https://github.com/smicallef/spiderfoot |
| Recon & OSINT | Datasploit | https://github.com/DataSploit/datasploit |
| Recon & OSINT | Photon | https://github.com/s0md3v/Photon |
| Recon & OSINT | Social-Analyzer | https://github.com/qeeqbox/social-analyzer |
| Web | XSStrike | https://github.com/s0md3v/XSStrike |
| Web | BruteXSS | https://github.com/rajeshmajumdar/BruteXSS |
| Web | Gopherus | https://github.com/tarunkant/Gopherus |
| Web | Drupwn | https://github.com/immunIT/drupwn |
| Web | Droopescan | https://github.com/SamJoan/droopescan |
| Network | Impacket | https://github.com/fortra/impacket |
| Network | SMTP-User-Enum | https://github.com/cytopia/smtp-user-enum |
| Network | SIPVicious | https://github.com/EnableSecurity/sipvicious |
| Post-Exploit | PEASS-ng (LinPEAS/WinPEAS) | https://github.com/peass-ng/PEASS-ng |
| Post-Exploit | pwncat | https://github.com/calebstewart/pwncat |
| Post-Exploit | Evil-WinRM | https://github.com/Hackplayers/evil-winrm |
| Post-Exploit | Mimikatz | https://github.com/gentilkiwi/mimikatz |
| Post-Exploit | CrackMapExec | https://github.com/byt3bl33d3r/CrackMapExec |
| Post-Exploit | Bashfuscator | https://github.com/Bashfuscator/Bashfuscator |
| Pivoting | Chisel | https://github.com/jpillora/chisel |
| Pivoting | Ligolo-ng | https://github.com/nicocha30/ligolo-ng |
| Pivoting | Proxychains-ng | https://github.com/rofl0r/proxychains-ng |
| Pivoting | sshuttle | https://github.com/sshuttle/sshuttle |
| Reverse Shells | revshells | https://github.com/0dayCTF/reverse-shell-generator |
| Forensics | Autopsy | https://github.com/sleuthkit/autopsy |
| Forensics | Volatility3 | https://github.com/volatilityfoundation/volatility3 |
| Forensics | Plaso | https://github.com/log2timeline/plaso |

---

## ⚙️ Environnement configuré

`configs.sh` configure 3 fichiers :

| Fichier | Rôle |
|---|---|
| `~/.zshrc` → lien vers `configs/.zshrc` | Aliases, fonctions, prompt |
| `~/.tmux.conf` → lien vers `configs/tmux.conf` | Config tmux |
| `~/.zshenv` | Exports `$TOOLS`, `$WORDLISTS`, `$PATH` (chargés en premier) |

> Prompt différencié : `[kali@kali]` pour user normal, `[ROOT@kali]` en rouge pour root.

---

## ⚡ Aliases disponibles

### Recon
```bash
nmap-quick <ip>       # nmap -sV -sC -T4
nmap-full <ip>        # nmap -sV -sC -p-
nmap-udp <ip>         # nmap -sU -T4
nmap-vuln <ip>        # nmap --script vuln
```

### Web
```bash
ffuf-dir              # ffuf directories (medium wordlist)
ffuf-sub              # ffuf sous-domaines
gobuster-dir          # gobuster dir
```

### Outils GitHub
```bash
spiderfoot            # OSINT → http://127.0.0.1:5001
xsstrike --url <url>  # scanner XSS
secretsdump <args>    # Impacket secretsdump
GetNPUsers <args>     # Impacket AS-REP Roasting
GetUserSPNs <args>    # Impacket Kerberoasting
linpeas               # LinPEAS local
evil-winrm -i <ip>    # WinRM shell
vol -f <dump> <plugin> # Volatility3
ligolo-proxy          # Ligolo proxy (ta machine)
chisel-server         # Chisel serveur
```

### Utils
```bash
serve                 # python3 -m http.server 8080
serve-linpeas         # sert linpeas + affiche commande cible
serve-tool <path>     # sert n'importe quel fichier via HTTP
listen <port>         # nc -lvnp <port>
target <nom>          # crée workspace/{recon,web,exploit,loot,notes}
quickscan <ip>        # scan nmap + sauvegarde automatique
b64e / b64d           # encode / décode base64
urlencode <string>    # URL encode
myip                  # IP publique
localip               # IP locale
```

---

## 🐚 Reverse shells

```bash
# Script CLI maison
./scripts/revshell.sh <LHOST> <LPORT> all

# Types : bash · python · php · netcat · perl · ruby · powershell · upgrade · all

# Interface web offline
revshells
```

---

## 📦 Wordlists

Le script vérifie d'abord les wordlists déjà présentes sur Kali avant de télécharger :

```
/usr/share/wordlists/   ← rockyou.txt (Kali natif)
/usr/share/seclists/    ← SecLists via apt
/usr/share/dirbuster/   ← listes dirbuster
```

Structure finale dans `~/wordlists/` :
```
passwords/rockyou.txt
directories/common.txt · medium.txt · big.txt
subdomains/top5000.txt · top20000.txt
usernames/common.txt · names.txt
fuzzing/fuzz.txt · lfi.txt
seclists/              ← SecLists complet
```

---

## ⚠️ Outils nécessitant une étape post-install

| Outil | Commande requise |
|---|---|
| Impacket | `cd ~/tools/impacket && pip install . --break-system-packages` |
| Bashfuscator | `cd ~/tools/bashfuscator && pip install . --break-system-packages` |
| pwncat | `pip install pwncat-cs --break-system-packages` |
| CrackMapExec | `pip install crackmapexec --break-system-packages` |
| sshuttle | `pip install sshuttle --break-system-packages` |
| Plaso | `pip install plaso --break-system-packages` |
| Drupwn | `pip install -r ~/tools/drupwn/requirements.txt --break-system-packages` |
| Evil-WinRM | `gem install evil-winrm` |
| Chisel | `cd ~/tools/chisel && go build .` |
| Ligolo-ng | `cd ~/tools/ligolo-ng/cmd/proxy && go build .` |
| Proxychains-ng | `cd ~/tools/proxychains-ng && ./configure && make && make install` |

---

## ⚠️ Disclaimer

Usage **éducatif et légal uniquement**.
