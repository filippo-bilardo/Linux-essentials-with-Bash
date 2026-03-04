# Guida alle Pipe in Bash

## Indice
1. [Introduzione](#introduzione)
2. [Sintassi di Base](#sintassi-di-base)
3. [Esempi Base](#esempi-base)
4. [Esempi Intermedi](#esempi-intermedi)
5. [Esempi Avanzati](#esempi-avanzati)
6. [Combinazioni Comuni](#combinazioni-comuni)
7. [Esercizi](#esercizi)
8. [Soluzioni](#soluzioni)

---

## Introduzione

La **pipe** (simbolo `|`) è uno degli strumenti più potenti della shell Unix/Linux. Permette di collegare l'output di un comando all'input di un altro, creando una "catena di montaggio" per l'elaborazione dei dati.

### Vantaggi delle Pipe:
- ✅ Elaborazione efficiente dei dati
- ✅ Combinazione di comandi semplici per operazioni complesse
- ✅ Riduzione dell'uso di file temporanei
- ✅ Codice più leggibile e modulare

### Concetto Fondamentale:
```
comando1 | comando2 | comando3
```
L'output di `comando1` diventa l'input di `comando2`, e l'output di `comando2` diventa l'input di `comando3`.

---

## Sintassi di Base

### Formato Generale:
```bash
comando1 | comando2
```

### Come Funziona:
1. `comando1` produce output su **stdout** (standard output)
2. La pipe `|` redirige questo output
3. `comando2` riceve l'output come **stdin** (standard input)

### Nota Importante:
- Gli **errori** (stderr) NON passano attraverso la pipe (a meno che non siano rediretti)
- Ogni comando nella pipe viene eseguito in un processo separato
- I comandi vengono eseguiti **contemporaneamente**, non sequenzialmente

---

## Esempi Base

### 1. Contare il numero di file in una directory
```bash
ls | wc -l
```
- `ls` elenca i file
- `wc -l` conta le righe (quindi i file)

### 2. Visualizzare le prime 10 righe di un file ordinato
```bash
cat file.txt | sort | head -10
```
- `cat` visualizza il contenuto
- `sort` ordina le righe
- `head -10` mostra le prime 10 righe

### 3. Cercare un processo specifico
```bash
ps aux | grep firefox
```
- `ps aux` mostra tutti i processi
- `grep firefox` filtra solo le righe contenenti "firefox"

### 4. Contare quante volte appare una parola
```bash
cat documento.txt | grep -o "parola" | wc -l
```
- `cat` visualizza il file
- `grep -o "parola"` estrae ogni occorrenza di "parola" su una nuova riga
- `wc -l` conta le righe (occorrenze)

### 5. Mostrare solo i file (non le directory)
```bash
ls -l | grep "^-"
```
- `ls -l` lista dettagliata
- `grep "^-"` filtra le righe che iniziano con `-` (file regolari)

### 6. Visualizzare l'uso del disco ordinato
```bash
du -h | sort -h
```
- `du -h` mostra l'uso del disco in formato leggibile
- `sort -h` ordina per dimensione umana (human-readable)

### 7. Estrarre informazioni specifiche
```bash
cat /etc/passwd | cut -d: -f1
```
- `cat /etc/passwd` mostra il file degli utenti
- `cut -d: -f1` estrae il primo campo (nome utente), usando `:` come delimitatore

### 8. Rimuovere righe duplicate
```bash
cat file.txt | sort | uniq
```
- `sort` ordina le righe (necessario per uniq)
- `uniq` rimuove le righe duplicate consecutive

---

## Esempi Intermedi

### 1. Top 5 file più grandi in una directory
```bash
ls -lh | sort -k5 -hr | head -6 | tail -5
```
- `ls -lh` lista con dimensioni leggibili
- `sort -k5 -hr` ordina per 5° campo (dimensione) in ordine inverso
- `head -6` prende le prime 6 righe (inclusa l'intestazione)
- `tail -5` prende le ultime 5 (escludendo l'intestazione)

### 2. Contare le estensioni dei file
```bash
ls | grep "\." | sed 's/.*\.//' | sort | uniq -c | sort -rn
```
- `ls` elenca i file
- `grep "\."` filtra solo file con estensione
- `sed 's/.*\.//'` estrae l'estensione
- `sort` ordina
- `uniq -c` conta le occorrenze
- `sort -rn` ordina numericamente in ordine inverso

### 3. Monitorare un log in tempo reale e filtrare errori
```bash
tail -f /var/log/syslog | grep -i error
```
- `tail -f` segue il file in tempo reale
- `grep -i error` filtra le righe con "error" (case-insensitive)

### 4. Trovare i 10 comandi più usati
```bash
history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
```
- `history` mostra la cronologia
- `awk '{print $2}'` estrae il secondo campo (il comando)
- `sort | uniq -c` conta le occorrenze
- `sort -rn` ordina per frequenza
- `head -10` mostra i primi 10

### 5. Elencare utenti che hanno effettuato login
```bash
last | grep -v "reboot" | grep -v "wtmp" | awk '{print $1}' | sort | uniq
```
- `last` mostra gli ultimi login
- `grep -v` esclude righe con "reboot" e "wtmp"
- `awk '{print $1}'` estrae il nome utente
- `sort | uniq` rimuove duplicati

### 6. Convertire testo in maiuscolo
```bash
echo "ciao mondo" | tr '[:lower:]' '[:upper:]'
```
Output: `CIAO MONDO`

### 7. Sostituire spazi con underscore nei nomi file
```bash
ls | grep " " | while read file; do mv "$file" "${file// /_}"; done
```
Questa pipeline:
- Trova file con spazi
- Li rinomina sostituendo spazi con underscore

### 8. Analizzare file CSV
```bash
cat dati.csv | cut -d',' -f2 | tail -n +2 | sort -n | uniq
```
- `cut -d',' -f2` estrae la seconda colonna
- `tail -n +2` salta l'intestazione
- `sort -n | uniq` ordina e rimuove duplicati

---

## Esempi Avanzati

### 1. Pipeline con multipli filtri e trasformazioni
```bash
cat access.log | grep "GET" | awk '{print $7}' | sort | uniq -c | sort -rn | head -20
```
Analizza un log Apache/Nginx per trovare le 20 URL più richieste:
- Filtra solo richieste GET
- Estrae l'URL (7° campo)
- Conta le occorrenze
- Ordina per frequenza

### 2. Trovare file duplicati per dimensione
```bash
find . -type f -exec ls -l {} \; | awk '{print $5, $9}' | sort -n | uniq -d -w 10
```
- `find` trova tutti i file
- `ls -l` mostra i dettagli
- `awk` estrae dimensione e nome
- Trova duplicati per dimensione

### 3. Monitoraggio larghezza di banda per interfaccia
```bash
cat /proc/net/dev | tail -n +3 | awk '{print $1, $2, $10}' | column -t
```
- Mostra statistiche di rete formattate

### 4. Estrazione e conversione dati
```bash
cat json_data.json | grep "temperature" | sed 's/.*: //' | sed 's/,//' | awk '{sum+=$1; count++} END {print sum/count}'
```
- Estrae valori di temperatura da JSON
- Calcola la media

### 5. Analisi avanzata dei log
```bash
cat /var/log/auth.log | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -10
```
Mostra i 10 IP che hanno tentato più accessi falliti:
- Filtra tentativi falliti
- Estrae l'IP
- Conta e ordina

### 6. Pipeline con tee (duplicare output)
```bash
cat file.txt | tee original.txt | tr '[:lower:]' '[:upper:]' | tee uppercase.txt | wc -l
```
- Salva l'originale
- Converte in maiuscolo e salva
- Conta le righe

### 7. Creare report formattato
```bash
ps aux | awk 'NR>1 {cpu[$11]+=$3; mem[$11]+=$4} END {for (cmd in cpu) printf "%-30s CPU: %6.2f%% MEM: %6.2f%%\n", cmd, cpu[cmd], mem[cmd]}' | sort -k3 -rn | head -10
```
Report aggregato dell'uso di CPU e memoria per comando

### 8. Pipeline con xargs
```bash
find . -name "*.log" | xargs grep "ERROR" | cut -d: -f1 | sort | uniq
```
- Trova tutti i file .log
- Cerca "ERROR" in ognuno
- Mostra solo i nomi dei file (senza duplicati)

### 9. Backup incrementale con data
```bash
tar czf - /home/user | tee backup_$(date +%Y%m%d).tar.gz | md5sum > backup_$(date +%Y%m%d).md5
```
- Crea archivio tar.gz
- Salva backup
- Calcola checksum MD5

### 10. Analisi statistica con awk
```bash
cat numeri.txt | awk '{sum+=$1; sumsq+=$1*$1} END {print "Media:", sum/NR, "Dev.Std:", sqrt(sumsq/NR - (sum/NR)^2)}'
```
Calcola media e deviazione standard di una lista di numeri

---

## Combinazioni Comuni

### grep + wc
```bash
# Contare le occorrenze
grep "pattern" file.txt | wc -l
```

### ps + grep
```bash
# Trovare processi
ps aux | grep nome_processo
```

### find + xargs
```bash
# Eseguire comando su file trovati
find . -name "*.txt" | xargs cat
```

### cat + grep + awk
```bash
# Estrazione e formattazione
cat file.txt | grep "pattern" | awk '{print $1}'
```

### sort + uniq
```bash
# Rimuovere duplicati
cat file.txt | sort | uniq
# O contare duplicati
cat file.txt | sort | uniq -c
```

### head + tail
```bash
# Estrarre righe specifiche (es: righe 10-20)
cat file.txt | head -20 | tail -10
```

### tar + ssh
```bash
# Backup remoto
tar czf - /directory | ssh user@host "cat > backup.tar.gz"
```

### cut + paste
```bash
# Riorganizzare colonne
cut -f1,3 file.txt | paste -d',' - file2.txt
```

---

## Esercizi

### Esercizio 1: Base
Crea un comando che mostri tutti i file `.txt` nella directory corrente, ordinati per nome.

**Hint**: usa `ls`, `grep` e `sort`

---

### Esercizio 2: Base
Scrivi un comando che conti quante righe contengono la parola "error" (case-insensitive) in un file chiamato `log.txt`.

**Hint**: usa `cat`, `grep -i` e `wc -l`

---

### Esercizio 3: Intermedio
Elenca tutti i processi in esecuzione che contengono la parola "python" nel nome, mostrando solo il PID e il nome del comando.

**Hint**: usa `ps aux`, `grep`, e `awk`

---

### Esercizio 4: Intermedio
Trova i 5 utenti che occupano più spazio nella directory `/home`.

**Hint**: usa `du`, `sort` e `head`

---

### Esercizio 5: Intermedio
Dato un file CSV con colonne separate da virgola, estrai la terza colonna e mostra solo i valori unici ordinati.

**Hint**: usa `cat`, `cut`, `sort` e `uniq`

---

### Esercizio 6: Avanzato
Analizza il file `/var/log/auth.log` (o simile) e mostra gli IP che hanno effettuato più di 5 tentativi di login falliti.

**Hint**: usa `grep`, `awk`, `sort`, `uniq -c` e condizioni in awk

---

### Esercizio 7: Avanzato
Crea un comando che mostri l'uso totale della memoria RAM da parte di tutti i processi di un determinato utente.

**Hint**: usa `ps`, `grep`, `awk` per sommare

---

### Esercizio 8: Avanzato
Scrivi una pipeline che trovi tutti i file modificati nelle ultime 24 ore, li comprima e calcoli l'MD5 checksum dell'archivio.

**Hint**: usa `find`, `tar`, `md5sum`

---

### Esercizio 9: Esperto
Crea un report che mostri, per ogni estensione di file in una directory, il numero totale di file e lo spazio totale occupato.

**Hint**: usa `find`, `awk`, array associativi in awk

---

### Esercizio 10: Esperto
Analizza un file di log Apache/Nginx e crea una statistica che mostri:
- Numero di richieste per ora
- Status code più frequenti
- User agent più comuni

**Hint**: pipeline complessa con `awk`, `grep`, `sort`, `uniq`

---

## Soluzioni

### Soluzione Esercizio 1
```bash
ls | grep "\.txt$" | sort
```
Oppure più semplicemente:
```bash
ls *.txt | sort
```

---

### Soluzione Esercizio 2
```bash
cat log.txt | grep -i "error" | wc -l
```
O in modo più efficiente:
```bash
grep -ic "error" log.txt
```

---

### Soluzione Esercizio 3
```bash
ps aux | grep python | grep -v grep | awk '{print $2, $11}'
```
Note: `grep -v grep` esclude la riga del grep stesso

---

### Soluzione Esercizio 4
```bash
du -sh /home/* | sort -hr | head -5
```
Oppure con più dettagli:
```bash
du -h --max-depth=1 /home | sort -hr | head -6 | tail -5
```

---

### Soluzione Esercizio 5
```bash
cat file.csv | cut -d',' -f3 | sort | uniq
```
Se vuoi saltare l'intestazione:
```bash
cat file.csv | tail -n +2 | cut -d',' -f3 | sort | uniq
```

---

### Soluzione Esercizio 6
```bash
cat /var/log/auth.log | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | awk '$1 > 5 {print $2, $1}'
```
Spiegazione:
- Filtra i tentativi falliti
- Estrae l'IP
- Conta le occorrenze
- Mostra solo IP con più di 5 tentativi

---

### Soluzione Esercizio 7
```bash
ps aux | grep "^USERNAME" | awk '{sum += $6} END {print "Memoria totale (KB):", sum}'
```
Sostituisci USERNAME con il nome utente desiderato.

---

### Soluzione Esercizio 8
```bash
find . -mtime -1 -type f | tar czf - -T - | tee backup.tar.gz | md5sum
```
O salvando il checksum:
```bash
find . -mtime -1 -type f | tar czf backup.tar.gz -T - && md5sum backup.tar.gz > backup.md5
```

---

### Soluzione Esercizio 9
```bash
find . -type f | awk -F. '{
    if (NF > 1) {
        ext = $NF
        cmd = "stat -f %z \"" $0 "\"" # macOS
        # cmd = "stat -c %s \"" $0 "\"" # Linux
        cmd | getline size
        close(cmd)
        count[ext]++
        total[ext] += size
    }
} END {
    printf "%-10s %10s %15s\n", "Estensione", "Num.File", "Dimensione(KB)"
    for (ext in count) {
        printf "%-10s %10d %15.2f\n", ext, count[ext], total[ext]/1024
    }
}' | column -t
```

Versione più semplice usando GNU tools:
```bash
find . -type f -name "*.*" -exec bash -c 'echo "${1##*.} $(stat -c %s "$1")"' _ {} \; | \
awk '{ext[$1]++; size[$1]+=$2} END {
    for (e in ext) printf "%s: %d file, %.2f KB\n", e, ext[e], size[e]/1024
}' | sort
```

---

### Soluzione Esercizio 10
```bash
# Richieste per ora
echo "=== Richieste per ora ==="
cat access.log | awk '{print $4}' | cut -d: -f2 | sort | uniq -c

echo -e "\n=== Status code più frequenti ==="
cat access.log | awk '{print $9}' | sort | uniq -c | sort -rn | head -10

echo -e "\n=== User agent più comuni ==="
cat access.log | awk -F'"' '{print $6}' | sort | uniq -c | sort -rn | head -10
```

---

## Best Practices

### 1. Evita UUOC (Useless Use Of Cat)
❌ **Sbagliato**:
```bash
cat file.txt | grep "pattern"
```

✅ **Corretto**:
```bash
grep "pattern" file.txt
```

### 2. Usa quotazioni appropriate
```bash
# Per variabili con spazi
echo "$variabile" | grep "pattern"
```

### 3. Gestisci gli errori
```bash
# Redirigere stderr a stdout
comando 2>&1 | grep "error"
```

### 4. Commenta pipeline complesse
```bash
cat file.txt |          # Leggi il file
  grep "pattern" |      # Filtra per pattern
  awk '{print $2}' |    # Estrai secondo campo
  sort | uniq           # Rimuovi duplicati
```

### 5. Testa in step
Quando costruisci pipeline complesse, testale passo per passo:
```bash
# Passo 1
cat file.txt

# Passo 2
cat file.txt | grep "pattern"

# Passo 3
cat file.txt | grep "pattern" | awk '{print $2}'

# E così via...
```

---

## Comandi Utili con le Pipe

| Comando | Descrizione | Esempio |
|---------|-------------|---------|
| `grep` | Filtra righe per pattern | `cat file \| grep "error"` |
| `awk` | Elabora e formatta testo | `ps aux \| awk '{print $2}'` |
| `sed` | Modifica stream di testo | `cat file \| sed 's/old/new/'` |
| `cut` | Taglia parti di righe | `cat file \| cut -d: -f1` |
| `sort` | Ordina righe | `cat file \| sort` |
| `uniq` | Rimuove duplicati | `sort file \| uniq` |
| `wc` | Conta righe/parole/caratteri | `cat file \| wc -l` |
| `head` | Prime n righe | `cat file \| head -10` |
| `tail` | Ultime n righe | `cat file \| tail -10` |
| `tr` | Traduce/elimina caratteri | `echo "text" \| tr 'a-z' 'A-Z'` |
| `xargs` | Costruisce ed esegue comandi | `ls \| xargs rm` |
| `tee` | Duplica output | `cat file \| tee copia.txt` |
| `column` | Formatta in colonne | `cat file \| column -t` |

---

## Conclusione

Le pipe sono uno strumento fondamentale in Bash che permette di:
- 🔗 Combinare comandi semplici per operazioni complesse
- 💾 Elaborare grandi quantità di dati efficientemente
- 🚀 Scrivere script potenti e concisi
- 🎯 Seguire la filosofia Unix: "Fai una cosa e falla bene"

**Ricorda**: la pratica rende perfetti! Sperimenta con questi esempi e crea le tue pipeline personalizzate.

---

## Risorse Aggiuntive

- Man pages: `man bash`, `man grep`, `man awk`, ecc.
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)

---

*Creato per scopi didattici - TECINF*