#!/bin/bash
# =============================================================================
# 01_comandi_informativi.sh
# Modulo 01 - Introduzione al s.o. Linux
#
# Mostra informazioni sul sistema Linux corrente usando i comandi base.
# Esecuzione: bash 01_comandi_informativi.sh
# =============================================================================

echo "============================================="
echo "   Informazioni sul Sistema Linux"
echo "============================================="
echo ""

# --- Utente corrente ---
echo ">>> Chi sono?"
echo "Username:   $(whoami)"
echo "ID utente:  $(id -u)"
echo "Gruppi:     $(groups)"
echo ""

# --- Hostname ---
echo ">>> Nome del computer:"
echo "Hostname:   $(hostname)"
echo "FQDN:       $(hostname -f 2>/dev/null || echo 'non disponibile')"
echo ""

# --- Sistema operativo ---
echo ">>> Sistema Operativo:"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Distribuzione: $PRETTY_NAME"
fi
echo ""

# --- Kernel ---
echo ">>> Kernel Linux:"
uname -a
echo ""
echo "Versione kernel: $(uname -r)"
echo "Architettura:    $(uname -m)"
echo ""

# --- Data e ora ---
echo ">>> Data e Ora:"
date
echo ""

# --- Uptime ---
echo ">>> Da quanto è acceso il sistema:"
uptime -p 2>/dev/null || uptime
echo ""

# --- Memoria RAM ---
echo ">>> Memoria RAM:"
free -h
echo ""

# --- CPU ---
echo ">>> Processore:"
lscpu | grep -E "^(Model name|Architecture|CPU\(s\)|Thread)"
echo ""

# --- Spazio su disco ---
echo ">>> Spazio su disco:"
df -h | grep -v "tmpfs\|udev"
echo ""

echo "============================================="
echo "Fine delle informazioni di sistema."
echo "============================================="
