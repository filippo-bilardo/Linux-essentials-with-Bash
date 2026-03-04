#!/bin/bash
# =============================================================================
# 04_snake_v2.sh
# Modulo 07 - Snake v2 — Grafica potenziata con 256 colori
#
# Miglioramenti rispetto a 03_snake.sh:
#   • 256-color gradient sul corpo del serpente (testa brillante → coda scura)
#   • Testa direzionale (▶ ▼ ◀ ▲) e corpo con ■
#   • Pannello laterale live: punteggio, record, livello, velocità, lunghezza
#   • Schermata di benvenuto con logo ASCII
#   • Pausa (tasto P)
#   • Sistema di livelli (ogni 5 cibi = +1 livello)
#   • Record salvato in /tmp/snake_highscore.txt
#   • Cibo lampeggiante (◆ alterna rosso/giallo ogni 2 frame)
#   • Sfondo del campo leggermente colorato
#
# Esecuzione: bash 04_snake_v2.sh
# Controlli : W/A/S/D o frecce — P pausa — Q esci — R ricomincia
# =============================================================================
set -uo pipefail   # variabili non definite = errore

# ─────────────────────────────────────────────────────────────────────────────
# ANSI — strutture di base
# ─────────────────────────────────────────────────────────────────────────────
ESC=$'\033'
CSI="${ESC}["
RESET="${CSI}0m"

# ── colori 256 (fg: \033[38;5;Nm — bg: \033[48;5;Nm) ──────────────────────
c256_fg() { printf "${CSI}38;5;%dm" "$1"; }
c256_bg() { printf "${CSI}48;5;%dm" "$1"; }

# Palette fissa
NERO_BG=$(c256_bg 232)          # sfondo campo quasi-nero
BORDO_FG=$(c256_fg 27)          # blu brillante per il bordo
BORDO_BG=$(c256_bg 17)          # blu notte per bg bordo
PANNELLO_BG=$(c256_bg 233)      # bg pannello laterale
PANNELLO_FG=$(c256_fg 250)      # grigio chiaro per testo pannello
TITOLO_FG=$(c256_fg 46)         # verde brillante per titoli pannello
CIBO_R_FG=$(c256_fg 196)        # rosso per cibo (frame pari)
CIBO_G_FG=$(c256_fg 226)        # giallo per cibo (frame dispari)
PUNTEGGIO_FG=$(c256_fg 220)     # arancione per punteggio
RECORD_FG=$(c256_fg 213)        # magenta per record
LIVELLO_FG=$(c256_fg 123)       # azzurro per livello
WARN_FG=$(c256_fg 202)          # arancione per avvisi
BIANCO_FG=$(c256_fg 255)
GRIGIO_FG=$(c256_fg 240)
ROSSO_FG=$(c256_fg 196)

# Palette gradiente serpente (256-color): da testa brillante a coda scura
GRAD=(46 40 34 28 22 22 22 22)   # indici 256-color verde

colore_segmento() {
    # $1 = indice segmento (0=testa), $2 = lunghezza totale
    local idx=$(( $1 * 7 / ($2 > 1 ? $2 : 1) ))
    (( idx > 7 )) && idx=7
    c256_fg "${GRAD[$idx]}"
}

# ── cursore / schermo ────────────────────────────────────────────────────────
NASCONDI_CURSORE="${CSI}?25l"
MOSTRA_CURSORE="${CSI}?25h"
PULISCI="${CSI}2J${CSI}H"
vai_a() { printf "${CSI}%d;%dH" "$1" "$2"; }

# ─────────────────────────────────────────────────────────────────────────────
# DIMENSIONI
# ─────────────────────────────────────────────────────────────────────────────
RIGHE=22          # campo bordo incluso
COLONNE=52        # campo bordo incluso
PANEL_COL=$(( COLONNE + 2 ))   # colonna iniziale pannello
PANEL_W=22        # larghezza pannello (interno)

CAMPO_R=$(( RIGHE - 2 ))
CAMPO_C=$(( COLONNE - 2 ))

# ─────────────────────────────────────────────────────────────────────────────
# STATO
# ─────────────────────────────────────────────────────────────────────────────
declare -a SNAKE_R SNAKE_C
LUNGHEZZA=3
DIR_R=0; DIR_C=1
PROSSIMA_DIR_R=0; PROSSIMA_DIR_C=1
CIBO_R=0; CIBO_C=0
PUNTEGGIO=0
RECORD=0
LIVELLO=1
CIBI_LIVELLO=0            # cibi mangiati nel livello corrente
VELOCITA=0.13
GAME_OVER=0
IN_PAUSA=0
FRAME=0

HIGHSCORE_FILE="/tmp/snake_highscore.txt"
[[ -f "$HIGHSCORE_FILE" ]] && RECORD=$(<"$HIGHSCORE_FILE") || RECORD=0

# ─────────────────────────────────────────────────────────────────────────────
# RIPRISTINO TERMINALE
# ─────────────────────────────────────────────────────────────────────────────
ripristina() {
    printf "%s%s" "$MOSTRA_CURSORE" "$RESET"
    tput rmcup 2>/dev/null
    stty echo 2>/dev/null
    stty sane 2>/dev/null
    echo "Grazie per aver giocato!  Punteggio: ${PUNTEGGIO}  Record: ${RECORD}"
}
trap ripristina EXIT INT TERM

# ─────────────────────────────────────────────────────────────────────────────
# DISEGNO BORDO
# ─────────────────────────────────────────────────────────────────────────────
disegna_bordo() {
    local r c
    # Riempie l'area del campo con il bg scuro
    for (( r=2; r<=RIGHE-1; r++ )); do
        vai_a "$r" 2
        printf "%s%*s%s" "$NERO_BG" $(( COLONNE - 2 )) "" "$RESET"
    done

    # Angoli e linee
    vai_a 1 1
    printf "%s%s╔" "$BORDO_FG" "$BORDO_BG"
    for (( c=1; c<COLONNE-1; c++ )); do printf "═"; done
    printf "╗%s" "$RESET"

    for (( r=2; r<=RIGHE-1; r++ )); do
        vai_a "$r" 1;          printf "%s%s║%s" "$BORDO_FG" "$BORDO_BG" "$RESET"
        vai_a "$r" "$COLONNE"; printf "%s%s║%s" "$BORDO_FG" "$BORDO_BG" "$RESET"
    done

    vai_a "$RIGHE" 1
    printf "%s%s╚" "$BORDO_FG" "$BORDO_BG"
    for (( c=1; c<COLONNE-1; c++ )); do printf "═"; done
    printf "╝%s" "$RESET"
}

# ─────────────────────────────────────────────────────────────────────────────
# PANNELLO LATERALE
# ─────────────────────────────────────────────────────────────────────────────
disegna_pannello_struttura() {
    local pw=$(( PANEL_W + 2 ))   # larghezza totale con bordi
    local p=$PANEL_COL

    # Riga superiore
    vai_a 1 "$p"
    printf "%s%s┌" "$PANNELLO_FG" "$PANNELLO_BG"
    printf '─%.0s' $(seq 1 $PANEL_W)
    printf "┐%s" "$RESET"

    # Righe interne (bg uniforme)
    for (( r=2; r<=RIGHE; r++ )); do
        vai_a "$r" "$p"
        printf "%s%s│%s%-*s%s│%s" \
            "$PANNELLO_FG" "$PANNELLO_BG" \
            "$PANNELLO_FG" "$PANEL_W" "" \
            "$PANNELLO_FG" "$RESET"
    done

    # Riga inferiore
    vai_a $(( RIGHE+1 )) "$p"
    printf "%s%s└" "$PANNELLO_FG" "$PANNELLO_BG"
    printf '─%.0s' $(seq 1 $PANEL_W)
    printf "┘%s" "$RESET"

    # Etichette fisse
    pannello_riga 2  "${TITOLO_FG}" "  🐍  SNAKE  v2.0     "
    pannello_sep  3
    pannello_riga 4  "${PANNELLO_FG}" "  PUNTEGGIO"
    pannello_sep  6
    pannello_riga 7  "${PANNELLO_FG}" "  RECORD"
    pannello_sep  9
    pannello_riga 10 "${PANNELLO_FG}" "  LIVELLO"
    pannello_riga 11 "${PANNELLO_FG}" "  VELOCITÀ"
    pannello_riga 12 "${PANNELLO_FG}" "  LUNGHEZZA"
    pannello_sep  13
    pannello_riga 14 "${TITOLO_FG}"   "  CONTROLLI"
    pannello_sep  15
    pannello_riga 16 "${GRIGIO_FG}"   "  W / ↑   su"
    pannello_riga 17 "${GRIGIO_FG}"   "  S / ↓   giù"
    pannello_riga 18 "${GRIGIO_FG}"   "  A / ←   sinistra"
    pannello_riga 19 "${GRIGIO_FG}"   "  D / →   destra"
    pannello_riga 20 "${GRIGIO_FG}"   "  P       pausa"
    pannello_riga 21 "${GRIGIO_FG}"   "  Q       esci"
    pannello_riga 22 "${GRIGIO_FG}"   "  R       ricomincia"
}

# Scrive testo su una riga del pannello (col PANEL_COL+1)
pannello_riga() {
    # $1=riga $2=colore $3=testo (max PANEL_W chars)
    vai_a "$1" $(( PANEL_COL + 1 ))
    printf "%s%s%-*.*s%s" \
        "$PANNELLO_BG" "$2" \
        "$PANEL_W" "$PANEL_W" "$3" \
        "$RESET"
}

# Linea separatrice orizzontale nel pannello
pannello_sep() {
    vai_a "$1" $(( PANEL_COL + 1 ))
    printf "%s%s" "$PANNELLO_BG" "$PANNELLO_FG"
    printf '─%.0s' $(seq 1 $PANEL_W)
    printf "%s" "$RESET"
}

# Aggiorna i valori numerici nel pannello
aggiorna_pannello_valori() {
    # Punteggio
    vai_a 5 $(( PANEL_COL + 1 ))
    printf "%s%s  %-*d%s" "$PANNELLO_BG" "$PUNTEGGIO_FG" "$PANEL_W" "$PUNTEGGIO" "$RESET"

    # Record
    vai_a 8 $(( PANEL_COL + 1 ))
    printf "%s%s  %-*d%s" "$PANNELLO_BG" "$RECORD_FG" "$PANEL_W" "$RECORD" "$RESET"

    # Livello
    vai_a 10 $(( PANEL_COL + 4 ))
    printf "%s%s%-*d%s" "$PANNELLO_BG" "$LIVELLO_FG" $(( PANEL_W - 3 )) "$LIVELLO" "$RESET"

    # Velocità — barre ●
    local vel_barre
    local lvl=$(( LIVELLO > 8 ? 8 : LIVELLO ))
    vel_barre=$(printf '●%.0s' $(seq 1 $lvl))
    vel_barre+=$(printf '○%.0s' $(seq 1 $(( 8 - lvl )) 2>/dev/null || true))
    vai_a 11 $(( PANEL_COL + 4 ))
    printf "%s%s%-*s%s" "$PANNELLO_BG" "$LIVELLO_FG" $(( PANEL_W - 3 )) "$vel_barre" "$RESET"

    # Lunghezza
    vai_a 12 $(( PANEL_COL + 4 ))
    printf "%s%s%-*d%s" "$PANNELLO_BG" "$PANNELLO_FG" $(( PANEL_W - 3 )) "$LUNGHEZZA" "$RESET"
}

# ─────────────────────────────────────────────────────────────────────────────
# PIAZZA CIBO
# ─────────────────────────────────────────────────────────────────────────────
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
        [[ "$libero" -eq 1 ]] && { CIBO_R=$r; CIBO_C=$c; return; }
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# RENDER CIBO (lampeggia ogni 2 frame)
# ─────────────────────────────────────────────────────────────────────────────
disegna_cibo() {
    local colore
    (( FRAME % 2 == 0 )) && colore="$CIBO_R_FG" || colore="$CIBO_G_FG"
    vai_a "$CIBO_R" "$CIBO_C"
    printf "%s%s◆%s" "$NERO_BG" "$colore" "$RESET"
}

# ─────────────────────────────────────────────────────────────────────────────
# RENDER SERPENTE — un segmento
# ─────────────────────────────────────────────────────────────────────────────
disegna_testa() {
    local r=$1 c=$2
    vai_a "$r" "$c"
    printf "%s%s%s%s" "$NERO_BG" "$(c256_fg 46)${CSI}1m" "█" "${CSI}22m${RESET}"
}

disegna_corpo() {
    local r=$1 c=$2 idx=$3
    vai_a "$r" "$c"
    printf "%s%s█%s" "$NERO_BG" "$(colore_segmento "$idx" "$LUNGHEZZA")" "$RESET"
}

cancella_cella() {
    vai_a "$1" "$2"
    printf "%s %s" "$NERO_BG" "$RESET"
}

# ─────────────────────────────────────────────────────────────────────────────
# INIZIALIZZAZIONE SERPENTE
# ─────────────────────────────────────────────────────────────────────────────
inizializza_serpente() {
    local r=$(( RIGHE / 2 ))
    local c=$(( COLONNE / 2 ))
    SNAKE_R=( "$r" "$r" "$r" )
    SNAKE_C=( "$c" $(( c-1 )) $(( c-2 )) )
    LUNGHEZZA=3
    DIR_R=0; DIR_C=1
    PROSSIMA_DIR_R=0; PROSSIMA_DIR_C=1
    PUNTEGGIO=0; LIVELLO=1; CIBI_LIVELLO=0
    VELOCITA=0.13; FRAME=0
    # Disegna serpente iniziale
    disegna_testa "${SNAKE_R[0]}" "${SNAKE_C[0]}"
    for (( i=1; i<LUNGHEZZA; i++ )); do
        disegna_corpo "${SNAKE_R[$i]}" "${SNAKE_C[$i]}" "$i"
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# SCHERMATA BENVENUTO
# ─────────────────────────────────────────────────────────────────────────────
schermata_benvenuto() {
    tput smcup 2>/dev/null
    stty -echo 2>/dev/null
    printf "%s%s%s" "$NASCONDI_CURSORE" "$PULISCI" ""

    local rc=$(( RIGHE / 2 ))
    local cc=$(( COLONNE / 2 ))

    local LOGO_FG; LOGO_FG=$(c256_fg 46)
    local DIM_FG;  DIM_FG=$(c256_fg 240)
    local KEY_FG;  KEY_FG=$(c256_fg 220)

    # Logo ASCII
    vai_a $(( rc-6 )) $(( cc-14 ))
    printf "%s███████╗███╗  ██╗ █████╗ ██╗  ██╗███████╗%s" "$LOGO_FG" "$RESET"
    vai_a $(( rc-5 )) $(( cc-14 ))
    printf "%s██╔════╝████╗ ██║██╔══██╗██║ ██╔╝██╔════╝%s" "$LOGO_FG" "$RESET"
    vai_a $(( rc-4 )) $(( cc-14 ))
    printf "%s███████╗██╔██╗██║███████║█████╔╝ █████╗  %s" "$LOGO_FG" "$RESET"
    vai_a $(( rc-3 )) $(( cc-14 ))
    printf "%s╚════██║██║╚████║██╔══██║██╔═██╗ ██╔══╝  %s" "$LOGO_FG" "$RESET"
    vai_a $(( rc-2 )) $(( cc-14 ))
    printf "%s███████║██║ ╚███║██║  ██║██║  ██╗███████╗%s" "$LOGO_FG" "$RESET"
    vai_a $(( rc-1 )) $(( cc-14 ))
    printf "%s╚══════╝╚═╝  ╚══╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝%s" "$LOGO_FG" "$RESET"

    vai_a $(( rc+1 )) $(( cc-10 ))
    printf "%sv2.0 — Grafica potenziata con 256 colori%s" "$DIM_FG" "$RESET"

    vai_a $(( rc+3 )) $(( cc-12 ))
    printf "%sControlli:%s  W A S D  o  frecce direzionali%s" "$KEY_FG" "$RESET" "$RESET"
    vai_a $(( rc+4 )) $(( cc-12 ))
    printf "           P = pausa    Q = esci    R = ricomincia"

    if [[ "$RECORD" -gt 0 ]]; then
        vai_a $(( rc+6 )) $(( cc-8 ))
        printf "%sRecord precedente: %s%d%s" "$(c256_fg 213)" "$(c256_fg 220)" "$RECORD" "$RESET"
    fi

    vai_a $(( rc+8 )) $(( cc-9 ))
    printf "%s[ Premi un tasto qualsiasi per iniziare ]%s" "$(c256_fg 250)" "$RESET"

    read -r -s -n1 _
}

# ─────────────────────────────────────────────────────────────────────────────
# SCHERMATA GAME OVER
# ─────────────────────────────────────────────────────────────────────────────
schermata_game_over() {
    local rc=$(( RIGHE / 2 ))
    local cc=$(( COLONNE / 2 ))
    local nuovo_record=0

    if (( PUNTEGGIO > RECORD )); then
        RECORD=$PUNTEGGIO
        echo "$RECORD" > "$HIGHSCORE_FILE"
        nuovo_record=1
        aggiorna_pannello_valori
    fi

    local BOX_FG; BOX_FG=$(c256_fg 196)
    local NR_FG;  NR_FG=$(c256_fg 226)

    vai_a $(( rc-2 )) $(( cc-11 ))
    printf "%s╔════════════════════════╗%s" "$BOX_FG" "$RESET"
    vai_a $(( rc-1 )) $(( cc-11 ))
    printf "%s║     ☠  GAME OVER  ☠    ║%s" "$BOX_FG" "$RESET"
    vai_a "$rc"       $(( cc-11 ))
    printf "%s║   Punteggio: %6d     ║%s" "$BOX_FG" "$PUNTEGGIO" "$RESET"
    vai_a $(( rc+1 )) $(( cc-11 ))
    if [[ "$nuovo_record" -eq 1 ]]; then
        printf "%s║  %s★ NUOVO RECORD! ★%s     ║%s" "$BOX_FG" "$NR_FG" "$BOX_FG" "$RESET"
    else
        printf "%s║   Record:    %6d     ║%s" "$BOX_FG" "$RECORD" "$RESET"
    fi
    vai_a $(( rc+2 )) $(( cc-11 ))
    printf "%s╚════════════════════════╝%s" "$BOX_FG" "$RESET"

    vai_a $(( rc+4 )) $(( cc-13 ))
    printf "%s[ R = ricomincia    Q = esci ]%s" "$(c256_fg 250)" "$RESET"
}

# ─────────────────────────────────────────────────────────────────────────────
# SCHERMATA PAUSA
# ─────────────────────────────────────────────────────────────────────────────
schermata_pausa() {
    local rc=$(( RIGHE / 2 ))
    local cc=$(( COLONNE / 2 ))
    vai_a $(( rc-1 )) $(( cc-9 ))
    printf "%s┌──────────────────┐%s" "$(c256_fg 220)" "$RESET"
    vai_a "$rc" $(( cc-9 ))
    printf "%s│ ⏸  GIOCO IN PAUSA │%s" "$(c256_fg 220)" "$RESET"
    vai_a $(( rc+1 )) $(( cc-9 ))
    printf "%s└──────────────────┘%s" "$(c256_fg 220)" "$RESET"
}

cancella_pausa() {
    # Ridisegna le celle coperte dal popup pausa
    local rc=$(( RIGHE / 2 ))
    local cc=$(( COLONNE / 2 ))
    for (( r=rc-1; r<=rc+1; r++ )); do
        for (( c=cc-9; c<=cc+9; c++ )); do
            # Determina se è una cella del serpente o cibo
            local trovato=0
            for (( i=0; i<LUNGHEZZA; i++ )); do
                if [[ "${SNAKE_R[$i]}" -eq "$r" && "${SNAKE_C[$i]}" -eq "$c" ]]; then
                    if [[ "$i" -eq 0 ]]; then disegna_testa "$r" "$c"
                    else                      disegna_corpo "$r" "$c" "$i"
                    fi
                    trovato=1; break
                fi
            done
            if [[ "$trovato" -eq 0 ]]; then
                if [[ "$r" -eq "$CIBO_R" && "$c" -eq "$CIBO_C" ]]; then
                    disegna_cibo
                else
                    cancella_cella "$r" "$c"
                fi
            fi
        done
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# LOOP PRINCIPALE
# ─────────────────────────────────────────────────────────────────────────────
gioca() {
    printf "%s%s%s" "$NASCONDI_CURSORE" "$PULISCI" ""

    disegna_bordo
    inizializza_serpente
    disegna_pannello_struttura
    piazza_cibo
    disegna_cibo
    aggiorna_pannello_valori

    local tasto resto
    while [[ "$GAME_OVER" -eq 0 ]]; do
        tasto=""
        read -r -s -n1 -t "$VELOCITA" tasto || true

        # Sequenze frecce: ESC [ A/B/C/D
        if [[ "$tasto" == $'\033' ]]; then
            read -r -s -n2 -t 0.05 resto || true
            case "$resto" in
                "[A") tasto="w" ;;   "[B") tasto="s" ;;
                "[C") tasto="d" ;;   "[D") tasto="a" ;;
            esac
        fi

        # ── Pausa ──────────────────────────────────────────────────────────
        if [[ "${tasto,,}" == "p" ]]; then
            if [[ "$IN_PAUSA" -eq 0 ]]; then
                IN_PAUSA=1
                schermata_pausa
            else
                IN_PAUSA=0
                cancella_pausa
            fi
            continue
        fi
        [[ "$IN_PAUSA" -eq 1 ]] && continue

        # ── Quit ───────────────────────────────────────────────────────────
        [[ "${tasto,,}" == "q" ]] && { GAME_OVER=1; return; }

        # ── Direzione ──────────────────────────────────────────────────────
        case "${tasto,,}" in
            w) [[ "$DIR_R" -ne  1 ]] && PROSSIMA_DIR_R=-1 && PROSSIMA_DIR_C=0 ;;
            s) [[ "$DIR_R" -ne -1 ]] && PROSSIMA_DIR_R=1  && PROSSIMA_DIR_C=0 ;;
            a) [[ "$DIR_C" -ne  1 ]] && PROSSIMA_DIR_R=0  && PROSSIMA_DIR_C=-1 ;;
            d) [[ "$DIR_C" -ne -1 ]] && PROSSIMA_DIR_R=0  && PROSSIMA_DIR_C=1  ;;
        esac
        DIR_R=$PROSSIMA_DIR_R
        DIR_C=$PROSSIMA_DIR_C

        # ── Nuova testa ────────────────────────────────────────────────────
        local nuova_r=$(( SNAKE_R[0] + DIR_R ))
        local nuova_c=$(( SNAKE_C[0] + DIR_C ))

        # Collisione bordo
        if (( nuova_r < 2 || nuova_r > RIGHE-1 ||
              nuova_c < 2 || nuova_c > COLONNE-1 )); then
            GAME_OVER=1; break
        fi

        # Collisione corpo
        for (( i=0; i<LUNGHEZZA; i++ )); do
            if [[ "${SNAKE_R[$i]}" -eq "$nuova_r" && "${SNAKE_C[$i]}" -eq "$nuova_c" ]]; then
                GAME_OVER=1; break 2
            fi
        done

        # ── Mangia? ────────────────────────────────────────────────────────
        local mangia=0
        if [[ "$nuova_r" -eq "$CIBO_R" && "$nuova_c" -eq "$CIBO_C" ]]; then
            mangia=1
            (( PUNTEGGIO += LIVELLO * 10 ))
            (( CIBI_LIVELLO++ ))
            # Nuovo livello ogni 5 cibi
            if (( CIBI_LIVELLO >= 5 )); then
                (( LIVELLO++ ))
                CIBI_LIVELLO=0
                VELOCITA=$(awk "BEGIN{v=${VELOCITA}-0.01; print (v<0.04?0.04:v)}")
            fi
        fi

        # ── Sposta serpente ────────────────────────────────────────────────
        local vecchia_coda_r="${SNAKE_R[$(( LUNGHEZZA - 1 ))]}"
        local vecchia_coda_c="${SNAKE_C[$(( LUNGHEZZA - 1 ))]}"

        if [[ "$mangia" -eq 1 ]]; then
            SNAKE_R=( "$nuova_r" "${SNAKE_R[@]}" )
            SNAKE_C=( "$nuova_c" "${SNAKE_C[@]}" )
            (( LUNGHEZZA++ ))
        else
            for (( i=LUNGHEZZA-1; i>=1; i-- )); do
                SNAKE_R[$i]="${SNAKE_R[$(( i-1 ))]}"
                SNAKE_C[$i]="${SNAKE_C[$(( i-1 ))]}"
            done
            SNAKE_R[0]="$nuova_r"
            SNAKE_C[0]="$nuova_c"
        fi

        # ── Aggiorna display ───────────────────────────────────────────────
        # nuova testa
        disegna_testa "$nuova_r" "$nuova_c"
        # il vecchio testa → corpo (ridisegna con gradiente corretto)
        disegna_corpo "${SNAKE_R[1]}" "${SNAKE_C[1]}" 1

        if [[ "$mangia" -eq 0 ]]; then
            cancella_cella "$vecchia_coda_r" "$vecchia_coda_c"
        else
            piazza_cibo
        fi

        # Ridisegna cibo (effetto lampeggio)
        disegna_cibo
        (( FRAME++ ))

        aggiorna_pannello_valori
    done
}

# ─────────────────────────────────────────────────────────────────────────────
# ENTRY POINT
# ─────────────────────────────────────────────────────────────────────────────
main() {
    schermata_benvenuto

    local scelta
    while true; do
        GAME_OVER=0; IN_PAUSA=0
        gioca

        # Game over vero (non Q)
        if [[ "$GAME_OVER" -eq 1 ]]; then
            schermata_game_over
            while true; do
                read -r -s -n1 scelta
                case "${scelta,,}" in
                    r) break  ;;
                    q) return ;;
                esac
            done
        else
            return   # Q premuto durante il gioco
        fi
    done
}

main
