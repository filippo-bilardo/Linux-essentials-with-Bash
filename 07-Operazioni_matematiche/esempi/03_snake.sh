#!/bin/bash
# =============================================================================
# 03_snake.sh
# Modulo 07 - Gioco Snake con codici ANSI
#
# Dimostra: array, aritmetica, codici ANSI, input non-bloccante, trap.
# Esecuzione: bash 03_snake.sh
# Controlli: W/A/S/D oppure frecce direzionali — Q per uscire
# =============================================================================

# -----------------------------------------------------------------------------
# Codici ANSI
# -----------------------------------------------------------------------------
ESC=$'\033'
CSI="${ESC}["

# Colori
RESET="${CSI}0m"
ROSSO="${CSI}1;31m"
VERDE="${CSI}1;32m"
GIALLO="${CSI}1;33m"
BLU="${CSI}1;34m"
MAGENTA="${CSI}1;35m"
CIANO="${CSI}1;36m"
BIANCO="${CSI}1;37m"
NERO_BG="${CSI}40m"

# Cursore / schermo
nascondo_cursore="${CSI}?25l"
mostro_cursore="${CSI}?25h"
pulisci_schermo="${CSI}2J"
vai_origine="${CSI}H"

# Muovi cursore: vai_a ROW COL
vai_a() { printf "${CSI}%d;%dH" "$1" "$2"; }

# -----------------------------------------------------------------------------
# Dimensioni campo (bordo incluso)
# -----------------------------------------------------------------------------
RIGHE=22
COLONNE=60

# Coordinate interne (senza bordo): 1..(RIGHE-2) x 1..(COLONNE-2)
CAMPO_R=$(( RIGHE - 2 ))
CAMPO_C=$(( COLONNE - 2 ))

# -----------------------------------------------------------------------------
# Stato del gioco
# -----------------------------------------------------------------------------
declare -a SNAKE_R   # array righe corpo serpente (testa in [0])
declare -a SNAKE_C   # array colonne corpo serpente
LUNGHEZZA=3

DIR_R=0              # direzione corrente (riga)
DIR_C=1              # direzione corrente (colonna) — parte verso destra
PROSSIMA_DIR_R=0
PROSSIMA_DIR_C=1

CIBO_R=0
CIBO_C=0

PUNTEGGIO=0
VELOCITA=0.12        # secondi per frame (diminuisce con il punteggio)
GAME_OVER=0

# -----------------------------------------------------------------------------
# Pulizia terminale all'uscita
# -----------------------------------------------------------------------------
ripristina() {
    printf "%s%s" "$mostro_cursore" "$RESET"
    tput rmcup 2>/dev/null   # ripristina schermo originale
    stty echo 2>/dev/null    # riabilita echo tastiera
    echo "Punteggio finale: ${PUNTEGGIO}"
}
trap ripristina EXIT INT TERM

# -----------------------------------------------------------------------------
# Disegna il bordo
# -----------------------------------------------------------------------------
disegna_bordo() {
    local c
    # Riga superiore
    vai_a 1 1
    printf "${BLU}╔"
    for (( c=1; c<COLONNE-1; c++ )); do printf "═"; done
    printf "╗${RESET}"

    # Righe laterali
    for (( r=2; r<=RIGHE-1; r++ )); do
        vai_a "$r" 1;           printf "${BLU}║${RESET}"
        vai_a "$r" "$COLONNE";  printf "${BLU}║${RESET}"
    done

    # Riga inferiore
    vai_a "$RIGHE" 1
    printf "${BLU}╚"
    for (( c=1; c<COLONNE-1; c++ )); do printf "═"; done
    printf "╝${RESET}"
}

# -----------------------------------------------------------------------------
# Posiziona il cibo in una cella libera
# -----------------------------------------------------------------------------
piazza_cibo() {
    local r c libero
    while true; do
        r=$(( RANDOM % CAMPO_R + 2 ))
        c=$(( RANDOM % CAMPO_C + 2 ))
        libero=1
        for (( i=0; i<LUNGHEZZA; i++ )); do
            if [[ "${SNAKE_R[$i]}" -eq "$r" && "${SNAKE_C[$i]}" -eq "$c" ]]; then
                libero=0; break
            fi
        done
        if [[ "$libero" -eq 1 ]]; then
            CIBO_R=$r; CIBO_C=$c
            return
        fi
    done
}

# -----------------------------------------------------------------------------
# Disegna un segmento del serpente
# -----------------------------------------------------------------------------
disegna_segmento() {
    local r=$1 c=$2 simbolo=$3 colore=$4
    vai_a "$r" "$c"
    printf "%s%s%s" "$colore" "$simbolo" "$RESET"
}

# -----------------------------------------------------------------------------
# Cancella l'ultima cella della coda
# -----------------------------------------------------------------------------
cancella_cella() {
    vai_a "$1" "$2"
    printf " "
}

# -----------------------------------------------------------------------------
# Disegna HUD (riga sotto il campo)
# -----------------------------------------------------------------------------
aggiorna_hud() {
    vai_a $(( RIGHE + 1 )) 1
    printf "${CIANO}Punteggio: ${GIALLO}%-5d${CIANO}  Controlli: W/A/S/D  Q = esci  Velocità: %.2f s${RESET}" \
        "$PUNTEGGIO" "$VELOCITA"
}

# -----------------------------------------------------------------------------
# Inizializzazione serpente (al centro, lungo 3)
# -----------------------------------------------------------------------------
inizializza() {
    local r_centro=$(( RIGHE / 2 ))
    local c_centro=$(( COLONNE / 2 ))
    SNAKE_R=( "$r_centro"  "$r_centro"  "$r_centro" )
    SNAKE_C=( "$c_centro"  "$(( c_centro - 1 ))"  "$(( c_centro - 2 ))" )
    LUNGHEZZA=3
    DIR_R=0; DIR_C=1
    PROSSIMA_DIR_R=0; PROSSIMA_DIR_C=1
    PUNTEGGIO=0
    VELOCITA=0.12
}

# -----------------------------------------------------------------------------
# Loop principale
# -----------------------------------------------------------------------------
gioca() {
    # Setup terminale
    tput smcup 2>/dev/null   # salva schermo
    stty -echo 2>/dev/null
    printf "%s%s%s" "$nascondo_cursore" "$pulisci_schermo" "$vai_origine"

    # Disegno iniziale
    disegna_bordo
    inizializza

    # Disegna serpente iniziale
    for (( i=0; i<LUNGHEZZA; i++ )); do
        if [[ $i -eq 0 ]]; then
            disegna_segmento "${SNAKE_R[0]}" "${SNAKE_C[0]}" "●" "${VERDE}"
        else
            disegna_segmento "${SNAKE_R[$i]}" "${SNAKE_C[$i]}" "○" "${CIANO}"
        fi
    done

    piazza_cibo
    disegna_segmento "$CIBO_R" "$CIBO_C" "★" "${ROSSO}"
    aggiorna_hud

    local tasto
    while [[ "$GAME_OVER" -eq 0 ]]; do
        # Lettura non-bloccante: aspetta VELOCITA secondi per un tasto
        tasto=""
        read -r -s -n1 -t "$VELOCITA" tasto || true

        # Gestione frecce (sequenza ESC [ A/B/C/D)
        if [[ "$tasto" == $'\033' ]]; then
            read -r -s -n2 -t 0.05 resto || true
            case "$resto" in
                "[A") tasto="w" ;;
                "[B") tasto="s" ;;
                "[C") tasto="d" ;;
                "[D") tasto="a" ;;
            esac
        fi

        # Aggiorna direzione (impedisce inversione a 180°)
        case "${tasto,,}" in
            w) [[ "$DIR_R" -ne  1 ]] && PROSSIMA_DIR_R=-1 && PROSSIMA_DIR_C=0 ;;
            s) [[ "$DIR_R" -ne -1 ]] && PROSSIMA_DIR_R=1  && PROSSIMA_DIR_C=0 ;;
            a) [[ "$DIR_C" -ne  1 ]] && PROSSIMA_DIR_R=0  && PROSSIMA_DIR_C=-1 ;;
            d) [[ "$DIR_C" -ne -1 ]] && PROSSIMA_DIR_R=0  && PROSSIMA_DIR_C=1  ;;
            q) GAME_OVER=1; return ;;
        esac

        DIR_R=$PROSSIMA_DIR_R
        DIR_C=$PROSSIMA_DIR_C

        # Calcola nuova testa
        local nuova_r=$(( SNAKE_R[0] + DIR_R ))
        local nuova_c=$(( SNAKE_C[0] + DIR_C ))

        # --- Collisione bordo ---
        if (( nuova_r < 2 || nuova_r > RIGHE-1 ||
              nuova_c < 2 || nuova_c > COLONNE-1 )); then
            GAME_OVER=1; break
        fi

        # --- Collisione con se stesso ---
        for (( i=0; i<LUNGHEZZA; i++ )); do
            if [[ "${SNAKE_R[$i]}" -eq "$nuova_r" && "${SNAKE_C[$i]}" -eq "$nuova_c" ]]; then
                GAME_OVER=1; break 2
            fi
        done

        # --- Controlla se mangia il cibo ---
        local mangia=0
        if [[ "$nuova_r" -eq "$CIBO_R" && "$nuova_c" -eq "$CIBO_C" ]]; then
            mangia=1
            (( PUNTEGGIO += 10 ))
            # Aumenta velocità ogni 5 bocconi
            if (( PUNTEGGIO % 50 == 0 )); then
                VELOCITA=$(awk "BEGIN{v=${VELOCITA}-0.01; print (v<0.04?0.04:v)}")
            fi
        fi

        # --- Sposta il serpente ---
        # Salva la cella di coda prima di spostarla (per cancellarla)
        local vecchia_coda_r="${SNAKE_R[$(( LUNGHEZZA - 1 ))]}"
        local vecchia_coda_c="${SNAKE_C[$(( LUNGHEZZA - 1 ))]}"

        if [[ "$mangia" -eq 1 ]]; then
            # Aggiungi un elemento (in fondo): shift dell'array
            SNAKE_R=( "$nuova_r" "${SNAKE_R[@]}" )
            SNAKE_C=( "$nuova_c" "${SNAKE_C[@]}" )
            (( LUNGHEZZA++ ))
        else
            # Scorri corpo da fondo a inizio
            for (( i=LUNGHEZZA-1; i>=1; i-- )); do
                SNAKE_R[$i]="${SNAKE_R[$(( i-1 ))]}"
                SNAKE_C[$i]="${SNAKE_C[$(( i-1 ))]}"
            done
            SNAKE_R[0]="$nuova_r"
            SNAKE_C[0]="$nuova_c"
        fi

        # --- Aggiorna display ---
        # Disegna nuova testa (con simbolo testa)
        disegna_segmento "$nuova_r" "$nuova_c" "●" "${VERDE}"
        # Il vecchio testa diventa corpo
        disegna_segmento "${SNAKE_R[1]}" "${SNAKE_C[1]}" "○" "${CIANO}"

        if [[ "$mangia" -eq 0 ]]; then
            # Cancella vecchia coda
            cancella_cella "$vecchia_coda_r" "$vecchia_coda_c"
            # Riposiziona cibo se era stato cancellato per errore (non dovrebbe)
        else
            # Nuovo cibo
            piazza_cibo
            disegna_segmento "$CIBO_R" "$CIBO_C" "★" "${ROSSO}"
        fi

        aggiorna_hud
    done
}

# -----------------------------------------------------------------------------
# Schermata GAME OVER
# -----------------------------------------------------------------------------
schermata_game_over() {
    local r_centro=$(( RIGHE / 2 ))
    local c_centro=$(( COLONNE / 2 ))
    vai_a $(( r_centro - 2 )) $(( c_centro - 9 ))
    printf "${ROSSO}╔══════════════════╗${RESET}"
    vai_a $(( r_centro - 1 )) $(( c_centro - 9 ))
    printf "${ROSSO}║   GAME  OVER !   ║${RESET}"
    vai_a "$r_centro" $(( c_centro - 9 ))
    printf "${ROSSO}║  Punteggio: %5d ║${RESET}" "$PUNTEGGIO"
    vai_a $(( r_centro + 1 )) $(( c_centro - 9 ))
    printf "${ROSSO}╚══════════════════╝${RESET}"
    vai_a $(( r_centro + 3 )) $(( c_centro - 12 ))
    printf "${GIALLO}Premi R per rigiocare, Q per uscire${RESET}"
    vai_a $(( RIGHE + 2 )) 1
}

# -----------------------------------------------------------------------------
# Entry point
# -----------------------------------------------------------------------------
main() {
    local scelta
    while true; do
        GAME_OVER=0
        gioca

        # Mostra game over solo se non si è premuto Q
        if [[ "$GAME_OVER" -eq 1 ]]; then
            schermata_game_over
            while true; do
                read -r -s -n1 scelta
                case "${scelta,,}" in
                    r) break ;;          # ricomincia
                    q) return ;;         # esci
                esac
            done
        else
            return
        fi
    done
}

main
