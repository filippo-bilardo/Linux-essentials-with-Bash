#!/bin/bash
# 01_visualizzazione.sh - Leggere, cercare e ordinare
# Modulo 05. Riferimento: ../02_ricerca_filtraggio.md
# Esecuzione: bash 01_visualizzazione.sh
# La preparazione automatica e la trap isolano e ripuliscono i dati di prova.
set -euo pipefail
export LC_ALL=C

directory_esempi=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
directory_lavoro=$(mktemp -d /tmp/lab05_lettura.XXXXXX)
trap 'rm -rf -- "$directory_lavoro"' EXIT
cp "$directory_esempi"/dati/* "$directory_lavoro/"
cd "$directory_lavoro"
titolo() { printf '\n--- %s ---\n' "$1"; }

titolo "1. Ispezionare inizio e fine"
head -n 3 studenti.csv
tail -n 2 studenti.csv
cat -n note.txt
printf 'Righe CSV attese: 8. Righe ricevute: '
wc -l < studenti.csv

titolo "2. Cercare il campo citta"
grep -n ',Roma,' studenti.csv
printf 'Studenti di Roma attesi: 4. Risultato: '
grep -c ',Roma,' studenti.csv
grep -i '^alice,' studenti.csv
grep -E ',(Roma|Milano),' studenti.csv

titolo "3. Raggruppare e contare"
sort visite.txt | uniq -c
# Risultato atteso: Milano 2, Napoli 1, Roma 4.
sort -u visite.txt

titolo "4. Ordinare per eta numerica, senza intestazione"
tail -n +2 studenti.csv | sort -t ',' -k2,2n

titolo "5. Trasformare caratteri"
echo "linux bash" | tr 'a-z' 'A-Z'

titolo "6. Confrontare due versioni"
cp note.txt note_revisionate.txt
echo "Revisione completata." >> note_revisionate.txt
# diff restituisce 1 quando trova differenze: qui e il risultato previsto.
diff -u note.txt note_revisionate.txt || [ "$?" -eq 1 ]
