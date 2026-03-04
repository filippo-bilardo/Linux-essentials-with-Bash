# Variabili e Input

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
- [➡️ successivo](<03_strutture_controllo.md>)
