#!/bin/bash
# =============================================================================
# 04_sed.sh - Sostituzioni e trasformazioni di testo con sed
# Riferimento: ../05_estrazione_dati.md
# Esecuzione dalla cartella esempi: bash 04_sed.sh
# Requisiti: Bash e sed (su Linux). Tutti i file usati sono temporanei.
# =============================================================================

# Abilitazione di opzioni per una gestione più sicura degli errori
set -euo pipefail

# Creazione di una cartella temporanea per i file di lavoro
directory_lavoro=$(mktemp -d /tmp/lab04_sed.XXXXXX)
# Impostazione di un trap per eliminare la cartella temporanea al termine dello script
trap 'rm -rf -- "$directory_lavoro"' EXIT
cd "$directory_lavoro"

# Funzione per stampare un titolo con separatori
titolo() { printf '\n--- %s ---\n' "$1"; }

# Creazione di file di esempio
cat > animali.txt <<'EOF'
Il gatto segue un gatto.
Un gatto dorme.
EOF

# Creazione di un file di configurazione di esempio
cat > servizio.conf <<'EOF'
# Configurazione di esempio
host=localhost
port=8080

# Opzioni di debug
debug=true
EOF

# --- Inizio esempio sed ---
titolo "1. Testo di partenza"
cat animali.txt

titolo "2. Sostituire la prima occorrenza per riga"
# s/vecchio/nuovo/ modifica solo la prima corrispondenza di ogni riga.
# Prima riga attesa: Il cane segue un gatto.
sed 's/gatto/cane/' animali.txt

titolo "3. Sostituire tutte le occorrenze: flag g"
# Prima riga attesa: Il cane segue un cane.
sed 's/gatto/cane/g' animali.txt

titolo "4. Sostituire solo la seconda occorrenza per riga"
# Prima riga attesa: Il gatto segue un cane.
# La seconda riga non cambia: contiene una sola occorrenza.
sed 's/gatto/cane/2' animali.txt

titolo "5. Senza -i il file originale rimane invariato"
cat animali.txt

titolo "6. Eliminare commenti e righe vuote"
printf 'Configurazione originale:\n'
cat servizio.conf
printf '\nConfigurazione filtrata:\n'
# ^# identifica i commenti a inizio riga; ^$ identifica le righe vuote.
# d elimina le righe dall'output; -e combina piu comandi sed.
sed -e '/^#/d' -e '/^$/d' servizio.conf

titolo "7. Stampare righe specifiche: -n e p"
# -n disattiva la stampa automatica; p stampa le righe selezionate.
printf 'Righe da 2 a 3 (host e port):\n'
sed -n '2,3p' servizio.conf
printf '\nRighe che contengono debug=true:\n'
sed -n '/debug=true/p' servizio.conf

titolo "8. Inserire e aggiungere testo: i e a"
# i inserisce prima della riga indicata; a aggiunge dopo.
# Sono due dimostrazioni indipendenti sullo stesso file originale.
printf 'Inserimento prima della riga 2:\n'
sed '2i\# Indirizzo del server' servizio.conf
printf '\nAggiunta dopo la riga 3:\n'
sed '3a\timeout=30' servizio.conf

titolo "9. Modificare un file con backup: -i.bak"
# Lavoriamo su una copia temporanea. -i.bak salva la versione precedente
# in servizio_modificato.conf.bak e modifica servizio_modificato.conf.
cp servizio.conf servizio_modificato.conf
sed -i.bak 's/debug=true/debug=false/g' servizio_modificato.conf
printf 'File modificato (debug=false):\n'
cat servizio_modificato.conf
printf '\nBackup precedente alla modifica (debug=true):\n'
cat servizio_modificato.conf.bak

printf '\nFine esempio sed. I file temporanei vengono eliminati.\n'
