# Strutture di Controllo

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

## Ciclo `for`

### Iterare su una lista

```bash
for frutto in mela banana arancia kiwi; do
    echo "Frutto: $frutto"
done
```

### Range numerico

```bash
for i in {1..5}; do
    echo "Iterazione $i"
done

# Con incremento
for i in {0..20..5}; do    # 0 5 10 15 20
    echo $i
done
```

### Stile C (come in C/Java)

```bash
for ((i=0; i<5; i++)); do
    echo "i = $i"
done
```

### Iterare su file

```bash
for file in *.sh; do
    echo "Trovato script: $file"
    chmod +x "$file"
done
```

### Iterare su output di un comando

```bash
for utente in $(awk -F: '$3>=1000 {print $1}' /etc/passwd); do
    echo "Utente reale: $utente"
done
```

---

## Ciclo `while`

```bash
contatore=1
while [[ $contatore -le 5 ]]; do
    echo "Conta: $contatore"
    ((contatore++))
done
```

### Leggere un file riga per riga

```bash
while IFS= read -r riga; do
    echo ">>> $riga"
done < /etc/hosts
```

### Loop infinito con `break`

```bash
while true; do
    read -p "Comando (q per uscire): " cmd
    if [[ $cmd == "q" ]]; then
        break
    fi
    echo "Hai scritto: $cmd"
done
```

---

## Ciclo `until`

Esegue il blocco finché la condizione è **falsa** (l'opposto di `while`):

```bash
n=0
until [[ $n -ge 5 ]]; do
    echo $n
    ((n++))
done
```

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

### Menu interattivo con case e while

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

## `break` e `continue`

```bash
for i in {1..10}; do
    if [[ $i -eq 5 ]]; then
        continue    # salta l'iterazione 5
    fi
    if [[ $i -eq 8 ]]; then
        break       # esce dal ciclo a 8
    fi
    echo $i
done
# stampa: 1 2 3 4 6 7
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<02_variabili.md>)
- [➡️ successivo](<../07-Operazioni_Matematiche_Stringhe/README.md>)
