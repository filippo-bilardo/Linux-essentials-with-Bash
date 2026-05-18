# `sed` Avanzato

## Struttura di un Comando sed

```
sed [opzioni] 'comando' file
sed [opzioni] -e 'cmd1' -e 'cmd2' file
sed [opzioni] -f script.sed file
```

`sed` legge il file riga per riga, applica i comandi, e scrive su stdout. Il file originale **non viene modificato** a meno di usare `-i`.

---

## Il Comando di Sostituzione `s`

```
s/pattern/sostituzione/flags
```

```bash
# Sostituisce prima occorrenza per riga
sed 's/gatto/cane/' animali.txt

# Sostituisce TUTTE le occorrenze (global)
sed 's/gatto/cane/g' animali.txt

# Case-insensitive
sed 's/errore/ERRORE/gi' log.txt

# Con regex ERE (opzione -E o -r)
sed -E 's/[0-9]+/NUM/g' file.txt

# Catturare gruppi con \(...\) in BRE oppure (...) in ERE
sed 's/\(.*\)@\(.*\)/utente:\1 dominio:\2/' email.txt
sed -E 's/(.+)@(.+)/utente:\1 dominio:\2/' email.txt
```

### Delimitatori alternativi

Quando il pattern contiene `/`, usa un altro delimitatore:

```bash
sed 's|/usr/local|/opt|g' percorsi.txt
sed 's#https://old.com#https://new.com#g' pagina.html
```

---

## Indirizzi di Riga

I comandi possono essere limitati a righe specifiche:

```bash
# Solo la riga 5
sed '5s/foo/bar/' file.txt

# Dalla riga 3 alla 7
sed '3,7s/foo/bar/' file.txt

# Dalla riga 3 fino alla fine
sed '3,$s/foo/bar/' file.txt

# Righe che corrispondono a un pattern
sed '/^#/s/^/;/' file.txt     # commenta le righe già commentate

# Range tra due pattern
sed '/BEGIN/,/END/s/x/y/' file.txt
```

---

## Altri Comandi sed

### `d` — cancellare righe

```bash
# Cancella le righe vuote
sed '/^[[:space:]]*$/d' file.txt

# Cancella i commenti
sed '/^#/d' config.txt

# Cancella dalla riga 5 alla 10
sed '5,10d' file.txt

# Cancella l'ultima riga
sed '$d' file.txt
```

### `p` — stampare (con `-n` per output selettivo)

```bash
# Stampa solo le righe con "ERROR"
sed -n '/ERROR/p' log.txt

# Stampa le righe dalla 3 alla 7
sed -n '3,7p' file.txt

# Equivalente a grep
sed -n '/pattern/p' file.txt
```

### `i` e `a` — inserire e aggiungere righe

```bash
# Inserisce una riga PRIMA della riga 3
sed '3i\Riga inserita prima' file.txt

# Aggiunge una riga DOPO ogni riga con "fine sezione"
sed '/fine sezione/a\--- separatore ---' file.txt

# Aggiunge intestazione e piè di pagina
sed -e '1i\=== INIZIO ===' -e '$a\=== FINE ===' file.txt
```

### `c` — sostituire l'intera riga

```bash
sed '5c\Questa riga sostituisce la riga 5' file.txt
sed '/password=.*/c\password=RIMOSSA' config.txt
```

### `y` — traduzione carattere per carattere (come `tr`)

```bash
sed 'y/abcdef/ABCDEF/' file.txt   # converte solo quelle 6 lettere
```

---

## Più Comandi con `-e` e Blocchi `{}`

```bash
# Due sostituzione in sequenza
sed -e 's/gatto/cane/g' -e 's/cane/uccello/g' file.txt

# Blocco su una riga con ;
sed 's/a/A/g; s/e/E/g; s/i/I/g' file.txt

# Blocco con { } per applicare più comandi alle stesse righe
sed '/^#/ { s/^#/;/; s/$/ <commento>/ }' file.txt
```

---

## Modifica In-place con `-i`

```bash
# Modifica il file originale (GNU sed)
sed -i 's/vecchio/nuovo/g' file.txt

# Con backup (crea file.txt.bak)
sed -i.bak 's/vecchio/nuovo/g' file.txt

# Rimuovi commenti da un file di configurazione
sed -i '/^#/d' config.conf

# Aggiorna la versione in tutti i file .py
sed -i 's/versione="1\.0"/versione="2.0"/' *.py
```

---

## Script sed con File `-f`

```bash
cat > normalizza.sed << 'EOF'
# Rimuovi spazi iniziali e finali
s/^[[:space:]]//
s/[[:space:]]*$//
# Rimuovi righe vuote e commenti
/^$/d
/^#/d
# Normalizza i separatori
s/[[:space:]]*=[[:space:]]*/=/g
EOF

sed -f normalizza.sed config_raw.txt > config_clean.txt
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<03_awk_avanzato.md>)
- [➡️ successivo](<05_comandi_testo.md>)
