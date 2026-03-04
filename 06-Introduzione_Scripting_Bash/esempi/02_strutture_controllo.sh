#!/bin/bash
# =============================================================================
# 02_strutture_controllo.sh
# Modulo 06 - Strutture di Controllo
#
# Dimostra: if/elif/else, [[ ]], for, while, case, break, continue.
# Esecuzione: bash 02_strutture_controllo.sh
# =============================================================================

CIANO='\033[0;36m'
GIALLO='\033[1;33m'
VERDE='\033[0;32m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }

# --- if con test su file ---
titolo "1. if — test su file"
for percorso in /etc/hosts /etc /inesistente; do
    if [[ -f "$percorso" ]]; then
        echo "  $percorso  → file regolare"
    elif [[ -d "$percorso" ]]; then
        echo "  $percorso  → directory"
    else
        echo "  $percorso  → non esiste"
    fi
done

# --- if con test numerici ---
titolo "2. if — confronto numeri"
for eta in 10 17 18 30 66; do
    if [[ $eta -lt 18 ]]; then
        cat="minorenne"
    elif [[ $eta -le 65 ]]; then
        cat="adulto"
    else
        cat="pensionato"
    fi
    echo "  Età $eta → $cat"
done

# --- if con stringhe ---
titolo "3. if — confronto stringhe e regex"
nomi=("alice" "Bob" "CARLO" "123" "mario_rossi")
for n in "${nomi[@]}"; do
    if [[ $n =~ ^[a-z]+$ ]]; then
        echo "  '$n' → tutto minuscolo"
    elif [[ $n =~ ^[A-Z][a-z]*$ ]]; then
        echo "  '$n' → capitalizzato"
    elif [[ $n =~ ^[0-9]+$ ]]; then
        echo "  '$n' → numero"
    else
        echo "  '$n' → formato misto"
    fi
done

# --- for su lista e range ---
titolo "4. for — lista e range"
echo "Frutti:"
for f in mela banana arancia kiwi pere; do
    printf "  • %s\n" "$f"
done

echo ""
echo "Numeri pari da 2 a 10:"
for i in {2..10..2}; do
    printf "%3d " $i
done
echo ""

echo ""
echo "Tabellina del 7:"
for ((i=1; i<=10; i++)); do
    printf "  7 × %2d = %2d\n" $i $((7*i))
done

# --- for su file e output ---
titolo "5. for — iterare su file con glob"
TMPDIR=$(mktemp -d)
touch "$TMPDIR"/{a,b,c}.txt "$TMPDIR"/{x,y}.sh
echo "File creati in $TMPDIR:"

for f in "$TMPDIR"/*.txt; do
    echo "  [TXT] $(basename $f)"
done
for f in "$TMPDIR"/*.sh; do
    echo "  [SH]  $(basename $f)"
done
rm -rf "$TMPDIR"

# --- while con contatore ---
titolo "6. while — conto alla rovescia"
n=5
while [[ $n -gt 0 ]]; do
    printf "\r  Lancio tra $n secondi...  "
    sleep 0.3
    ((n--))
done
echo -e "\r  Decollo!                    "

# --- while legge file riga per riga ---
titolo "7. while read — elaborare file CSV"
cat > /tmp/lab06_dati.csv << 'EOF'
nome,voto,materia
Alice,9,Linux
Bob,7,Linux
Carlo,8,Bash
Diana,10,Bash
Eva,6,Linux
EOF

echo "Studenti con voto >= 8:"
printf "  %-10s %-5s %s\n" "NOME" "VOTO" "MATERIA"
printf "  %-10s %-5s %s\n" "----" "----" "-------"
while IFS=',' read -r nome voto materia; do
    [[ $nome == "nome" ]] && continue   # salta intestazione
    if [[ $voto -ge 8 ]]; then
        printf "  %-10s %-5s %s\n" "$nome" "$voto" "$materia"
    fi
done < /tmp/lab06_dati.csv
rm /tmp/lab06_dati.csv

# --- break e continue ---
titolo "8. break e continue"
echo "Numeri da 1 a 10, salto i multipli di 3, mi fermo a 8:"
for i in {1..10}; do
    if [[ $((i % 3)) -eq 0 ]]; then
        continue
    fi
    if [[ $i -gt 8 ]]; then
        break
    fi
    printf "%d " $i
done
echo ""

# --- case con menu ---
titolo "9. case — classificatore"
comandi=(ls cd echo mkdir rm cp mv grep find chmod)
for c in "${comandi[@]}"; do
    case $c in
        ls|ll)        tipo="navigazione" ;;
        cd|pwd|mkdir) tipo="filesystem" ;;
        cp|mv|rm)     tipo="gestione file" ;;
        grep|find)    tipo="ricerca" ;;
        chmod|chown)  tipo="permessi" ;;
        *)            tipo="vario" ;;
    esac
    printf "  %-8s → %s\n" "$c" "$tipo"
done

echo -e "\n${VERDE}Demo completata!${RESET}"
