#!/bin/bash
# 03_pipe.sh - Pipe, tee e sostituzione di comando
# Modulo 04. Riferimento: ../03_pipe.md
# Esecuzione: bash 03_pipe.sh
# La preparazione automatica e la trap isolano e ripuliscono i dati di prova.
set -euo pipefail
export LC_ALL=C

directory_lavoro=$(mktemp -d /tmp/lab04_pipe.XXXXXX)
trap 'rm -rf -- "$directory_lavoro"' EXIT
cd "$directory_lavoro"
titolo() { printf '\n--- %s ---\n' "$1"; }

echo "Alice" > gruppo_a.txt
echo "Bob" >> gruppo_a.txt
echo "Carlo" > gruppo_b.txt

titolo "1. Due file diventano un solo flusso"
cat gruppo_a.txt gruppo_b.txt | wc -l
# Risultato atteso: 3.

titolo "2. Visualizzare e salvare"
cat gruppo_a.txt gruppo_b.txt | tee iscritti.txt

titolo "3. Salvare i nomi, mostrare soltanto il conteggio"
cat gruppo_a.txt gruppo_b.txt | tee controllo.txt | wc -l

titolo "4. Aggiungere con tee -a"
echo "Diana" | tee -a iscritti.txt
printf 'Righe attese dopo aggiunta: 4. Righe ricevute: '
wc -l < iscritti.txt

titolo "5. Usare il risultato come testo"
totale=$(cat gruppo_a.txt gruppo_b.txt | wc -l)
echo "Iscritti nei due gruppi iniziali: $totale"
echo "Directory corrente: $(pwd)"
