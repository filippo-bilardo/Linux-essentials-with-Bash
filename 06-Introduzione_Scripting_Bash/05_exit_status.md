# Exit Status e Comando `exit`

## Cos'è l'Exit Status

Ogni comando Unix/Linux, quando termina, restituisce un **numero intero** al processo che lo ha chiamato: è l'**exit status** (o codice di uscita).

| Valore | Significato convenzionale |
|--------|--------------------------|
| `0` | **successo** — il comando ha completato correttamente |
| `1` | errore generico |
| `2` | uso errato del comando (argomenti sbagliati) |
| `126` | il file esiste ma non è eseguibile |
| `127` | comando non trovato |
| `128+N` | terminato da segnale N (es. `130` = Ctrl+C, segnale 2) |
| `1-255` | qualsiasi valore != 0 indica un errore |

La variabile speciale **`$?`** contiene sempre l'exit status dell'**ultimo** comando eseguito:

```bash
ls /etc/passwd
echo $?        # 0 — successo

ls /file-inesistente 2>/dev/null
echo $?        # 2 — errore (file non trovato)

grep "root" /etc/passwd > /dev/null
echo $?        # 0 — pattern trovato

grep "xyz_inesistente" /etc/passwd > /dev/null
echo $?        # 1 — pattern non trovato
```

> **Attenzione:** `$?` viene sovrascritto da ogni comando. Salvarlo subito se serve dopo:
> ```bash
> cp file1 file2
> status=$?
> echo "Ho eseguito altri comandi..."
> echo "Exit status della copia: $status"
> ```

---

## Il Comando `exit`

`exit [N]` termina lo script restituendo il codice `N` al chiamante. Se `N` è omesso, ritorna l'exit status dell'ultimo comando eseguito.

```bash
#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Errore: nessun argomento" >&2
    exit 1          # esce con codice 1 (errore)
fi

echo "Argomento ricevuto: $1"
exit 0              # esce con codice 0 (successo)
```

### Convenzioni per i codici di uscita

```bash
#!/bin/bash
# Codici di errore con nomi significativi
readonly E_OK=0
readonly E_ARGS=1
readonly E_FILE=2
readonly E_PERM=3

if [[ $# -lt 2 ]]; then
    echo "Uso: $0 <sorgente> <destinazione>" >&2
    exit $E_ARGS
fi

if [[ ! -f "$1" ]]; then
    echo "Errore: '$1' non esiste" >&2
    exit $E_FILE
fi

if [[ ! -r "$1" ]]; then
    echo "Errore: '$1' non leggibile" >&2
    exit $E_PERM
fi

cp "$1" "$2"
exit $E_OK
```

### Verificare l'exit status da riga di comando

```bash
./mio_script.sh argomento
echo "Exit status: $?"

# Oppure direttamente con &&/||
./mio_script.sh file.txt && echo "OK" || echo "Fallito (codice $?)"
```

---

## `if` con un Comando Diretto

`if` in Bash non valuta solo `[[ ]]` o `(( ))`: esegue **qualsiasi comando** e usa il suo exit status come condizione. Il blocco `then` si esegue se l'exit status è **0**.

```
if comando; then
    # eseguito se exit status == 0 (successo)
fi
```

### Esempi pratici

```bash
# Verificare se un pacchetto è installato
if which git > /dev/null 2>&1; then
    echo "git è installato: $(git --version)"
else
    echo "git non trovato — installalo con: sudo apt install git"
fi
```

```bash
# grep restituisce 0 se trova il pattern, 1 se no
if grep -q "root" /etc/passwd; then
    echo "L'utente root esiste"
fi
```

```bash
# Creare la directory solo se non esiste
if ! mkdir -p ~/backup 2>/dev/null; then
    echo "Impossibile creare ~/backup" >&2
    exit 1
fi
echo "Directory ~/backup pronta"
```

```bash
# ping per verificare la connettività
if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
    echo "Rete disponibile"
else
    echo "Nessuna connessione a Internet"
fi
```

```bash
# Verificare se un servizio è in esecuzione (systemd)
if systemctl is-active --quiet nginx; then
    echo "nginx è attivo"
else
    echo "nginx non è in esecuzione"
    systemctl start nginx
fi
```

```bash
# Leggere l'exit status di una funzione
controlla_file() {
    [[ -f "$1" && -r "$1" ]]   # l'exit status è quello dell'ultimo [[ ]]
}

if controlla_file /etc/hosts; then
    echo "/etc/hosts è leggibile"
fi
```

### Shorthand con `&&` e `||`

Quando il blocco `then`/`else` è un solo comando, si può usare la forma compatta:

```bash
# && → esegui solo se il precedente ha successo (exit 0)
mkdir -p ~/logs && echo "Directory creata"

# || → esegui solo se il precedente ha fallito (exit != 0)
cd ~/progetto || { echo "Directory non trovata"; exit 1; }

# Catena completa
cp backup.tar.gz /mnt/disk/ && echo "Copia OK" || echo "Copia fallita"
```

> Le parentesi graffe `{ ...; }` nei blocchi `||` sono necessarie per raggruppare più comandi. Nota lo spazio dopo `{` e il `;` prima di `}`.

---

## `trap` — Gestire l'Uscita e i Segnali

`trap` permette di eseguire comandi quando lo script riceve un segnale o termina:

```bash
#!/bin/bash

# Pulizia eseguita sempre all'uscita (EXIT è un pseudo-segnale)
cleanup() {
    echo "Pulizia in corso..."
    rm -f /tmp/mio_script_$$*.tmp
}
trap cleanup EXIT

# Eseguire qualcosa anche in caso di interruzione (Ctrl+C)
trap 'echo "Interrotto dall utente"; exit 130' INT

# Il resto dello script
echo "Script in esecuzione (PID: $$)"
sleep 60
echo "Fine normale"
```

### Segnali comuni

| Segnale | Numero | Causa |
|---------|--------|-------|
| `EXIT` | — | uscita dello script (qualunque causa) |
| `INT` | 2 | Ctrl+C |
| `TERM` | 15 | `kill PID` |
| `ERR` | — | qualsiasi comando con exit status != 0 |

```bash
# Uscire subito al primo errore e mostrare dove
set -e                          # exit on error
trap 'echo "Errore alla riga $LINENO"' ERR

comando_che_puo_fallire
echo "Questo non viene eseguito se il precedente fallisce"
```

---

## Riepilogo

| Meccanismo | Scopo |
|------------|-------|
| `$?` | leggere l'exit status dell'ultimo comando |
| `exit N` | terminare lo script con codice `N` |
| `if comando` | branching basato sull'esito di un comando |
| `&&` / `\|\|` | shorthand condizionale su exit status |
| `trap` | hook su uscita e segnali |

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<04_strutture_iterative.md>)
- [➡️ successivo](<../07-Operazioni_matematiche/README.md>)
