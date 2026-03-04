#!/bin/bash
# =============================================================================
# 01_visualizzazione.sh
# Modulo 04 - Visualizzazione e Ricerca nei File
#
# Dimostra cat, head, tail, wc, grep, sort, uniq, cut, awk in azione.
# Crea un file di dati temporaneo su cui lavorare.
# Esecuzione: bash 01_visualizzazione.sh
# =============================================================================

CIANO='\033[0;36m'
GIALLO='\033[1;33m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }

# Crea file di lavoro temporanei
TMPDIR=$(mktemp -d /tmp/lab04_XXXXX)
cd "$TMPDIR"

cat > frutti.txt << 'EOF'
mela
banana
arancia
mela
kiwi
banana
banana
pera
uva
mela
EOF

cat > persone.csv << 'EOF'
nome,eta,citta
Alice,30,Roma
Bob,25,Milano
Carlo,35,Roma
Diana,28,Napoli
Eva,30,Milano
Franco,45,Roma
EOF

cat > numeri.txt << 'EOF'
42
7
100
3
55
7
21
100
8
EOF

echo "File di lavoro creati in $TMPDIR"

# --- cat e head/tail ---
titolo "1. Visualizziamo i file (cat, head, tail)"
echo "Contenuto di frutti.txt:"
cmd "cat frutti.txt"
echo "Prime 3 righe:"
cmd "head -3 frutti.txt"
echo "Ultime 3 righe:"
cmd "tail -3 frutti.txt"
echo "Numero di righe, parole e caratteri (wc):"
cmd "wc frutti.txt"
cmd "wc -l frutti.txt"

# --- grep ---
titolo "2. Cercare con grep"
echo "Righe che contengono 'mela':"
cmd "grep 'mela' frutti.txt"
echo "Righe che NON contengono 'mela':"
cmd "grep -v 'mela' frutti.txt"
echo "Quante righe con 'banana':"
cmd "grep -c 'banana' frutti.txt"
echo "Ricerca case-insensitive:"
cmd "echo 'MELA Mela mela' | grep -i 'mela'"

# --- sort e uniq ---
titolo "3. Ordinare e rimuovere duplicati"
echo "Frutti ordinati:"
cmd "sort frutti.txt"
echo "Frutti unici ordinati:"
cmd "sort frutti.txt | uniq"
echo "Con conteggio delle frequenze:"
cmd "sort frutti.txt | uniq -c | sort -rn"

# --- cut e awk su CSV ---
titolo "4. Estrarre colonne dal CSV"
cmd "cat persone.csv"
echo "Solo i nomi (cut):"
cmd "cut -d ',' -f 1 persone.csv | tail -n +2"
echo "Solo nome e città (cut):"
cmd "cut -d ',' -f 1,3 persone.csv"
echo "Con awk - persone di Roma:"
cmd "awk -F ',' '\$3==\"Roma\"' persone.csv"
echo "Età media (awk):"
cmd "awk -F ',' 'NR>1 {sum+=\$2; n++} END {printf \"Eta media: %.1f\n\", sum/n}' persone.csv"

# --- numeri ---
titolo "5. Elaborazione di numeri"
echo "Numeri ordinati:"
cmd "sort -n numeri.txt"
echo "Numero più grande:"
cmd "sort -n numeri.txt | tail -1"
echo "Numero più piccolo:"
cmd "sort -n numeri.txt | head -1"
echo "Somma di tutti i numeri:"
cmd "awk '{sum+=\$1} END {print \"Somma:\",sum}' numeri.txt"

# --- /etc/passwd ---
titolo "6. Analisi di /etc/passwd"
echo "Primo utente con shell bash:"
cmd "grep 'bash$' /etc/passwd | head -3"
echo "Lista username e shell:"
cmd "cut -d ':' -f 1,7 /etc/passwd | head -10"
echo "Utenti con UID >= 1000:"
cmd "awk -F ':' '\$3>=1000 {print \$1, \"UID:\"\$3}' /etc/passwd"

# Pulizia
cd /tmp
rm -rf "$TMPDIR"
echo -e "\n${CIANO}File temporanei eliminati.${RESET}"
