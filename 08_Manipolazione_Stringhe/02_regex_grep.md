# Espressioni Regolari e `grep` Avanzato

## Cosa Sono le Espressioni Regolari?

Le **espressioni regolari** (regex o regexp) sono pattern per descrivere e cercare testo. Sono il linguaggio universale della manipolazione testuale in Linux.

---

## Tipi di Regex in Linux

| Tipo | Flag grep | Descrizione |
|------|-----------|-------------|
| **BRE** — Basic | `grep` (default) | Standard POSIX di base |
| **ERE** — Extended | `grep -E` o `egrep` | Più potente, meno backslash |
| **PCRE** — Perl Compatible | `grep -P` | Funzionalità avanzate (lookahead, ecc.) |

---

## Metacaratteri Fondamentali

### Caratteri singoli

| Pattern | Corrisponde a |
|---------|---------------|
| `.` | qualsiasi carattere (tranne newline) |
| `[abc]` | uno tra: a, b, c |
| `[a-z]` | una lettera minuscola |
| `[A-Z0-9]` | una lettera maiuscola o cifra |
| `[^abc]` | qualsiasi carattere **tranne** a, b, c |
| `\d` | cifra (solo PCRE; in ERE: `[0-9]`) |
| `\w` | parola: `[a-zA-Z0-9_]` |
| `\s` | spazio: `[ \t\n]` |

### Ancoraggi

| Pattern | Significato |
|---------|-------------|
| `^` | inizio riga |
| `$` | fine riga |
| `\b` | confine di parola |
| `\B` | NON confine di parola |

### Quantificatori

| Pattern | Significato |
|---------|-------------|
| `*` | 0 o più volte |
| `+` | 1 o più volte (ERE/PCRE) |
| `?` | 0 o 1 volta (ERE/PCRE) |
| `{n}` | esattamente n volte |
| `{n,m}` | da n a m volte |
| `{n,}` | almeno n volte |

### Raggruppamento e Alternanza (ERE)

```regex
(cat|dog)      # cat oppure dog
(ab)+          # ab, abab, ababab...
(\d{1,3}\.){3}\d{1,3}   # formato IPv4
```

---

## `grep` — Opzioni Fondamentali

### Opzioni di ricerca

| Opzione | Significato |
|---------|-------------|
| `-E` | usa ERE (Extended Regular Expressions) |
| `-P` | usa PCRE (Perl Compatible) |
| `-i` | case-insensitive |
| `-v` | inverte (mostra righe che NON corrispondono) |
| `-w` | corrisponde solo a parole intere |
| `-x` | corrisponde a righe intere |
| `-F` | tratta il pattern come stringa letterale (no regex) |

### Opzioni di output

| Opzione | Significato |
|---------|-------------|
| `-n` | mostra il numero di riga |
| `-c` | conta le righe corrispondenti |
| `-l` | mostra solo i nomi dei file con corrispondenze |
| `-L` | mostra i file SENZA corrispondenze |
| `-o` | mostra solo la parte corrispondente |
| `-h` | non mostrare il nome del file |
| `-A N` | mostra N righe **dopo** la corrispondenza |
| `-B N` | mostra N righe **prima** |
| `-C N` | mostra N righe prima e dopo (contesto) |

### Ricerca ricorsiva

| Opzione | Significato |
|---------|-------------|
| `-r` | ricorsivo nelle directory |
| `-R` | ricorsivo (segue anche i symlink) |
| `--include="*.py"` | limita a certi file |
| `--exclude="*.log"` | esclude certi file |

---

## Esempi Pratici

### Ricerche di base

```bash
# Righe che iniziano con #
grep '^#' /etc/apt/sources.list

# Righe non vuote e non commenti
grep -v '^[[:space:]]*#\|^[[:space:]]*$' /etc/hosts

# Indirizzi IP (formato semplice)
grep -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' /var/log/auth.log

# Email address
grep -E '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' contatti.txt
```

### Estrarre corrispondenze con `-o`

```bash
# Estrai tutti i numeri di un file
grep -oE '[0-9]+' dati.txt

# Estrai tutti gli URL
grep -oE 'https?://[^ ]+' pagina.html

# Estrai solo la parte di interesse
echo "Versione: 3.14.159" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+'
```

### Ricerca con contesto

```bash
# 3 righe prima e dopo "ERROR"
grep -C 3 "ERROR" /var/log/syslog

# Cercare in tutto il codice sorgente
grep -rn "TODO" ./src/ --include="*.py"

# File che contengono la parola "password" (attenzione!)
grep -rl "password" /etc/ 2>/dev/null
```

### Combinare più pattern

```bash
# Righe con A oppure B
grep -E "errore|warning" app.log

# Righe con A e B (entrambi presenti)
grep "errore" app.log | grep "connessione"

# Ricerca multi-pattern con -e
grep -e "WARN" -e "ERROR" -e "FATAL" app.log
```

---

## Classi di Caratteri POSIX

Usabili dentro `[]`:

| Classe | Equivale a |
|--------|-----------|
| `[:alpha:]` | `[a-zA-Z]` |
| `[:digit:]` | `[0-9]` |
| `[:alnum:]` | `[a-zA-Z0-9]` |
| `[:space:]` | spazio, tab, newline |
| `[:upper:]` | `[A-Z]` |
| `[:lower:]` | `[a-z]` |
| `[:punct:]` | caratteri di punteggiatura |

```bash
grep '^[[:upper:]]' file.txt     # righe che iniziano in maiuscolo
grep '[[:digit:]]' file.txt       # righe con almeno una cifra
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_stringhe_bash.md>)
- [➡️ successivo](<03_awk_avanzato.md>)
