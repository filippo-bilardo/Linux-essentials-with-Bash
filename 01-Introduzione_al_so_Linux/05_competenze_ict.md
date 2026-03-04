# Competenze ICT — Lavorare con Linux

## Avviare Linux

Quando accendi un computer con Linux installato, il processo di avvio (boot) segue questi passi:

1. **BIOS/UEFI** — firmware hardware, verifica l'hardware e cerca il bootloader
2. **GRUB** — bootloader che permette di scegliere il sistema operativo da avviare
3. **Kernel Linux** — viene caricato in memoria, inizializza l'hardware
4. **systemd (PID 1)** — gestore dei servizi di sistema, avvia tutti i processi
5. **Display Manager** — schermata di login grafica (es. GDM, SDDM, LightDM)
6. **Desktop Environment** — l'interfaccia grafica (es. GNOME, KDE, XFCE)

---

## Ambienti Desktop di Linux

Un **Desktop Environment** (DE) è il sistema grafico che fornisce finestre, icone, barre e applicazioni di sistema. I più diffusi:

| Desktop | Caratteristiche | Distribuzioni tipiche |
|---|---|---|
| **GNOME** | Moderno, minimalista, touch-friendly | Ubuntu, Fedora |
| **KDE Plasma** | Ricco di funzionalità, altamente personalizzabile | Kubuntu, openSUSE |
| **XFCE** | Leggero, classico, veloce su hardware vecchio | Xubuntu, Linux Mint XFCE |
| **LXQt** | Estremamente leggero | Lubuntu |
| **Cinnamon** | Simile a Windows, intuitivo | Linux Mint |
| **MATE** | Fork di GNOME 2, classico | Ubuntu MATE |

---

## Il Terminale: lo Strumento Fondamentale

Su Linux, il **terminale** (o emulatore di terminale) è l'applicazione grafica che ospita la **shell**, cioè la riga di comando. È lo strumento più potente di Linux.

### Aprire il terminale

- **Ubuntu/GNOME**: cerca "Terminale" nelle applicazioni, oppure `Ctrl+Alt+T`
- **KDE**: cerca "Konsole"
- **Linux Mint**: cerca "Terminal" o premi `Ctrl+Alt+T`
- **Clic destro sul desktop**: molti DE hanno "Apri terminale qui"

### Anatomia del prompt

Quando apri il terminale vedi il **prompt**, che di solito ha questa forma:

```
filippo@ubuntu:~$
```

| Parte | Significato |
|---|---|
| `filippo` | Il nome utente corrente |
| `@` | Separatore |
| `ubuntu` | Il nome del computer (hostname) |
| `:` | Separatore |
| `~` | La directory corrente (`~` = home dell'utente) |
| `$` | Utente normale (diventa `#` per root) |

---

## I Primi Comandi Linux

Apri il terminale e prova questi comandi:

### Informazioni sull'utente e sul sistema
```bash
whoami          # Chi sono? (nome utente)
id              # ID utente e gruppi
hostname        # Nome del computer
uname -a        # Informazioni complete sul kernel e il sistema
date            # Data e ora attuali
cal             # Calendario del mese corrente
uptime          # Da quanto tempo il sistema è acceso
```

### Navigazione rapida
```bash
pwd             # Dove mi trovo? (Print Working Directory)
ls              # Cosa c'è qui? (lista file e cartelle)
ls -la          # Lista dettagliata con file nascosti
cd ~            # Vai alla home
cd /            # Vai alla radice del filesystem
```

### Informazioni sull'hardware
```bash
lscpu           # Informazioni sul processore
free -h         # Memoria RAM disponibile (-h = formato leggibile)
df -h           # Spazio su disco
lsblk           # Lista dispositivi a blocchi (dischi)
```

---

## Gestione Utenti: Base

Linux è un sistema **multiutente**. Ogni utente ha:
- Un **username** univoco
- Una **home directory** (es. `/home/filippo`)
- Un **UID** (User ID, numero univoco)
- Appartenenza a uno o più **gruppi**

### Tipi di utenti
| Tipo | UID | Descrizione |
|---|---|---|
| **root** | 0 | Amministratore, accesso totale |
| **Utenti di sistema** | 1-999 | Creati dai servizi (es. www-data, mysql) |
| **Utenti normali** | 1000+ | Utenti reali del sistema |

### sudo: eseguire comandi come amministratore
```bash
sudo apt update          # Aggiorna la lista pacchetti (richiede password)
sudo -i                  # Apre una shell root (usare con cautela!)
```

Il comando `sudo` (Super User DO) permette a utenti autorizzati di eseguire comandi con privilegi di amministratore senza conoscere la password di root.

---

## Spegnere e Riavviare

```bash
sudo shutdown now        # Spegni subito
sudo shutdown -h +10     # Spegni tra 10 minuti
sudo reboot              # Riavvia
```

---

## Installare Software su Linux

Il **gestore di pacchetti** automatizza il download, l'installazione e l'aggiornamento del software.

### Sistemi Debian/Ubuntu (apt)
```bash
sudo apt update                  # Aggiorna la lista dei pacchetti disponibili
sudo apt upgrade                 # Aggiorna tutti i pacchetti installati
sudo apt install nome-pacchetto  # Installa un pacchetto
sudo apt remove nome-pacchetto   # Rimuove un pacchetto
apt search parola-chiave         # Cerca un pacchetto
```

### Sistemi Fedora/RHEL (dnf)
```bash
sudo dnf update
sudo dnf install nome-pacchetto
sudo dnf remove nome-pacchetto
```

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<04_distribuzioni_linux.md>)
