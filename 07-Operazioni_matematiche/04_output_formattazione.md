# Colorazione e Formattazione dell'Output

## Codici ANSI

I **codici di escape ANSI** permettono di controllare colori, stile del testo e il cursore direttamente dal terminale. Si inseriscono con `echo -e` o `printf`.

La sequenza di escape inizia con `\033[` (o `\e[`) seguita dal codice e termina con `m`.

### Stili del testo

| Codice | Effetto |
|--------|---------|
| `0` | reset (tutto off) |
| `1` | grassetto |
| `2` | tenue |
| `3` | corsivo |
| `4` | sottolineato |
| `5` | lampeggiante |
| `7` | invertito (sfondo/testo invertiti) |
| `9` | barrato |

### Colori del testo (foreground)

| Codice | Colore |
|--------|--------|
| `30` | nero |
| `31` | rosso |
| `32` | verde |
| `33` | giallo |
| `34` | blu |
| `35` | magenta |
| `36` | ciano |
| `37` | bianco |
| `90`–`97` | versioni brillanti dei precedenti |

### Colori dello sfondo (background)

Aggiungere `10` ai codici foreground: `40`=nero, `41`=rosso, `42`=verde, ecc.

---

## Usare i Codici ANSI negli Script

### Con variabili (pattern consigliato)

```bash
#!/bin/bash
NERO='\033[0;30m'
ROSSO='\033[0;31m'
VERDE='\033[0;32m'
GIALLO='\033[1;33m'   # 1 = grassetto
BLU='\033[0;34m'
MAGENTA='\033[0;35m'
CIANO='\033[0;36m'
BIANCO='\033[0;37m'
GRASSETTO='\033[1m'
SOTTOLINEATO='\033[4m'
RESET='\033[0m'

echo -e "${VERDE}Operazione completata${RESET}"
echo -e "${ROSSO}${GRASSETTO}ERRORE CRITICO${RESET}"
echo -e "${GIALLO}Attenzione: file non trovato${RESET}"
echo -e "${BLU}${SOTTOLINEATO}Titolo Sezione${RESET}"
```

### Funzioni di log colorate

```bash
#!/bin/bash
VERDE='\033[0;32m'; GIALLO='\033[1;33m'
ROSSO='\033[0;31m'; CIANO='\033[0;36m'; RESET='\033[0m'

info()    { echo -e "${CIANO}[INFO]${RESET}  $*"; }
ok()      { echo -e "${VERDE}[OK]${RESET}    $*"; }
warn()    { echo -e "${GIALLO}[WARN]${RESET}  $*"; }
errore()  { echo -e "${ROSSO}[ERR]${RESET}   $*" >&2; }

info "Avvio script..."
ok "Connessione riuscita"
warn "Spazio disco < 10%"
errore "File non trovato"
```

---

## `tput` — Formattazione Portabile

`tput` interroga il database del terminale e genera le sequenze corrette, rendendo gli script più portabili su diversi terminali.

```bash
# Stili
GRASSETTO=$(tput bold)
RESET=$(tput sgr0)
SOTTOLINEATO=$(tput smul)
INVERSO=$(tput rev)

# Colori (0=nero … 7=bianco)
ROSSO=$(tput setaf 1)
VERDE=$(tput setaf 2)
GIALLO=$(tput setaf 3)
BLU=$(tput setaf 4)
CIANO=$(tput setaf 6)

# Uso
echo "${GRASSETTO}${VERDE}Titolo in verde grassetto${RESET}"
echo "${GIALLO}Attenzione${RESET}"
```

### Controllo del cursore con `tput`

```bash
tput clear          # pulisce lo schermo
tput cup 5 10       # posiziona il cursore riga 5, colonna 10
tput civis          # nasconde il cursore
tput cnorm          # mostra il cursore
tput cols           # numero di colonne del terminale
tput lines          # numero di righe del terminale
```

---

## Barra di Progresso

```bash
#!/bin/bash
barra_progresso() {
    local corrente=$1
    local totale=$2
    local larghezza=40
    local percentuale=$(( corrente * 100 / totale ))
    local riempimento=$(( corrente * larghezza / totale ))
    local vuoto=$(( larghezza - riempimento ))

    printf "\r["
    printf "%${riempimento}s" | tr ' ' '█'
    printf "%${vuoto}s"       | tr ' ' '░'
    printf "] %3d%%" $percentuale
}

echo "Elaborazione in corso..."
for ((i=1; i<=50; i++)); do
    barra_progresso $i 50
    sleep 0.05
done
echo ""
echo "Completato!"
```

---

## Box e Separatori

```bash
#!/bin/bash
CIANO='\033[0;36m'; RESET='\033[0m'
LARGH=$(tput cols)

titolo_box() {
    local testo="$1"
    local linea=$(printf '═%.0s' $(seq 1 $((LARGH - 2))))
    echo -e "${CIANO}╔${linea}╗"
    printf "║ %-*s║\n" $((LARGH - 3)) "$testo"
    echo -e "╚${linea}╝${RESET}"
}

separatore() {
    printf "${CIANO}%${LARGH}s${RESET}\n" | tr ' ' '─'
}

titolo_box "REPORT SISTEMA"
separatore
echo "  Utente : $USER"
echo "  Data   : $(date '+%d/%m/%Y')"
separatore
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<03_array_bash.md>)
- [➡️ successivo](<05_menu_select.md>)
