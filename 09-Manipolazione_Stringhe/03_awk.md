# AWK: elaborazione di testo e dati in ambiente Linux

## Introduzione

`awk` è un linguaggio di programmazione orientato al testo, pensato per elaborare file organizzati in righe e campi (record e field). Nasce nel 1977 ad opera di **A**ho, **W**einberger e **K**ernighan (da cui il nome) presso i Bell Labs, e oggi è uno degli strumenti fondamentali della cassetta degli attrezzi di ogni amministratore di sistema e sviluppatore che lavora in ambiente Unix/Linux.

A differenza di `grep` (che filtra righe) o `sed` (che trasforma testo tramite pattern di sostituzione), `awk` è un vero e proprio linguaggio: ha variabili, array associativi, funzioni, strutture di controllo (`if`, `for`, `while`) e un modello di esecuzione basato su **pattern-action**, molto efficace per l'elaborazione di dati tabellari (file CSV, log, output di comandi come `ps`, `df`, `ls -l`).

> **Tip.** Se ti accorgi di scrivere uno script `bash` con molti `cut`, `grep` e `while read` concatenati per estrarre colonne da un file, probabilmente stai reinventando `awk`: prova a riscriverlo con un solo comando `awk`.

### Le tre implementazioni principali

| Implementazione | Descrizione | Comando |
|---|---|---|
| **AWK originale (One True Awk)** | Implementazione storica, minimale | `awk` su BSD/macOS |
| **GNU Awk (gawk)** | Estende lo standard POSIX con funzionalità aggiuntive (array multidimensionali, I/O di rete, `gensub`, ecc.) | `gawk`, spesso alias di `awk` su Linux |
| **mawk** | Implementazione più veloce ma meno ricca di funzionalità | `mawk` |

Su gran parte delle distribuzioni Linux, `awk` è un link simbolico a `gawk`. In questa guida useremo le funzionalità POSIX standard, segnalando esplicitamente le estensioni GNU.

```bash
# Verificare quale implementazione è in uso
awk --version
readlink -f $(which awk)
```

---

## 1. Il modello concettuale: record, campi e pattern-action

### 1.1 Record e campi

`awk` legge l'input **riga per riga**. Ogni riga è un **record** (`$0`), che viene automaticamente suddiviso in **campi** in base a un separatore (di default, uno o più spazi/tab).

- `$0` → l'intera riga
- `$1` → il primo campo
- `$2` → il secondo campo
- `$NF` → l'ultimo campo (NF = Number of Fields)
- `$(NF-1)` → il penultimo campo

```bash
echo "Mario Rossi 35 Milano" | awk '{ print $1, $3 }'
# Output: Mario 35
```

### 1.2 La struttura pattern { azione }

Uno script `awk` è una sequenza di regole nella forma:

```
pattern { azione }
```

Per ogni riga letta in input, `awk` valuta il `pattern`: se è vero (o assente), esegue l'`azione` associata.

```bash
awk '/errore/ { print $0 }' log.txt      # stampa le righe che contengono "errore"
awk 'NR == 1 { print }' file.txt          # stampa solo la prima riga
awk '{ print }' file.txt                  # pattern assente = sempre vero: stampa tutto
awk 'END { print NR }' file.txt           # pattern speciale: eseguito a fine input
```

I pattern speciali `BEGIN` e `END` vengono eseguiti rispettivamente **prima** di leggere qualsiasi riga e **dopo** aver letto l'ultima:

```bash
awk 'BEGIN { print "Inizio elaborazione" }
     { totale += $1 }
     END { print "Totale:", totale }' numeri.txt
```

> **Best practice.** Usa sempre `BEGIN` per inizializzare variabili (es. separatori, contatori) e `END` per stampare riepiloghi. Rende lo script più leggibile e separa chiaramente "setup", "elaborazione" e "risultato finale".

---

## 2. Variabili predefinite

| Variabile | Significato |
|---|---|
| `NR` | Numero di record (riga) corrente, globale su tutti i file |
| `FNR` | Numero di record corrente, relativo al singolo file (si azzera ad ogni nuovo file) |
| `NF` | Numero di campi nella riga corrente |
| `FS` | Field Separator: carattere/regex usato per separare i campi in input (default: spazio) |
| `OFS` | Output Field Separator: separatore usato da `print` tra i campi (default: spazio) |
| `RS` | Record Separator: carattere che separa i record in input (default: `\n`) |
| `ORS` | Output Record Separator: separatore usato da `print` tra i record (default: `\n`) |
| `FILENAME` | Nome del file corrente in elaborazione |

```bash
# Differenza tra NR e FNR con due file
awk '{ print FILENAME, "riga file:", FNR, "- riga totale:", NR }' file1.txt file2.txt
```

### 2.1 Cambiare i separatori

```bash
# Elaborare un CSV (separatore virgola)
awk -F',' '{ print $2 }' dati.csv

# Impostare FS in BEGIN è equivalente a -F
awk 'BEGIN { FS="," } { print $2 }' dati.csv

# Cambiare anche il separatore in output
awk -F',' 'BEGIN { OFS=";" } { $1=$1; print }' dati.csv
```

> **Tip and trick.** L'istruzione `$1=$1` (o qualunque riassegnazione di un campo) **forza awk a ricostruire `$0`** usando `OFS` al posto di `FS`. È il modo idiomatico per convertire un CSV separato da virgole in uno separato da punto e virgola.

`FS` può essere anche un'espressione regolare, utile per file con spazi multipli o separatori misti:

```bash
awk -F'[ \t]+' '{ print $2 }' file.txt   # uno o più spazi/tab come separatore
awk -F'\t' '{ print $3 }' file.tsv        # file TSV
```

---

## 3. Print e printf

### 3.1 print

```bash
awk '{ print $1, $2 }' file.txt      # separati da OFS (default: spazio)
awk '{ print $1 $2 }' file.txt       # concatenati, senza separatore
awk '{ print "Nome:", $1 }' file.txt # con testo statico
```

### 3.2 printf, per un output formattato

Quando serve controllare precisione, allineamento o larghezza dei campi, `printf` è preferibile a `print`:

```bash
awk '{ printf "%-10s %5d\n", $1, $2 }' file.txt
# %-10s : stringa allineata a sinistra, larghezza 10
# %5d   : intero allineato a destra, larghezza 5
```

| Specificatore | Significato |
|---|---|
| `%s` | stringa |
| `%d` | intero |
| `%f` | numero in virgola mobile |
| `%.2f` | numero con 2 decimali |
| `%-10s` | stringa allineata a sinistra, larghezza minima 10 |
| `%05d` | intero con padding di zeri, larghezza 5 |

> **Attenzione.** A differenza di `print`, `printf` **non aggiunge automaticamente** un a capo: va sempre incluso esplicitamente `\n`.

---

## 4. Operatori e pattern

### 4.1 Pattern di confronto e regex

```bash
awk '$3 > 30' file.txt                     # righe dove il 3° campo è > 30
awk '$1 == "Mario"' file.txt                # confronto stringa esatta
awk '/^#/ { next }  { print }' file.txt     # salta righe che iniziano con #
awk '$0 !~ /errore/' log.txt                # righe che NON contengono "errore"
awk 'NR >= 5 && NR <= 10' file.txt           # intervallo di righe
```

Operatori di confronto pattern: `~` (matcha regex), `!~` (non matcha), `==`, `!=`, `<`, `>`, `<=`, `>=`, combinabili con `&&`, `||`, `!`.

### 4.2 Range pattern

```bash
awk '/INIZIO/,/FINE/' file.txt   # stampa tutte le righe comprese tra due marcatori
```

---

## 5. Variabili, array e strutture di controllo

### 5.1 Variabili e tipi

`awk` non richiede dichiarazione di variabili: il tipo (stringa o numero) viene dedotto dal contesto.

```bash
awk '{ somma += $1 } END { print somma }' numeri.txt
awk '{ conta[$1]++ } END { for (k in conta) print k, conta[k] }' file.txt
```

### 5.2 Array associativi

Gli array in `awk` sono sempre associativi (simili a dizionari/hash map), indicizzati per stringa:

```bash
# Contare le occorrenze del secondo campo (es. codici di stato HTTP)
awk '{ count[$2]++ } END { for (codice in count) print codice, count[codice] }' access.log
```

> **Best practice.** L'ordine di iterazione con `for (k in array)` **non è garantito**. Se serve un ordine specifico (es. alfabetico o numerico), ordina le chiavi esplicitamente con la funzione GNU `asorti()`, oppure passa l'output a `sort`.

### 5.3 Strutture di controllo

```bash
awk '{
  if ($3 > 90) {
    voto = "eccellente"
  } else if ($3 > 60) {
    voto = "sufficiente"
  } else {
    voto = "insufficiente"
  }
  print $1, voto
}' voti.txt
```

```bash
# Ciclo for classico
awk '{ for (i=1; i<=NF; i++) print i, $i }' file.txt

# Ciclo while
awk '{ i=1; while (i<=NF) { print $i; i++ } }' file.txt
```

---

## 6. Funzioni built-in principali

| Funzione | Descrizione | Esempio |
|---|---|---|
| `length(s)` | Lunghezza di una stringa (o di `$0` se omesso) | `awk '{ print length($0) }'` |
| `substr(s,m,n)` | Sottostringa da posizione `m`, lunga `n` | `awk '{ print substr($1,1,3) }'` |
| `split(s,arr,fs)` | Divide `s` in `arr` usando `fs` come separatore | `awk '{ n=split($0,a,":"); print a[1] }'` |
| `gsub(re,sub,s)` | Sostituzione globale (modifica `s` o `$0`) | `awk '{ gsub(/ /,"_"); print }'` |
| `sub(re,sub,s)` | Sostituisce solo la prima occorrenza | `awk '{ sub(/^ +/,""); print }'` |
| `toupper(s)` / `tolower(s)` | Converte maiuscole/minuscole | `awk '{ print toupper($1) }'` |
| `index(s,t)` | Posizione della prima occorrenza di `t` in `s` | `awk '{ print index($0,"@") }'` |
| `sprintf(fmt,...)` | Come `printf` ma restituisce una stringa | `s = sprintf("%05d", n)` |

```bash
# Esempio combinato: normalizzare un elenco di email in minuscolo
awk '{ print tolower($1) }' email.txt

# Estrarre dominio da un indirizzo email
awk -F'@' '{ print $2 }' email.txt
```

---

## 7. Esempi pratici da riga di comando

### 7.1 Analisi di log

```bash
# Contare le richieste per indirizzo IP in un access log Apache/Nginx
awk '{ print $1 }' access.log | sort | uniq -c | sort -rn | head

# Somma dei byte trasferiti (7° campo tipico del Common Log Format)
awk '{ sum += $10 } END { printf "Totale: %.2f MB\n", sum/1024/1024 }' access.log

# Estrarre solo le righe con status code 500
awk '$9 == 500 { print }' access.log
```

### 7.2 Amministrazione di sistema

```bash
# Somma della memoria usata per processo (colonna RSS di ps aux)
ps aux | awk 'NR>1 { sum += $6 } END { print sum/1024, "MB" }'

# Elenco utenti con shell diversa da /usr/sbin/nologin
awk -F: '$7 != "/usr/sbin/nologin" { print $1, $7 }' /etc/passwd

# Spazio disco per filesystem, ordinato per uso %
df -h | awk 'NR>1 { print $5, $6 }' | sort -rn
```

### 7.3 CSV e report

```bash
# Somma di una colonna numerica in un CSV con intestazione
awk -F',' 'NR>1 { sum += $3 } END { print "Totale:", sum }' vendite.csv

# Filtrare righe di un CSV in base a una colonna e stampare un report formattato
awk -F',' 'NR>1 && $4=="Milano" { printf "%-20s %8.2f\n", $2, $3 }' vendite.csv

# Rimuovere duplicati mantenendo l'ordine originale
awk '!seen[$0]++' file.txt
```

> **Tip and trick.** `awk '!seen[$0]++'` è un idioma classico e molto usato: per ogni riga, controlla se è già presente nell'array `seen`; se non lo è, la stampa (perché `!0` è vero) e incrementa il contatore. È più efficiente ed elegante di `sort | uniq` quando si vuole **preservare l'ordine originale**.

### 7.4 Manipolazione di testo

```bash
# Numerare le righe di un file (come cat -n)
awk '{ print NR, $0 }' file.txt

# Invertire l'ordine dei campi di ogni riga
awk '{ for (i=NF; i>=1; i--) printf "%s ", $i; print "" }' file.txt

# Stampare solo righe con un numero di campi specifico
awk 'NF == 3' file.txt

# Sommare tutte le righe che iniziano per un pattern
awk '/^TOT/ { sum += $2 } END { print sum }' file.txt
```

---

## 8. Script awk multi-riga e uso con -f

Per script complessi, è preferibile salvare il codice in un file `.awk` invece di scriverlo inline:

```awk
#!/usr/bin/awk -f
# report.awk — genera un riepilogo vendite per città

BEGIN {
    FS = ","
    print "Report vendite per città"
    print "-------------------------"
}

NR > 1 {
    totale[$4] += $3
    conteggio[$4]++
}

END {
    for (citta in totale) {
        printf "%-15s vendite: %3d  totale: %10.2f\n", \
            citta, conteggio[citta], totale[citta]
    }
}
```

Esecuzione:

```bash
awk -f report.awk vendite.csv
# oppure, rendendolo eseguibile:
chmod +x report.awk
./report.awk vendite.csv
```

---

## 9. AWK vs altri strumenti: quando usarlo

| Esigenza | Strumento consigliato |
|---|---|
| Filtrare righe che matchano un pattern | `grep` |
| Sostituzioni semplici carattere/stringa | `sed` |
| Estrarre singole colonne senza logica | `cut` |
| Elaborazione di campi con logica, calcoli, aggregazioni | **awk** |
| Trasformazioni JSON complesse | `jq` |
| Analisi dati molto complesse, join tra più file | Python/pandas |

> **Best practice.** Non tutto va fatto in `awk`: per logiche molto complesse (parsing JSON, chiamate di rete, strutture dati annidate) è più manutenibile passare a Python. `awk` eccelle quando i dati sono **tabellari, riga per riga**, e la logica è relativamente semplice e "streaming" (una riga alla volta, senza necessità di tenere in memoria l'intero dataset — salvo per gli array di aggregazione).

---

## 10. Pipeline: combinare awk con altri comandi

```bash
# Top 5 processi per uso memoria
ps aux | awk 'NR>1 {print $4, $11}' | sort -rn | head -5

# Contare parole uniche in un testo, ordinate per frequenza
tr -s ' ' '\n' < testo.txt | awk '{ print tolower($0) }' | sort | uniq -c | sort -rn | head -20

# Monitoraggio in tempo reale di un log con filtro
tail -f app.log | awk '/ERROR/ { print strftime("%Y-%m-%d %H:%M:%S"), $0 }'
```

---

## Esercizi

**Esercizio 1 (livello base).**
Dato un file `studenti.txt` con il formato `nome cognome voto`, scrivi un comando `awk` che stampi solo gli studenti con voto maggiore o uguale a 6.

**Esercizio 2 (livello base).**
Scrivi un comando `awk` che, dato un file di testo, stampi il numero totale di righe e il numero totale di parole (suggerimento: `NF` si somma su ogni riga).

**Esercizio 3 (livello intermedio).**
Dato `/etc/passwd`, stampa un elenco `username:shell` solo per gli utenti con UID maggiore o uguale a 1000, formattando l'output con `printf` su colonne allineate.

**Esercizio 4 (livello intermedio).**
Scrivi uno script `awk` che legga un file CSV `prodotti.csv` (colonne: `nome,categoria,prezzo,quantita`) e calcoli il valore totale di magazzino (`prezzo * quantita`) per ciascuna categoria.

**Esercizio 5 (livello avanzato).**
Scrivi uno script `awk` (salvato in un file `.awk`, eseguibile con `-f`) che analizzi un access log e produca, in un'unica passata: (a) il numero totale di richieste, (b) le 3 pagine più richieste, (c) la percentuale di richieste con status code ≥ 400.

**Esercizio 6 (livello avanzato).**
Utilizzando `awk '!seen[$0]++'` come punto di partenza, modifica lo script in modo da rimuovere le righe duplicate considerando **solo il primo campo** come chiave di unicità, mantenendo però l'intera riga in output.

---

## Domande a scelta multipla (autovalutazione)

**1. Qual è la variabile predefinita che contiene il numero di campi della riga corrente?**
a) `NR`
b) `NF`
c) `FS`
d) `FNR`

**2. Quale comando stampa il secondo campo di un file separato da virgole?**
a) `awk '{ print $2 }' -F',' file.csv`
b) `awk -F',' '{ print $2 }' file.csv`
c) `awk 'FS="," { print $2 }' file.csv`
d) `awk print $2 -F, file.csv`

**3. A cosa serve il blocco `END` in uno script awk?**
a) Viene eseguito prima di leggere qualsiasi riga
b) Viene eseguito una volta per ogni riga
c) Viene eseguito dopo aver letto l'ultima riga di input
d) Termina forzatamente lo script con un errore

**4. Cosa fa l'espressione idiomatica `awk '!seen[$0]++'`?**
a) Conta le righe duplicate
b) Rimuove i duplicati mantenendo l'ordine originale delle righe
c) Ordina le righe alfabeticamente
d) Sostituisce le righe duplicate con una stringa vuota

**5. Qual è la differenza principale tra `NR` e `FNR` quando si elaborano più file?**
a) Non c'è alcuna differenza
b) `NR` si azzera per ogni nuovo file, `FNR` è cumulativo
c) `FNR` si azzera per ogni nuovo file, `NR` è cumulativo su tutti i file
d) `NR` conta i campi, `FNR` conta le righe

**6. Quale funzione awk permette di dividere una stringa in un array usando un separatore specifico?**
a) `substr()`
b) `split()`
c) `index()`
d) `gsub()`

**7. Come si forza awk a ricostruire `$0` usando il valore di `OFS` invece di `FS`?**
a) Assegnando un valore a un qualsiasi campo, es. `$1=$1`
b) Impostando `RS` a un nuovo valore
c) Usando la funzione `rebuild($0)`
d) Non è possibile, `$0` è sempre di sola lettura

---

## Soluzioni al quiz

1. **b)** `NF` — Number of Fields, il numero di campi nella riga corrente.
2. **b)** `awk -F',' '{ print $2 }' file.csv` — l'opzione `-F` va specificata prima dello script, per impostare il Field Separator.
3. **c)** Il blocco `END` viene eseguito una sola volta, dopo che tutte le righe di input sono state lette.
4. **b)** Rimuove i duplicati preservando l'ordine originale: `seen[$0]` funge da contatore di occorrenze; `!0` è vero solo la prima volta che una riga viene incontrata.
5. **c)** `FNR` (File Number of Records) si azzera a ogni nuovo file elaborato, mentre `NR` continua a incrementarsi su tutti i file passati in input.
6. **b)** `split(stringa, array, separatore)` è la funzione dedicata a suddividere una stringa in un array associativo.
7. **a)** Qualsiasi riassegnazione di un campo (anche a se stesso, `$1=$1`) fa sì che awk ricostruisca l'intero record `$0`, usando `OFS` come separatore tra i campi.