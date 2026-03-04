# Modulo 10: Input/Output e Redirezione in Bash

Benvenuti al decimo modulo del corso "Linux Essential with Bash"!

## Indice

1. [Introduzione](#introduzione)
2. [I Tre Stream Standard](#i-tre-stream-standard)
3. [Ridirezione Output (>)](#ridirezione-output-)
4. [Ridirezione Input (<)](#ridirezione-input-)
5. [Append (>>)](#append-)
6. [Ridirezione Errori (2>)](#ridirezione-errori-2)
7. [Ridirezione Combinata](#ridirezione-combinata)
8. [Here Document (<<)](#here-document-)
9. [Here String (<<<)](#here-string-)
10. [File Descriptor](#file-descriptor)
11. [Pipe (|)](#pipe-)
12. [Comando tee](#comando-tee)
13. [Esempi Pratici](#esempi-pratici)
14. [Best Practices](#best-practices)
15. [Quick Reference](#quick-reference)

---

## Introduzione

La ridirezione e le pipe sono concetti fondamentali della shell Unix/Linux. Permettono di controllare dove i comandi ricevono il loro input e dove inviano il loro output, creando potenti pipeline di elaborazione dati.

### Perché è importante?

- 📝 Salvare output di comandi in file
- 🔀 Collegare comandi tra loro
- ❌ Gestire gli errori separatamente
- 📊 Automatizzare elaborazioni di dati
- 🔇 Silenziare output non desiderati

### Filosofia Unix

Ogni programma Unix:

- Legge da un input stream (stdin)
- Scrive su un output stream (stdout)
- Scrive errori su error stream (stderr)

---

## I Tre Stream Standard

### 1. STDIN (Standard Input) - File Descriptor 0

L'input standard è da dove un programma legge i dati.

- **Default**: tastiera
- **Simbolo**: `<` o `0<`

### 2. STDOUT (Standard Output) - File Descriptor 1

L'output standard è dove un programma scrive i risultati normali.

- **Default**: terminale/schermo
- **Simbolo**: `>` o `1>`

### 3. STDERR (Standard Error) - File Descriptor 2

L'error standard è dove un programma scrive i messaggi di errore.

- **Default**: terminale/schermo
- **Simbolo**: `2>`

### Visualizzazione dei Stream

```
           ┌─────────────┐
   stdin → │   COMANDO   │ → stdout
    (0)    │             │   (1)
           └─────────────┘
                  ↓
               stderr (2)
```

### Esempio Base

```bash
# Senza ridirezione
ls /tmp          # Output va sul terminale
ls /nonexiste    # Errore va sul terminale

# Con ridirezione
ls /tmp > output.txt         # Output va nel file
ls /nonexiste 2> errori.txt  # Errori vanno nel file
```

---

## Ridirezione Output (>)

### Descrizione

L'operatore `>` redirige l'output standard (stdout) in un file.

- Sovrascrive il file se esiste
- Crea il file se non esiste

### Sintassi

```bash
comando > file
```

### Esempi Base

```bash
# Salva output in file
echo "Hello World" > output.txt

# Sovrascrive il file esistente
echo "Nuova riga" > output.txt

# Lista directory in file
ls -l > lista.txt

# Informazioni di sistema
date > data.txt
uname -a > sistema.txt

# Output di comando complesso
ps aux > processi.txt
```

### File Speciali

#### /dev/null - Il "buco nero"

```bash
# Elimina output (non visualizza nulla)
comando > /dev/null

# Esempio
echo "Questo sparisce" > /dev/null
```

#### /dev/stdout - Output standard

```bash
# Redirige esplicitamente a stdout
echo "Visible" > /dev/stdout
```

### Esempio Pratico

```bash
# Crea report di sistema
{
    echo "=== REPORT DI SISTEMA ==="
    echo "Data: $(date)"
    echo ""
    echo "Hostname: $(hostname)"
    echo "Utente: $(whoami)"
    echo "Uptime: $(uptime)"
    echo ""
    echo "=== USO DISCO ==="
    df -h
} > report.txt
```

---

## Ridirezione Input (<)

### Descrizione

L'operatore `<` redirige l'input standard (stdin) da un file. Il comando legge dal file invece che dalla tastiera.

### Sintassi

```bash
comando < file
```

### Esempi

```bash
# Conta righe in un file
wc -l < file.txt

# Ordina contenuto file
sort < nomi.txt

# Input per comando mail
mail -s "Oggetto" user@example.com < messaggio.txt

# Invia contenuto file a comando
cat < input.txt

# Confronta file
diff file1.txt file2.txt
# È equivalente a:
diff < file1.txt < file2.txt
```

### Combinazione Input e Output

```bash
# Legge da input.txt, elabora, scrive su output.txt
sort < input.txt > output.txt

# Filtra e salva
grep "pattern" < file.txt > risultati.txt

# Trasforma dati
tr 'a-z' 'A-Z' < minuscolo.txt > maiuscolo.txt
```

---

## Append (>>)

### Descrizione

L'operatore `>>` aggiunge output alla fine del file.

- Non sovrascrive il contenuto esistente
- Crea il file se non esiste

### Sintassi

```bash
comando >> file
```

### Esempi

```bash
# Aggiungi riga a file
echo "Nuova riga" >> file.txt

# Log progressivo
date >> log.txt
echo "Operazione completata" >> log.txt

# Aggiungi output comando
ls -l >> lista_completa.txt

# Report incrementale
{
    echo "=== Nuovo report $(date) ==="
    df -h
    echo ""
} >> report_giornaliero.txt
```

### Differenza > vs >>

```bash
# Con > (sovrascrive)
echo "Prima riga" > file.txt
echo "Seconda riga" > file.txt
cat file.txt
# Output: Seconda riga

# Con >> (aggiunge)
echo "Prima riga" > file.txt
echo "Seconda riga" >> file.txt
cat file.txt
# Output:
# Prima riga
# Seconda riga
```

### Esempio Pratico - Logging

```bash
#!/bin/bash
# Script con logging

LOG_FILE="/var/log/myscript.log"

echo "[$(date)] Script avviato" >> "$LOG_FILE"
echo "[$(date)] Eseguendo backup..." >> "$LOG_FILE"

# ... operazioni ...

echo "[$(date)] Backup completato" >> "$LOG_FILE"
```

---

## Ridirezione Errori (2>)

### Descrizione

L'operatore `2>` redirige lo stderr (errori) in un file. Utile per separare errori dall'output normale.

### Sintassi

```bash
comando 2> file_errori
```

### Esempi Base

```bash
# Salva solo errori
ls /nonexiste 2> errori.txt

# Output normale e errori separati
ls /tmp /nonexiste > output.txt 2> errori.txt

# Append errori
comando 2>> errori.log
```

### Ignorare Errori

```bash
# Elimina messaggi di errore
comando 2> /dev/null

# Esempio: trova file ignorando errori "Permission denied"
find / -name "*.conf" 2> /dev/null
```

### Esempi Pratici

```bash
# Backup con log errori
cp -r /source /backup 2> backup_errors.log

# Compilazione con errori separati
gcc program.c -o program 2> compile_errors.txt

# Ricerca in filesystem
find / -name "passwd" 2> /dev/null

# Ping con errori in file
ping -c 3 host_inesistente 2> ping_errors.txt
```

---

## Ridirezione Combinata

### Redirigere Stdout e Stderr insieme

#### Metodo 1: &> (consigliato)

```bash
# Tutto nello stesso file
comando &> output.txt

# Esempio
ls /tmp /nonexiste &> tutto.txt
```

#### Metodo 2: >file 2>&1 (tradizionale)

```bash
# Stdout a file, stderr segue stdout
comando > output.txt 2>&1

# Esempio
ls /tmp /nonexiste > tutto.txt 2>&1
```

#### Metodo 3: |& (con pipe)

```bash
# Passa stdout e stderr alla pipe
comando |& grep "pattern"
```

### Redirigere Stderr a Stdout

```bash
# Errori vanno dove va stdout
comando 2>&1

# Utile con pipe
comando 2>&1 | grep "error"
```

### Redirigere Stdout a Stderr

```bash
# Output normale va sugli errori
comando 1>&2

# O semplicemente:
comando >&2
```

### Esempi Combinati

```bash
# Output e errori in file diversi
comando > output.txt 2> errori.txt

# Output e errori nello stesso file
comando > tutto.txt 2>&1

# Output in file, errori a schermo
comando > output.txt

# Output a schermo, errori in file
comando 2> errori.txt

# Tutto in /dev/null (silenzioso)
comando &> /dev/null

# Append tutto
comando &>> log.txt
```

### Esempio Pratico - Script con Logging Completo

```bash
#!/bin/bash

LOGFILE="script.log"
ERRFILE="script_errors.log"

# Output normale in log
echo "Inizio script $(date)" > "$LOGFILE"

# Comando con output separato
find /etc -name "*.conf" > "$LOGFILE" 2> "$ERRFILE"

# Comando con tutto insieme
ls -la /var /nonexiste &>> "$LOGFILE"

# Verifica errori
if [ -s "$ERRFILE" ]; then
    echo "Si sono verificati errori!" >&2
fi
```

---

## Here Document (<<)

### Descrizione

Il here document permette di passare input multi-riga a un comando. Utile per script e input complessi.

### Sintassi

```bash
comando << DELIMITER
testo
su
multiple
righe
DELIMITER
```

### Esempi Base

```bash
# Input multi-riga per cat
cat << EOF
Questa è una riga
Questa è un'altra riga
Fine del testo
EOF

# Scrivere in file
cat << EOF > file.txt
Prima riga
Seconda riga
Terza riga
EOF

# Con variabili (sostituzione attiva)
NAME="Mario"
cat << EOF
Ciao $NAME!
La data di oggi è: $(date)
EOF
```

### Disabilitare Sostituzione Variabili

```bash
# Usa 'DELIMITER' tra apici
cat << 'EOF'
$HOME non viene sostituito
$(date) non viene eseguito
EOF
```

### Rimuovere Tab Iniziali

```bash
# Usa <<- invece di <<
cat <<- EOF
	Queste tabulazioni
	vengono rimosse
EOF
```

### Esempi Pratici

#### Creare Script

```bash
cat << 'EOF' > script.sh
#!/bin/bash
echo "Questo è uno script"
echo "Creato con here document"
EOF
chmod +x script.sh
```

#### Configurazione Multi-riga

```bash
cat << EOF > config.conf
[database]
host = localhost
port = 5432
user = admin

[logging]
level = debug
file = /var/log/app.log
EOF
```

#### SQL Script

```bash
mysql -u root -p database << EOF
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO users VALUES (1, 'Mario', 'mario@example.com');
INSERT INTO users VALUES (2, 'Luigi', 'luigi@example.com');
EOF
```

#### Email con Here Document

```bash
mail -s "Report Giornaliero" admin@example.com << EOF
Caro Admin,

Questo è il report giornaliero.

Statistiche:
- Utenti attivi: 150
- Errori: 3
- Uptime: 99.9%

Cordiali saluti,
Sistema Automatico
EOF
```

---

## Here String (<<<)

### Descrizione

Il here string passa una stringa singola come input a un comando. Più semplice del here document per input brevi.

### Sintassi

```bash
comando <<< "stringa"
```

### Esempi

```bash
# Input stringa a comando
grep "pattern" <<< "testo con pattern da cercare"

# Conta parole in stringa
wc -w <<< "questa è una frase"

# Trasforma stringa
tr 'a-z' 'A-Z' <<< "converti in maiuscolo"

# Con variabili
TEXT="Hello World"
grep "World" <<< "$TEXT"

# Base64 encode
base64 <<< "testo da codificare"

# Calcoli con bc
bc <<< "5 + 3 * 2"

# Hashing
md5sum <<< "testo da hashare"
```

### Confronto << vs <<<

```bash
# Here document (multi-riga)
cat << EOF
riga 1
riga 2
EOF

# Here string (singola riga)
cat <<< "una sola riga"
```

### Esempi Pratici

```bash
# Verifica formato email
grep -E "^[a-z]+@[a-z]+\.[a-z]+$" <<< "$email"

# Parse JSON (con jq)
jq '.name' <<< '{"name":"Mario","age":30}'

# Converti CSV in colonne
column -t -s',' <<< "Nome,Età,Città"

# Test espressioni regolari
[[ "test123" =~ [0-9]+ ]] && echo "Contiene numeri"
```

---

## File Descriptor

### Descrizione

I file descriptor sono numeri che identificano i canali di I/O.

- **0** = stdin
- **1** = stdout
- **2** = stderr
- **3-9** = disponibili per uso custom

### Creare File Descriptor Custom

```bash
# Apri file descriptor 3 per scrittura
exec 3> custom.txt

# Scrivi su FD 3
echo "Riga 1" >&3
echo "Riga 2" >&3

# Chiudi FD 3
exec 3>&-
```

### Aprire per Lettura

```bash
# Apri FD 3 per lettura
exec 3< input.txt

# Leggi da FD 3
read line1 <&3
read line2 <&3
echo "Prima riga: $line1"
echo "Seconda riga: $line2"

# Chiudi FD 3
exec 3<&-
```

### Aprire per Lettura/Scrittura

```bash
# Apri FD 3 in lettura/scrittura
exec 3<> file.txt

# Leggi e scrivi
read line <&3
echo "Nuova riga" >&3

# Chiudi
exec 3>&-
```

### Esempi Avanzati

#### Backup/Restore di STDOUT

```bash
# Salva stdout originale
exec 3>&1

# Redirige stdout a file
exec 1> output.txt

echo "Questo va nel file"
echo "Anche questo"

# Ripristina stdout originale
exec 1>&3

echo "Questo torna sul terminale"

# Chiudi FD 3
exec 3>&-
```

#### Logging Avanzato

```bash
#!/bin/bash

# Apri file log
exec 3> script.log

# Funzione di log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >&3
}

# Usa la funzione
log "Script avviato"
log "Operazione 1 completata"
log "Script terminato"

# Chiudi log
exec 3>&-
```

---

## Pipe (|)

### Introduzione

La pipe (simbolo `|`) è uno degli strumenti più potenti della shell Unix/Linux. Permette di collegare l'output di un comando all'input di un altro, creando una "catena di montaggio" per l'elaborazione dei dati.

### Vantaggi delle Pipe

- ✅ Elaborazione efficiente dei dati
- ✅ Combinazione di comandi semplici per operazioni complesse
- ✅ Riduzione dell'uso di file temporanei
- ✅ Codice più leggibile e modulare

### Concetto Fondamentale

```bash
comando1 | comando2 | comando3
```

L'output di `comando1` diventa l'input di `comando2`, e l'output di `comando2` diventa l'input di `comando3`.

### Sintassi di Base

```bash
comando1 | comando2
```

#### Come Funziona

1. `comando1` produce output su stdout (standard output)
2. La pipe `|` redirige questo output
3. `comando2` riceve l'output come stdin (standard input)

#### Nota Importante

- Gli errori (stderr) NON passano attraverso la pipe (a meno che non siano rediretti)
- Ogni comando nella pipe viene eseguito in un processo separato
- I comandi vengono eseguiti contemporaneamente, non sequenzialmente

### Esempi Base

#### 1. Contare il numero di file in una directory

```bash
ls | wc -l
```

- `ls` elenca i file
- `wc -l` conta le righe (quindi i file)

#### 2. Visualizzare le prime 10 righe di un file ordinato

```bash
cat file.txt | sort | head -10
```

- `cat` visualizza il contenuto
- `sort` ordina le righe
- `head -10` mostra le prime 10 righe

#### 3. Cercare un processo specifico

```bash
ps aux | grep firefox
```

- `ps aux` mostra tutti i processi
- `grep firefox` filtra solo le righe contenenti "firefox"

#### 4. Contare quante volte appare una parola

```bash
cat documento.txt | grep -o "parola" | wc -l
```

- `cat` visualizza il file
- `grep -o "parola"` estrae ogni occorrenza di "parola" su una nuova riga
- `wc -l` conta le righe (occorrenze)

#### 5. Mostrare solo i file (non le directory)

```bash
ls -l | grep "^-"
```

- `ls -l` lista dettagliata
- `grep "^-"` filtra le righe che iniziano con `-` (file regolari)

#### 6. Visualizzare l'uso del disco ordinato

```bash
du -h | sort -h
```

- `du -h` mostra l'uso del disco in formato leggibile
- `sort -h` ordina per dimensione umana (human-readable)

#### 7. Estrarre informazioni specifiche

```bash
cat /etc/passwd | cut -d: -f1
```

- `cat /etc/passwd` mostra il file degli utenti
- `cut -d: -f1` estrae il primo campo (nome utente), usando `:` come delimitatore

#### 8. Rimuovere righe duplicate

```bash
cat file.txt | sort | uniq
```

- `sort` ordina le righe (necessario per uniq)
- `uniq` rimuove le righe duplicate consecutive

### Esempi Intermedi

#### 1. Top 5 file più grandi in una directory

```bash
ls -lh | sort -k5 -hr | head -6 | tail -5
```

- `ls -lh` lista con dimensioni leggibili
- `sort -k5 -hr` ordina per 5° campo (dimensione) in ordine inverso
- `head -6` prende le prime 6 righe (inclusa l'intestazione)
- `tail -5` prende le ultime 5 (escludendo l'intestazione)

#### 2. Contare le estensioni dei file

```bash
ls | grep "\." | sed 's/.*\.//' | sort | uniq -c | sort -rn
```

- `ls` elenca i file
- `grep "\."` filtra solo file con estensione
- `sed 's/.*\.//'` estrae l'estensione
- `sort` ordina
- `uniq -c` conta le occorrenze
- `sort -rn` ordina numericamente in ordine inverso

#### 3. Monitorare un log in tempo reale e filtrare errori

```bash
tail -f /var/log/syslog | grep -i error
```

- `tail -f` segue il file in tempo reale
- `grep -i error` filtra le righe con "error" (case-insensitive)

#### 4. Trovare i 10 comandi più usati

```bash
history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
```

- `history` mostra la cronologia
- `awk '{print $2}'` estrae il secondo campo (il comando)
- `sort | uniq -c` conta le occorrenze
- `sort -rn` ordina per frequenza
- `head -10` mostra i primi 10

#### 5. Elencare utenti che hanno effettuato login

```bash
last | grep -v "reboot" | grep -v "wtmp" | awk '{print $1}' | sort | uniq
```

- `last` mostra gli ultimi login
- `grep -v` esclude righe con "reboot" e "wtmp"
- `awk '{print $1}'` estrae il nome utente
- `sort | uniq` rimuove duplicati

### Esempi Avanzati

#### 1. Pipeline con multipli filtri e trasformazioni

```bash
cat access.log | grep "GET" | awk '{print $7}' | sort | uniq -c | sort -rn | head -20
```

Analizza un log Apache/Nginx per trovare le 20 URL più richieste:

- Filtra solo richieste GET
- Estrae l'URL (7° campo)
- Conta le occorrenze
- Ordina per frequenza

#### 2. Analisi avanzata dei log

```bash
cat /var/log/auth.log | grep "Failed password" | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | head -10
```

Mostra i 10 IP che hanno tentato più accessi falliti:

- Filtra tentativi falliti
- Estrae l'IP
- Conta e ordina

### Combinazioni Comuni

```bash
# grep + wc
# Contare le occorrenze
grep "pattern" file.txt | wc -l

# ps + grep
# Trovare processi
ps aux | grep nome_processo

# find + xargs
# Eseguire comando su file trovati
find . -name "*.txt" | xargs cat

# cat + grep + awk
# Estrazione e formattazione
cat file.txt | grep "pattern" | awk '{print $1}'

# sort + uniq
# Rimuovere duplicati
cat file.txt | sort | uniq
# O contare duplicati
cat file.txt | sort | uniq -c

# head + tail
# Estrarre righe specifiche (es: righe 10-20)
cat file.txt | head -20 | tail -10
```

---

## Comando tee

Il comando `tee` permette di duplicare l'output: salva in un file E lo mostra a schermo contemporaneamente.

### Sintassi

```bash
comando | tee file.txt
```

### Esempi

```bash
# Salva e mostra
ls -l | tee lista.txt

# Append mode
comando | tee -a log.txt

# Pipeline con tee (duplicare output)
cat file.txt | tee original.txt | tr '[:lower:]' '[:upper:]' | tee uppercase.txt | wc -l
```

- Salva l'originale
- Converte in maiuscolo e salva
- Conta le righe

---

## Esempi Pratici

### 1. Script di Backup con Logging

```bash
#!/bin/bash

LOGFILE="backup.log"
ERRFILE="backup_errors.log"

{
    echo "=== Backup avviato: $(date) ==="
    
    # Backup con errori separati
    tar -czf backup.tar.gz /important/data 2>> "$ERRFILE"
    
    if [ $? -eq 0 ]; then
        echo "Backup completato con successo"
    else
        echo "Backup fallito - vedere $ERRFILE"
    fi
    
    echo "=== Backup terminato: $(date) ==="
    echo ""
} >> "$LOGFILE"
```

### 2. Monitoraggio Sistema

```bash
#!/bin/bash

REPORT="system_report.txt"

{
    echo "=============================="
    echo "REPORT DI SISTEMA"
    echo "Data: $(date)"
    echo "=============================="
    echo ""
    
    echo "--- Utilizzo CPU ---"
    top -bn1 | head -n 5
    echo ""
    
    echo "--- Utilizzo Memoria ---"
    free -h
    echo ""
    
    echo "--- Utilizzo Disco ---"
    df -h
    echo ""
    
    echo "--- Processi Attivi ---"
    ps aux | wc -l
    echo ""
    
} > "$REPORT" 2>&1

echo "Report salvato in $REPORT"
```

### 3. Elaborazione Dati con Ridirezione

```bash
#!/bin/bash

INPUT="dati_grezzi.txt"
OUTPUT="dati_processati.txt"
ERRORS="elaborazione_errors.txt"

# Elabora dati
{
    # Rimuovi righe vuote
    grep -v "^$" < "$INPUT" |
    
    # Rimuovi duplicati
    sort -u |
    
    # Converti in maiuscolo
    tr 'a-z' 'A-Z' |
    
    # Aggiungi numerazione
    nl
    
} > "$OUTPUT" 2> "$ERRORS"

echo "Elaborazione completata"
echo "Output: $OUTPUT"
echo "Errori: $ERRORS"
```

---

## Best Practices

### 1. Usa Redirect Appropriati

```bash
# ❌ SBAGLIATO: perde errori
comando > output.txt

# ✅ CORRETTO: cattura anche errori
comando > output.txt 2>&1
```

### 2. Controlla Successo Operazioni

```bash
if comando > output.txt 2>&1; then
    echo "Successo"
else
    echo "Fallito"
    cat output.txt >&2
fi
```

### 3. Usa Append per Log

```bash
# ✅ CORRETTO per logging
echo "$(date): Evento" >> log.txt

# ❌ SBAGLIATO: sovrascrive
echo "$(date): Evento" > log.txt
```

### 4. Gestisci /dev/null con Attenzione

```bash
# ✅ OK: elimina solo output
comando > /dev/null

# ⚠️ ATTENZIONE: elimina anche errori
comando &> /dev/null

# ✅ MEGLIO: mostra errori
comando > /dev/null 2>&1 || echo "Errore" >&2
```

### 5. Documenta Redirections Complesse

```bash
# Chiaro e commentato
comando \
    > output.txt \      # Output normale
    2> errors.txt \     # Errori
    < input.txt         # Input

# Invece di:
comando > output.txt 2> errors.txt < input.txt
```

### 6. Usa Here Documents per Configurazioni

```bash
# ✅ LEGGIBILE
cat << EOF > config.yml
database:
  host: localhost
  port: 5432
EOF

# Invece di multipli echo
```

### 7. Proteggi da Sovrascrittura Accidentale

```bash
# Abilita noclobber
set -o noclobber

# Ora questo fallisce se file esiste:
echo "test" > existing_file.txt

# Override quando necessario
echo "test" >| existing_file.txt

# Disabilita noclobber
set +o noclobber
```

### 8. Evita UUOC (Useless Use Of Cat)

```bash
# ❌ Sbagliato:
cat file.txt | grep "pattern"

# ✅ Corretto:
grep "pattern" file.txt
```

### 9. Testa Pipeline in Step

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

## Quick Reference

### Operatori di Ridirezione

| Operatore | Descrizione | Esempio |
|-----------|-------------|---------|
| `>` | Redirect output (sovrascrive) | `ls > file.txt` |
| `>>` | Redirect output (append) | `date >> log.txt` |
| `<` | Redirect input | `sort < input.txt` |
| `2>` | Redirect errori | `cmd 2> err.txt` |
| `2>>` | Redirect errori (append) | `cmd 2>> err.txt` |
| `&>` | Redirect output+errori | `cmd &> all.txt` |
| `&>>` | Redirect output+errori (append) | `cmd &>> all.txt` |
| `2>&1` | Errori dove va output | `cmd > file 2>&1` |
| `1>&2` | Output dove vanno errori | `echo "err" 1>&2` |
| `<<` | Here document | `cat << EOF` |
| `<<<` | Here string | `grep x <<< "text"` |
| `\|` | Pipe | `cmd1 \| cmd2` |
| `\|&` | Pipe output+errori | `cmd \|& grep err` |

### File Speciali

| File | Descrizione |
|------|-------------|
| `/dev/null` | "Buco nero" - elimina output |
| `/dev/stdin` | Standard input (fd 0) |
| `/dev/stdout` | Standard output (fd 1) |
| `/dev/stderr` | Standard error (fd 2) |
| `/dev/zero` | Fonte infinita di byte zero |
| `/dev/random` | Numeri casuali |

### Comandi Utili con le Pipe

| Comando | Funzione | Esempio |
|---------|----------|---------|
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

La ridirezione e le pipe sono strumenti potenti che permettono di:

- 🔀 Controllare il flusso di dati
- 📝 Creare log e report automatici
- 🛠️ Costruire script complessi e robusti
- 🎯 Separare output normale da errori
- ⚡ Automatizzare workflow di elaborazione
- 🔗 Combinare comandi semplici per operazioni complesse

**Ricorda:**

1. stdout (1) per output normale
2. stderr (2) per errori
3. `>` sovrascrive, `>>` aggiunge
4. `2>&1` combina stderr con stdout
5. La pipe `|` collega comandi tra loro
6. Testa sempre le tue redirezioni!

---

## Risorse

- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [GNU Coreutils Manual](https://www.gnu.org/software/coreutils/manual/)
- Man pages: `man bash`, `man grep`, `man awk`, ecc.

## Esempi e Esercizi

La cartella `esempi/` contiene script di esempio relativi a questo modulo.

La cartella `esercizi/` contiene problemi pratici per consolidare l'apprendimento degli argomenti trattati.

---

*Creato per scopi didattici - TPSIT1 Linux Essentials with Bash*