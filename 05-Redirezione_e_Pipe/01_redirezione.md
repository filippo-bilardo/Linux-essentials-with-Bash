# Redirezione di Input e Output

## I Tre Canali Standard

In Linux ogni processo comunica attraverso tre canali predefiniti:

| Canale | Nome | Numero | Descrizione |
|--------|------|--------|-------------|
| **stdin** | Standard Input | `0` | dati in ingresso (di solito la tastiera) |
| **stdout** | Standard Output | `1` | output normale (di solito il terminale) |
| **stderr** | Standard Error | `2` | messaggi di errore (di solito il terminale) |

```
           ┌────────────┐
stdin ──0──►            ├──1──► stdout
           │  programma │
           │            ├──2──► stderr
           └────────────┘
```

Normalmente sia stdout che stderr appaiono sullo stesso terminale. La **redirezione** permette di inviare questi canali altrove.

---

## Redirezione di stdout

### Sovrascrittura: `>`

```bash
echo "Ciao mondo" > saluto.txt      # crea saluto.txt (o sovrascrive se esiste)
ls /etc > lista_etc.txt              # salva l'output di ls in un file
date > timestamp.txt
```

> **Attenzione:** `>` sovrascrive sempre il file. Se il file contiene dati importanti, usa `>>`.

### Aggiunta: `>>`

```bash
echo "Prima riga"  > note.txt       # crea il file
echo "Seconda riga" >> note.txt     # aggiunge senza sovrascrivere
echo "Terza riga"   >> note.txt
cat note.txt
# Prima riga
# Seconda riga
# Terza riga
```

### Applicazione pratica: log con timestamp

```bash
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Avvio script" >> ~/mio_log.txt
```

---

## Redirezione di stderr

I messaggi di errore vanno su **stderr** (canale 2), non su stdout.

```bash
ls /cartella_inesistente             # l'errore appare sul terminale
ls /cartella_inesistente 2> errore.txt   # l'errore va nel file
ls /cartella_inesistente 2>> errori.log  # aggiunge l'errore al log
```

### Ignorare gli errori con `/dev/null`

`/dev/null` è un dispositivo speciale che scarta tutto ciò che gli viene inviato.

```bash
ls /cartella_inesistente 2> /dev/null    # ignora l'errore
find / -name "*.conf" 2> /dev/null       # cerca senza mostrare "Permission denied"
```

---

## Redirigere stdout e stderr insieme

### `2>&1` — stderr verso stdout

```bash
# Prima redirige stdout su file, poi stderr sullo stesso canale di stdout
ls /esiste /non_esiste > output.txt 2>&1
cat output.txt   # contiene sia l'output normale che gli errori
```

### `&>` — sintassi abbreviata (Bash 4+)

```bash
ls /esiste /non_esiste &> tutto.txt      # equivale a > tutto.txt 2>&1
```

### Separare stdout da stderr

```bash
comando > output.txt 2> errori.txt       # output e errori in file separati
```

---

## Redirezione di stdin: `<`

Il simbolo `<` fa leggere il programma da un file invece che dalla tastiera.

```bash
# sort legge da tastiera di default
sort < frutti.txt           # legge dal file

# wc conta le righe di un file
wc -l < /etc/passwd

# Passare input a un programma interattivo
cat < messaggio.txt         # cat legge dal file
```

Combinazione con stdout:

```bash
sort < input.txt > output_ordinato.txt
```

---

## Here-Document: `<<`

Permette di fornire blocchi di testo come stdin direttamente nello script.

```bash
cat << FINE
Questa è la prima riga
Questa è la seconda riga
Puoi includere $variabili normalmente
FINE
```

La parola delimitatrice può essere qualsiasi parola (convenzione: `EOF`, `FINE`, `END`).

```bash
# Creare file con contenuto su più righe
cat > config.txt << EOF
host=localhost
porta=8080
debug=true
EOF
```

### Here-Document senza espansione di variabili

Metti il delimitatore tra virgolette singole o usa `\` per disabilitare l'espansione:

```bash
cat << 'EOF'
La variabile $HOME non viene espansa qui
EOF
```

---

## Here-String: `<<<`

Passa una singola stringa come stdin (più compatto di here-doc per stringhe brevi):

```bash
grep "bash" <<< "utente:x:1000:1000::/home/utente:/bin/bash"

# Equivalente a:
echo "utente:x:1000:1000::/home/utente:/bin/bash" | grep "bash"

# Calcolare con bc tramite here-string
bc <<< "2^10"   # 1024
```

---

## Riepilogo Operatori

| Operatore | Azione |
|-----------|--------|
| `> file` | stdout → file (sovrascrive) |
| `>> file` | stdout → file (aggiunge) |
| `< file` | file → stdin |
| `2> file` | stderr → file |
| `2>> file` | stderr → file (aggiunge) |
| `2>&1` | stderr → stesso canale di stdout |
| `&> file` | stdout+stderr → file |
| `> /dev/null` | scarta stdout |
| `2> /dev/null` | scarta stderr |
| `<< DELIM` | here-document |
| `<<< stringa` | here-string |

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<../04-Visualizzazione_e_Ricerca/05_estrazione_dati.md>)
- [➡️ successivo](<02_pipe.md>)
