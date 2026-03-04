#!/bin/bash
# =============================================================================
# 01_usare_la_shell.sh
# Modulo 02 - Utilizzo della Command Line
#
# Dimostra le funzionalità principali della shell Bash:
# scorciatoie, variabili speciali, alias, cronologia e tipi di comandi.
# Esecuzione: bash 01_usare_la_shell.sh
# =============================================================================

echo "============================================="
echo "   Utilizzo Efficace della Shell Bash"
echo "============================================="
echo ""

# --- Identificare la shell ---
echo ">>> Quale shell stiamo usando?"
echo "Shell predefinita dell'utente : $SHELL"
echo "Shell attualmente in uso      : $0"
echo "PID della shell corrente      : $$"
echo ""

# --- Tipi di comandi ---
echo ">>> Tipi di comandi (builtin vs esterni)"
echo ""
for cmd in cd echo pwd ls grep python3 bash; do
    tipo=$(type -t "$cmd" 2>/dev/null || echo "non trovato")
    percorso=$(which "$cmd" 2>/dev/null || echo "n/a")
    printf "  %-10s → tipo: %-10s  percorso: %s\n" "$cmd" "$tipo" "$percorso"
done
echo ""

# --- Exit status ---
echo ">>> Exit status (\$?)"
echo ""
echo "Eseguo: ls /tmp (dovrebbe avere successo)"
ls /tmp > /dev/null 2>&1
echo "Exit status: $?"

echo ""
echo "Eseguo: ls /cartella_inesistente_xyz (dovrebbe fallire)"
ls /cartella_inesistente_xyz > /dev/null 2>&1
echo "Exit status: $?"
echo ""

# --- Variabili speciali ---
echo ">>> Variabili speciali della shell"
echo ""
echo "  \$?  = exit status ultimo comando  → $?"
echo "  \$0  = nome script/shell           → $0"
echo "  \$\$  = PID della shell             → $$"
echo "  \$_  = ultimo argomento            → $_"
echo ""

# --- PATH ---
echo ">>> La variabile PATH"
echo "Contiene ${#PATH} caratteri. Directory cercate nell'ordine:"
echo "$PATH" | tr ':' '\n' | nl
echo ""

# --- Cronologia comandi ---
echo ">>> Cronologia comandi (ultimi 10)"
history | tail -10
echo ""

# --- Alias predefiniti ---
echo ">>> Alias attivi in questa sessione"
alias 2>/dev/null || echo "(nessun alias definito)"
echo ""

echo "============================================="
echo "Suggerimento: prova Ctrl+R per cercare"
echo "nella cronologia dei comandi!"
echo "============================================="
