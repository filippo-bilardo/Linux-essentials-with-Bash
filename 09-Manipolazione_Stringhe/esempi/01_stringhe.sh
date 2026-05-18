#!/bin/bash
# =============================================================
# 01_stringhe.sh — Manipolazione stringhe in Bash e grep
# =============================================================

CIANO='\033[0;36m'; VERDE='\033[0;32m'; GIALLO='\033[1;33m'; RESET='\033[0m'

titolo() { echo -e "\n${CIANO}══════════════════════════════${RESET}"; echo -e "${CIANO}  $1${RESET}"; echo -e "${CIANO}══════════════════════════════${RESET}"; }
cmd()    { echo -e "${GIALLO}$ $1${RESET}"; eval "$1"; }

# ─────────────────────────────────────────
titolo "1. LUNGHEZZA E ACCESSO"
# ─────────────────────────────────────────
frase="Hello, Bash World!"
cmd 'echo "Stringa: $frase"'
cmd 'echo "Lunghezza: ${#frase}"'
cmd 'echo "Caratteri 0-4: ${frase:0:5}"'
cmd 'echo "Dal char 7: ${frase:7}"'
cmd 'echo "Ultimi 6 char: ${frase: -6}"'

# ─────────────────────────────────────────
titolo "2. SOSTITUZIONE"
# ─────────────────────────────────────────
testo="Il gatto e il gatto grasso"
cmd 'echo "$testo"'
cmd 'echo "Prima occ.: ${testo/gatto/cane}"'
cmd 'echo "Tutte le occ.: ${testo//gatto/cane}"'
cmd 'echo "Maiuscolo: ${testo^^}"'
cmd 'echo "Minuscolo: ${testo,,}"'
cmd 'echo "Prima lettera maius: ${testo^}"'

# ─────────────────────────────────────────
titolo "3. RIMOZIONE DI PREFISSI E SUFFISSI"
# ─────────────────────────────────────────
percorso="/home/user/documenti/report.txt"
cmd 'echo "Percorso: $percorso"'
cmd 'echo "Nome file (##*/): ${percorso##*/}"'
cmd 'echo "Directory (#*/): ${percorso%/*}"'
cmd 'echo "Senza estensione (%.): ${percorso%.*}"'
cmd 'echo "Solo estensione: ${percorso##*.}"'

versione="v2.3.1-beta"
cmd 'echo "Rimuovi prefisso v: ${versione#v}"'
cmd 'echo "Rimuovi suffisso -beta: ${versione%-*}"'

# ─────────────────────────────────────────
titolo "4. VALORI DI DEFAULT"
# ─────────────────────────────────────────
cmd 'nome=""; echo "Default se vuoto: ${nome:-Anonimo}"'
cmd 'unset cfg; echo "Default se non definito: ${cfg:-/etc/default.conf}"'
cmd 'user="Alice"; echo "Alternativo se definito: ${user:+[${user}]}"'

# ─────────────────────────────────────────
titolo "5. SPLIT CON IFS"
# ─────────────────────────────────────────
csv="mela,pera,banana,kiwi"
cmd 'echo "CSV: $csv"'

IFS=',' read -ra frutti <<< "$csv"
echo -e "${GIALLO}$ IFS=',' read -ra frutti <<< \"\$csv\"${RESET}"
echo "Numero di frutti: ${#frutti[@]}"
for f in "${frutti[@]}"; do
    echo "  - $f"
done

# ─────────────────────────────────────────
titolo "6. GREP — RICERCA IN TESTO"
# ─────────────────────────────────────────
DATI=$(cat <<'EOF'
mario.rossi@email.it - età: 32 - ruolo: admin
anna.bianchi@azienda.com - età: 28 - ruolo: user
carlo123@test.org - età: 45 - ruolo: admin
guest@demo.net - età: N/A - ruolo: guest
EOF
)

echo "$DATI" > /tmp/utenti.txt

cmd 'grep "admin" /tmp/utenti.txt'
echo ""
cmd 'grep -v "admin" /tmp/utenti.txt'
echo ""
cmd 'grep -c "admin" /tmp/utenti.txt'
echo ""
cmd 'grep -n "age" /tmp/utenti.txt'
echo ""
cmd 'grep -E "[a-z]+\.[a-z]+@" /tmp/utenti.txt'
echo ""
cmd 'grep -oE "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" /tmp/utenti.txt'
echo ""
cmd 'grep -E "\betà: [0-9]+\b" /tmp/utenti.txt'

rm /tmp/utenti.txt

echo -e "\n${VERDE}Fine demo 01_stringhe.sh${RESET}"
