# Il Primo Script Bash

## Cos'è uno Script?

Uno script Bash è un file di testo che contiene una sequenza di comandi da eseguire in ordine. Invece di digitare i comandi uno per uno nel terminale, li scrivi nel file e li esegui tutti insieme con un solo comando.

---

## Lo Shebang: `#!/bin/bash`

La **prima riga** di ogni script deve essere la shebang line, che indica al sistema operativo quale interprete usare:

```bash
#!/bin/bash
```

Il carattere `#!` si chiama "shebang" o "hashbang". Il percorso che segue è l'interprete:

```bash
#!/bin/bash        # usa Bash (più comune)
#!/usr/bin/env bash  # cerca bash nel PATH (più portabile)
#!/bin/sh          # usa sh (POSIX, meno funzionalità)
```

---

## Creare e Rendere Eseguibile uno Script

### Passo 1: Crea il file

```bash
nano ~/saluto.sh
```

Scrivi il contenuto:

```bash
#!/bin/bash
# Il mio primo script Bash
echo "Ciao, mondo!"
echo "Oggi è: $(date '+%d/%m/%Y')"
echo "Utente: $USER"
```

### Passo 2: Rendi eseguibile con `chmod`

```bash
chmod +x ~/saluto.sh   # aggiunge il permesso di esecuzione
```

### Passo 3: Esegui

```bash
~/saluto.sh             # esegui con percorso esplicito
# oppure, se sei nella stessa cartella:
./saluto.sh
```

### Alternativa: eseguire senza chmod

```bash
bash ~/saluto.sh        # bash interpreta il file direttamente
```

---

## Commenti

Tutto ciò che segue `#` su una riga è un commento e viene ignorato dall'interprete.

```bash
#!/bin/bash
# Questo è un commento su riga intera

echo "Ciao"   # commento in coda a un comando

# Commenti multi-riga: usa una # per ogni riga
# Riga 1: questa parte fa X
# Riga 2: questa parte fa Y
# Riga 3: attenzione a Z
```

---

## Stampare Output: `echo` e `printf`

### `echo`

```bash
echo "Testo semplice"
echo "Vai a capo esplicito\n"   # \n non viene interpretato di default
echo -e "Con -e\nil newline\nfunziona"    # -e abilita le sequenze di escape
echo -n "senza newline finale"  # -n non aggiunge newline
echo ""                          # riga vuota
```

### Sequenze di escape con `echo -e`

| Sequenza | Significato |
|----------|-------------|
| `\n` | nuova riga |
| `\t` | tabulazione |
| `\033[1;32m` | verde grassetto (ANSI) |
| `\033[0m` | reset colore |

### `printf` — output formattato

```bash
printf "Nome: %-15s Età: %3d\n" "Alice" 25
printf "Pi greco: %.4f\n" 3.14159265
printf "Hex di 255: %x\n" 255
```

---

## Exit Status

Ogni comando restituisce un **exit status** (codice di uscita):
- `0` = successo
- Qualsiasi altro valore = errore

```bash
ls /etc             # exit status 0 (successo)
echo "Risultato: $?"    # stampa 0

ls /inesistente     # exit status 2 (errore)
echo "Risultato: $?"    # stampa 2
```

### `exit` — terminare uno script con un codice

```bash
#!/bin/bash
if [[ ! -f "$1" ]]; then
    echo "Errore: file '$1' non trovato" >&2
    exit 1          # esce con errore
fi

echo "Elaboro il file $1..."
# ... elaborazione ...
exit 0              # esce con successo
```

### Usare `&&` e `||` con l'exit status

```bash
mkdir ~/miadir && echo "Creata con successo"
mkdir ~/miadir || echo "Errore: cartella già esistente"

# Catena robusta
comando1 && comando2 && comando3    # esegue solo se tutti OK
```

---

## Struttura di Uno Script Ben Scritto

```bash
#!/bin/bash
# =============================================================================
# nome_script.sh — Breve descrizione
# Uso: ./nome_script.sh [argomenti]
# Autore: Nome Cognome — Data
# =============================================================================

# --- Costanti e Configurazione ---
VERSIONE="1.0"
LOG_FILE="/tmp/mio_script.log"

# --- Funzioni ---
uso() {
    echo "Uso: $0 [opzioni] argomento"
    echo "  -h  mostra questo aiuto"
    exit 0
}

# --- Corpo Principale ---
[[ "$1" == "-h" ]] && uso

echo "Script versione $VERSIONE avviato"
# ... logica dello script ...
exit 0
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<../05-Redirezione_e_Pipe/02_pipe.md>)
- [➡️ successivo](<02_variabili.md>)
