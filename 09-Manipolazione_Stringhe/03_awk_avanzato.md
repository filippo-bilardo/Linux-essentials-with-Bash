# `awk` Avanzato

## Struttura di un Programma awk

```
awk 'BEGIN { init } /pattern/ { body } END { finale }' file
```

- **`BEGIN`** — eseguito **prima** di leggere qualsiasi riga (inizializzazione)
- **body** — eseguito su ogni riga che corrisponde al pattern (opzionale)
- **`END`** — eseguito **dopo** l'ultima riga (totali, report finali)

```bash
awk 'BEGIN { print "=== Inizio ===" }
     { print NR": "$0 }
     END   { print "=== Fine: "NR" righe ===" }' /etc/hosts
```

---

## Variabili Built-in

| Variabile | Significato |
|-----------|-------------|
| `NR` | numero riga corrente (Number of Records) |
| `NF` | numero di campi nella riga (Number of Fields) |
| `$0` | riga intera |
| `$1`, `$2`, … | campi dalla 1a colonna in poi |
| `$NF` | ultimo campo |
| `$(NF-1)` | penultimo campo |
| `FS` | separatore di campo in input (default: spazio/tab) |
| `OFS` | separatore di campo in output (default: spazio) |
| `RS` | separatore di record in input (default: newline) |
| `ORS` | separatore di record in output (default: newline) |
| `FILENAME` | nome del file corrente |
| `FNR` | numero riga nel file corrente (con più file) |

```bash
# Cambiare separatori
awk -F ':' 'BEGIN { OFS="→" } { print $1, $7 }' /etc/passwd
# root→/bin/bash
# daemon→/usr/sbin/nologin

# Ultima colonna
awk '{ print $NF }' file.txt

# Penultima colonna
awk '{ print $(NF-1) }' file.txt
```

---

## Condizioni e Pattern

```bash
# Righe dove la 3a colonna è > 100
awk '$3 > 100' dati.txt

# Righe dove il 2° campo è "Roma"
awk '$2 == "Roma"' studenti.txt

# Pattern regex (righe che contengono "error")
awk '/error/' app.log
awk '/^[0-9]/' file.txt          # righe che iniziano con cifra

# Range di righe
awk 'NR>=5 && NR<=10' file.txt   # righe dalla 5 alla 10

# Condizioni multiple
awk '$3 > 18 && $4 == "Roma"' persone.txt
awk '$2 == "A" || $2 == "B"'  voti.txt
```

---

## Calcoli e Aggregazioni

```bash
# Somma di una colonna
awk '{ somma += $3 } END { print "Totale:", somma }' prezzi.csv

# Media
awk '{ somma += $3; n++ } END { printf "Media: %.2f\n", somma/n }' file.txt

# Min e Max
awk 'NR==1 { min=$3; max=$3 }
     $3 < min { min=$3 }
     $3 > max { max=$3 }
     END { print "Min:", min, "Max:", max }' file.txt

# Contare occorrenze
awk '{ conteggio[$1]++ }
     END { for (k in conteggio) print k, conteggio[k] }' file.txt
```

---

## Array Associativi

```bash
cat > accessi.log << 'EOF'
Alice GET /index.html 200
Bob   GET /login.php  200
Alice POST /login.php 302
Carlo GET /admin.php  403
Alice GET /dashboard  200
EOF

# Conta accessi per utente
awk '{ utenti[$1]++ }
     END { for (u in utenti) printf "%-10s %d accessi\n", u, utenti[u] }' accessi.log

# Aggrupa per codice HTTP
awk '{ codici[$4]++ }
     END { for (c in codici) print c":", codici[c] }' accessi.log | sort
```

---

## Funzioni Built-in di `awk`

### Stringhe

| Funzione | Descrizione |
|----------|-------------|
| `length(s)` | lunghezza della stringa s |
| `substr(s, i, n)` | sottostringa di s dall'indice i, n caratteri |
| `index(s, t)` | posizione di t in s (0 se non trovato) |
| `split(s, a, sep)` | divide s in array a usando sep come separatore |
| `sub(r, s, t)` | sostituisce prima occorrenza di regex r con s in t |
| `gsub(r, s, t)` | sostituisce tutte le occorrenze |
| `match(s, r)` | trova regex r in s; imposta RSTART e RLENGTH |
| `toupper(s)` | converte in maiuscolo |
| `tolower(s)` | converte in minuscolo |
| `sprintf(fmt, ...)` | formattazione come printf, restituisce stringa |

```bash
# Estrarre dominio dalle email
echo "utente@esempio.com" | awk '{ split($0, parti, "@"); print parti[2] }'

# Sostituire in un campo
awk '{ gsub(/,/, ";", $3); print }' file.csv

# Convertire in maiuscolo un campo
awk '{ $1 = toupper($1); print }' nomi.txt

# Formattare l'output
awk '{ printf "%-15s %8.2f€\n", $1, $3 }' prodotti.csv
```

---

## Script awk Multi-riga

Per programmi complessi conviene usare un file `-f`:

```bash
cat > analisi.awk << 'EOF'
BEGIN {
    FS = ","
    OFS = "\t"
    print "NOME", "VOTO", "ESITO"
    print "----", "-----", "------"
}
NR > 1 {
    if ($2 >= 6)
        esito = "PROMOSSO"
    else
        esito = "BOCCIATO"
    printf "%-15s  %2d   %s\n", $1, $2, esito
    totale += $2
    n++
}
END {
    printf "\nMedia classe: %.2f\n", totale/n
}
EOF

awk -f analisi.awk voti.csv
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<02_regex_grep.md>)
- [➡️ successivo](<04_sed_avanzato.md>)
