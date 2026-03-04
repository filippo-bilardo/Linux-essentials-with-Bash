# Modulo 06 — Introduzione allo Scripting Bash

## Obiettivi del Modulo

Al termine di questo modulo sarai in grado di:

- Scrivere e rendere eseguibili script Bash da zero
- Usare variabili scalari, variabili d'ambiente e parametri posizionali
- Leggere input dall'utente con `read`
- Controllare il flusso con `if`, `for`, `while` e `case`
- Usare l'exit status per scrivere script robusti
- Definire e chiamare funzioni riutilizzabili

---

## Argomenti

1. [Il primo script Bash](./01_primo_script.md)
   - Shebang `#!/bin/bash`
   - Creare ed eseguire uno script
   - Commenti, `echo`, formattazione output
   - Exit status e `exit`

2. [Variabili e Input](./02_variabili.md)
   - Variabili scalari: assegnazione e lettura
   - Variabili speciali: `$0`, `$1`…`$9`, `$#`, `$@`, `$?`, `$$`
   - Variabili d'ambiente: `PATH`, `HOME`, `USER`
   - Input interattivo con `read`
   - Espansione e quoting: `""`, `''`, `\`

3. [Strutture Condizionali](./03_strutture_condizionali.md)
   - Condizionale `if / elif / else / fi`
   - Test con `[[ ]]`: confronto numeri, stringhe, file
   - Operatori logici `&&`, `||`, `!`
   - `case ... esac` per menu e pattern matching

4. [Strutture Iterative](./04_strutture_iterative.md)
   - Ciclo `for` (lista, range, stile C, file, output comandi)
   - Ciclo `while` e lettura di file
   - Ciclo `until`
   - `break` e `continue` (anche annidati)

5. [Exit Status e Comando `exit`](./05_exit_status.md)
   - `$?` e i codici di uscita standard
   - `exit N` e convenzioni per i codici
   - `if comando`: branching sull'exit status
   - Shorthand `&&` / `||`
   - `trap` per pulizia e gestione segnali

---

## Esempi

- [`esempi/01_primi_script.sh`](./esempi/01_primi_script.sh) — shebang, variabili, read, exit status
- [`esempi/02_strutture_controllo.sh`](./esempi/02_strutture_controllo.sh) — if, for, while, case

---

## Esercizi

Vai agli [esercizi del modulo](./esercizi/README.md) per mettere in pratica i concetti.

---

## Convenzioni degli Script in Questo Corso

```bash
#!/bin/bash
# Breve descrizione dello script

# Colori per output leggibile
CIANO='\033[0;36m'
VERDE='\033[0;32m'
GIALLO='\033[1;33m'
ROSSO='\033[0;31m'
RESET='\033[0m'

titolo() { echo -e "\n${CIANO}=== $1 ===${RESET}\n"; }
ok()     { echo -e "${VERDE}[OK]${RESET} $1"; }
errore() { echo -e "${ROSSO}[ERR]${RESET} $1"; }
```

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../05-Redirezione_e_Pipe/README.md>)
- [➡️ successivo](<../07-Operazioni_Matematiche_Stringhe/README.md>)
