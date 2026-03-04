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

### Operatori bitwise

Bash supporta anche operazioni a livello di bit, utili per manipolare dati binari:

```bash
#!/bin/bash
# Operatori bitwise

a=42   # 101010 in binario
b=27   # 011011 in binario

echo "AND bitwise: $((a & b)) = 10"  # 001010 in binario
echo "OR bitwise: $((a | b)) = 59"   # 111011 in binario
echo "XOR bitwise: $((a ^ b)) = 49"  # 110001 in binario
echo "NOT bitwise di a: $(( ~a ))"    # Negazione bit a bit
echo "Shift left di a: $((a << 1)) = 84"   # Sposta di 1 bit a sinistra
echo "Shift right di a: $((a >> 1)) = 21"  # Sposta di 1 bit a destra
```

### Operatori logici e di confronto

All'interno dell'espansione aritmetica, gli operatori di confronto restituiscono 1 per vero e 0 per falso:

```bash
#!/bin/bash
# Operatori di confronto e logici

a=10
b=20

echo "a == b: $((a == b))"  # 0 (falso)
echo "a != b: $((a != b))"  # 1 (vero)
echo "a < b: $((a < b))"    # 1 (vero)
echo "a <= b: $((a <= b))"  # 1 (vero)
echo "a > b: $((a > b))"    # 0 (falso)
echo "a >= b: $((a >= b))"  # 0 (falso)

# Operatori logici
echo "a < 5 E b > 15: $(( (a < 5) && (b > 15) ))"  # 0 (falso)
echo "a < 5 O b > 15: $(( (a < 5) || (b > 15) ))"  # 1 (vero)
echo "NOT (a < 5): $(( !(a < 5) ))"                # 1 (vero)
```
---

## Limiti dell'aritmetica in Bash

È importante comprendere che l'aritmetica in Bash ha alcuni limiti significativi:

### Precisione intera

Bash lavora solo con numeri interi. Non c'è supporto nativo per numeri a virgola mobile o decimali:

```bash
#!/bin/bash
# Limitazioni con numeri decimali

# Questo non funziona come previsto in Bash
risultato=$((10 / 3))
echo "10 / 3 = $risultato"  # Output: 3 (la parte decimale viene troncata)

# Workaround con il comando bc per calcoli decimali
if command -v bc &>/dev/null; then
    risultato_decimale=$(echo "scale=2; 10 / 3" | bc)
    echo "10 / 3 = $risultato_decimale (usando bc)"  # Output: 3.33
fi
```

### Intervallo di numeri

Bash può gestire numeri fino a un certo limite, che dipende dalla piattaforma (generalmente 64 bit nelle installazioni moderne):

```bash
#!/bin/bash
# Limiti dell'intervallo numerico

# Mostra il valore massimo intero
max_int=$((2**63 - 1))  # Su sistemi a 64 bit
echo "Massimo intero rappresentabile: $max_int"

# Overflow
echo "Tentativo di overflow: $((max_int + 1))"
```

## Variabili in espressioni aritmetiche

Una delle caratteristiche più utili dell'espansione aritmetica è la facilità con cui è possibile utilizzare variabili nelle espressioni:

```bash
#!/bin/bash
# Utilizzo di variabili in espressioni aritmetiche

base=10
altezza=5

# Calcolo area rettangolo
area=$((base * altezza))
echo "Area del rettangolo: $area"

# Calcolo perimetro rettangolo
perimetro=$((2 * (base + altezza)))
echo "Perimetro del rettangolo: $perimetro"

# Utilizzo di variabili calcolate
lato_maggiore=$((base > altezza ? base : altezza))
echo "Lato maggiore: $lato_maggiore"
```

## Espressioni aritmetiche nelle strutture di controllo

Le espressioni aritmetiche sono particolarmente utili nelle strutture di controllo come cicli e condizioni.

### In condizioni if

```bash
#!/bin/bash
# Espressioni aritmetiche in condizioni if

eta=25

if (( eta >= 18 )); then
    echo "Sei maggiorenne"
else
    echo "Sei minorenne"
fi

# Condizioni più complesse
punteggio=85
if (( punteggio >= 90 )); then
    echo "Voto: A"
elif (( punteggio >= 80 )); then
    echo "Voto: B"
elif (( punteggio >= 70 )); then
    echo "Voto: C"
else
    echo "Voto: D"
fi
```

### In cicli for e while

```bash
#!/bin/bash
# Espressioni aritmetiche nei cicli

# Ciclo for con contatore
echo "Ciclo for aritmetico:"
for (( i=1; i<=5; i++ )); do
    echo "Iterazione $i"
done

# Ciclo while aritmetico
echo "Ciclo while aritmetico:"
contatore=5
while (( contatore > 0 )); do
    echo "Conto alla rovescia: $contatore"
    (( contatore-- ))
done
```

## Operatore ternario

Bash supporta anche l'operatore ternario `?:` per espressioni condizionali compatte:

```bash
#!/bin/bash
# Operatore ternario

temperatura=25
messaggio=$((temperatura > 30 ? "fa caldo" : "temperatura gradevole"))
echo "Oggi $messaggio"

# Può essere nidificato
punteggio=75
voto=$((punteggio >= 90 ? "A" : (punteggio >= 80 ? "B" : (punteggio >= 70 ? "C" : "D"))))
echo "Il tuo voto è $voto"
```


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
- [⬅️ precedente](<../06-Introduzione_Scripting_Bash/05_exit_status.md>)
- [➡️ successivo](<02_parametri_posizionali.md>)
