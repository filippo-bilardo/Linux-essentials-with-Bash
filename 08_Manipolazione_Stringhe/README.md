# Modulo 08 — Manipolazione di Stringhe in Bash

## Obiettivi del Modulo

Al termine di questo modulo sarai in grado di:

- Manipolare stringhe direttamente in Bash senza comandi esterni
- Usare espressioni regolari con `grep`, `awk` e `sed`
- Elaborare testo strutturato con `awk` in modo avanzato
- Applicare trasformazioni con `sed`, `tr`, `cut`, `sort`, `uniq`
- Confrontare file con `diff` e costruire pipeline di elaborazione testo complesse

---

## Argomenti

1. [Manipolazione di Stringhe in Bash](./01_stringhe_bash.md)
   - Lunghezza, estrazione, sostituzione, case conversion
   - Rimozione di prefissi/suffissi (`#`, `##`, `%`, `%%`)
   - Trim degli spazi, test su stringhe

2. [Espressioni Regolari e `grep` Avanzato](./02_regex_grep.md)
   - BRE, ERE e PCRE
   - Metacaratteri: `.`, `*`, `+`, `?`, `[]`, `^`, `$`, `|`, `()`
   - `grep -E`, `grep -P`, `grep -o`, `grep -n`, `grep -r`

3. [`awk` Avanzato](./03_awk_avanzato.md)
   - Struttura dei programmi awk: `BEGIN`, body, `END`
   - Variabili built-in: `NR`, `NF`, `FS`, `OFS`, `RS`
   - Array associativi in awk
   - Funzioni: `sub()`, `gsub()`, `split()`, `sprintf()`

4. [`sed` Avanzato](./04_sed_avanzato.md)
   - Comandi: sostituzione `s`, cancellazione `d`, stampa `p`, inserimento `i/a`
   - Indirizzi di riga e range
   - Script sed con `-e` e file `-f`
   - Modifica in-place con `-i`

5. [Comandi di Testo: `cut`, `tr`, `sort`, `uniq`, `wc`, `diff`, `tee`](./05_comandi_testo.md)
   - `tr` per trasformazioni carattere per carattere
   - `cut` per colonne e campi
   - `sort` e `uniq` per ordinamento e deduplicazione avanzata
   - `wc` per conteggi
   - `diff` e `patch` per confronto file
   - `tee` in pipeline complesse

---

## Esempi

- [`esempi/01_stringhe.sh`](./esempi/01_stringhe.sh) — stringhe native Bash, regex, grep
- [`esempi/02_awk_sed.sh`](./esempi/02_awk_sed.sh) — awk avanzato, sed, pipeline di testo

---

## Esercizi

Vai agli [esercizi del modulo](./esercizi/README.md) per mettere in pratica i concetti.

---

## Concetti Chiave

| Strumento | Uso principale |
|-----------|----------------|
| `${#var}` | lunghezza stringa |
| `${var:pos:len}` | sottostringa |
| `${var/cerca/sost}` | sostituzione (prima occorrenza) |
| `${var//cerca/sost}` | sostituzione (tutte le occorrenze) |
| `${var^^}` | converti in maiuscolo |
| `${var,,}` | converti in minuscolo |
| `grep -E` | regex estesa (ERE) |
| `awk 'BEGIN{} {} END{}'` | elaborazione strutturata |
| `sed 's/a/b/g'` | sostituzione globale |
| `tr 'a-z' 'A-Z'` | conversione carattere per carattere |
| `diff file1 file2` | confronto file |

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../07-Operazioni_matematiche/README.md>)
- [➡️ successivo](<../09_Date_e_Orari/README.md>)
