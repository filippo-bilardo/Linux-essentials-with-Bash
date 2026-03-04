#!/bin/bash
# =============================================================================
# 01_navigazione.sh
# Modulo 03 - Lavorare con File e Cartelle
#
# Dimostra la navigazione del filesystem Linux: pwd, ls, cd, percorsi.
# Esecuzione: bash 01_navigazione.sh
# =============================================================================

CIANO='\033[0;36m'
GIALLO='\033[1;33m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }

clear
echo "Modulo 03 — Navigazione del Filesystem Linux"
echo "============================================="

titolo "1. Dove mi trovo?"
cmd "pwd"

titolo "2. Lista directory corrente"
cmd "ls ~"
echo "Con dettagli (ls -la):"
cmd "ls -la ~ | head -15"

titolo "3. Le directory principali del filesystem"
cmd "ls -la /"

titolo "4. Percorso assoluto vs relativo"
echo "Percorso assoluto: inizia con /"
cmd "ls /home"
echo "Percorso relativo: parte dalla directory corrente"
echo "  '..' = su di un livello"
echo "  '.'  = directory corrente"
echo "  '~'  = home dell'utente"
echo ""

titolo "5. I simboli speciali: . .. ~ -"
echo "Directory corrente:"
cmd "pwd"
echo "Salgo di un livello (..):"
cmd "cd .. && pwd && cd -"
echo "Vado alla home (~):"
cmd "cd ~ && pwd && cd -"

titolo "6. Esploro le directory di sistema importanti"
echo "/etc (configurazioni):"
cmd "ls /etc | head -10"
echo "/var/log (log di sistema):"
cmd "ls /var/log | head -10"
echo "/proc (informazioni sistema - virtuale):"
cmd "ls /proc | head -20"

titolo "7. Tipi di file con ls -la"
echo "Il primo carattere indica il tipo:"
echo "  d = directory, - = file, l = link simbolico"
cmd "ls -la /dev | head -15"

titolo "8. Trovare file con find"
echo "File .conf in /etc:"
cmd "find /etc -name '*.conf' -maxdepth 1 | head -10"
echo ""
echo "Directory nella home:"
cmd "find ~ -maxdepth 1 -type d"

titolo "9. Dimensioni con du"
cmd "du -sh /var/log"
cmd "du -sh /etc"
cmd "du -h --max-depth=1 /var | sort -h | tail -10"

echo "============================================="
echo "Fine dimostrazione navigazione filesystem."
