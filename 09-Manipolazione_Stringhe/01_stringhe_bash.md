# Manipolazione di Stringhe in Bash

## Lunghezza di una Stringa

```bash
testo="Ciao mondo"
echo ${#testo}          # 10

file="/etc/apt/sources.list"
echo ${#file}           # 24
```

---

## Estrazione di Sottostringhe

```bash
# ${variabile:posizione:lunghezza}
testo="Linux Bash Scripting"
#      01234567890123456789

echo ${testo:6:4}       # Bash       (4 caratteri dall'indice 6)
echo ${testo:11}        # Scripting  (dall'indice 11 fino alla fine)
echo ${testo: -9}       # Scripting  (9 caratteri dalla fine, nota lo spazio)
echo ${testo: -9:4}     # Scri       (4 caratteri partendo da -9)
```

---

## Sostituzione di Testo

```bash
filename="rapporto_2025.txt"

# ${var/cerca/sostituzione}  — prima occorrenza
echo ${filename/2025/2026}  # rapporto_2026.txt

# ${var//cerca/sostituzione} — tutte le occorrenze
frase="un due un tre un"
echo ${frase//un/UNO}       # UNO due UNO tre UNO

# Cancellare (sostituzione vuota)
echo ${frase// /}           # unduountreun
```

---

## Rimozione di Prefissi e Suffissi

Con i caratteri `#`, `##`, `%`, `%%`:

| Operatore | Azione |
|-----------|--------|
| `${var#pattern}` | rimuove prefisso **più corto** che corrisponde a pattern |
| `${var##pattern}` | rimuove prefisso **più lungo** (greedy) |
| `${var%pattern}` | rimuove suffisso **più corto** |
| `${var%%pattern}` | rimuove suffisso **più lungo** |

```bash
percorso="/home/utente/documenti/relazione.txt"

echo ${percorso#*/}         # home/utente/documenti/relazione.txt  (rimuove prima /)
echo ${percorso##*/}        # relazione.txt  (basename: tutto fino all'ultimo /)
echo ${percorso%/*}         # /home/utente/documenti  (dirname: dall'ultimo / in poi)
echo ${percorso%%/*}        # (stringa vuota, rimuove tutto dopo il primo /)

# Rimozione estensione
file="archivio.tar.gz"
echo ${file%.gz}            # archivio.tar
echo ${file%%.*}            # archivio
```

### Uso pratico: gestione nomi file

```bash
for f in *.txt; do
    nome="${f%.txt}"        # rimuove .txt
    cp "$f" "${nome}.md"    # copia come .md
done
```

---

## Conversione Maiuscolo/Minuscolo (Bash 4+)

```bash
testo="Ciao Mondo"

echo ${testo^^}             # CIAO MONDO  (tutto maiuscolo)
echo ${testo,,}             # ciao mondo  (tutto minuscolo)
echo ${testo^}              # Ciao Mondo  (prima lettera maiuscola)
echo ${testo,}              # ciao Mondo  (prima lettera minuscola)

# Solo un carattere specifico
echo ${testo^^[aeiou]}      # CIAo mOndo  (solo vocali maiuscole)
```

---

## Valori di Default e Test

```bash
# ${var:-default}   usa default se var è vuota o non impostata
nome="${1:-Utente}"
echo "Ciao, $nome"

# ${var:=default}   assegna default a var se vuota
: "${Config:=/etc/default.conf}"   # : è un no-op che forza l'espansione

# ${var:+alternativo}  usa alternativo SE var è impostata (e non vuota)
debug=1
echo "${debug:+[DEBUG MODE ON]}"    # stampa il messaggio solo se debug≠0

# ${var:?messaggio_errore}  esce con errore se var è vuota
: "${FILE_INPUT:?Errore: FILE_INPUT non impostata}"
```

---

## Operazioni Comuni sulle Stringhe

### Concatenare

```bash
a="Ciao"
b=" mondo"
c="$a$b"        # "Ciao mondo"
c+="!"          # aggiunta in fondo: "Ciao mondo!"
```

### Trim (rimozione spazi)

Bash non ha una funzione trim nativa, ma si può fare con `xargs` o con `sed`:

```bash
testo="   spazi ai lati   "

# Con xargs (semplice ma non gestisce tutti i casi)
trimmed=$(echo "$testo" | xargs)
echo "'$trimmed'"

# Con parameter expansion (solo spazi iniziali/finali semplici)
# Rimuovi spazi iniziali
shopt -s extglob
testo="${testo##+([[:space:]])}"
# Rimuovi spazi finali
testo="${testo%%+([[:space:]])}"
echo "'$testo'"
```

### Controllare se una stringa contiene una sottostringa

```bash
testo="Linux Bash Scripting"

if [[ $testo == *"Bash"* ]]; then
    echo "Contiene 'Bash'"
fi

# Con regex
if [[ $testo =~ Ba.h ]]; then
    echo "Corrisponde alla regex"
fi
```

### Dividere una stringa (split)

```bash
data="2026-03-04"

# Usando IFS
IFS='-' read -r anno mese giorno <<< "$data"
echo "Anno: $anno, Mese: $mese, Giorno: $giorno"

# In un array
IFS=',' read -ra campi <<< "alpha,beta,gamma,delta"
for campo in "${campi[@]}"; do
    echo "  → $campo"
done
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<../07-Operazioni_matematiche/05_getopts.md>)
- [➡️ successivo](<02_regex_grep.md>)
