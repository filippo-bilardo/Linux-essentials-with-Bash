#!/bin/bash
# =============================================================================
# 01_redirezione.sh
# Modulo 05 - Redirezione di Input e Output
#
# Dimostra stdin, stdout, stderr, >, >>, 2>, 2>&1, /dev/null, here-doc.
# Esecuzione: bash 01_redirezione.sh
# =============================================================================

CIANO='\033[0;36m'
GIALLO='\033[1;33m'
VERDE='\033[0;32m'
ROSSO='\033[0;31m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }

WORKDIR=$(mktemp -d /tmp/lab05_XXXXX)
cd "$WORKDIR"
echo "Directory di lavoro: $WORKDIR"

# --- stdout su file ---
titolo "1. Redirezione stdout → file (>  e  >>)"
cmd "ls /etc/host* > lista.txt"
echo "Contenuto di lista.txt:"
cmd "cat lista.txt"

echo "Aggiungo la data al file:"
cmd "date >> lista.txt"
cmd "cat lista.txt"

# --- stderr ---
titolo "2. Catturare stderr"
echo "Proviamo a listare una cartella inesistente:"
cmd "ls /cartella_inesistente 2> errore.txt"
echo "Il terminale non ha mostrato nulla. Il file errore.txt contiene:"
cmd "cat errore.txt"

# --- scartare stderr ---
titolo "3. /dev/null — ignorare gli errori"
echo "Cerco senza errori 'Permission denied':"
cmd "find /etc -name '*.conf' 2>/dev/null | wc -l"

echo "Scarto completamente l'output (solo per sapere se esce con successo):"
cmd "ls /etc > /dev/null && echo 'Comando OK' || echo 'Comando fallito'"

# --- unire stdout e stderr ---
titolo "4. Unire stdout e stderr (2>&1  e  &>)"
echo "Lista di directory miste (alcune esistono, alcune no):"
cmd "ls /etc/hosts /inesistente /etc/hostname > tutto.txt 2>&1"
echo "Tutto (output + errori) in tutto.txt:"
cmd "cat tutto.txt"

echo "Sintassi abbreviata &>:"
cmd "ls /etc/hosts /inesistente &> tutto2.txt"
cmd "cat tutto2.txt"

# --- stdout separato da stderr ---
titolo "5. Separare stdout da stderr"
cmd "ls /etc/hosts /inesistente > output.txt 2> errors.txt"
echo "--- output.txt ---"
cmd "cat output.txt"
echo "--- errors.txt ---"
cmd "cat errors.txt"

# --- stdin da file ---
titolo "6. Redirezione stdin (<)"
echo "mele
banane
arancia
kiwi
banane
mele" > frutti.txt

echo "Ordinare frutti.txt usando stdin:"
cmd "sort < frutti.txt"
echo "Contare righe con wc:"
cmd "wc -l < frutti.txt"

# --- here-document ---
titolo "7. Here-Document (<<)"
cat << EOF > config.txt
host=localhost
porta=8080
debug=true
versione=1.0
EOF
echo "File config.txt creato con here-doc:"
cmd "cat config.txt"

echo "Here-doc inline con cat:"
cmd "cat << 'FINE'
Questa riga NON espande \$HOME
Questo è un here-doc 'raw'
FINE"

# --- here-string ---
titolo "8. Here-String (<<<)"
cmd "grep 'bash' <<< 'utente:x:1001:1001::/home/utente:/bin/bash'"
echo "Calcolo con bc:"
cmd "bc <<< '2^10'"
cmd "bc <<< 'scale=4; 22/7'"

# Pulizia
cd /tmp
rm -rf "$WORKDIR"
echo -e "\n${CIANO}Directory temporanea eliminata.${RESET}"
