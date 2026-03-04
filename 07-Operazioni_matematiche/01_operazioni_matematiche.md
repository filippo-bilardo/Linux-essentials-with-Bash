# Operazioni Matematiche in Bash

## Aritmetica con `$(( ))`

La sintassi `$(( espressione ))` è il modo moderno e preferito per fare calcoli interi in Bash. È veloce, leggibile e non richiede comandi esterni.

```bash
a=10
b=3

echo "Somma:        $((a + b))"    # 13
echo "Differenza:   $((a - b))"    # 7
echo "Prodotto:     $((a * b))"    # 30
echo "Divisione:    $((a / b))"    # 3  (intera, troncata)
echo "Resto:        $((a % b))"    # 1  (modulo)
echo "Potenza:      $((a ** b))"   # 1000
```

### Assegnazione e incremento

```bash
n=5
((n++))         # post-incremento: n diventa 6
((++n))         # pre-incremento
((n += 3))      # n = n + 3
((n *= 2))      # n = n * 2
((n--))         # decremento

# Assegnazione diretta con risultato
risultato=$(( 5 * 8 + 3 ))
echo $risultato   # 43
```

### Usare `$(( ))` nelle condizioni

```bash
if (( $1 > 100 )); then
    echo "Valore grande"
fi

n=7
while (( n > 0 )); do
    printf "%d " $n
    ((n--))
done
echo ""
```

---

## Il Comando `let`

`let` esegue calcoli interi come effetto collaterale (non produce output, modifica la variabile).

```bash
let a=5+3           # a = 8
let "b = 10 * 2"    # b = 20 (virgolette necessarie con spazi)
let "c = a ** 2"    # c = 64

let a++             # incremento
let "a += 10"

# In una condizione (esce false se il risultato è 0)
let "5 > 3" && echo "vero"   # stampa "vero"
```

---

## Il Comando `expr`

`expr` era lo strumento originale per l'aritmetica in shell. È più prolisso e richiede spazi tra gli operatori.

```bash
expr 5 + 3          # 8
expr 10 \* 3        # 30  (\* perché * è un glob)
expr 10 / 3         # 3   (divisione intera)
expr 10 % 3         # 1

# Catturare il risultato
n=$(expr 7 + 5)
echo $n             # 12
```

> **Nota:** `expr` è ancora presente per compatibilità ma `$(( ))` è sempre preferito nei nuovi script.

---

## Calcoli in Virgola Mobile con `bc`

Bash gestisce solo interi. Per i decimali si usa `bc` (basic calculator):

```bash
# Impostare la precisione con scale
echo "scale=2; 10 / 3"    | bc   # 3.33
echo "scale=4; 22 / 7"    | bc   # 3.1428
echo "scale=6; sqrt(2)"   | bc -l  # 1.414213  (-l carica la libreria matematica)
echo "scale=4; s(1)"      | bc -l  # seno di 1 rad
echo "scale=4; 2^32"      | bc     # 4294967296

# In uno script
calcola() {
    echo "scale=$2; $1" | bc -l
}
calcola "sqrt(144)" 0    # 12
calcola "1.5 * 3.7" 2    # 5.55
```

### Funzioni matematiche in `bc -l`

| Funzione | Operazione |
|----------|-----------|
| `s(x)` | seno di x (radianti) |
| `c(x)` | coseno di x |
| `a(x)` | arcotangente di x |
| `l(x)` | logaritmo naturale |
| `e(x)` | e^x |
| `sqrt(x)` | radice quadrata |

---

## Riepilogo: Quando Usare Cosa

| Strumento | Tipo | Uso ideale |
|-----------|------|-----------|
| `$(( ))` | intero | calcoli semplici e veloci in script Bash |
| `let` | intero | incrementi, assegnazione senza output |
| `expr` | intero | compatibilità con sh (evitare in nuovi script) |
| `bc` | float | divisioni decimali, funzioni matematiche |

---

## Esempi Pratici

### Convertitore di temperatura

```bash
#!/bin/bash
read -p "Temperatura in Celsius: " celsius
fahrenheit=$(echo "scale=1; $celsius * 9/5 + 32" | bc)
echo "$celsius°C = $fahrenheit°F"
```

### Calcolo percentuale

```bash
totale=200
parte=45
percento=$(echo "scale=1; $parte * 100 / $totale" | bc)
echo "$parte su $totale = $percento%"
```

### Sommatore di argomenti

```bash
#!/bin/bash
somma=0
for n in "$@"; do
    (( somma += n ))
done
echo "Somma: $somma"
```

```bash
./sommatore.sh 3 7 12 8    # Somma: 30
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<../06-Introduzione_Scripting_Bash/03_strutture_controllo.md>)
- [➡️ successivo](<02_parametri_posizionali.md>)
