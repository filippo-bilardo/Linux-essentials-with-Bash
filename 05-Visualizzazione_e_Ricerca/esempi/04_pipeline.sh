#!/bin/bash
# 04_pipeline.sh - Comporre i filtri e passare nomi a xargs
# Modulo 05. Riferimento: ../04_pipeline_e_xargs.md
# Esecuzione: bash 04_pipeline.sh
# La preparazione automatica e la trap isolano e ripuliscono i dati di prova.
set -euo pipefail
export LC_ALL=C

directory_esempi=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
directory_lavoro=$(mktemp -d /tmp/lab05_pipeline.XXXXXX)
trap 'rm -rf -- "$directory_lavoro"' EXIT
cp "$directory_esempi"/dati/* "$directory_lavoro/"
cd "$directory_lavoro"
titolo() { printf '\n--- %s ---\n' "$1"; }

titolo "1. Frequenze delle citta"
tail -n +2 studenti.csv | cut -d ',' -f 3 | sort | uniq -c | sort -nr | tee frequenze.txt
# Risultato atteso: Roma 4, Milano 2, Napoli 1.

titolo "2. Filtrare e ordinare campi"
awk -F ',' 'NR>1 && $3=="Roma" && $2>=20 {print $1, $2}' studenti.csv | sort -k2,2nr
# Risultato atteso: Giulia 22, Franco 20.

titolo "3. Due studenti con eta maggiore"
tail -n +2 studenti.csv | sort -t ',' -k2,2nr | head -n 2
# Risultato atteso: Giulia, Diana.

titolo "4. Salvare la configurazione pulita e contare"
sed -e '/^#/d' -e '/^$/d' servizio.conf | tee configurazione_pulita.conf | wc -l
# Risultato atteso: 4.

titolo "5. Approfondimento: xargs e nomi con spazi"
mkdir documenti copie
touch "documenti/relazione finale.txt" "documenti/appunti.txt"
find documenti -type f -name '*.txt' -print0 | xargs -0 -r -I {} cp -- "{}" copie/
find copie -type f
# Devono comparire due file, incluso relazione finale.txt.
