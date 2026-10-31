#!/bin/bash
# 03_sed.sh - Trasformare testo e conservare un backup
# Modulo 05. Riferimento: ../03_estrazione_dati.md
# Esecuzione: bash 03_sed.sh
# La preparazione automatica e la trap isolano e ripuliscono i dati di prova.
set -euo pipefail
export LC_ALL=C

directory_esempi=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
directory_lavoro=$(mktemp -d /tmp/lab05_sed.XXXXXX)
trap 'rm -rf -- "$directory_lavoro"' EXIT
cp "$directory_esempi"/dati/* "$directory_lavoro/"
cd "$directory_lavoro"
titolo() { printf '\n--- %s ---\n' "$1"; }

titolo "1. Prima occorrenza e tutte le occorrenze"
echo "gatto gatto" | sed 's/gatto/cane/'
echo "gatto gatto" | sed 's/gatto/cane/g'
# Risultati attesi: cane gatto; cane cane.

titolo "2. Selezionare righe"
sed -n '2,4p' studenti.csv

titolo "3. Eliminare commenti e righe vuote dall'output"
sed -e '/^#/d' -e '/^$/d' servizio.conf
# Risultato atteso: quattro impostazioni; il file originale non cambia.

titolo "4. Inserire e aggiungere righe"
sed '2i\# Indirizzo del server' servizio.conf
sed '3a\timeout=30' servizio.conf

titolo "5. Modificare una copia con backup"
cp servizio.conf servizio_modificato.conf
sed -i.bak 's/^debug=true$/debug=false/' servizio_modificato.conf
printf 'Versione precedente:\n'
cat servizio_modificato.conf.bak
printf 'Versione modificata:\n'
cat servizio_modificato.conf
# La differenza attesa produce stato 1.
diff -u servizio_modificato.conf.bak servizio_modificato.conf || [ "$?" -eq 1 ]
