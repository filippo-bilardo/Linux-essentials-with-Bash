#!/bin/bash
# 02_awk.sh - Campi, condizioni e calcoli con awk
# Modulo 05. Riferimento: ../03_estrazione_dati.md
# Esecuzione: bash 02_awk.sh
# La preparazione automatica e la trap isolano e ripuliscono i dati di prova.
set -euo pipefail
export LC_ALL=C

directory_esempi=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
directory_lavoro=$(mktemp -d /tmp/lab05_awk.XXXXXX)
trap 'rm -rf -- "$directory_lavoro"' EXIT
cp "$directory_esempi"/dati/* "$directory_lavoro/"
cd "$directory_lavoro"
titolo() { printf '\n--- %s ---\n' "$1"; }

titolo "1. Dati iniziali"
cat studenti.csv
# CSV semplice: nessun campo contiene virgole o valori tra virgolette.

titolo "2. Separatore, campi e intestazione"
# Le virgolette singole impediscono a Bash di espandere $1 e $3.
awk -F ',' 'NR>1 {print $1, $3}' studenti.csv

titolo "3. Numerare righe e selezionare un intervallo"
awk 'NR>=2 && NR<=4 {print NR, $0}' studenti.csv

titolo "4. Condizioni sui campi"
# Risultato atteso: Franco 20, Giulia 22.
awk -F ',' 'NR>1 && $3=="Roma" && $2>=20 {print $1, $2}' studenti.csv

titolo "5. Accumulare e riepilogare con END"
# Risultato atteso: 7 studenti, somma 138, media 19.7.
awk -F ',' '
NR>1 {somma += $2; n++}
END {
    print "Studenti:", n
    print "Somma eta:", somma
    printf "Eta media: %.1f\n", somma/n
}' studenti.csv

titolo "6. Campi senza -F: spazi e tabulazioni"
echo "10 2" > numeri.txt
echo "20 4" >> numeri.txt
echo "30 6" >> numeri.txt
awk '{somma += $1} END {print "Somma prima colonna:", somma}' numeri.txt
# Risultato atteso: 60.
