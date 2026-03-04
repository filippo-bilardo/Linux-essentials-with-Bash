# Strutture Iterative

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

### `break N` e `continue N` — cicli annidati

Con un numero opzionale si può uscire da più livelli di ciclo annidati:

```bash
for i in {1..3}; do
    for j in {1..3}; do
        if [[ $j -eq 2 ]]; then
            continue 2    # salta all'iterazione successiva del ciclo esterno
        fi
        echo "$i,$j"
    done
done
# stampa: 1,1  2,1  3,1
```

---

## Riepilogo: scegliere il ciclo giusto

| Ciclo | Usarlo quando… |
|-------|---------------|
| `for … in lista` | conosci la lista su cui iterare |
| `for ((C-style))` | serve un contatore numerico con passo personalizzato |
| `while condizione` | vuoi continuare finché una condizione è vera |
| `until condizione` | vuoi continuare finché una condizione è falsa |
| `while true + break` | loop interattivo o server loop, uscita condizionale |

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<03_strutture_condizionali.md>)
- [➡️ successivo](<05_exit_status.md>)
