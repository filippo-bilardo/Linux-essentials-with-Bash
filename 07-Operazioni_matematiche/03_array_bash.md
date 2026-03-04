# Array in Bash

Gli array permettono di raggruppare più valori in un'unica variabile indicizzata. Bash supporta due tipi: **array indicizzati** (indice numerico, da 0) e **array associativi** (chiave stringa, Bash 4+).

---

## Array Indicizzati

### Creare e accedere agli elementi

```bash
# Definizione inline
frutti=("mela" "banana" "arancia" "kiwi")

# Accesso per indice (parte da 0)
echo "${frutti[0]}"      # mela
echo "${frutti[2]}"      # arancia

# Tutti gli elementi
echo "${frutti[@]}"      # mela banana arancia kiwi

# Numero di elementi
echo "${#frutti[@]}"     # 4

# Indici disponibili (utile con array "sparsi")
echo "${!frutti[@]}"     # 0 1 2 3
```

### Modificare un array

```bash
# Modifica elemento esistente
frutti[1]="pera"

# Aggiungere in fondo
frutti+=("uva")
frutti+=("ciliegia" "fico")

# Rimuovere un elemento (lascia un "buco" nell'indice)
unset frutti[2]

# Riassegnare tutto
frutti=("${frutti[@]}")   # compatta gli indici
```

### Iterare

```bash
# Iterare sui valori
for f in "${frutti[@]}"; do
    echo "  • $f"
done

# Iterare con indice
for i in "${!frutti[@]}"; do
    echo "[$i] ${frutti[$i]}"
done

# Slicing: elementi da indice 1, lunghezza 3
echo "${frutti[@]:1:3}"
```

---

## Usare `$@` come Array di Argomenti

`"$@"` si comporta esattamente come un array di tutti gli argomenti dello script:

```bash
#!/bin/bash
# args_come_array.sh

argomenti=("$@")

echo "Primo arg  : ${argomenti[0]}"
echo "Secondo arg: ${argomenti[1]}"
echo "Totale     : ${#argomenti[@]}"

# Elaborare dal secondo argomento in poi
echo "Dalla seconda posizione:"
for a in "${argomenti[@]:1}"; do
    echo "  $a"
done

# Passare solo i file (dal 2° in poi) a un'altra funzione
elabora_file() {
    echo "Elaboro: $1"
}
for file in "${argomenti[@]:1}"; do
    elabora_file "$file"
done
```

---

## Array Associativi (Dizionari)

Disponibili da **Bash 4** (`bash --version`). Vanno dichiarati esplicitamente.

```bash
declare -A capitali

# Assegnazione
capitali["Italia"]="Roma"
capitali["Francia"]="Parigi"
capitali["Germania"]="Berlino"
capitali["Spagna"]="Madrid"

# Accesso
echo "Capitale d'Italia: ${capitali["Italia"]}"

# Numero di chiavi
echo "Paesi: ${#capitali[@]}"

# Tutte le chiavi
echo "Chiavi: ${!capitali[@]}"

# Tutte le valori
echo "Valori: ${capitali[@]}"

# Iterare su chiavi e valori
for paese in "${!capitali[@]}"; do
    echo "$paese → ${capitali[$paese]}"
done

# Verificare se una chiave esiste
if [[ -v capitali["Italia"] ]]; then
    echo "Italia presente"
fi

# Rimuovere una chiave
unset capitali["Francia"]
```

---

## Pattern Pratici

### Raccogliere output di un comando in un array

```bash
# Tutti i file .sh nella directory corrente
mapfile -t script_files < <(find . -name "*.sh" -maxdepth 1)
echo "Script trovati: ${#script_files[@]}"
for f in "${script_files[@]}"; do
    echo "  $f"
done

# Leggere un file riga per riga in un array
mapfile -t righe < /etc/passwd
echo "Righe in /etc/passwd: ${#righe[@]}"
```

### Passare un array a una funzione

In Bash gli array non si passano direttamente: si usa `"${array[@]}"` o il nome (e si usa `nameref`):

```bash
stampa_array() {
    local -n ref=$1    # nameref: riferimento all'array originale (Bash 4.3+)
    for elem in "${ref[@]}"; do
        echo "  - $elem"
    done
}

colori=("rosso" "verde" "blu")
stampa_array colori
```

### Array come stack (LIFO)

```bash
stack=()

# push
stack+=("primo")
stack+=("secondo")
stack+=("terzo")

# pop
ultimo="${stack[-1]}"
unset 'stack[-1]'
echo "Rimosso: $ultimo"
echo "Stack: ${stack[@]}"
```

---

## Tabella Riepilogativa

| Sintassi | Significato |
|----------|-------------|
| `arr=(a b c)` | Definizione array |
| `${arr[i]}` | Elemento all'indice `i` |
| `${arr[@]}` | Tutti gli elementi |
| `${#arr[@]}` | Numero di elementi |
| `${!arr[@]}` | Tutti gli indici/chiavi |
| `${arr[@]:s:n}` | Slice: `n` elementi da `s` |
| `arr+=(x)` | Aggiunge `x` in fondo |
| `unset arr[i]` | Rimuove elemento `i` |
| `declare -A map` | Dichiara array associativo |
| `mapfile -t arr < file` | Legge file in array |

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<02_parametri_posizionali.md>)
- [➡️ successivo](<04_output_formattazione.md>)
