#!/bin/bash
# =============================================================================
# 02_gestione_file.sh
# Modulo 03 - Lavorare con File e Cartelle
#
# Dimostra creazione, copia, spostamento, rinomina e cancellazione di file
# e directory. Lavora in una directory temporanea per non toccare il sistema.
# Esecuzione: bash 02_gestione_file.sh
# =============================================================================

VERDE='\033[0;32m'
GIALLO='\033[1;33m'
CIANO='\033[0;36m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }
stato()  { echo -e "${VERDE}[stato]${RESET} Contenuto di $WORKDIR:"; ls -la "$WORKDIR"; echo ""; }

# Crea una directory temporanea di lavoro
WORKDIR=$(mktemp -d /tmp/lab03_XXXXX)
echo "Directory di lavoro temporanea: $WORKDIR"
echo "(verrà eliminata alla fine)"
cd "$WORKDIR"

titolo "1. Creare file con touch ed echo"
cmd "touch file1.txt file2.txt file3.txt"
cmd "echo 'Primo file' > file1.txt"
cmd "echo 'Secondo file' > file2.txt"
cmd "echo -e 'Riga 1\nRiga 2\nRiga 3' > file3.txt"
stato

titolo "2. Creare directory con mkdir"
cmd "mkdir docs immagini script"
cmd "mkdir -p progetto/src progetto/bin progetto/doc"
stato
echo "Struttura progetto:"
cmd "find progetto -type d"

titolo "3. Copiare file con cp"
cmd "cp file1.txt docs/copia_file1.txt"
cmd "cp file2.txt file3.txt docs/"
cmd "cp -r progetto/ backup_progetto/"
stato

titolo "4. Spostare e rinominare con mv"
cmd "mv file2.txt docs/file2_spostato.txt"
cmd "mv file3.txt file3_rinominato.txt"
stato

titolo "5. Globbing: selezionare file con metacaratteri"
echo "Creo altri file per il globbing..."
cmd "touch nota1.txt nota2.txt nota3.txt appunto.txt appunto2.txt"
echo ""
echo "Tutti i .txt:"
cmd "ls *.txt"
echo ""
echo "Solo nota?.txt (un carattere dopo 'nota'):"
cmd "ls nota?.txt"
echo ""
echo "File che iniziano con 'app':"
cmd "ls app*"
echo ""
echo "Brace expansion - crea molti file in un colpo:"
cmd "touch log_{lun,mar,mer,gio,ven}.txt"
cmd "ls log_*.txt"

titolo "6. Link simbolici e hard link"
echo "Hard link:"
cmd "ln file1.txt hard_link_file1.txt"
echo "Stesso inode number (primo campo dopo permessi):"
cmd "ls -li file1.txt hard_link_file1.txt"
echo ""
echo "Link simbolico:"
cmd "ln -s file1.txt symlink_file1.txt"
echo "Il link punta a:"
cmd "ls -la symlink_file1.txt"
cmd "readlink symlink_file1.txt"

titolo "7. Trovare ed eliminare file"
echo "Elimina tutti i .txt che iniziano con 'nota':"
cmd "rm nota*.txt"
echo "Elimina la directory backup:"
cmd "rm -rf backup_progetto/"
stato

titolo "8. Pulizia finale"
cd /tmp
rm -rf "$WORKDIR"
echo "Directory temporanea $WORKDIR eliminata."
echo ""
echo "============================================"
echo "Riepilogo comandi principali:"
echo "  mkdir       → crea directory"
echo "  touch       → crea file vuoto"  
echo "  cp          → copia"
echo "  mv          → sposta/rinomina"
echo "  rm          → elimina (PERMANENTE!)"
echo "  ln          → hard link"
echo "  ln -s       → link simbolico"
echo "  find        → cerca file"
echo "============================================"
