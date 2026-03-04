#!/bin/bash
# =============================================================================
# 02_archivi.sh
# Modulo 04 - Archiviazione e Compressione
#
# Dimostra tar, gzip, gunzip, bzip2, zip, unzip in azione.
# Usa una directory temporanea per tutti i test.
# Esecuzione: bash 02_archivi.sh
# =============================================================================

CIANO='\033[0;36m'
VERDE='\033[0;32m'
GIALLO='\033[1;33m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }
ok()     { echo -e "${VERDE}OK: $1${RESET}"; }

# Preparazione area di lavoro
WORKDIR=$(mktemp -d /tmp/lab04arch_XXXXX)
cd "$WORKDIR"

titolo "Preparazione file di esempio"
mkdir progetto
echo "# File principale"     > progetto/main.sh
echo "# Config"               > progetto/config.txt
echo "# Log"                  > progetto/app.log
mkdir progetto/dati
echo "record1,100"            > progetto/dati/gennaio.csv
echo "record2,200"            > progetto/dati/febbraio.csv
echo "File creati in: $WORKDIR/progetto"
cmd "find progetto -type f"

# --- tar .tar.gz ---
titolo "1. Creazione archivio tar.gz"
cmd "tar -czvf backup.tar.gz progetto/"
echo "Dimensione dell'archivio:"
cmd "du -sh backup.tar.gz"
ok "Archivio backup.tar.gz creato"

# --- listare contenuto tar ---
titolo "2. Elenco contenuto archivio"
cmd "tar -tzvf backup.tar.gz"

# --- estrarre in nuova directory ---
titolo "3. Estrazione in una directory diversa"
mkdir ripristino
cmd "tar -xzvf backup.tar.gz -C ripristino/"
echo "Contenuto estratto:"
cmd "find ripristino -type f"
ok "Estrazione completata"

# --- estrarre solo un file specifico ---
titolo "4. Estrarre un solo file dall'archivio"
cmd "tar -xzvf backup.tar.gz progetto/config.txt -C /tmp/"
cmd "cat /tmp/progetto/config.txt"

# --- tar .tar.bz2 (più compresso, più lento) ---
titolo "5. Archivio tar.bz2 (migliore compressione)"
cmd "tar -cjvf backup.tar.bz2 progetto/"
echo "Confronto dimensioni:"
cmd "du -sh backup.tar.gz backup.tar.bz2"

# --- gzip su singolo file ---
titolo "6. Compressione gzip su file singolo"
cp progetto/config.txt .
echo "Dimensione originale:"
cmd "du -sh config.txt"
cmd "gzip config.txt"
echo "Dopo gzip (file .txt non esiste più):"
cmd "ls -lh config.txt.gz"
cmd "gunzip config.txt.gz"
echo "Dopo gunzip (ripristino):"
cmd "ls -lh config.txt"

# --- gzip con mantenimento dell'originale ---
titolo "7. gzip -k (mantieni l'originale)"
cmd "gzip -k config.txt"
cmd "ls -lh config.txt config.txt.gz"
rm config.txt.gz

# --- zip ---
titolo "8. Archivio zip (compatibile con Windows)"
if command -v zip &>/dev/null; then
    cmd "zip -r archivio.zip progetto/"
    echo "Dimensione zip:"
    cmd "du -sh archivio.zip"
    mkdir estratto_zip
    cmd "unzip -l archivio.zip"
    cmd "unzip archivio.zip -d estratto_zip/"
    ok "zip/unzip completato"
else
    echo "zip non installato — installa con: sudo apt install zip"
fi

# --- riassunto ---
titolo "9. Riepilogo formati archivio"
echo "Archivi presenti:"
cmd "ls -lh *.tar.gz *.tar.bz2 2>/dev/null; ls -lh *.zip 2>/dev/null || true"

echo "Confronto compressione:"
echo "  .tar.gz  : buona velocità, compatibilità alta"
echo "  .tar.bz2 : compressione migliore, più lento"
echo "  .zip     : nessun tar necessario, compatibile con Windows"

# Pulizia
cd /tmp
rm -rf "$WORKDIR"
echo -e "\n${CIANO}Directory temporanea eliminata.${RESET}"
