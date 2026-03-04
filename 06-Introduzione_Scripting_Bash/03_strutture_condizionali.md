# Strutture Condizionali

## Condizionale `if`

```bash
if [[ condizione ]]; then
    # comandi se vero
elif [[ altra_condizione ]]; then
    # comandi se la prima è falsa e questa è vera
else
    # comandi se tutte le condizioni sono false
fi
```

> La parola chiave `fi` chiude sempre il blocco `if` (è `if` al contrario).

---

## Test con `[[ ]]`

`[[ ]]` è la forma moderna e preferita in Bash. Non ha i problemi di quoting di `[ ]`.

### Confronto numerico

| Operatore | Significato |
|-----------|-------------|
| `-eq` | uguale (`==`) |
| `-ne` | diverso (`!=`) |
| `-lt` | minore di (`<`) |
| `-le` | minore o uguale (`<=`) |
| `-gt` | maggiore di (`>`) |
| `-ge` | maggiore o uguale (`>=`) |

```bash
eta=20
if [[ $eta -ge 18 ]]; then
    echo "Maggiorenne"
else
    echo "Minorenne"
fi
```

### Confronto stringhe

| Operatore | Significato |
|-----------|-------------|
| `==` | uguale |
| `!=` | diverso |
| `<` | alfabeticamente minore |
| `>` | alfabeticamente maggiore |
| `-z` | stringa vuota |
| `-n` | stringa non vuota |
| `=~` | corrispondenza regex |

```bash
colore="rosso"
if [[ $colore == "rosso" ]]; then
    echo "Il colore è rosso"
fi

if [[ -z "$nome" ]]; then
    echo "Nome non inserito"
fi

if [[ $email =~ ^[a-z]+@[a-z]+\.[a-z]+$ ]]; then
    echo "Email valida"
fi
```

### Test su file

| Operatore | Significato |
|-----------|-------------|
| `-e file` | esiste |
| `-f file` | esiste ed è un file regolare |
| `-d file` | esiste ed è una directory |
| `-r file` | è leggibile |
| `-w file` | è scrivibile |
| `-x file` | è eseguibile |
| `-s file` | esiste e ha dimensione > 0 |

```bash
if [[ -f "/etc/hosts" ]]; then
    echo "Il file esiste"
fi

if [[ ! -d ~/backup ]]; then
    mkdir ~/backup
    echo "Directory backup creata"
fi
```

### Operatori logici

```bash
if [[ $eta -ge 18 && $eta -le 65 ]]; then
    echo "Età lavorativa"
fi

if [[ $ext == "jpg" || $ext == "png" ]]; then
    echo "È un'immagine"
fi

if [[ ! -f "$file" ]]; then
    echo "File non trovato"
fi
```

---

## `if` con Espansione Aritmetica `(( ))`

Oltre a `[[ ]]`, Bash permette di usare direttamente `(( espressione ))` come condizione. Il blocco `if` è vero quando l'espressione ha valore **non zero**.

```bash
x=10
if (( x > 5 )); then
    echo "x è maggiore di 5"
fi
```

Con `(( ))` si usano gli operatori aritmetici standard (C-style), **senza** `-eq`, `-lt` ecc.:

| Operatore | Significato |
|-----------|-------------|
| `==` | uguale |
| `!=` | diverso |
| `<` | minore di |
| `<=` | minore o uguale |
| `>` | maggiore di |
| `>=` | maggiore o uguale |
| `%` | modulo (resto) |
| `&&` | AND logico |
| `\|\|` | OR logico |
| `!` | NOT logico |

```bash
n=7

# Verifica parità
if (( n % 2 == 0 )); then
    echo "$n è pari"
else
    echo "$n è dispari"
fi

# Intervallo
if (( n >= 1 && n <= 10 )); then
    echo "$n è tra 1 e 10"
fi

# Espressione sempre vera se non zero
if (( n )); then
    echo "n è diverso da zero"
fi
```

### Confronto tra `[[ ]]` e `(( ))` per i numeri

```bash
a=5

# Con [[ ]]: serve -gt, -lt ecc.
if [[ $a -gt 3 ]]; then echo "a > 3 (stile [[ ]])"; fi

# Con (( )): operatori matematici naturali
if (( a > 3 )); then echo "a > 3 (stile (( )))"; fi
```

> **Regola pratica:** usa `(( ))` per condizioni puramente numeriche/aritmetiche, `[[ ]]` per stringhe, file e regex.

---

## Il Comando `test`

`test` è il predecessore di `[[ ]]` ed è disponibile su ogni shell POSIX (non solo Bash). Esiste in due forme equivalenti:

```bash
test condizione
[ condizione ]     # nota: gli spazi attorno alle parentesi sono obbligatori
```

Restituisce **exit status 0** (vero) o **1** (falso), senza produrre output.

### Operatori numerici

```bash
test 5 -gt 3 && echo "vero"
[ 10 -eq 10 ] && echo "dieci uguale dieci"
[ 7 -lt 3 ]  || echo "7 non è minore di 3"
```

### Operatori su stringhe

| Operatore | Significato |
|-----------|-------------|
| `= o ==` | uguale |
| `!=` | diverso |
| `-z stringa` | stringa è vuota |
| `-n stringa` | stringa non è vuota |

```bash
nome="Alice"
[ -n "$nome" ] && echo "Nome presente: $nome"
[ -z "$nome" ] && echo "Nome vuoto"
[ "$nome" = "Alice" ] && echo "Ciao Alice!"
```

> Con `[ ]` è **obbligatorio** quotare le variabili (`"$var"`). Una variabile vuota non quotata causa errori di sintassi.

### Operatori su file

Identici a `[[ ]]`:

```bash
[ -f /etc/passwd ] && echo "file esiste"
[ -d /tmp ]        && echo "è una directory"
[ -r /etc/shadow ] || echo "non leggibile"
[ -s file.txt ]    && echo "file non vuoto"
```

### Operatori logici con `[ ]`

Con `[ ]` gli operatori logici **non** sono `&&`/`||` dentro le parentesi, ma `-a` (AND) e `-o` (OR), oppure si concatenano con `&&`/`||` fuori:

```bash
# Stile POSIX interno (sconsigliato: ambiguo con molti termini)
[ $a -gt 0 -a $a -lt 10 ] && echo "tra 0 e 10"

# Stile moderno: concatenazione esterna (preferito)
[ $a -gt 0 ] && [ $a -lt 10 ] && echo "tra 0 e 10"
```

### Quando usare `test` / `[ ]` vs `[[ ]]`

| Caratteristica | `test` / `[ ]` | `[[ ]]` |
|----------------|----------------|---------|
| Portabilità POSIX | ✅ sì | ❌ solo Bash/Zsh |
| Variabili non quotate | ⚠️ pericoloso | ✅ sicuro |
| Regex con `=~` | ❌ no | ✅ sì |
| Pattern glob con `==` | ❌ no | ✅ sì |
| AND/OR interni | `-a` / `-o` (deprecati) | `&&` / `\|\|` |

> **Regola:** in script Bash usa sempre `[[ ]]`. Usa `[ ]` o `test` solo se devi garantire compatibilità POSIX con altre shell come `sh` o `dash`.

---

## `case ... esac`

Ideale per menu e confronto di stringhe su pattern multipli:

```bash
read -p "Scegli (a/b/c): " scelta

case $scelta in
    a)
        echo "Hai scelto A"
        ;;
    b|B)
        echo "Hai scelto B (maiuscolo o minuscolo)"
        ;;
    c*)
        echo "Inizia con c"
        ;;
    [0-9])
        echo "Hai inserito un numero"
        ;;
    *)
        echo "Scelta non valida"
        ;;
esac
```

> Ogni caso termina con `;;`. Il caso `*)` è il default (catch-all).

### Menu interattivo con `case` e `while`

```bash
#!/bin/bash
while true; do
    echo ""
    echo "=== MENU ==="
    echo "1) Mostra data"
    echo "2) Mostra utente"
    echo "3) Elenco file"
    echo "q) Esci"
    read -p "Scelta: " scelta

    case $scelta in
        1) date ;;
        2) echo "Utente: $USER" ;;
        3) ls ;;
        q) echo "Arrivederci!"; break ;;
        *) echo "Opzione non valida" ;;
    esac
done
```

--- 

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<02_variabili.md>)
- [➡️ successivo](<04_strutture_iterative.md>)
