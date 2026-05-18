#!/bin/bash
# =============================================================
# 02_awk_sed.sh — awk avanzato, sed, tr, cut, sort, uniq, diff
# =============================================================

CIANO='\033[0;36m'; VERDE='\033[0;32m'; GIALLO='\033[1;33m'; RESET='\033[0m'

titolo() { echo -e "\n${CIANO}══════════════════════════════${RESET}"; echo -e "${CIANO}  $1${RESET}"; echo -e "${CIANO}══════════════════════════════${RESET}"; }
cmd()    { echo -e "${GIALLO}$ $1${RESET}"; eval "$1"; }

# Dati di lavoro
CSV=$(cat <<'EOF'
nome,reparto,stipendio
Alice,IT,3200
Bob,HR,2800
Carlo,IT,3500
Diana,HR,3100
Eva,IT,2950
Franco,Vendite,4200
Giulia,Vendite,3800
EOF
)
echo "$CSV" > /tmp/dipendenti.csv

# ─────────────────────────────────────────
titolo "1. AWK — BEGIN/END e aggregazioni"
# ─────────────────────────────────────────
cmd 'awk -F "," "NR>1 {print \$1, \$3}" /tmp/dipendenti.csv'
echo ""
awk -F ',' '
NR==1 { next }
{
    totale += $3
    count++
    if ($3 > max) { max = $3; top = $1 }
}
END {
    printf "Dipendenti: %d\n", count
    printf "Stipendio medio: %.2f€\n", totale/count
    printf "Stipendio max: %d€ (%s)\n", max, top
}' /tmp/dipendenti.csv

# ─────────────────────────────────────────
titolo "2. AWK — Array associativi"
# ─────────────────────────────────────────
echo -e "${GIALLO}Totale stipendi per reparto:${RESET}"
awk -F ',' '
NR>1 {
    rep[$2] += $3
    cnt[$2]++
}
END {
    printf "%-12s %8s %8s\n", "Reparto", "Totale", "Media"
    printf "%s\n", "----------------------------"
    for (r in rep)
        printf "%-12s %8d %8.0f\n", r, rep[r], rep[r]/cnt[r]
}' /tmp/dipendenti.csv

# ─────────────────────────────────────────
titolo "3. AWK — Filtri e funzioni stringa"
# ─────────────────────────────────────────
cmd 'awk -F "," "NR>1 && \$3>3000 {printf \"%-8s %-10s %d€\n\", \$1, \$2, \$3}" /tmp/dipendenti.csv'
echo ""
cmd 'awk -F "," "NR>1 {print toupper(\$1), \$2}" /tmp/dipendenti.csv'

# ─────────────────────────────────────────
titolo "4. SED — Sostituzioni e trasformazioni"
# ─────────────────────────────────────────
cp /tmp/dipendenti.csv /tmp/dip_test.csv

cmd 'sed "1p;1d" /tmp/dip_test.csv'        # stampa header saltando
echo ""
cmd 'sed "s/IT/InformationTechnology/g" /tmp/dip_test.csv'
echo ""
cmd 'sed "/HR/d" /tmp/dip_test.csv'
echo ""
cmd 'sed "2,4s/,/ | /g" /tmp/dip_test.csv'
echo ""

# Aggiungere intestazione di sezione
sed -i '1i== REPORT DIPENDENTI ==' /tmp/dip_test.csv
sed -i '$a== FINE REPORT ==' /tmp/dip_test.csv
echo -e "${GIALLO}Dopo modifica in-place:${RESET}"
cat /tmp/dip_test.csv

# ─────────────────────────────────────────
titolo "5. TR — Trasformazione caratteri"
# ─────────────────────────────────────────
cmd 'echo "ciao mondo" | tr "a-z" "A-Z"'
cmd 'echo "uno:due:tre:quattro" | tr ":" "\n"'
cmd 'echo "   troppi   spazi   " | tr -s " "'
cmd 'echo "H3ll0 W0rld" | tr -d "0-9"'
cmd 'echo "aabbccddee" | tr -s "a-e"'

# ─────────────────────────────────────────
titolo "6. CUT — Estrazione campi"
# ─────────────────────────────────────────
cmd 'cut -d "," -f 1 /tmp/dipendenti.csv'
echo ""
cmd 'cut -d "," -f 1,3 /tmp/dipendenti.csv'
echo ""
cmd 'cut -d "," -f 2- /tmp/dipendenti.csv'

# ─────────────────────────────────────────
titolo "7. SORT + UNIQ — Statistiche rapide"
# ─────────────────────────────────────────
# Frequenza reparti
echo -e "${GIALLO}Dipendenti per reparto:${RESET}"
cmd 'awk -F "," "NR>1 {print \$2}" /tmp/dipendenti.csv | sort | uniq -c | sort -rn'
echo ""

# Lista stipendi ordinata
echo -e "${GIALLO}Stipendi ordinati (decrescente):${RESET}"
cmd 'awk -F "," "NR>1 {print \$3, \$1}" /tmp/dipendenti.csv | sort -rn'

# ─────────────────────────────────────────
titolo "8. DIFF — Confronto file"
# ─────────────────────────────────────────
cat > /tmp/v1.conf <<'EOF'
# Config v1
host=localhost
port=8080
debug=true
timeout=30
EOF

cat > /tmp/v2.conf <<'EOF'
# Config v2
host=production.server.it
port=443
debug=false
timeout=60
max_conn=100
EOF

echo -e "${GIALLO}diff normale:${RESET}"
diff /tmp/v1.conf /tmp/v2.conf
echo ""
echo -e "${GIALLO}diff -u (unified):${RESET}"
diff -u /tmp/v1.conf /tmp/v2.conf

# Cleanup
rm -f /tmp/dipendenti.csv /tmp/dip_test.csv /tmp/v1.conf /tmp/v2.conf

echo -e "\n${VERDE}Fine demo 02_awk_sed.sh${RESET}"
