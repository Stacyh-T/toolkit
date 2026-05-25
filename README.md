# ⚡ toolkit

> Mon environnement de cybersécurité portable — Kali Linux / Parrot OS.
> Un `git clone` + `./install.sh` et je suis opérationnel.

---

## 🚀 Installation rapide

```bash
git clone https://github.com/ton-user/toolkit.git ~/toolkit
cd ~/toolkit
chmod +x install.sh setup/*.sh
sudo ./install.sh
```

---

## 📂 Structure

```
toolkit/
├── install.sh              # Script principal (menu interactif)
├── setup/
│   ├── apt-tools.sh        # Installation via apt
│   ├── git-tools.sh        # Clonage depuis GitHub → ~/tools/
│   ├── wordlists.sh        # Wordlists → ~/wordlists/
│   └── configs.sh          # Applique les dotfiles
├── configs/
│   ├── .zshrc              # Aliases, fonctions, prompt
│   └── tmux.conf           # Config tmux
├── scripts/
│   ├── recon/              # Scripts de recon perso
│   ├── web/                # Scripts web perso
│   └── utils/              # Utilitaires divers
└── wordlists/
    └── README.md           # Références wordlists
```

---

## 🛠️ Ce qui est installé

### Via apt
| Catégorie | Outils |
|---|---|
| Recon & OSINT | nmap, amass, recon-ng, dnsenum, whatweb, exiftool |
| Web | ffuf, gobuster, feroxbuster, nikto, curl, sqlmap, wafw00f |
| Network | netcat, hydra, enum4linux, wireshark, tcpdump |
| Passwords | hashcat, john, crunch |
| Exploit | metasploit-framework |
| Forensics | autopsy, volatility3 |

### Via GitHub (dans `~/tools/`)
| Outil | Repo |
|---|---|
| XSStrike | https://github.com/s0md3v/XSStrike |
| Gopherus | https://github.com/tarunkant/Gopherus |
| Impacket | https://github.com/fortra/impacket |
| Spiderfoot | https://github.com/smicallef/spiderfoot |
| Bashfuscator | https://github.com/Bashfuscator/Bashfuscator |
| Drupwn | https://github.com/immunIT/drupwn |

---

## ⚡ Alias utiles

```bash
nmap-quick <ip>       # nmap -sV -sC -T4
nmap-full <ip>        # nmap -sV -sC -p-
serve                 # python3 -m http.server 8080
listen <port>         # nc -lvnp <port>
target <nom>          # Crée workspace/{recon,web,exploit,loot,notes}
quickscan <ip>        # Scan + sauvegarde automatique
b64e / b64d           # Encode / décode base64
urlencode <string>    # URL encode
```

---

## ⚠️ Disclaimer

Usage **éducatif et légal uniquement**. N'utilise ces outils que sur des systèmes pour lesquels tu as une autorisation explicite.
