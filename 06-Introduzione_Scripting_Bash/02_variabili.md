# Variabili, tipi di dati e input in Bash

## Variabili Scalari

In Bash le variabili non hanno un tipo fisso — contengono stringhe di testo.

### Assegnazione

```bash
nome="Alice"           # nessuno spazio attorno a =
eta=25
percorso=/home/alice
messaggio="Ciao $nome"
```

> **Regola fondamentale:** nessuno spazio attorno al segno `=`  
> `nome = "Alice"` — ERRORE  
> `nome="Alice"` — CORRETTO

### Lettura (espansione)

```bash
echo $nome             # stampa: Alice
echo "$nome"           # preferito: le virgolette proteggono da spazi
echo "${nome}!"        # delimitare esplicitamente: Alice!
```

### Buone pratiche con le virgolette

| Sintassi | Comportamento |
|----------|---------------|
| `"$var"` | espande la variabile, protegge gli spazi |
| `'$var'` | non espande nulla, tratta tutto come testo |
| `$var` | pericoloso se var contiene spazi |

```bash
file="nome con spazi.txt"
cat $file          # errore: interpreta come 3 argomenti
cat "$file"        # corretto: un solo argomento
```

---

## Quoting

Il **quoting** controlla come Bash interpreta i caratteri speciali. È uno dei concetti più importanti per scrivere script robusti e privi di bug.

### Tre tipi di quoting

#### Doppi apici `"..."` — quoting parziale

Espandono variabili e command substitution, ma proteggono spazi e la maggior parte dei caratteri speciali:

```bash
nome="Mario Rossi"
echo "$nome"           # Mario Rossi  (una sola parola per Bash)
echo "Ciao $nome!"     # Ciao Mario Rossi!
echo "Home: $HOME"     # Home: /home/utente
echo "Data: $(date)"   # Data: Wed Mar  4 10:00:00 UTC 2026

# I caratteri ancora espansi dentro "...":
# $var  ${var}  $(cmd)  `cmd`  \n  \\
```

#### Singoli apici `'...'` — quoting totale (letterale)

Tutto ciò che è dentro viene trattato come stringa letterale. Nessuna espansione, nessun carattere speciale:

```bash
echo '$HOME'           # $HOME  (letterale, non espande)
echo 'Ciao $nome!'     # Ciao $nome!
echo '$(date)'         # $(date)  (non eseguito)
echo 'It'\''s fine'    # It's fine  (unico modo per inserire ' dentro '...')
```

> Non esiste un modo per inserire un singolo apice all'interno di `'...'`. La tecnica è chiudere, aggiungere `\'`, riaprire: `'It'\''s fine'`

#### Backslash `\` — escape di un singolo carattere

Impedisce l'interpretazione del carattere immediatamente successivo:

```bash
echo \$HOME            # $HOME  (letterale)
echo "prezzo: \$5"     # prezzo: $5
echo "riga1\nriga2"    # riga1\nriga2  (echo senza -e non espande \n)
echo -e "riga1\nriga2" # riga1 (newline) riga2

# Escape del newline: continua il comando sulla riga successiva
cp file_sorgente.txt \
   /destinazione/file.txt
```

---

### Word Splitting — perché le virgolette contano

Bash divide l'output non quotato in "parole" usando i caratteri in `$IFS` (default: spazio, tab, newline):

```bash
nomi="Alice Bob Carlo"

# Senza virgolette: word splitting → 3 argomenti separati
for n in $nomi; do echo "  → $n"; done
# → Alice
# → Bob
# → Carlo

# Con virgolette: una sola stringa
for n in "$nomi"; do echo "  → $n"; done
# → Alice Bob Carlo  (un'unica iterazione)
```

Questo è critico con nomi di file che contengono spazi:

```bash
file="Il mio documento.txt"

rm $file       # tenta di rimuovere "Il", "mio" e "documento.txt" — SBAGLIATO
rm "$file"     # rimuove correttamente "Il mio documento.txt"
```

---

### Glob Expansion — quoting e wildcard

Le virgolette disabilitano anche l'espansione dei glob (`*`, `?`, `[...]`):

```bash
echo *.sh           # elenca tutti i file .sh nella directory corrente
echo "*.sh"         # stampa letteralmente *.sh
echo '*.sh'         # stampa letteralmente *.sh

# Utile per passare un pattern letterale a grep o find:
grep "*.log" file.txt           # cerca la stringa *.log, non i file
find . -name "*.sh"             # il glob è espanso da find, non da Bash
```

---

### ANSI-C Quoting `$'...'`

Permette di usare sequenze di escape stile C all'interno delle virgolette:

```bash
echo $'riga1\nriga2'      # riga1 (newline) riga2
echo $'tab\there'         # tab (TAB) here
echo $'bell\a'            # suono del campanello
echo $'ciao\tmondo'       # ciao    mondo

# Utile per caratteri speciali in variabili
sep=$'\t'                 # variabile contenente un TAB
echo -e "a${sep}b"        # a   b
```

---

### Regole pratiche

| Situazione | Soluzione |
|------------|-----------|
| Variabile con possibili spazi | `"$var"` |
| Stringa letterale senza espansione | `'testo'` |
| Pattern per grep/sed/awk | `'pattern'` |
| Sequenze escape (`\n`, `\t`) | `$'...'` oppure `echo -e "..."` |
| Percorso con spazi | `"$percorso"` |
| Argomenti a ciclo `for` | `for x in "$@"` |
| Nome file dinamico | `"${dir}/${file}"` |

> **Regola d'oro:** quota sempre le variabili con `"$var"` a meno che tu non voglia esplicitamente il word splitting o la glob expansion.

---

## Variabili Speciali

| Variabile | Significato |
|-----------|-------------|
| `$0` | nome dello script |
| `$1` … `$9` | parametri posizionali (argomenti passati allo script) |
| `${10}` `${11}` | parametri oltre il 9° (servono le graffe) |
| `$#` | numero di argomenti |
| `$@` | tutti gli argomenti come lista separata |
| `$*` | tutti gli argomenti come una stringa unica |
| `$?` | exit status dell'ultimo comando |
| `$$` | PID del processo corrente |
| `$!` | PID dell'ultimo processo in background |

```bash
#!/bin/bash
# Salva come: info_args.sh
echo "Script: $0"
echo "Numero argomenti: $#"
echo "Primo: $1, Secondo: $2"
echo "Tutti: $@"
```

```bash
./info_args.sh ciao mondo foo
# Script: ./info_args.sh
# Numero argomenti: 3
# Primo: ciao, Secondo: mondo
# Tutti: ciao mondo foo
```

---

## Variabili d'Ambiente

Le variabili d'ambiente sono disponibili globalmente e passate ai processi figli.

```bash
echo $HOME       # /home/utente
echo $USER       # nomeutente
echo $PATH       # /usr/local/bin:/usr/bin:/bin:...
echo $SHELL      # /bin/bash
echo $PWD        # directory corrente
echo $LANG       # it_IT.UTF-8 o simile
```

### Esportare una variabile

```bash
MIA_VAR="valore"
export MIA_VAR     # ora è visibile ai processi figli

# Alternativa compatta
export ALTRA="testo"

# Visualizzare tutte le variabili d'ambiente
printenv | head -20
env | grep HOME
```

---

## Operazioni sulle Variabili

### Valore di default

```bash
echo ${nome:-"sconosciuto"}     # usa "sconosciuto" se nome è vuoto
echo ${file:-/etc/default.conf} # usa il path default se file non è impostato
```

### Lunghezza di una stringa

```bash
testo="Ciao mondo"
echo ${#testo}        # 10
```

### Sostituzione di testo nella variabile

```bash
file="documento.txt"
echo ${file%.txt}     # rimuove .txt dal fondo → documento
echo ${file/.txt/.md} # sostituisce .txt con .md → documento.md
```

### Estrarre sottostringa

```bash
testo="Linux Bash Scripting"
echo ${testo:6:4}     # 4 caratteri dall'indice 6 → Bash
echo ${testo:6}       # dal carattere 6 in poi → Bash Scripting
```

---

## Tipi di Dati e `declare`

Bash è un linguaggio a **tipizzazione debole**: ogni variabile è di default una stringa di testo. Tuttavia, il comando `declare` permette di aggiungere attributi che modificano il comportamento della variabile.

### Tipi di dati usati internamente da Bash

A differenza di linguaggi come C o Java, Bash non ha un sistema di tipi esplicito. Internamente riconosce tuttavia le seguenti categorie:

| Tipo | Rappresentazione interna | Note |
|------|--------------------------|------|
| **Stringa** | sequenza di caratteri | Tipo di default; qualsiasi valore è una stringa se non diversamente dichiarato |
| **Intero** | valore numerico intero (a 64 bit con segno su sistemi a 64-bit) | Abilitato con `declare -i`; non c'è overflow controllato, i valori "wrappano" |
| **Array indicizzato** | lista ordinata di stringhe con indice numerico (0-based) | Dichiarato con `declare -a` o con la sintassi `arr=(...)` |
| **Array associativo** | mappa chiave→valore, entrambi stringhe | Richiede `declare -A`; disponibile da Bash 4.0 |
| **Nameref** | riferimento (alias) a un'altra variabile | Dichiarato con `declare -n`; il valore è il nome della variabile puntata |
| **Sola lettura** | qualsiasi tipo reso immutabile | Attributo aggiuntivo applicabile con `declare -r` o `readonly` |
| **Esportata** | variabile disponibile ai sottoprocessi | Attributo aggiuntivo (`declare -x` o `export`); il valore resta stringa |

> **Nessun tipo floating point nativo.** Bash non supporta aritmetica in virgola mobile.
> Per calcoli decimali usa il comando esterno `bc` o `awk`:
> ```bash
> echo "scale=4; 22/7" | bc          # 3.1428
> awk 'BEGIN { printf "%.4f\n", 22/7 }'  # 3.1429
> ```

> **Nessun tipo booleano nativo.** Le condizioni si basano sull'**exit status**:
> `0` = vero (successo), qualsiasi altro valore = falso. Le variabili vengono
> trattate come stringa vuota (falso) o non vuota (vero) nei test con `[[ ]]`.

### Panoramica degli attributi `declare`

| Flag | Tipo / Effetto |
|------|---------------|
| `-i` | **intero** — espressioni aritmetiche assegnate automaticamente |
| `-r` | **sola lettura** — non modificabile dopo l'assegnazione |
| `-l` | **lowercase** — converte in minuscolo ad ogni assegnazione |
| `-u` | **uppercase** — converte in maiuscolo ad ogni assegnazione |
| `-a` | **array indicizzato** |
| `-A` | **array associativo** (Bash 4+) |
| `-n` | **nameref** — riferimento a un'altra variabile |
| `-x` | **export** — equivale a `export` |
| `-p` | **print** — stampa il tipo e il valore corrente |

### Intero (`-i`)

```bash
declare -i contatore=0
contatore+=1          # aggiunge 1 aritmeticamente (non concatena)
contatore+=1
echo $contatore       # 2

declare -i n
n="5 * 3"             # viene valutato come espressione
echo $n               # 15

# Senza -i, la stessa assegnazione è una stringa:
x="5 * 3"
echo $x               # 5 * 3  (stringa letterale)
```

> Con `-i` i confronti e le operazioni aritmetiche diventano impliciti. Senza, bisogna usare `$(( ))` o `let`.

### Sola Lettura (`-r`)

```bash
declare -r PI=3.14159
echo $PI              # 3.14159
PI=3                  # bash: PI: readonly variable (errore)

# Equivalente compatto
readonly VERSIONE="1.0"
VERSIONE="2.0"        # errore
```

### Maiuscolo / Minuscolo (`-u` / `-l`)

```bash
declare -u SIGLA
SIGLA="ciao"
echo $SIGLA            # CIAO  (sempre convertito in maiuscolo)

declare -l nome_lower
nome_lower="MARIO ROSSI"
echo $nome_lower       # mario rossi
```

### Nameref (`-n`) — riferimento indiretto

```bash
declare -n ref=contatore    # ref è un alias di contatore
contatore=42
echo $ref                   # 42
ref=100
echo $contatore             # 100  (modificato tramite alias)
```

Utile per passare array a funzioni per nome:

```bash
stampa_info() {
    declare -n arr=$1       # riferimento all'array passato per nome
    echo "Elementi: ${#arr[@]}"
    for e in "${arr[@]}"; do echo "  - $e"; done
}

frutti=("mela" "pera" "kiwi")
stampa_info frutti
```

### Ispezionare una variabile con `-p`

```bash
declare -i punteggio=10
declare -p punteggio
# declare -i punteggio="10"

declare -r CONF="/etc/app.conf"
declare -p CONF
# declare -r CONF="/etc/app.conf"

declare -p HOME
# declare -x HOME="/home/utente"   (è anche esportata)
```

### `declare` senza flag — comportamento stringa

Quando non si usa `declare`, Bash tratta tutto come stringa; le operazioni aritmetiche richiedono `$(( ))`:

```bash
a="10"
b="20"
echo $((a + b))        # 30  — aritmetica esplicita
echo "$a + $b"         # 10 + 20  — concatenazione stringa

# Test numerico
if [[ $a -lt $b ]]; then
    echo "$a è minore di $b"
fi
```

### Riepilogo: scegliere il tipo giusto

| Situazione | Soluzione |
|------------|-----------|
| Contatore / somma | `declare -i` oppure `$(( ))` |
| Costante di configurazione | `declare -r` oppure `readonly` |
| Normalizzare input utente | `declare -l` / `declare -u` |
| Passare array a funzioni | `declare -n` (nameref) |
| Lista di elementi | `declare -a` (array) |
| Dizionario chiave-valore | `declare -A` (associativo) |

---

## Input Interattivo: `read`

```bash
#!/bin/bash
read -p "Inserisci il tuo nome: " nome
echo "Ciao, $nome!"

read -p "Quanti anni hai? " eta
echo "Tra 10 anni ne avrai $((eta + 10))"
```

### Opzioni di `read`

| Opzione | Significato |
|---------|-------------|
| `-p "testo"` | stampa un prompt prima di leggere |
| `-s` | modalità silenziosa (per password) |
| `-n N` | legge solo N caratteri |
| `-t N` | timeout di N secondi |
| `-r` | non interpreta il backslash `\` |

```bash
read -s -p "Password: " pwd
echo ""   # newline dopo la password nascosta
echo "Password inserita (lunghezza): ${#pwd}"

read -t 10 -p "Hai 10 secondi per rispondere: " risposta
```

### Leggere più valori

```bash
read -p "Inserisci nome cognome: " nome cognome
echo "Nome: $nome — Cognome: $cognome"

# Leggere una riga da file con while read
while IFS=',' read -r campo1 campo2 campo3; do
    echo "Prodotto: $campo1, Quantità: $campo2, Prezzo: $campo3"
done < inventario.csv
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_primo_script.md>)
- [➡️ successivo](<03_strutture_condizionali.md>)
