#!/bin/bash
# =============================================================================
# 03_awk.sh - Estrazione e analisi di dati con awk
# Riferimento: ../05_estrazione_dati.md
# Esecuzione dalla cartella esempi: bash 03_awk.sh
# Requisiti: Bash e awk. I file temporanei vengono eliminati all'uscita.
# =============================================================================

# Abilitazione di opzioni per una gestione più sicura degli errori
set -euo pipefail

# Creazione di una cartella temporanea per i file di lavoro
directory_lavoro=$(mktemp -d /tmp/lab04_awk.XXXXXX)
# Impostazione di un trap per eliminare la cartella temporanea al termine dello script
trap 'rm -rf -- "$directory_lavoro"' EXIT
cd "$directory_lavoro"

# Funzione per stampare un titolo con separatori
titolo() { printf '\n--- %s ---\n' "$1"; }

# Creazione di file di esempio
# CSV semplice: i campi non contengono virgole o valori tra virgolette.
# awk -F ',' divide sui separatori, ma non gestisce un CSV generale.
cat > persone.csv <<'EOF'
nome,eta,citta
Alice,30,Roma
Bob,25,Milano
Carlo,35,Roma
Diana,28,Napoli
Eva,30,Milano
Franco,45,Roma
EOF

# File di esempio con numeri separati da spazi
cat > numeri.txt <<'EOF'
10 2
20 4
30 6
EOF

# --- Inizio esempio awk ---
titolo "1. Dati di partenza"
cat persone.csv

titolo "2. Estrarre nome e citta: -F, \$1 e \$3"
# Sintassi: awk 'pattern { azione }' file
# -F ',' imposta la virgola come separatore; NR>1 salta l'intestazione.
# Le virgolette singole impediscono a Bash di espandere $1 e $3.
awk -F ',' 'NR>1 {print $1, $3}' persone.csv

titolo "3. Numerare le righe: NR e \$0"
# NR e il numero della riga corrente; $0 contiene la riga intera.
awk -F ',' '{print NR ": " $0}' persone.csv

titolo "4. Filtrare con una condizione numerica"
# Risultato atteso: Carlo 35 e Franco 45.
awk -F ',' 'NR>1 && $2>30 {print $1, $2}' persone.csv

titolo "5. Cercare un pattern e selezionare un intervallo"
# /Roma/ cerca il testo in tutta la riga: Alice, Carlo e Franco.
awk '/Roma/' persone.csv
printf '\nSolo le righe da 2 a 4 (Alice, Bob e Carlo):\n'
awk 'NR>=2 && NR<=4' persone.csv

titolo "6. Sommare un campo e contare i record: END"
# END viene eseguito dopo aver letto tutte le righe.
# Risultato atteso: somma 193, persone 6 (intestazione esclusa).
awk -F ',' 'NR>1 {somma += $2} END {print "Somma eta:", somma}' persone.csv
awk 'END {print "Numero persone:", NR-1}' persone.csv

titolo "7. Separatore predefinito: spazi e tabulazioni"
cat numeri.txt
# Senza -F i campi sono separati da sequenze di spazi o tabulazioni.
# Risultato atteso: somma della prima colonna = 60.
awk '{somma += $1} END {print "Somma prima colonna:", somma}' numeri.txt

titolo "8. Pipeline: ordinare le persone per eta crescente"
# awk estrae i campi; sort -k2,2n ordina numericamente il secondo campo.
# Bob e il primo (25), Franco l'ultimo (45).
awk -F ',' 'NR>1 {print $1, $2}' persone.csv | sort -k2,2n

printf '\nFine esempio awk. I file temporanei vengono eliminati.\n'
