#!/bin/bash
# =============================================================================
# 02_pipe.sh
# Modulo 05 - Pipe e Filtri
#
# Dimostra |, tee, xargs, sostituzione di comando $() in pipeline.
# Esecuzione: bash 02_pipe.sh
# =============================================================================

CIANO='\033[0;36m'
GIALLO='\033[1;33m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }

WORKDIR=$(mktemp -d /tmp/lab05p_XXXXX)
cd "$WORKDIR"

# Crea file di dati
cat > accessi.log << 'EOF'
192.168.1.10 GET /index.html 200
10.0.0.5     GET /login.php  200
192.168.1.10 POST /login.php 302
172.16.0.3   GET /admin.php  403
10.0.0.5     GET /dashboard  200
192.168.1.10 GET /style.css  200
172.16.0.3   GET /admin.php  403
10.0.0.5     POST /api/data  201
192.168.1.10 GET /logo.png   200
172.16.0.3   GET /robots.txt 200
EOF

cat > parole.txt << 'EOF'
linux bash shell
linux bash terminal
bash script linux
shell kernel linux
bash linux programmazione
EOF

echo "File di dati creati."

# --- pipe di base ---
titolo "1. Pipe di base — collegare comandi"
echo "Quanti file ci sono in /etc?"
cmd "ls /etc | wc -l"

echo "File in /etc che contengono 'host':"
cmd "ls /etc | grep 'host'"

echo "Prime 5 entry di /etc/passwd con shell bash:"
cmd "grep 'bash' /etc/passwd | head -5"

# --- pipeline a più stadi ---
titolo "2. Pipeline multi-stadio"
echo "IP univoci nel log con conteggio accessi:"
cmd "awk '{print \$1}' accessi.log | sort | uniq -c | sort -rn"

echo "Codici di risposta HTTP nel log:"
cmd "awk '{print \$4}' accessi.log | sort | uniq -c | sort -rn"

echo "10 parole più frequenti in parole.txt:"
cmd "cat parole.txt | tr ' ' '\n' | sort | uniq -c | sort -rn | head -10"

# --- tee ---
titolo "3. tee — vedere e salvare allo stesso tempo"
echo "Elaboro il log e salvo l'analisi mentre la mostro:"
cmd "awk '{print \$1}' accessi.log | sort | uniq -c | sort -rn | tee analisi_ip.txt"
echo "Il file analisi_ip.txt esiste con questo contenuto:"
cmd "cat analisi_ip.txt"

echo "tee con aggiunta (-a):"
cmd "echo '--- Fine analisi ---' | tee -a analisi_ip.txt"
cmd "cat analisi_ip.txt"

# --- xargs ---
titolo "4. xargs — output come argomenti"
echo "Creo alcuni file .tmp:"
cmd "touch file1.tmp file2.tmp file3.tmp file4.tmp"
cmd "ls *.tmp"

echo "Elimino i .tmp trasforming l'output di ls in argomenti:"
cmd "ls *.tmp | xargs rm -v"

echo "Cerco tutti i file .log nella dir corrente e li listo:"
touch test1.log test2.log
cmd "find . -name '*.log' | xargs ls -lh"

echo "xargs con -I {} (placeholder):"
cmd "ls *.log | xargs -I {} echo 'Trovato: {}'"

# --- sostituzione di comando ---
titolo "5. Sostituzione di comando \$()"
echo "Usiamo il risultato di un comando come testo:"
cmd "echo \"Oggi è: \$(date '+%d/%m/%Y')\""
cmd "echo \"Hostname: \$(hostname)   Kernel: \$(uname -r)\""

n_processi=$(ps aux | wc -l)
echo "Processi attivi: $n_processi"

echo "Creare un archivio con data nel nome:"
tar -czvf backup_$(date '+%Y%m%d_%H%M').tar.gz accessi.log parole.txt 2>/dev/null
cmd "ls backup_*.tar.gz"

# --- pipeline complessa finale ---
titolo "6. Pipeline complessa: analisi completa del log"
echo "Report completo:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Totale richieste: $(wc -l < accessi.log)"
echo "IP univoci: $(awk '{print $1}' accessi.log | sort -u | wc -l)"
echo "Richieste con errore 4xx: $(awk '$4~/^4/{count++} END{print count+0}' accessi.log)"
echo ""
echo "Top 3 IP per accessi:"
awk '{print $1}' accessi.log | sort | uniq -c | sort -rn | head -3
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Pulizia
cd /tmp
rm -rf "$WORKDIR"
echo -e "\n${CIANO}Directory temporanea eliminata.${RESET}"
