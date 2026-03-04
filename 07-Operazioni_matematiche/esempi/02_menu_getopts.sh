#!/bin/bash
# =============================================================================
# 02_menu_getopts.sh
# Modulo 07 - Colori ANSI, select, case e getopts
#
# Dimostra: codici ANSI, barra di progresso, select, menu while+case,
#           getopts per parsing opzioni.
# Esecuzione: bash 02_menu_getopts.sh [-v] [-m]
#   -v  demo solo colori
#   -m  avvia il menu interattivo
# =============================================================================

# Codici ANSI
NERO='\033[0;30m';  ROSSO='\033[0;31m';  VERDE='\033[0;32m'
GIALLO='\033[1;33m'; BLU='\033[0;34m';  MAGENTA='\033[0;35m'
CIANO='\033[0;36m'; BIANCO='\033[0;37m'; RESET='\033[0m'
GRASSETTO='\033[1m'; SOTTOLINEATO='\033[4m'; INVERSO='\033[7m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
ok()     { echo -e "${VERDE}[OK]${RESET}  $1"; }
warn()   { echo -e "${GIALLO}[WARN]${RESET} $1"; }
errore() { echo -e "${ROSSO}[ERR]${RESET}  $1" >&2; }

# --- Parsing opzioni con getopts ---
SHOW_COLORI=0
SHOW_MENU=0

while getopts ":vmc:h" opt; do
    case $opt in
        v) SHOW_COLORI=1 ;;
        m) SHOW_MENU=1 ;;
        h)
            echo "Uso: $0 [-v] [-m] [-h]"
            echo "  -v  demo colori ANSI"
            echo "  -m  avvia menu interattivo"
            echo "  -h  questo aiuto"
            exit 0 ;;
        \?) errore "Opzione sconosciuta: -$OPTARG (usa -h)"; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Se nessuna opzione → mostra tutto
[[ $SHOW_COLORI -eq 0 && $SHOW_MENU -eq 0 ]] && SHOW_COLORI=1

# === DEMO COLORI ===
if [[ $SHOW_COLORI -eq 1 ]]; then
    titolo "1. Palette colori ANSI"
    echo -e "  ${NERO}●  NERO${RESET}     ${ROSSO}●  ROSSO${RESET}     ${VERDE}●  VERDE${RESET}"
    echo -e "  ${GIALLO}●  GIALLO${RESET}   ${BLU}●  BLU${RESET}       ${MAGENTA}●  MAGENTA${RESET}"
    echo -e "  ${CIANO}●  CIANO${RESET}    ${BIANCO}●  BIANCO${RESET}"
    echo ""
    echo -e "  ${GRASSETTO}Grassetto${RESET} — ${SOTTOLINEATO}Sottolineato${RESET} — ${INVERSO}Inverso${RESET}"
    echo -e "  ${ROSSO}${GRASSETTO}ERRORE CRITICO${RESET}"
    echo -e "  ${VERDE}${GRASSETTO}OPERAZIONE OK${RESET}"
    echo -e "  ${GIALLO}⚠  Attenzione${RESET}"

    titolo "2. Funzioni di log"
    ok "Connessione al server riuscita"
    ok "Backup completato (2.3 MB)"
    warn "Spazio disco al 88% — pulizia consigliata"
    errore "File di configurazione non trovato"

    titolo "3. Barra di avanzamento"
    echo -n "Elaborazione: "
    for ((i=0; i<=40; i++)); do
        printf "\rElaborazione: [%-40s] %3d%%" "$(printf '#%.0s' $(seq 1 $i))" $((i*100/40))
        sleep 0.03
    done
    echo ""
    ok "Elaborazione completata"

    titolo "4. select — menu automatico"
    PS3="${CIANO}Scegli una shell (q=esci): ${RESET}"
    select shell in bash zsh fish ksh dash; do
        if [[ -z "$shell" ]]; then
            [[ "$REPLY" == "q" ]] && break
            warn "Inserisci un numero valido"
        else
            ok "Hai scelto: ${GRASSETTO}$shell${RESET}"
            break
        fi
    done
fi

# === MENU INTERATTIVO ===
if [[ $SHOW_MENU -eq 1 ]]; then
    mostra_menu() {
        clear
        COLS=$(tput cols 2>/dev/null || echo 40)
        sep=$(printf '═%.0s' $(seq 1 $((COLS - 2))))
        echo -e "${CIANO}╔${sep}╗"
        printf  "║ %-*s║\n" $((COLS - 3)) "  PANNELLO DI CONTROLLO"
        echo -e "╠${sep}╣"
        printf  "║ %-*s║\n" $((COLS - 3)) "  1) Informazioni sistema"
        printf  "║ %-*s║\n" $((COLS - 3)) "  2) Processi (top 5 CPU)"
        printf  "║ %-*s║\n" $((COLS - 3)) "  3) Spazio disco"
        printf  "║ %-*s║\n" $((COLS - 3)) "  4) Utenti connessi"
        printf  "║ %-*s║\n" $((COLS - 3)) "  5) Contenuto directory"
        printf  "║ %-*s║\n" $((COLS - 3)) "  q) Esci"
        echo -e "╚${sep}╝${RESET}"
    }

    while true; do
        mostra_menu
        read -p "$(echo -e "${GIALLO}Scelta: ${RESET}")" scelta
        case $scelta in
            1)
                titolo "Informazioni sistema"
                printf "  %-12s %s\n" "Hostname:"  "$(hostname)"
                printf "  %-12s %s\n" "Kernel:"    "$(uname -r)"
                printf "  %-12s %s\n" "Utente:"    "$USER"
                printf "  %-12s %s\n" "Data/Ora:"  "$(date '+%d/%m/%Y %H:%M')"
                ;;
            2)
                titolo "Top 5 processi per CPU"
                ps aux --sort=-%cpu | head -6
                ;;
            3)
                titolo "Spazio disco"
                df -h | grep -v tmpfs
                ;;
            4)
                titolo "Utenti connessi"
                who
                ;;
            5)
                read -p "Directory (default .): " dir
                dir="${dir:-.}"
                titolo "Contenuto di $dir"
                ls -la "$dir" 2>/dev/null || errore "Directory non trovata"
                ;;
            q|Q)
                echo -e "${VERDE}Arrivederci!${RESET}"
                exit 0
                ;;
            *)
                warn "Opzione '$scelta' non valida"
                sleep 1
                continue
                ;;
        esac
        read -p "$(echo -e "${CIANO}Premi Invio per continuare...${RESET}")"
    done
fi
