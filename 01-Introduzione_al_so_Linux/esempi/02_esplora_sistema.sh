#!/bin/bash
# =============================================================================
# 02_esplora_sistema.sh
# Modulo 01 - Introduzione al s.o. Linux
#
# Script interattivo che guida l'utente nell'esplorazione del sistema Linux.
# Esecuzione: bash 02_esplora_sistema.sh
# =============================================================================

# Colori per l'output
VERDE='\033[0;32m'
GIALLO='\033[1;33m'
CIANO='\033[0;36m'
RESET='\033[0m'

titolo() {
    echo ""
    echo -e "${CIANO}========================================${RESET}"
    echo -e "${CIANO}  $1${RESET}"
    echo -e "${CIANO}========================================${RESET}"
}

info() {
    echo -e "${VERDE}[+]${RESET} $1"
}

pausa() {
    echo ""
    read -p "Premi INVIO per continuare..." _
    clear
}

clear
echo -e "${GIALLO}"
echo "  _     _                  ______                  _   _       _      "
echo " | |   (_)                |  ____|                | | (_)     | |     "
echo " | |    _ _ __  _   ___  _| |__  ___  ___ ___ _ __| |_ _  __ _| |___  "
echo " | |   | | '_ \| | | \ \/ /  __/ ___/ __/ _ \' _\ | __| |/ _\` | / __| "
echo " | |___| | | | | |_| |>  <| |__\__ \__ \  __/ | | | |_| | (_| | \__ \ "
echo " |_____|_|_| |_|\__,_/_/\_\____/___/___/\___|_| |_|\__|_|\__,_|_|___/ "
echo -e "${RESET}"
echo "  Benvenuto nel tour di esplorazione del tuo sistema Linux!"
pausa

# --- Passo 1: Chi sei? ---
titolo "Passo 1: Chi sei tu in questo sistema?"
info "Comando: whoami"
echo ""
whoami
echo ""
info "Comando: id"
echo ""
id
echo ""
info "La tua home directory è: $HOME"
info "La tua shell predefinita è: $SHELL"
pausa

# --- Passo 2: Che sistema stai usando? ---
titolo "Passo 2: Che sistema stai usando?"
info "Distribuzione Linux:"
if [ -f /etc/os-release ]; then
    cat /etc/os-release | grep -E "^(NAME|VERSION|ID|PRETTY)" | sed 's/^/    /'
fi
echo ""
info "Versione del kernel (uname -r):"
echo "    $(uname -r)"
echo ""
info "Architettura CPU (uname -m):"
echo "    $(uname -m)"
pausa

# --- Passo 3: Risorse hardware ---
titolo "Passo 3: Le risorse hardware del sistema"
info "Memoria RAM disponibile (free -h):"
free -h
echo ""
info "Spazio sui dischi (df -h):"
df -h --output=source,size,used,avail,pcent,target 2>/dev/null | \
    grep -v "tmpfs\|udev\|loop" | head -10
pausa

# --- Passo 4: Processi in esecuzione ---
titolo "Passo 4: I 10 processi più attivi"
info "Comando: ps aux --sort=-%cpu | head -11"
echo ""
ps aux --sort=-%cpu | head -11
pausa

# --- Passo 5: La struttura del filesystem ---
titolo "Passo 5: Esploriamo il filesystem"
info "Le directory principali nella radice /:"
echo ""
ls -la / | grep "^d"
echo ""
info "Cosa contiene la tua home directory?"
ls -la ~
pausa

# --- Passo 6: Variabili d'ambiente ---
titolo "Passo 6: Le variabili d'ambiente principali"
info "Alcune variabili d'ambiente importanti:"
echo ""
echo "    HOME    = $HOME"
echo "    USER    = $USER"
echo "    SHELL   = $SHELL"
echo "    PATH    = $PATH" | fold -w 70 -s
echo "    LANG    = $LANG"
echo "    TERM    = $TERM"
pausa

# --- Fine ---
clear
echo -e "${VERDE}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║   Tour completato! Ottimo lavoro!    ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${RESET}"
echo ""
echo "Hai esplorato:"
echo "  ✓ Identità utente e permessi"
echo "  ✓ Distribuzione e kernel Linux"
echo "  ✓ Risorse hardware (RAM, disco, CPU)"
echo "  ✓ Processi in esecuzione"
echo "  ✓ Struttura del filesystem"
echo "  ✓ Variabili d'ambiente"
echo ""
echo "Prossimo passo: studia la guida sulla riga di comando!"
echo ""
