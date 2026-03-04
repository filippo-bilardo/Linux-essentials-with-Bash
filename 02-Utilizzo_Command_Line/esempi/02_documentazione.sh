#!/bin/bash
# =============================================================================
# 02_documentazione.sh
# Modulo 02 - Utilizzo della Command Line
#
# Mostra come usare gli strumenti di documentazione integrati di Linux:
# man, --help, whatis, apropos, type, which, whereis.
# Esecuzione: bash 02_documentazione.sh
# =============================================================================

# Colori
VERDE='\033[0;32m'
GIALLO='\033[1;33m'
CIANO='\033[0;36m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}=== $1 ===${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }

clear
echo -e "${VERDE}Strumenti di Documentazione in Linux${RESET}"
echo "Questo script mostra come trovare aiuto per qualsiasi comando."
echo ""

# --- whatis ---
titolo "1. whatis — descrizione in una riga"
echo "Sintassi: whatis <comando>"
echo ""
for c in ls cp grep find tar ssh; do
    printf "  %-8s → " "$c"
    whatis "$c" 2>/dev/null | head -1 | sed 's/^[^ ]* //' || echo "(non disponibile)"
done

# --- type ---
titolo "2. type — che tipo di comando è?"
echo "Sintassi: type <comando>"
echo ""
cmd "type ls"
cmd "type cd"
cmd "type echo"
cmd "type -a python3 2>/dev/null || echo '(python3 non installato)'"

# --- which / whereis ---
titolo "3. which e whereis — dove si trova il comando?"
echo "Sintassi: which <comando>  |  whereis <comando>"
echo ""
cmd "which bash"
cmd "which ls"
cmd "whereis grep"

# --- --help ---
titolo "4. --help — aiuto rapido del comando"
echo "Sintassi: <comando> --help"
echo "Esempio: ls --help (prima 15 righe)"
echo ""
ls --help 2>&1 | head -15
echo "..."

# --- apropos ---
titolo "5. apropos — cerca per parola chiave nel manuale"
echo "Sintassi: apropos <parola>   (equivalente a: man -k <parola>)"
echo ""
echo "Ricerca di comandi relativi a 'compress':"
apropos compress 2>/dev/null | head -8 || echo "(database man non aggiornato, esegui: sudo mandb)"

# --- man: sezione SYNOPSIS ---
titolo "6. Leggere la SYNOPSIS di una man page"
echo "La sezione SYNOPSIS usa questa notazione:"
echo ""
echo "  [elemento]   → opzionale"
echo "  elemento     → obbligatorio"
echo "  ...          → ripetibile"
echo "  a | b        → alternativa"
echo ""
echo "Esempio — SYNOPSIS di 'cp':"
man cp 2>/dev/null | grep -A 10 "^SYNOPSIS" | head -12 || \
    echo "cp SOURCE DEST | cp [OPTION]... SOURCE... DIRECTORY"

# --- tldr (opzionale) ---
titolo "7. tldr — riassunti pratici (se installato)"
if command -v tldr &>/dev/null; then
    tldr ls
else
    echo "tldr non è installato. Per installarlo:"
    echo "  sudo apt install tldr"
    echo "  oppure: pip install tldr"
    echo ""
    echo "Dopo l'installazione, prova: tldr tar"
fi

echo ""
echo -e "${VERDE}Riepilogo strumenti:${RESET}"
echo "  man <cmd>       → documentazione completa"
echo "  <cmd> --help    → riepilogo rapido"
echo "  whatis <cmd>    → una riga di descrizione"
echo "  apropos <keyword> → cerca nel manuale"
echo "  type <cmd>      → tipo del comando"
echo "  which <cmd>     → percorso dell'eseguibile"
echo "  tldr <cmd>      → esempi pratici (se installato)"
echo ""
