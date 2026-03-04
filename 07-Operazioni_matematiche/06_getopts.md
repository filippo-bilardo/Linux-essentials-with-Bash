# Gestione Opzioni con `getopts`

## Perché `getopts`?

Quando uno script deve accettare opzioni in stile Unix (`-v`, `-f file`, `-n 5`) è scomodo gestirle manualmente con `if [[ $1 == "-v" ]]`. Il comando built-in `getopts` analizza automaticamente le opzioni POSIX.

---

## Sintassi di Base

```bash
while getopts "opzioni" variabile; do
    case $variabile in
        # gestione di ogni opzione
    esac
done
shift $((OPTIND - 1))   # rimuove le opzioni; $@ contiene il resto
```

- Le **lettere** nella stringa di opzioni definiscono le opzioni accettate (`"vhf:"`)
- Un **`:`** dopo la lettera significa che quell'opzione richiede un argomento
- `$OPTARG` contiene il valore dell'argomento (quando c'è il `:`)
- `$OPTIND` è l'indice del prossimo parametro da elaborare

---

## Esempio Completo

```bash
#!/bin/bash
# Uso: ./script.sh [-v] [-n N] [-f file] argomento
VERBOSE=0
NUMERO=10
FILE=""

uso() {
    echo "Uso: $0 [-v] [-n numero] [-f file] argomento"
    echo "  -v          modalità verbosa"
    echo "  -n numero   quante righe mostrare (default: 10)"
    echo "  -f file     file da elaborare"
    echo "  -h          mostra questo aiuto"
    exit 0
}

while getopts "vn:f:h" opt; do
    case $opt in
        v) VERBOSE=1 ;;
        n) NUMERO="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        h) uso ;;
        \?) echo "Opzione sconosciuta: -$OPTARG" >&2; exit 1 ;;
        :)  echo "L'opzione -$OPTARG richiede un argomento" >&2; exit 1 ;;
    esac
done

# Rimuove le opzioni dai parametri posizionali
shift $((OPTIND - 1))

# Ora $@ contiene solo gli argomenti non-opzione
[[ $VERBOSE -eq 1 ]] && echo "Verbose: ON"
[[ -n "$FILE" ]] && echo "File: $FILE"
echo "Numero: $NUMERO"
echo "Argomenti rimasti: $@"
```

### Esempi di invocazione:

```bash
./script.sh -v -n 5 -f input.txt argomento_extra
./script.sh -vn 5 -f input.txt      # opzioni corte raggruppabili
./script.sh -h
./script.sh -x                       # opzione sconosciuta → errore
./script.sh -n                       # n senza argomento → errore
```

---

## Sopprimere i Messaggi di Errore Automatici

Se la stringa di opzioni inizia con `:`, `getopts` non stampa errori automatici — li gestisci tu:

```bash
while getopts ":vn:f:h" opt; do   # nota il : iniziale
    case $opt in
        v) VERBOSE=1 ;;
        \?) echo "[ERR] Opzione non valida: -$OPTARG" >&2; exit 1 ;;
        :)  echo "[ERR] -$OPTARG richiede un argomento" >&2; exit 1 ;;
    esac
done
```

---

## Combinare `getopts` con Funzionalità Complete

```bash
#!/bin/bash
# Strumento di analisi file: analizza.sh
VERBOSE=0
MAX_RIGHE=20
FORMATO="testo"

uso() {
    cat << EOF
Uso: $(basename $0) [opzioni] file...

Opzioni:
  -v          output dettagliato
  -n N        numero massimo di righe (default: 20)
  -f FORMATO  formato output: testo|csv (default: testo)
  -h          mostra questo aiuto

Esempi:
  $(basename $0) /var/log/syslog
  $(basename $0) -v -n 50 file1.txt file2.txt
  $(basename $0) -f csv -n 5 dati.log
EOF
    exit 0
}

while getopts ":vn:f:h" opt; do
    case $opt in
        v) VERBOSE=1 ;;
        n) if [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
               MAX_RIGHE=$OPTARG
           else
               echo "Errore: -n richiede un numero intero" >&2; exit 1
           fi ;;
        f) case $OPTARG in
               testo|csv) FORMATO=$OPTARG ;;
               *) echo "Formato '$OPTARG' non valido. Usa: testo|csv" >&2; exit 1 ;;
           esac ;;
        h) uso ;;
        \?) echo "Opzione sconosciuta: -$OPTARG (usa -h per aiuto)" >&2; exit 1 ;;
        :)  echo "L'opzione -$OPTARG richiede un argomento" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Verifica che ci siano file da elaborare
if [[ $# -eq 0 ]]; then
    echo "Errore: specificare almeno un file" >&2
    uso
fi

# Elabora ogni file
for file in "$@"; do
    if [[ ! -f "$file" ]]; then
        echo "Attenzione: '$file' non trovato, salto" >&2
        continue
    fi

    [[ $VERBOSE -eq 1 ]] && echo "=== Elaboro: $file ==="

    if [[ $FORMATO == "csv" ]]; then
        echo "file,righe,parole,bytes"
        wc "$file" | awk '{printf "%s,%s,%s,%s\n","'"$file"'",$1,$2,$3}'
    else
        echo "File: $file"
        echo "  Righe:  $(wc -l < "$file")"
        echo "  Parole: $(wc -w < "$file")"
        echo "  Ultimi $MAX_RIGHE righe:"
        tail -n $MAX_RIGHE "$file"
    fi
done
```

---

## Differenza tra `getopts` e `getopt`

| | `getopts` | `getopt` |
|-|-----------|---------|
| Tipo | built-in Bash | comando esterno |
| Opzioni lunghe | No (`--verbose`) | Sì |
| Portabilità | POSIX | GNU/Linux |
| Uso consigliato | script semplici | script con `--opzioni-lunghe` |

Per opzioni lunghe (`--verbose`, `--output=FILE`) si usa `getopt` (con `t` finale):

```bash
# getopt con opzioni lunghe (GNU)
opts=$(getopt -o vn:f:h --long verbose,numero:,formato:,help -- "$@")
eval set -- "$opts"
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<05_menu_select.md>)
- [➡️ successivo](<../08_Manipolazione_Stringhe/README.md>)
