# Ottenere Aiuto e Documentazione

## Introduzione

Una delle abilità più importanti su Linux è saper trovare **autonomamente** la documentazione. Linux è dotato di un sistema di aiuto integrato molto completo: non devi sempre cercare su Google!

---

## Il Manuale di Linux: `man`

Il comando `man` (manual) mostra la pagina del manuale di un comando. È la fonte più autorevole e completa.

```bash
man ls          # manuale di ls
man grep        # manuale di grep
man man         # manuale di man (meta!)
```

### Navigare nella man page

| Tasto | Azione |
|-------|--------|
| `↑` / `↓` | Muovi su/giù riga per riga |
| `Space` / `PgDn` | Pagina successiva |
| `b` / `PgUp` | Pagina precedente |
| `/parola` | Cerca "parola" nel manuale |
| `n` | Prossima occorrenza della ricerca |
| `N` | Occorrenza precedente della ricerca |
| `g` | Vai all'inizio |
| `G` | Vai alla fine |
| `q` | Esci dal manuale |

### Sezioni del manuale

Le man page sono divise in sezioni numerate:

| Sezione | Contenuto |
|---------|-----------|
| 1 | Comandi utente |
| 2 | Chiamate di sistema (system calls) |
| 3 | Funzioni delle librerie C |
| 4 | File speciali (es. `/dev`) |
| 5 | Formato dei file di configurazione |
| 6 | Giochi |
| 7 | Miscellanea, convenzioni |
| 8 | Comandi di amministrazione di sistema |

```bash
man 5 passwd    # sezione 5: formato del file /etc/passwd
man 1 passwd    # sezione 1: comando passwd
man -k password # cerca "password" in tutte le man page (= apropos)
```

### Struttura di una man page

Una man page tipica ha queste sezioni:

```
NAME        → nome del comando e breve descrizione
SYNOPSIS    → sintassi: come usare il comando
DESCRIPTION → descrizione dettagliata del comportamento
OPTIONS     → elenco e spiegazione di tutte le opzioni
EXAMPLES    → esempi pratici d'uso
FILES       → file usati dal comando
SEE ALSO    → comandi correlati
EXIT STATUS → codici di ritorno
```

---

## Aiuto Rapido: `--help`

Quasi tutti i comandi supportano l'opzione `--help` (o `-h`) che mostra un riepilogo rapido:

```bash
ls --help
grep --help
tar --help
python3 --help
```

L'output di `--help` è molto più sintetico di `man` ma utile per ricordare rapidamente le opzioni.

---

## Il Comando `info`

`info` è un sistema di documentazione alternativo a `man`, strutturato come un ipertesto navigabile. Spesso contiene informazioni più dettagliate per i programmi GNU.

```bash
info ls
info bash
info coreutils
```

### Navigare in info

| Tasto | Azione |
|-------|--------|
| `Space` | Pagina successiva |
| `b` | Inizio del nodo |
| `n` | Nodo successivo |
| `p` | Nodo precedente |
| `u` | Nodo padre (su) |
| `Enter` | Segui un link |
| `l` | Torna al nodo precedente |
| `q` | Esci |

---

## Comandi di Ricerca Rapida

### `whatis` — descrizione in una riga
```bash
whatis ls
# ls (1) - list directory contents

whatis grep
# grep (1) - print lines that match patterns
```

### `apropos` — cerca per parola chiave
```bash
apropos copy          # trova tutti i comandi che riguardano "copy"
apropos "file system" # cerca la frase esatta
apropos -r "^list"    # usa espressioni regolari
```

`apropos` è equivalente a `man -k`.

### `type` — che tipo di comando è?
```bash
type ls       # → ls is /usr/bin/ls
type cd       # → cd is a shell builtin
type ll       # → ll is aliased to 'ls -lah'
```

### `which` — dove si trova il file eseguibile?
```bash
which python3
which bash
which -a python   # mostra tutti i percorsi (se ci sono più versioni)
```

### `whereis` — dove sono binario, sorgente e manuale?
```bash
whereis ls
# ls: /usr/bin/ls /usr/share/man/man1/ls.1.gz
```

---

## Il Comando `help` per i Builtin

Per i comandi interni (builtin) della shell, `man` non funziona sempre. Usa `help`:

```bash
help cd
help echo
help if
help for
help          # lista tutti i builtin della shell
```

---

## Leggere la SYNOPSIS di una man page

La sezione SYNOPSIS usa una notazione convenzionale:

```
ls [OPTION]... [FILE]...
    ^          ^
    |          └── argomenti opzionali (possono essere più di uno)
    └── opzioni opzionali (il... indica che si possono metterne più)

grep [OPTION]... PATTERN [FILE]...
                 ^
                 └── PATTERN è obbligatorio (senza parentesi quadre)
```

| Notazione | Significato |
|-----------|-------------|
| `[elemento]` | Opzionale |
| `elemento` | Obbligatorio |
| `...` | Può essere ripetuto |
| `a \| b` | Alternativa: a oppure b |
| `{a,b}` | Una delle scelte tra parentesi graffe |

---

## Documentazione Online

Oltre agli strumenti integrati, esistono eccellenti risorse online:

| Risorsa | URL | Contenuto |
|---------|-----|-----------|
| **man7.org** | https://man7.org/linux/man-pages/ | Man page online ufficiali |
| **ExplainShell** | https://explainshell.com | Spiega comandi passo per passo |
| **TLDR pages** | https://tldr.sh | Riassunti pratici (installabile come `tldr`) |
| **Manuale Bash** | https://www.gnu.org/software/bash/manual/ | Manuale completo di Bash |
| **ArchWiki** | https://wiki.archlinux.org | Documentazione tecnica eccellente |

### Installare tldr (Too Long; Didn't Read)
```bash
sudo apt install tldr    # installa tldr
tldr ls                  # esempi pratici e concisi
tldr tar                 # molto più leggibile di man tar!
```

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_linea_di_comando.md>)
