#!/bin/bash
# 01_redirezione.sh - Redirigere i tre canali
# Modulo 04. Riferimento: ../01_redirezione.md
# Esecuzione: bash 01_redirezione.sh
# La preparazione automatica e la trap isolano e ripuliscono i dati di prova.
set -euo pipefail
export LC_ALL=C

directory_lavoro=$(mktemp -d /tmp/lab04_flussi.XXXXXX)
trap 'rm -rf -- "$directory_lavoro"' EXIT
cd "$directory_lavoro"
titolo() { printf '\n--- %s ---\n' "$1"; }

titolo "1. Sovrascrivere, aggiungere, leggere"
echo "prima riga" > note.txt
echo "seconda riga" >> note.txt
cat < note.txt > copia.txt
cat copia.txt
printf 'Righe attese: 2. Righe ricevute: '
wc -l < copia.txt

titolo "2. Separare stdout e stderr"
# Il nome assente provoca un errore intenzionale; il blocco lo gestisce.
if ls note.txt manca.txt > elenco.txt 2> errori.txt; then
    printf 'Tutti i nomi esistono.\n'
else
    printf 'Errore previsto per manca.txt.\n'
fi
printf 'Output normale:\n'
cat elenco.txt
printf 'Diagnostica:\n'
cat errori.txt

titolo "3. Prima stdout sul file, poi stderr sullo stesso canale"
if ls note.txt manca.txt > tutto.txt 2>&1; then
    printf 'Tutti i nomi esistono.\n'
else
    printf 'Risultato ed errore sono stati salvati insieme:\n'
fi
cat tutto.txt

titolo "4. Invertendo le redirezioni, l'errore resta sul terminale"
if ls note.txt manca.txt 2>&1 > solo_output.txt; then
    printf 'Tutti i nomi esistono.\n'
else
    printf 'Il file seguente contiene solo stdout:\n'
fi
cat solo_output.txt

titolo "5. Scartare solo stderr"
if ls note.txt manca.txt 2> /dev/null; then
    printf 'Tutti i nomi esistono.\n'
else
    printf 'Lo stato segnala ancora un errore, anche senza diagnostica.\n'
fi
