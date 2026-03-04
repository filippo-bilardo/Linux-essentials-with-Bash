# Distribuzioni Linux: Differenze e Scelte

## Che cos'è una Distribuzione?

Una **distribuzione Linux** (o *distro*) è un sistema operativo completo costruito attorno al kernel Linux. Ogni distribuzione combina:

- Il **kernel Linux**
- Strumenti di sistema **GNU** (bash, coreutils, etc.)
- Un **gestore di pacchetti** per installare software
- Un **ambiente desktop** (opzionale)
- Software applicativo preinstallato
- Strumenti di configurazione e installazione

Esistono centinaia di distribuzioni, ognuna ottimizzata per scopi diversi. Vediamo le più importanti.

---

## Le Famiglie di Distribuzioni

Le distribuzioni si raggruppano in "famiglie" che condividono il gestore di pacchetti e la filosofia di base.

### Famiglia Debian / Ubuntu

```
Debian (stabile, universale)
└── Ubuntu (facile, desktop/server)
    ├── Linux Mint (semplicissimo, ottimo per principianti)
    ├── Kubuntu (desktop KDE)
    ├── Xubuntu (desktop XFCE, leggero)
    └── Ubuntu Server
```

**Gestore pacchetti**: `apt` / `dpkg`  
**Formato pacchetti**: `.deb`  
**Filosofia**: stabilità, universalità, ampia compatibilità

### Famiglia Red Hat / Fedora

```
Red Hat Enterprise Linux - RHEL (commerciale, enterprise)
├── Fedora (innovativa, testing ground)
├── CentOS Stream (community, rolling)
├── AlmaLinux / Rocky Linux (RHEL-compatibili, gratuiti)
└── Oracle Linux
```

**Gestore pacchetti**: `dnf` / `rpm`  
**Formato pacchetti**: `.rpm`  
**Filosofia**: stabilità enterprise, ciclo di supporto lungo

### Famiglia Arch

```
Arch Linux (rolling release, massimo controllo)
├── Manjaro (Arch più facile, ottimo desktop)
├── EndeavourOS (Arch con installer guidato)
└── SteamOS (console di gioco Valve)
```

**Gestore pacchetti**: `pacman`  
**Filosofia**: keep it simple, rolling release, utenti avanzati

### Altre Distribuzioni Notevoli

| Distribuzione | Caratteristica |
|---|---|
| **openSUSE** | Stabilità + Tumbleweed (rolling) |
| **Gentoo** | Compilazione da sorgente, massima ottimizzazione |
| **Slackware** | La più antica ancora viva (1993) |
| **Alpine Linux** | Minimalista, usatissimo nei container Docker |
| **Kali Linux** | Sicurezza informatica e penetration testing |
| **Raspbian / Raspberry Pi OS** | Per schede Raspberry Pi |

---

## Quale Distribuzione Scegliere?

### Per i principianti
- **Linux Mint** — interfaccia familiare, tutto funziona subito
- **Ubuntu** — ottima documentazione, grande comunità
- **Zorin OS** — pensato per chi arriva da Windows

### Per il desktop avanzato
- **Fedora** — software aggiornato, innovativa
- **Manjaro** — rolling release con interfacce curate

### Per i server
- **Ubuntu Server** — facilissimo, enorme ecosistema
- **Debian** — solidissimo, minimalista
- **Rocky Linux / AlmaLinux** — compatibile RHEL, enterprise

### Per imparare Linux a fondo
- **Arch Linux** — installi tutto a mano, capisci tutto
- **Debian** — filosofia pura Unix

### Per la sicurezza informatica
- **Kali Linux** — centinaia di strumenti preinstallati
- **Parrot OS** — più leggero di Kali

---

## Il Ciclo di Rilascio

Le distribuzioni seguono strategie di aggiornamento diverse:

| Tipo | Come funziona | Esempi |
|---|---|---|
| **Rilascio fisso** | Versioni numerate (es. 22.04, 24.04) ogni 6-24 mesi | Ubuntu, Fedora, Debian |
| **Rolling release** | Aggiornamenti continui, sempre all'ultima versione | Arch, openSUSE Tumbleweed |
| **LTS (Long Term Support)** | Supporto esteso (5-10 anni), ideale per server | Ubuntu LTS, RHEL |

---

## Come Provare Linux senza Installarlo

- **Live USB**: avvia Linux da una chiavetta USB senza modificare il disco
- **Macchina virtuale**: usa VirtualBox o VMware per testare
- **WSL**: Windows Subsystem for Linux su Windows 10/11
- **Cloud shell**: terminali Linux online (es. Google Cloud Shell)

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<03_applicazioni_open_source.md>)
- [➡️ successivo](<05_competenze_ict.md>)
