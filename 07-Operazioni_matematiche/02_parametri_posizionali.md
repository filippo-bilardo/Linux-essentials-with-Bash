# Parametri Posizionali, Shift e Array

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

---

## Array in Bash

Gli array permettono di raggruppare più valori in un'unica struttura.

### Creare e usare un array

```bash
# Definizione
frutti=("mela" "banana" "arancia" "kiwi")

# Accesso per indice (parte da 0)
echo "${frutti[0]}"      # mela
echo "${frutti[2]}"      # arancia

# Tutti gli elementi
echo "${frutti[@]}"      # mela banana arancia kiwi

# Numero di elementi
echo "${#frutti[@]}"     # 4

# Modifica
frutti[1]="pera"

# Aggiungere in fondo
frutti+=("uva")
frutti+=("ciliegia" "fico")

# Rimuovere un elemento
unset frutti[2]

# Iterare
for f in "${frutti[@]}"; do
    echo "  • $f"
done
```

### Usare gli argomenti `$@` come array

```bash
#!/bin/bash
# $@ si comporta come un array di argomenti
argomenti=("$@")
echo "Primo: ${argomenti[0]}"
echo "Totale: ${#argomenti[@]}"

# Slicing: dal 2° in poi
for a in "${argomenti[@]:1}"; do
    echo "Arg: $a"
done
```

### Array associativi (dizionari)

Disponibili da Bash 4:

```bash
declare -A capitali
capitali["Italia"]="Roma"
capitali["Francia"]="Parigi"
capitali["Germania"]="Berlino"

echo "${capitali["Italia"]}"    # Roma

# Iterare su chiavi e valori
for paese in "${!capitali[@]}"; do
    echo "$paese → ${capitali[$paese]}"
done
```

---

## Pattern: Script con Argomenti Opzionali

```bash
#!/bin/bash
# Uso: ./processa.sh [-v] file1 [file2 ...]
VERBOSE=0

if [[ "$1" == "-v" ]]; then
    VERBOSE=1
    shift    # consuma il flag, $2 diventa $1
fi

if [[ $# -eq 0 ]]; then
    echo "Uso: $0 [-v] file1 [file2 ...]" >&2
    exit 1
fi

for file in "$@"; do
    [[ $VERBOSE -eq 1 ]] && echo "Processo: $file"
    [[ -f "$file" ]] && wc -l "$file"
done
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_operazioni_matematiche.md>)
- [➡️ successivo](<03_output_formattazione.md>)
