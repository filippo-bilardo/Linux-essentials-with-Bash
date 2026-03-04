#!/bin/bash
# =============================================================================
# 01_matematica.sh
# Modulo 07 - Operazioni Matematiche in Bash
#
# Dimostra: $(( )), let, expr, bc, shift, array, parametri posizionali.
# Esecuzione: bash 01_matematica.sh
# =============================================================================

CIANO='\033[0;36m'
GIALLO='\033[1;33m'
VERDE='\033[0;32m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}--- $1 ---${RESET}\n"; }
cmd()    { echo -e "${GIALLO}\$ $1${RESET}"; eval "$1"; echo ""; }

# --- Aritmetica con $(( )) ---
titolo "1. Aritmetica con \$(( ))"
a=17
b=5
echo "a=$a, b=$b"
echo "Somma:      $((a + b))"
echo "Differenza: $((a - b))"
echo "Prodotto:   $((a * b))"
echo "Divisione:  $((a / b))  (intera)"
echo "Modulo:     $((a % b))"
echo "Potenza:    $((a ** b))"
echo ""

n=10
echo "n=$n"
((n++));  echo "Dopo n++:   n=$n"
((n+=5)); echo "Dopo n+=5:  n=$n"
((n*=2)); echo "Dopo n*=2:  n=$n"

# --- let ---
titolo "2. Il comando let"
let "x = 100"
let "y = x / 7"
let "z = x % 7"
echo "100 / 7 = $y  (resto $z)"
let "x++"
echo "x dopo incremento: $x"

# --- expr ---
titolo "3. expr (compatibilità storica)"
cmd "expr 42 + 8"
cmd "expr 100 \* 3"
cmd "expr 17 % 5"
risultato=$(expr 6 \* 7)
echo "6 × 7 = $risultato"

# --- bc per decimali ---
titolo "4. Calcoli in virgola mobile con bc"
cmd "echo 'scale=2; 22/7' | bc"
cmd "echo 'scale=4; sqrt(2)' | bc -l"
cmd "echo 'scale=6; 4*a(1)' | bc -l"   # pi greco

echo "Tabella di conversione Celsius → Fahrenheit:"
printf "%-8s | %-8s\n" "Celsius" "Fahrenheit"
printf "%-8s-+-%-8s\n" "--------" "----------"
for c in 0 10 20 25 37 100; do
    f=$(echo "scale=1; $c * 9/5 + 32" | bc)
    printf "%-8d | %-8s\n" $c $f
done

# --- Parametri posizionali simulati ---
titolo "5. Variabili speciali e array"
frutti=("mela" "banana" "arancia" "kiwi" "pera")
echo "Array: ${frutti[@]}"
echo "Lunghezza: ${#frutti[@]}"
echo "Elemento [2]: ${frutti[2]}"

echo ""
echo "Iterazione:"
for f in "${frutti[@]}"; do
    printf "  • %s\n" "$f"
done

echo ""
echo "Slicing [1..3]:"
echo "${frutti[@]:1:3}"

# Array modifiche
frutti+=("uva")
echo ""
echo "Dopo aggiunta 'uva': ${frutti[@]}"
unset frutti[1]
echo "Dopo rimozione [1]:  ${frutti[@]}"

# --- shift demo ---
titolo "6. Dimostrazione shift"
demo_shift() {
    local args=("$@")
    echo "Argomenti: ${args[*]}"
    # simuliamo shift su una funzione
    echo "set -- ${args[*]}"
    set -- "${args[@]}"
    echo "Prima di shift: \$1=$1  \$#=$#"
    shift
    echo "Dopo shift:     \$1=$1  \$#=$#"
    shift 2
    echo "Dopo shift 2:   \$1=$1  \$#=$#"
}
demo_shift alfa beta gamma delta epsilon

# --- Calcoli con argomenti ---
titolo "7. Somma e statistiche su numeri"
numeri=(15 8 42 3 99 7 55 21 36 14)
echo "Numeri: ${numeri[@]}"

somma=0
massimo=${numeri[0]}
minimo=${numeri[0]}

for n in "${numeri[@]}"; do
    ((somma += n))
    (( n > massimo )) && massimo=$n
    (( n < minimo ))  && minimo=$n
done

media=$(echo "scale=2; $somma / ${#numeri[@]}" | bc)
echo "Somma:   $somma"
echo "Media:   $media"
echo "Massimo: $massimo"
echo "Minimo:  $minimo"

echo -e "\n${VERDE}Demo completata!${RESET}"
