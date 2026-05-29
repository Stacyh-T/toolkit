# ⚡ toolkit v1.1

> Mon environnement de cybersécurité portable — Kali Linux / Parrot OS.

---

## 🚀 Installation rapide

```bash
# Prérequis
git --version
ping -c 3 github.com
df -h ~               # prévoir ~3 Go libres minimum (6 Go avec RE + IoT)

# Installation
git clone https://github.com/Stacyh-T/toolkit.git ~/toolkit
cd ~/toolkit
chmod +x install.sh setup/*.sh scripts/*.sh
sudo ./install.sh
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
│   ├── configs.sh              # Dotfiles + ~/.zshenv
│   ├── re-tools.sh             # 🆕 Reverse Engineering (optionnel, ~200 Mo + Ghidra ~1 Go)
│   └── iot-tools.sh            # 🆕 IoT & WiFi (optionnel, ~300 Mo)
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
| Passwords | hashcat, john, crunch, **medusa**, **ncrack** |
| RE (base) | **gdb**, **binutils** (readelf, objdump, strings, file), **strace**, **ltrace**, **binwalk**, **upx** |
| Exploit | metasploit-framework |
| Utils | tmux, git, python3-pip, jq, wget, unzip, golang-go |

### Via GitHub → `~/tools/`

| Catégorie | Outil | Repo |
|---|---|---|
| Recon & OSINT | Spiderfoot | https://github.com/smicallef/spiderfoot |
| Recon & OSINT | Datasploit | https://github.com/DataSploit/datasploit |
| Recon & OSINT | Photon | https://github.com/s0md3v/Photon |
| Recon & OSINT | Social-Analyzer | https://github.com/qeeqbox/social-analyzer |
| **OSINT** | **Holehe** | https://github.com/megadose/holehe |
| **OSINT** | **TruffleHog** | https://github.com/trufflesecurity/trufflehog |
| **OSINT** | **PhoneInfoga** | https://github.com/sundowndev/phoneinfoga |
| **OSINT** | **WaybackURLs** | https://github.com/tomnomnom/waybackurls |
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
| **PrivEsc Windows** | **GodPotato** | https://github.com/BeichenDream/GodPotato |
| **PrivEsc Windows** | **PrintSpoofer** | https://github.com/itm4n/PrintSpoofer |
| **PrivEsc Windows** | **JuicyPotato** | https://github.com/ohpe/juicy-potato |
| Pivoting | Chisel | https://github.com/jpillora/chisel |
| Pivoting | Ligolo-ng | https://github.com/nicocha30/ligolo-ng |
| Pivoting | Proxychains-ng | https://github.com/rofl0r/proxychains-ng |
| Pivoting | sshuttle | https://github.com/sshuttle/sshuttle |
| **RE** | **pwndbg** | https://github.com/pwndbg/pwndbg |
| Reverse Shells | revshells | https://github.com/0dayCTF/reverse-shell-generator |
| Forensics | Autopsy | https://github.com/sleuthkit/autopsy |
| Forensics | Volatility3 | https://github.com/volatilityfoundation/volatility3 |
| Forensics | Plaso | https://github.com/log2timeline/plaso |

### Module RE — `setup/re-tools.sh` 🆕

> Module optionnel — `sudo bash setup/re-tools.sh`

| Outil | Description |
|---|---|
| gdb + pwndbg | Debugger Linux + extension CTF |
| pwntools | Framework Python exploit dev |
| checksec | Vérification des protections d'un binaire |
| binwalk | Extraction de firmware |
| upx | Décompression de binaires packés |
| Ghidra | Désassembleur/décompilateur NSA (optionnel, ~1 Go) |

### Module IoT & WiFi — `setup/iot-tools.sh` 🆕

> Module optionnel — `sudo bash setup/iot-tools.sh`

| Outil | Description |
|---|---|
| aircrack-ng | Suite WiFi (capture, injection, cracking) |
| hcxdumptool + hcxtools | Capture PMKID WiFi |
| hostapd + dnsmasq | Evil Twin / AP rogue |
| mosquitto + clients | Broker MQTT + tests |
| bluez (hcitool, gatttool) | BLE Bluetooth |
| bettercap | Framework MitM/BLE/WiFi |
| esptool | Flash ESP32/ESP8266 |
| routersploit | Exploitation routeurs IoT |

---

## ⚙️ Environnement configuré

`configs.sh` configure 3 fichiers :

| Fichier | Rôle |
|---|---|
| `~/.zshrc` → lien vers `configs/.zshrc` | Aliases, fonctions, prompt |
| `~/.tmux.conf` → lien vers `configs/tmux.conf` | Config tmux |
| `~/.zshenv` | Exports `$TOOLS`, `$WORDLISTS`, `$PATH` |

> Prompt différencié : `[kali@kali]` pour user normal, `[ROOT@kali]` en rouge pour root.

---

## ⚡ Aliases disponibles

### Recon
```
nmap-quick <ip>       # nmap -sV -sC -T4
nmap-full <ip>        # nmap -sV -sC -p-
nmap-udp <ip>         # nmap -sU -T4
nmap-vuln <ip>        # nmap --script vuln
```

### Web
```
ffuf-dir              # ffuf directories (medium wordlist)
ffuf-sub              # ffuf sous-domaines
gobuster-dir          # gobuster dir
sqlmap                # sqlmap --batch
```

### OSINT
```
spiderfoot            # OSINT → http://127.0.0.1:5001
holehe <email>        # Vérifie l'email sur 120+ services
phoneinfroga -n +33…  # OSINT numéro de téléphone
waybackurls <domain>  # URLs archivées Wayback Machine
```

### Post-Exploitation
```
secretsdump <args>    # Impacket secretsdump
GetNPUsers <args>     # AS-REP Roasting
GetUserSPNs <args>    # Kerberoasting
linpeas               # LinPEAS local
evil-winrm -i <ip>    # WinRM shell
cme smb <ip>          # CrackMapExec SMB
```

### PrivEsc Windows
```
godpotato            # Token Impersonation (Win 2012→2022)
printspoofer         # Token Impersonation (Win10/2019)
juicypotato          # Token Impersonation (legacy)
```

### Pivoting
```
chisel-server         # Chisel serveur (attaquant)
ligolo-proxy          # Ligolo-ng proxy (attaquant)
```

### Reverse Engineering
```
ghidra                # Lancer Ghidra (GUI)
r2 <binary>           # Radare2
checksec <binary>     # Vérifier les protections
gdb-pwn <binary>      # GDB + pwndbg
die <binary>          # Detect-It-Easy (identifier packer)
upx-unpack <binary>   # Déballer un binaire UPX
```

### IoT & WiFi
```
hcx-dump              # Capture PMKID WiFi
hcx-crack             # Convertir + cracker avec hashcat
mqtt-sniff            # Écouter tous les topics MQTT
routersploit          # Framework exploitation routeurs
```

### Utils
```
serve                 # python3 -m http.server 8080
serve-linpeas         # sert linpeas + affiche commande cible
serve-tool <path>     # sert n'importe quel fichier via HTTP
listen <port>         # nc -lvnp <port>
target <nom>          # crée workspace/{recon,web,exploit,loot,notes,re}
quickscan <ip>        # scan nmap + sauvegarde automatique
b64e / b64d           # encode / décode base64
urlencode <string>    # URL encode
myip                  # IP publique
localip               # IP locale
shell-old             # utiliser l'ancien terminal
shell-new             # utiliser le nouveau terminal
```

---

## 🐚 Reverse shells

```bash
# Script CLI maison
./scripts/revshell.sh <LHOST> <LPORT> all
# Types : bash · python · php · netcat · perl · ruby · powershell · upgrade · all
```

---

## 📦 Wordlists

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

## ⚠️ Étapes post-installation

| Outil | Commande requise |
|---|---|
| Impacket | `cd ~/tools/impacket && pip install . --break-system-packages` |
| pwndbg | `cd ~/tools/pwndbg && ./setup.sh` |
| Bashfuscator | `cd ~/tools/bashfuscator && pip install . --break-system-packages` |
| pwncat | `pip install pwncat-cs --break-system-packages` |
| CrackMapExec | `pip install crackmapexec --break-system-packages` |
| sshuttle | `pip install sshuttle --break-system-packages` |
| pwntools | `pip install pwntools --break-system-packages` |
| Plaso | `pip install plaso --break-system-packages` |
| Evil-WinRM | `gem install evil-winrm` |
| Chisel | `cd ~/tools/chisel && go build .` |
| Ligolo-ng | `cd ~/tools/ligolo-ng/cmd/proxy && go build .` |
| Proxychains-ng | `cd ~/tools/proxychains-ng && ./configure && make && make install` |

---

## ➕ Ajouter un outil

### Via apt
Ouvrir `setup/apt-tools.sh` et ajouter dans la bonne catégorie :
```bash
install_apt nom-outil
```

### Via GitHub
Ouvrir `setup/git-tools.sh` et ajouter :
```bash
clone_tool "nom-outil" "https://github.com/user/repo"
```
Puis ajouter l'alias dans `configs/.zshrc`.

---

## 🔄 Mettre à jour le toolkit

```bash
cd ~/toolkit
git pull
source ~/.zshrc
```

Pour réinstaller un module :
```bash
sudo bash setup/apt-tools.sh    # outils apt
sudo bash setup/git-tools.sh    # outils GitHub
sudo bash setup/re-tools.sh     # RE tools (nouveau)
sudo bash setup/iot-tools.sh    # IoT tools (nouveau)
```

---

## 📋 Changelog

### v1.1 (2026-05)
- ✅ Ajout `setup/re-tools.sh` — module Reverse Engineering (gdb, pwndbg, pwntools, ghidra)
- ✅ Ajout `setup/iot-tools.sh` — module IoT & WiFi (aircrack, mosquitto, bettercap...)
- ✅ apt-tools.sh : medusa, ncrack, gdb, binutils, strace, ltrace, binwalk, upx, tcpdump
- ✅ git-tools.sh : holehe, trufflehog, phoneinfroga, waybackurls, GodPotato, PrintSpoofer, JuicyPotato, pwndbg
- ✅ .zshrc : +30 nouveaux aliases (RE, IoT, WiFi, OSINT, PrivEsc)
- ✅ install.sh : menu mis à jour avec modules 5 (RE) et 6 (IoT)
- ✅ Workspace étendu : ajout du dossier `re/`

### v1.0 (2026-05-26)
- 🎉 Release initiale

---

## ⚠️ Disclaimer

Usage **éducatif et légal uniquement**.
