#!/bin/bash
# 02_heredoc.sh - Heredoc letterali e con espansioni
# Modulo 04. Riferimento: ../02_heredoc.md
# Esecuzione: bash 02_heredoc.sh
# La preparazione automatica e la trap isolano e ripuliscono i dati di prova.
set -euo pipefail
export LC_ALL=C

directory_lavoro=$(mktemp -d /tmp/lab04_heredoc.XXXXXX)
trap 'rm -rf -- "$directory_lavoro"' EXIT
cd "$directory_lavoro"
titolo() { printf '\n--- %s ---\n' "$1"; }

titolo "1. Creare una configurazione letterale"
cat > server.conf <<'CONFIG'
host=localhost
port=8080
directory=$HOME
CONFIG
cat server.conf

titolo "2. Aggiungere senza sovrascrivere"
cat >> server.conf <<'CONFIG'
debug=false
CONFIG
printf 'Righe attese: 4. Righe ricevute: '
wc -l < server.conf

titolo "3. Espandere una variabile e una sostituzione di comando"
nome="Ada"
cat <<REPORT
Studente: $nome
Directory di lavoro: $(pwd)
REPORT

titolo "4. Confrontare con un testo letterale"
cat <<'MODELLO'
Studente: $nome
Directory di lavoro: $(pwd)
MODELLO

titolo "5. Contare le righe ricevute su stdin"
wc -l <<'DATI'
Alice
Bob
Carlo
DATI

titolo "6. Here-string"
cat <<< "Una sola riga"
