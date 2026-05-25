# ⚡ toolkit

> Mon environnement de cybersécurité portable — Kali Linux / Parrot OS.
> Un `git clone` + `./install.sh` et je suis opérationnel.

---

## 🚀 Installation rapide

```bash
# 1. Vérifie les prérequis
git --version
ping -c 3 github.com
df -h ~               # il faut ~3 Go libres

# 2. Clone et installe
git clone https://github.com/ton-user/toolkit.git ~/toolkit
cd ~/toolkit
chmod +x install.sh setup/*.sh scripts/*.sh
sudo ./install.sh
```

> 💡 Sur Kali, les outils déjà installés sont automatiquement **ignorés** — pas de réinstallation inutile.

---

## 📂 Structure

```
toolkit/
├── install.sh                  # Script principal (menu interactif + vérif espace disque)
├── setup/
│   ├── apt-tools.sh            # Installation via apt (~800 Mo)
│   ├── git-tools.sh            # Clonage depuis GitHub → ~/tools/ (~200 Mo)
│   ├── wordlists.sh            # Wordlists → ~/wordlists/ (~1.2 Go)
│   └── configs.sh              # Applique les dotfiles (.zshrc, tmux)
├── configs/
│   ├── .zshrc                  # Aliases, fonctions, prompt
│   └── tmux.conf               # Config tmux (splits, navigation, barre statut)
├── scripts/
│   ├── revshell.sh             # Générateur de reverse shells (CLI)
│   ├── recon/                  # Scripts de recon perso
│   ├── web/                    # Scripts web perso
│   └── utils/                  # Utilitaires divers
└── wordlists/
    └── README.md               # Références wordlists (SecLists, rockyou…)
```
---

## 🛠️ Ce qui est installé

### Via apt

| Catégorie | Outils |
|---|---|
| Recon & OSINT | nmap, amass, recon-ng, maltego, sherlock, dnsenum, whatweb, exiftool |
| Web | ffuf, gobuster, feroxbuster, nikto, curl, dirb, wfuzz, sqlmap, wafw00f |
| Network | netcat, hydra, enum4linux, nbtscan, onesixtyone, snmp, macchanger, wireshark, tcpdump |
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

## ⚡ Alias utiles

```bash
# Recon
nmap-quick <ip>             # nmap -sV -sC -T4
nmap-full <ip>              # nmap -sV -sC -p-
nmap-udp <ip>               # nmap -sU -T4
nmap-vuln <ip>              # nmap --script vuln

# Web
ffuf-dir                    # ffuf sur directories (medium)
ffuf-sub                    # ffuf sur sous-domaines
gobuster-dir                # gobuster dir avec wordlist medium

# Passwords
john-rock <hashfile>        # john avec rockyou
hashcat-rock                # hashcat -a 0 -w 3

# Outils GitHub
spiderfoot                  # interface web OSINT → http://127.0.0.1:5001
xsstrike --url <url>        # scanner XSS
vol -f <mem.dmp> <plugin>   # Volatility3
secretsdump <domain/user:pass@ip>
GetNPUsers <domain/> -usersfile users.txt
linpeas                     # lance linpeas.sh localement
evil-winrm -i <ip> -u <user> -p <pass>
ligolo-proxy                # proxy Ligolo sur ta machine
chisel-server               # chisel en mode serveur

# Utils
serve                       # python3 -m http.server 8080
serve-linpeas               # sert linpeas + affiche commande cible
serve-tool <chemin>         # sert n'importe quel fichier via HTTP
listen <port>               # nc -lvnp <port>
target <nom>                # crée workspace/{recon,web,exploit,loot,notes}
quickscan <ip>              # scan nmap + sauvegarde automatique
b64e / b64d                 # encode / décode base64
urlencode <string>          # URL encode
myip                        # IP publique
localip                     # IP locale
```

---

## 🐚 Reverse shells

```bash
chmod +x scripts/revshell.sh

# Tous les shells disponibles
./scripts/revshell.sh <LHOST> <LPORT> all

# Un type spécifique
./scripts/revshell.sh 10.10.14.1 4444 bash
./scripts/revshell.sh 10.10.14.1 4444 python
./scripts/revshell.sh 10.10.14.1 4444 powershell

# Upgrade shell basique → TTY interactif
./scripts/revshell.sh 10.10.14.1 4444 upgrade

# Générateur web offline (interface navigateur)
revshells
```

Types disponibles : `bash` · `python` · `php` · `netcat` · `perl` · `ruby` · `powershell` · `upgrade` · `all`

---

## 📦 Wordlists (~1.2 Go)

Installées dans `~/wordlists/` via `setup/wordlists.sh` :

```
~/wordlists/
├── passwords/rockyou.txt
├── directories/common.txt · medium.txt · big.txt
├── subdomains/top5000.txt
├── usernames/common.txt
├── fuzzing/fuzz.txt
└── seclists/              ← SecLists complet
```

---

## ⚠️ Disclaimer

Usage **éducatif et légal uniquement**.
