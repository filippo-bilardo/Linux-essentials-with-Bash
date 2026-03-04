#!/bin/bash
# =============================================================================
# 01_primi_script.sh
# Modulo 06 - I Fondamenti dello Scripting Bash
#
# Dimostra: shebang, variabili, parametri, read, exit status, printf.
# Esecuzione: bash 01_primi_script.sh
# =============================================================================

CIANO='\033[0;36m'
GIALLO='\033[1;33m'
VERDE='\033[0;32m'
ROSSO='\033[0;31m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }

# --- variabili scalari ---
titolo "1. Variabili scalari"
nome="Alice"
eta=25
citta="Roma"
echo "Nome: $nome"
echo "Età: $eta"
echo "Città: ${citta}!"        # graffe per delimitare

echo ""
echo "Senza virgolette (pericoloso con spazi):"
percorso_sicuro="/home/utente"
echo $percorso_sicuro

percorso_spazi="/home/utente con spazi"
echo "Con spazio nel valore:"
for parola in $percorso_spazi; do  # senza "" si spacca!
    echo "  > $parola"
done
echo "Con virgolette:"
for parola in "$percorso_spazi"; do  # con "" è un argomento solo
    echo "  > $parola"
done

# --- operazioni su stringhe ---
titolo "2. Operazioni sulle variabili"
file="documento.txt"
echo "Valore originale: $file"
echo "Senza estensione: ${file%.txt}"
echo "Sostituzione: ${file/.txt/.md}"
echo "Lunghezza: ${#file} caratteri"
echo "Maiuscolo: ${file^^}"
echo "Sottostringa [0:3]: ${file:0:3}"
echo "Default se vuoto: ${non_esiste:-'valore_default'}"

# --- variabili speciali ---
titolo "3. Variabili speciali"
echo "Script: $0"
echo "PID corrente: $$"
echo "Argomenti passati: $#"
echo "Lista argomenti: $@"

ls /etc/hosts > /dev/null 2>&1
echo "Exit status di 'ls /etc/hosts': $?"
ls /inesistente > /dev/null 2>&1
echo "Exit status di 'ls /inesistente': $?"

# --- variabili d'ambiente ---
titolo "4. Variabili d'ambiente"
echo "HOME    = $HOME"
echo "USER    = $USER"
echo "SHELL   = $SHELL"
echo "PWD     = $PWD"
echo "PATH (prime 3 voci):"
echo "$PATH" | tr ':' '\n' | head -3

# Esportare una variabile locale
MIA_VAR="valore_locale"
export MIA_VAR
echo "MIA_VAR esportata: $MIA_VAR"
echo "Verifica con env:"
env | grep MIA_VAR

# --- printf ---
titolo "5. Formattazione con printf"
printf "%-15s %5s %10s\n" "NOME" "ETÀ" "CITTÀ"
printf "%-15s %5d %10s\n" "Alice" 25 "Roma"
printf "%-15s %5d %10s\n" "Bob" 30 "Milano"
printf "%-15s %5d %10s\n" "Carlo" 22 "Napoli"
echo ""
printf "Pi greco: %.6f\n" 3.14159265358979
printf "In hex: %x  In ottale: %o\n" 255 255

# --- exit status e controllo errori ---
titolo "6. Exit status"
controlla_dir() {
    local dir="$1"
    if ls "$dir" > /dev/null 2>&1; then
        echo "  [OK] '$dir' accessibile (exit 0)"
    else
        echo "  [ERR] '$dir' non accessibile (exit $?)"
    fi
}

controlla_dir "/etc"
controlla_dir "/root"
controlla_dir "/inesistente"

# --- sostituzione di comando ---
titolo "7. Sostituzione di comando \$()"
data=$(date '+%d/%m/%Y %H:%M')
utente=$(whoami)
n_file=$(ls /etc | wc -l)
kernel=$(uname -r)

echo "Data: $data"
echo "Utente: $utente"
echo "File in /etc: $n_file"
echo "Kernel: $kernel"

archivio="log_${utente}_$(date '+%Y%m%d').tar.gz"
echo "Nome archivio generato: $archivio"

echo -e "\n${VERDE}Demo completata!${RESET}"
