# Parametri Posizionali, Shift e Argomenti

## Introduzione

Quando lavoriamo con script Bash, la capacità di passare e gestire argomenti da riga di comando è fondamentale per creare strumenti flessibili e riutilizzabili. Gli argomenti permettono di modificare il comportamento di uno script senza modificare il codice sorgente, rendendolo più versatile e professionale.

---

## Riepilogo dei Parametri Speciali

Prima di approfondire, rivediamo tutti i parametri disponibili in uno script:

| Parametro | Significato |
|-----------|-------------|
| `$0` | nome dello script (con percorso) |
| `$1` … `$9` | argomenti 1-9 |
| `${10}`, `${11}` | argomenti oltre il 9° (servono le graffe) |
| `$#` | numero di argomenti passati |
| `$@` | tutti gli argomenti come lista separata (preferito) |
| `$*` | tutti gli argomenti come stringa unica |
| `$?` | exit status dell'ultimo comando |
| `$$` | PID dello script corrente |
| `$!` | PID dell'ultimo processo in background |
| `$_` | ultimo argomento del comando precedente |

### Esempio di base

Vediamo un esempio semplice che mostra come accedere agli argomenti:

```bash
#!/bin/bash
# Script: argomenti_base.sh
# Descrizione: Dimostra l'uso base degli argomenti da riga di comando

echo "Nome dello script: $0"
echo "Primo argomento: $1"
echo "Secondo argomento: $2"
echo "Numero totale di argomenti: $#"
echo "Tutti gli argomenti: $@"
```

Se eseguiamo questo script con:
```
./argomenti_base.sh uno due tre
```

L'output sarà:
```
Nome dello script: ./argomenti_base.sh
Primo argomento: uno
Secondo argomento: due
Numero totale di argomenti: 3
Tutti gli argomenti: uno due tre
```
---

## Differenza tra `$@` e `$*`

Questa distinzione è fondamentale quando i parametri contengono spazi:

```bash
#!/bin/bash
# Supponiamo: ./script.sh "ciao mondo" "foo bar"

echo "Con \$@:"
for arg in "$@"; do
    echo "  → $arg"    # itera sulle 2 stringhe originali
done
# → ciao mondo
# → foo bar

echo "Con \$*:"
for arg in "$*"; do
    echo "  → $arg"    # li unisce in una stringa sola
done
# → ciao mondo foo bar
```

> **Regola:** usa sempre `"$@"` per iterare sugli argomenti. Preserva gli spazi.

---

## Validare gli Argomenti

```bash
#!/bin/bash
# Richiedere esattamente 2 argomenti
if [[ $# -ne 2 ]]; then
    echo "Uso: $0 <file_sorgente> <file_destinazione>" >&2
    exit 1
fi

sorgente="$1"
destinazione="$2"

if [[ ! -f "$sorgente" ]]; then
    echo "Errore: '$sorgente' non trovato" >&2
    exit 2
fi

cp "$sorgente" "$destinazione"
echo "Copiato: $sorgente → $destinazione"
```

---

## Il Comando `shift`

`shift` sposta i parametri posizionali: `$2` diventa `$1`, `$3` diventa `$2`, ecc. `$1` viene scartato.

```bash
#!/bin/bash
echo "Argomenti: $@"   # a b c d e
shift                   # scarta $1
echo "Dopo shift: $@"  # b c d e
shift 2                 # scarta i prossimi 2
echo "Dopo shift 2: $@" # d e
```

### Uso classico: processare tutti gli argomenti uno per volta

```bash
#!/bin/bash
while [[ $# -gt 0 ]]; do
    echo "Processo: $1"
    shift
done
```

## Shift: spostare gli argomenti

Il comando `shift` è uno strumento potente per elaborare gli argomenti in sequenza. Questo comando sposta gli argomenti a sinistra, facendo diventare `$2` il nuovo `$1`, `$3` il nuovo `$2`, e così via. 

```bash
#!/bin/bash
# Script: shift_esempio.sh
# Descrizione: Dimostra l'uso del comando shift

echo "Argomenti iniziali: $@"
echo "Primo argomento: $1"

# Sposta gli argomenti di una posizione
shift
echo "Dopo shift, gli argomenti sono: $@"
echo "Nuovo primo argomento: $1"

# Sposta gli argomenti di 2 posizioni
shift 2
echo "Dopo shift 2, gli argomenti sono: $@"
echo "Nuovo primo argomento: $1"
```

Eseguendo:
```
./shift_esempio.sh a b c d e
```

Otterremo:
```
Argomenti iniziali: a b c d e
Primo argomento: a
Dopo shift, gli argomenti sono: b c d e
Nuovo primo argomento: b
Dopo shift 2, gli argomenti sono: d e
Nuovo primo argomento: d
```
---

## Iterare sugli Argomenti

Spesso è necessario elaborare tutti gli argomenti uno per uno:

```bash
#!/bin/bash
echo "Elaborazione di $# argomenti"

# Metodo 1: usando $@ (preferito)
for argomento in "$@"; do
    echo "Elaboro: $argomento"
done

# Metodo 2: usando un contatore con shift
echo "Metodo con shift:"
i=1
while [[ $# -gt 0 ]]; do
    echo "Argomento $i: $1"
    shift
    i=$((i + 1))
done
```

---

## Argomenti con Valori Predefiniti

È buona pratica definire valori predefiniti per gli argomenti opzionali:

```bash
#!/bin/bash
# valori_predefiniti.sh — usa la sintassi ${var:-default}

iterazioni=${1:-5}
messaggio=${2:-"Messaggio predefinito"}
modalita=${3:-"normale"}

echo "Iterazioni : $iterazioni"
echo "Messaggio  : $messaggio"
echo "Modalità   : $modalita"

for (( i=1; i<=iterazioni; i++ )); do
    echo "[$i] $messaggio (modalità: $modalita)"
done
```

Eseguibile sia con `./script.sh` (tutti i default) sia con argomenti espliciti.

---

## Gestione Opzioni con `while`/`case`

Per opzioni in stile Unix (`-v`, `-o file`, `--help`) senza `getopts`:

```bash
#!/bin/bash
# opzioni_manuali.sh

verbose=0
output_file=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--verbose)
            verbose=1
            ;;
        -o|--output)
            if [[ -n "$2" ]]; then
                output_file="$2"
                shift          # consuma il valore dell'opzione
            else
                echo "Errore: -o richiede un nome file" >&2
                exit 1
            fi
            ;;
        -h|--help)
            echo "Uso: $0 [-v] [-o FILE] file..."
            echo "  -v, --verbose    Output dettagliato"
            echo "  -o, --output     File di output"
            echo "  -h, --help       Mostra questo aiuto"
            exit 0
            ;;
        -*)
            echo "Errore: opzione sconosciuta: $1" >&2
            exit 1
            ;;
        *)
            # primo argomento non-opzione: interrompi l'analisi
            break
            ;;
    esac
    shift   # passa all'argomento successivo
done

# $@ ora contiene solo i file/argomenti rimanenti
echo "verbose=$verbose  output=${output_file:-stdout}"
echo "File da elaborare: $@"
```

> Questo pattern manuale gestisce anche opzioni lunghe (`--verbose`). Per soli flag corti, preferire `getopts` (vedi [05 getopts](./06_getopts.md)).

---

## Convalida degli Argomenti

Uno script robusto verifica tipo, numero e correttezza degli input:

```bash
#!/bin/bash
# validazione_argomenti.sh

if [[ $# -lt 2 ]]; then
    echo "Errore: richiesti almeno 2 argomenti" >&2
    echo "Uso: $0 <numero> <file>" >&2
    exit 1
fi

# Verifica che il primo argomento sia un intero positivo
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Errore: '$1' non è un numero intero positivo" >&2
    exit 2
fi

# Verifica esistenza e permessi di lettura del file
if [[ ! -f "$2" ]]; then
    echo "Errore: il file '$2' non esiste" >&2
    exit 3
fi

if [[ ! -r "$2" ]]; then
    echo "Errore: non hai i permessi per leggere '$2'" >&2
    exit 4
fi

echo "OK: elaboro '$2' con parametro $1"
```

> Usa codici di uscita diversi per tipi di errore diversi: facilita il debug quando lo script viene chiamato da altri script.

---

## Best Practices

1. **Documentazione in testa**: commenta `Uso:`, argomenti e opzioni accettati.
2. **Aiuto integrato**: includi sempre `-h`/`--help` con `show_help()` e `exit 0`.
3. **Valori predefiniti**: usa `${var:-default}` per gli argomenti opzionali.
4. **Validazione**: verifica tipo, numero di argomenti e permessi dei file prima di usarli.
5. **Messaggi di errore su stderr**: `echo "Errore: ..." >&2; exit N`
6. **Convenzioni Unix**:
   - Opzioni brevi con un trattino: `-v`
   - Opzioni lunghe con due trattini: `--verbose`
   - Opzioni con argomento: `-o file` oppure `-o=file`
7. **Usa `"$@"` non `$*`**: preserva gli spazi nei parametri con spazi interni.

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_operazioni_matematiche.md>)
- [➡️ successivo](<03_array_bash.md>)
