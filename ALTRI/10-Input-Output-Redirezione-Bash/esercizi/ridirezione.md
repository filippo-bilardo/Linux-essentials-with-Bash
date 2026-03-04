# Guida alla Ridirezione in Bash

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
11. [Esempi Pratici](#esempi-pratici)
12. [Esercizi](#esercizi)
13. [Soluzioni](#soluzioni)

---

## Introduzione

La **ridirezione** è uno dei concetti fondamentali della shell Unix/Linux. Permette di controllare dove i comandi ricevono il loro input e dove inviano il loro output.

### Perché è importante?
- 📝 Salvare output di comandi in file
- 🔀 Collegare comandi tra loro
- ❌ Gestire gli errori separatamente
- 📊 Automatizzare elaborazioni di dati
- 🔇 Silenziare output non desiderati

### Filosofia Unix
Ogni programma Unix:
- Legge da un **input stream** (stdin)
- Scrive su un **output stream** (stdout)
- Scrive errori su **error stream** (stderr)

---

## I Tre Stream Standard

### 1. STDIN (Standard Input) - File Descriptor 0
L'**input standard** è da dove un programma legge i dati.
- Default: **tastiera**
- Simbolo: `<` o `0<`

### 2. STDOUT (Standard Output) - File Descriptor 1
L'**output standard** è dove un programma scrive i risultati normali.
- Default: **terminale/schermo**
- Simbolo: `>` o `1>`

### 3. STDERR (Standard Error) - File Descriptor 2
L'**error standard** è dove un programma scrive i messaggi di errore.
- Default: **terminale/schermo**
- Simbolo: `2>`

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
- **Sovrascrive** il file se esiste
- **Crea** il file se non esiste

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
L'operatore `<` redirige l'input standard (stdin) da un file.
Il comando legge dal file invece che dalla tastiera.

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
L'operatore `>>` **aggiunge** output alla fine del file.
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
L'operatore `2>` redirige lo **stderr** (errori) in un file.
Utile per separare errori dall'output normale.

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
Il **here document** permette di passare input multi-riga a un comando.
Utile per script e input complessi.

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

#### Documentazione in Script
```bash
#!/bin/bash

# Funzione help
show_help() {
    cat << EOF
Uso: $0 [opzioni] file

Opzioni:
    -h, --help      Mostra questo help
    -v, --verbose   Output dettagliato
    -o FILE         File di output

Esempi:
    $0 input.txt
    $0 -v -o result.txt input.txt
EOF
}

if [ "$1" = "-h" ]; then
    show_help
    exit 0
fi
```

---

## Here String (<<<)

### Descrizione
Il **here string** passa una stringa singola come input a un comando.
Più semplice del here document per input brevi.

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
[[ "test123" =~ [0-9]+ ]] <<< "test123" && echo "Contiene numeri"
```

---

## File Descriptor

### Descrizione
I **file descriptor** sono numeri che identificano i canali di I/O.
- 0 = stdin
- 1 = stdout
- 2 = stderr
- 3-9 = disponibili per uso custom

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

#### Duplicare Stream
```bash
# Duplica stdout e stderr
exec 3>&1 4>&2

# Redirige entrambi
exec 1> output.txt 2> errors.txt

# Comandi che scrivono su file
echo "Output normale"
echo "Errore" >&2

# Ripristina
exec 1>&3 2>&4

# Chiudi duplicati
exec 3>&- 4>&-
```

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

### 4. Menu Interattivo con Here Document
```bash
#!/bin/bash

show_menu() {
    cat << EOF
================================
    MENU PRINCIPALE
================================
1. Visualizza file
2. Cerca pattern
3. Statistiche
4. Esci

Inserisci la tua scelta: 
EOF
}

while true; do
    show_menu
    read -r choice
    
    case $choice in
        1) ls -l ;;
        2) read -p "Pattern: " pattern
           grep "$pattern" * 2>/dev/null ;;
        3) df -h ;;
        4) break ;;
        *) echo "Scelta non valida" >&2 ;;
    esac
    
    echo ""
    read -p "Premi ENTER per continuare..."
done
```

### 5. Validator con Output Separati
```bash
#!/bin/bash

VALID="valid_entries.txt"
INVALID="invalid_entries.txt"

while IFS= read -r line; do
    if [[ "$line" =~ ^[0-9]+$ ]]; then
        echo "$line" >> "$VALID"
    else
        echo "$line" >> "$INVALID"
    fi
done < input.txt

echo "Validazione completata"
echo "Validi: $(wc -l < "$VALID")"
echo "Invalidi: $(wc -l < "$INVALID")"
```

### 6. Installazione Automatica
```bash
#!/bin/bash

mysql_secure_installation << EOF
y
MySecurePassword
MySecurePassword
y
y
y
y
EOF

echo "MySQL configurato"
```

### 7. Generatore Configurazioni
```bash
#!/bin/bash

SERVER_NAME="$1"
SERVER_IP="$2"

cat << EOF > "/etc/nginx/sites-available/$SERVER_NAME"
server {
    listen 80;
    server_name $SERVER_NAME;
    
    location / {
        proxy_pass http://$SERVER_IP:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

echo "Configurazione creata per $SERVER_NAME"
```

### 8. Test Suite con Report
```bash
#!/bin/bash

REPORT="test_results.txt"
PASSED=0
FAILED=0

run_test() {
    local test_name="$1"
    local command="$2"
    
    if eval "$command" &>/dev/null; then
        echo "✓ $test_name" | tee -a "$REPORT"
        ((PASSED++))
    else
        echo "✗ $test_name" | tee -a "$REPORT"
        ((FAILED++))
    fi
}

{
    echo "=============================="
    echo "TEST SUITE - $(date)"
    echo "=============================="
    
    run_test "File config esiste" "[ -f config.ini ]"
    run_test "Database raggiungibile" "ping -c 1 db.local"
    run_test "Servizio attivo" "systemctl is-active myservice"
    
    echo ""
    echo "=============================="
    echo "Risultati: $PASSED passati, $FAILED falliti"
    echo "=============================="
    
} > "$REPORT"

cat "$REPORT"
```

---

## Esercizi

### Esercizio 1: Base
Scrivi un comando che salvi la lista dei file nella directory corrente in un file chiamato `lista.txt`.

---

### Esercizio 2: Base
Crea un comando che aggiunga la data corrente alla fine del file `log.txt` senza cancellare il contenuto esistente.

---

### Esercizio 3: Base
Esegui il comando `find` per cercare tutti i file `.txt` nel sistema, salvando i risultati in `risultati.txt` e gli errori in `errori.txt`.

---

### Esercizio 4: Intermedio
Crea un comando che converta tutto il testo di `input.txt` in maiuscolo e salvi il risultato in `output.txt`.

---

### Esercizio 5: Intermedio
Scrivi un comando che conti il numero di righe, parole e caratteri del file `documento.txt` e salvi il risultato in `statistiche.txt`.

---

### Esercizio 6: Intermedio
Usa un here document per creare un file `utenti.csv` con almeno 3 righe di dati nel formato: `nome,cognome,email`.

---

### Esercizio 7: Avanzato
Scrivi uno script che:
1. Crei un file di log
2. Salvi stdout nel log
3. Salvi stderr in un file separato
4. Esegua alcuni comandi (alcuni con successo, altri con errori)

---

### Esercizio 8: Avanzato
Crea un comando che cerchi la parola "ERROR" in tutti i file `.log` della directory `/var/log`, ignorando gli errori di permesso, e salvi solo le righe che contengono "CRITICAL".

---

### Esercizio 9: Esperto
Scrivi uno script che implementi un sistema di logging avanzato con:
- Timestamp automatico
- Livelli di log (INFO, WARNING, ERROR)
- Rotazione automatica dei log
- Output sia su file che su console

---

### Esercizio 10: Esperto
Crea uno script che:
1. Faccia backup di file descriptor stdout e stderr
2. Reindirizzi tutto su file
3. Esegua operazioni
4. Ripristini i file descriptor originali
5. Mostri un resoconto sul terminale

---

## Soluzioni

### Soluzione Esercizio 1
```bash
ls > lista.txt
```
O con dettagli:
```bash
ls -la > lista.txt
```

---

### Soluzione Esercizio 2
```bash
date >> log.txt
```
Con formato personalizzato:
```bash
date "+%Y-%m-%d %H:%M:%S" >> log.txt
```

---

### Soluzione Esercizio 3
```bash
find / -name "*.txt" > risultati.txt 2> errori.txt
```
O per essere più chiari:
```bash
find / -name "*.txt" 1> risultati.txt 2> errori.txt
```

---

### Soluzione Esercizio 4
```bash
tr 'a-z' 'A-Z' < input.txt > output.txt
```
O con cat:
```bash
cat input.txt | tr 'a-z' 'A-Z' > output.txt
```

---

### Soluzione Esercizio 5
```bash
wc < documento.txt > statistiche.txt
```
O più esplicito:
```bash
wc -lwc documento.txt > statistiche.txt
```
Con descrizione:
```bash
{
    echo "Statistiche di documento.txt:"
    echo "-------------------------"
    wc documento.txt
} > statistiche.txt
```

---

### Soluzione Esercizio 6
```bash
cat << EOF > utenti.csv
nome,cognome,email
Mario,Rossi,mario.rossi@email.com
Luigi,Verdi,luigi.verdi@email.com
Anna,Bianchi,anna.bianchi@email.com
EOF
```
O con intestazione:
```bash
cat << 'EOF' > utenti.csv
nome,cognome,email
Mario,Rossi,mario.rossi@email.com
Luigi,Verdi,luigi.verdi@email.com
Anna,Bianchi,anna.bianchi@email.com
EOF
```

---

### Soluzione Esercizio 7
```bash
#!/bin/bash

LOGFILE="output.log"
ERRFILE="errors.log"

# Crea file log
echo "=== Log avviato: $(date) ===" > "$LOGFILE"
echo "=== Errori ===" > "$ERRFILE"

# Comandi con successo
echo "Eseguendo comandi..." >> "$LOGFILE"
ls /tmp >> "$LOGFILE" 2>> "$ERRFILE"
date >> "$LOGFILE" 2>> "$ERRFILE"

# Comandi con errori
echo "Tentando operazioni rischiose..." >> "$LOGFILE"
ls /directory/inesistente >> "$LOGFILE" 2>> "$ERRFILE"
cat /file/inesistente >> "$LOGFILE" 2>> "$ERRFILE"

# Resoconto
echo "=== Log terminato: $(date) ===" >> "$LOGFILE"

# Mostra risultati
echo "Log salvato in: $LOGFILE"
echo "Errori salvati in: $ERRFILE"
echo ""
echo "Numero di errori: $(grep -c "No such file" "$ERRFILE")"
```

---

### Soluzione Esercizio 8
```bash
grep -h "ERROR" /var/log/*.log 2>/dev/null | grep "CRITICAL" > errori_critici.txt
```
O più dettagliato:
```bash
find /var/log -name "*.log" 2>/dev/null | \
    xargs grep "ERROR" 2>/dev/null | \
    grep "CRITICAL" > errori_critici.txt
```
Con informazioni sul file:
```bash
grep -r "ERROR" /var/log/*.log 2>/dev/null | grep "CRITICAL" > errori_critici.txt
```

---

### Soluzione Esercizio 9
```bash
#!/bin/bash

# Configurazione
LOGFILE="/var/log/myapp.log"
LOGDIR="$(dirname "$LOGFILE")"
MAX_SIZE=1048576  # 1MB

# Colori per console
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Funzione di rotazione log
rotate_log() {
    if [ -f "$LOGFILE" ] && [ $(stat -f %z "$LOGFILE" 2>/dev/null || stat -c %s "$LOGFILE") -ge $MAX_SIZE ]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        mv "$LOGFILE" "${LOGFILE}.${timestamp}"
        gzip "${LOGFILE}.${timestamp}"
        echo "Log ruotato: ${LOGFILE}.${timestamp}.gz"
    fi
}

# Funzione di log
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Rotazione se necessario
    rotate_log
    
    # Scrivi su file
    echo "[$timestamp] [$level] $message" >> "$LOGFILE"
    
    # Scrivi su console con colori
    case "$level" in
        ERROR)
            echo -e "${RED}[$timestamp] [$level] $message${NC}" ;;
        WARNING)
            echo -e "${YELLOW}[$timestamp] [$level] $message${NC}" ;;
        INFO)
            echo -e "${GREEN}[$timestamp] [$level] $message${NC}" ;;
        *)
            echo "[$timestamp] [$level] $message" ;;
    esac
}

# Crea directory log se non esiste
mkdir -p "$LOGDIR"

# Test del sistema di logging
log INFO "Applicazione avviata"
log INFO "Sistema di logging inizializzato"
log WARNING "Questo è un warning di test"
log ERROR "Questo è un errore di test"
log INFO "Test completato"

# Cleanup vecchi log (più di 30 giorni)
find "$LOGDIR" -name "$(basename "$LOGFILE").*.gz" -mtime +30 -delete 2>/dev/null
log INFO "Pulizia log completata"
```

---

### Soluzione Esercizio 10
```bash
#!/bin/bash

# Funzione principale
main() {
    # Step 1: Backup file descriptor
    echo "Step 1: Backup file descriptor originali"
    exec 3>&1 4>&2
    
    # Step 2: Redirige su file
    echo "Step 2: Redirezione output su file"
    exec 1> output.log 2> errors.log
    
    # Step 3: Operazioni (output va nei file)
    echo "=== Inizio operazioni $(date) ==="
    echo "Queste righe vanno in output.log"
    
    # Comandi con successo
    echo "--- Comandi con successo ---"
    ls /tmp
    date
    whoami
    
    # Comandi con errori
    echo "--- Comandi con errori ---"
    ls /directory_inesistente
    cat /file_inesistente
    
    echo "=== Fine operazioni $(date) ==="
    
    # Step 4: Ripristina file descriptor
    exec 1>&3 2>&4
    
    # Step 5: Chiudi file descriptor backup
    exec 3>&- 4>&-
    
    # Step 6: Mostra resoconto sul terminale
    echo "================================"
    echo "RESOCONTO OPERAZIONI"
    echo "================================"
    echo ""
    
    echo "Output normale:"
    echo "---------------"
    cat output.log
    echo ""
    
    echo "Errori rilevati:"
    echo "---------------"
    if [ -s errors.log ]; then
        cat errors.log
    else
        echo "Nessun errore"
    fi
    
    echo ""
    echo "================================"
    echo "File creati:"
    echo "  - output.log ($(wc -l < output.log) righe)"
    echo "  - errors.log ($(wc -l < errors.log) righe)"
    echo "================================"
}

# Esegui
main
```

Versione con gestione errori:
```bash
#!/bin/bash

set -euo pipefail

# Variabili globali
OUTPUT_FILE="output.log"
ERROR_FILE="errors.log"

# Cleanup
cleanup() {
    # Ripristina fd se ancora aperti
    exec 1>&3 2>&4 2>/dev/null || true
    exec 3>&- 4>&- 2>/dev/null || true
}

# Trap per cleanup
trap cleanup EXIT

main() {
    echo "Inizio elaborazione..."
    
    # Backup originali
    exec 3>&1 4>&2
    
    # Redirige su file
    exec 1>"$OUTPUT_FILE" 2>"$ERROR_FILE"
    
    # Operazioni
    echo "=== Log Inizio: $(date) ==="
    
    # Esegui comandi
    for cmd in "ls -l /tmp" "date" "hostname" "ls /invalid" "cat /nofile"; do
        echo "Eseguendo: $cmd"
        eval "$cmd" || echo "Comando fallito: $cmd"
    done
    
    echo "=== Log Fine: $(date) ==="
    
    # Ripristina
    exec 1>&3 2>&4
    exec 3>&- 4>&-
    
    # Report
    echo ""
    echo "╔════════════════════════════════╗"
    echo "║   REPORT FINALE OPERAZIONI     ║"
    echo "╚════════════════════════════════╝"
    echo ""
    echo "📄 Output: $OUTPUT_FILE"
    echo "   Righe: $(wc -l < "$OUTPUT_FILE")"
    echo ""
    echo "❌ Errori: $ERROR_FILE"
    echo "   Righe: $(wc -l < "$ERROR_FILE")"
    echo ""
    
    if [ -s "$ERROR_FILE" ]; then
        echo "⚠️  ATTENZIONE: Errori rilevati!"
        echo "   Primi 5 errori:"
        head -5 "$ERROR_FILE" | sed 's/^/   /'
    else
        echo "✅ Nessun errore rilevato"
    fi
    
    echo ""
}

# Esegui
main "$@"
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
| `<>` | Apri per lettura/scrittura | `exec 3<> file` |

### File Speciali

| File | Descrizione |
|------|-------------|
| `/dev/null` | "Buco nero" - elimina output |
| `/dev/stdin` | Standard input (fd 0) |
| `/dev/stdout` | Standard output (fd 1) |
| `/dev/stderr` | Standard error (fd 2) |
| `/dev/zero` | Fonte infinita di byte zero |
| `/dev/random` | Numeri casuali |

---

## Conclusione

La ridirezione è uno strumento potente che permette di:
- 🔀 Controllare il flusso di dati
- 📝 Creare log e report automatici
- 🛠️ Costruire script complessi e robusti
- 🎯 Separare output normale da errori
- ⚡ Automatizzare workflow di elaborazione

**Ricorda**:
1. stdout (1) per output normale
2. stderr (2) per errori
3. `>` sovrascrive, `>>` aggiunge
4. `2>&1` combina stderr con stdout
5. Testa sempre le tue redirezioni!

---

*Creato per scopi didattici - TECINF*