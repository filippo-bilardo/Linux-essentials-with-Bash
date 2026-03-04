# Il Filesystem di Linux

## La Struttura ad Albero

Il filesystem di Linux è organizzato come un **albero gerarchico** con una singola radice, chiamata **root** e indicata con `/`. Tutto — file, directory, dispositivi, processi — si trova da qualche parte in questo albero.

```
/
├── bin/        → Comandi essenziali per tutti gli utenti
├── boot/       → File necessari per l'avvio del sistema
├── dev/        → File speciali per i dispositivi hardware
├── etc/        → File di configurazione del sistema
├── home/       → Directory home degli utenti
│   ├── filippo/
│   └── alice/
├── lib/        → Librerie condivise essenziali
├── media/      → Punti di mount per dispositivi rimovibili
├── mnt/        → Punti di mount temporanei
├── opt/        → Software opzionale di terze parti
├── proc/       → Filesystem virtuale: informazioni sui processi
├── root/       → Home dell'utente root
├── run/        → Dati runtime dei processi
├── sbin/       → Comandi di sistema (per root)
├── srv/        → Dati dei servizi di rete
├── sys/        → Filesystem virtuale: informazioni sull'hardware
├── tmp/        → File temporanei (cancellati al riavvio)
├── usr/        → Programmi e dati degli utenti
│   ├── bin/    → Comandi utente (la maggior parte dei programmi)
│   ├── lib/    → Librerie
│   ├── local/  → Software installato localmente
│   └── share/  → Dati condivisi (documentazione, icone...)
└── var/        → Dati variabili (log, database, email...)
    ├── log/    → File di log del sistema
    └── www/    → File dei web server
```

## Le Directory Principali

### `/` — La Radice
Il punto di partenza di tutto il filesystem. Non esiste nulla "sopra" di `/`.

### `/home` — Le Directory Utente
Ogni utente ha la propria directory home in `/home/nomeutente`. Qui si trovano documenti personali, configurazioni e file dell'utente. Il simbolo `~` è una scorciatoia per la propria home.

```bash
echo ~              # /home/filippo
echo ~root          # /root
ls ~                # contenuto della tua home
```

### `/etc` — Configurazioni di Sistema
Contiene quasi tutti i file di configurazione del sistema. Esempi importanti:

```
/etc/passwd         → informazioni sugli utenti
/etc/group          → informazioni sui gruppi
/etc/hostname       → nome del computer
/etc/hosts          → mappatura IP→nome locale
/etc/fstab          → configurazione dei filesystem montati
/etc/ssh/           → configurazione SSH
/etc/apt/           → configurazione gestore pacchetti (Debian/Ubuntu)
```

### `/var` — Dati Variabili
Dati che cambiano durante il normale funzionamento del sistema:
- `/var/log/` — log di sistema (`/var/log/syslog`, `/var/log/auth.log`)
- `/var/www/` — file dei siti web
- `/var/lib/` — dati persistenti delle applicazioni

### `/proc` e `/sys` — Filesystem Virtuali
Esistono solo in memoria, rappresentano lo stato del sistema in tempo reale:

```bash
cat /proc/cpuinfo       # informazioni CPU
cat /proc/meminfo       # informazioni memoria
cat /proc/version       # versione del kernel
ls /proc/               # un file per ogni processo (PID)
```

### `/dev` — File Dispositivo
Su Linux, i dispositivi hardware sono rappresentati come file:

```bash
/dev/sda            → primo disco rigido (SATA)
/dev/sda1           → prima partizione del disco
/dev/nvme0n1        → disco NVMe
/dev/tty            → terminale corrente
/dev/null           → "buco nero" (scarta tutto l'input)
/dev/zero           → produce zeri infiniti
/dev/random         → generatore di numeri casuali
```

---

## Percorsi: Assoluti e Relativi

### Percorso Assoluto
Inizia sempre con `/` e specifica il percorso completo dalla radice:

```bash
/home/filippo/documenti/relazione.txt
/etc/apt/sources.list
/var/log/syslog
```

### Percorso Relativo
Parte dalla directory corrente (senza `/`):

```bash
documenti/relazione.txt     # una directory più in basso
../altro_utente/file.txt    # salgo di un livello poi scendo
../../etc/hostname           # salgo di due livelli
./script.sh                 # file nella directory corrente
```

### Riferimenti Speciali

| Simbolo | Significato |
|---------|------------|
| `.` | Directory corrente |
| `..` | Directory padre (un livello su) |
| `~` | Home dell'utente corrente (`/home/filippo`) |
| `~utente` | Home di un utente specifico |
| `-` | (solo con `cd`) Torna alla directory precedente |

```bash
cd ..           # vai su di un livello
cd ../..        # vai su di due livelli
cd ~            # vai alla home
cd -            # torna alla directory precedente
```

---

## Il Filesystem e i Dispositivi: Mounting

A differenza di Windows (dove ogni disco ha una lettera diversa: `C:\`, `D:\`...), Linux usa un **unico albero** di directory. I dischi e le partizioni vengono "montati" (collegati) in un punto dell'albero chiamato **mount point**.

```bash
mount               # mostra tutti i filesystem montati
df -h               # spazio su disco per ogni filesystem
lsblk               # struttura dei dispositivi a blocchi
```

---

## Tipi di File in Linux

In Linux, tutto è un file. I tipi principali:

| Tipo | Simbolo in `ls -l` | Descrizione |
|------|-------------------|----|
| File regolare | `-` | Testo, binari, immagini... |
| Directory | `d` | Cartella |
| Link simbolico | `l` | Scorciatoia a un altro file |
| File dispositivo blocco | `b` | Disco, partizione |
| File dispositivo carattere | `c` | Terminale, porta seriale |
| Socket | `s` | Comunicazione inter-processo |
| Named pipe (FIFO) | `p` | Canale di comunicazione |

```bash
ls -la /dev/ | head -20    # vedere i tipi di file in /dev
file nomefile              # identifica il tipo di un file
```

---

## I File Nascosti

Un file o directory il cui nome inizia con `.` (punto) è considerato **nascosto** e non viene mostrato da `ls` di default.

```bash
ls -a ~         # mostra anche i file nascosti
ls -la ~        # lista lunga con nascosti
```

File di configurazione nascosti comuni nella home:
```
~/.bashrc       → configurazione Bash
~/.profile      → script di login
~/.ssh/         → chiavi SSH
~/.gitconfig    → configurazione Git
~/.vimrc        → configurazione Vim
```

---

- [📑 Indice](<README.md>)
- [➡️ successivo](<02_comandi_navigazione_gestione.md>)
