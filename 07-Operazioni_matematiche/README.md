# Modulo 07 — Operazioni Matematiche in Bash

## Obiettivi del Modulo

Al termine di questo modulo sarai in grado di:

- Eseguire calcoli matematici in Bash con `expr`, `let`, `$(( ))` e `bc`
- Utilizzare i parametri posizionali e il comando `shift`
- Colorare e formattare l'output con i codici ANSI e `tput`
- Costruire menu interattivi con `select` e `case`
- Gestire le opzioni degli script con `getopts`

---

## Argomenti

1. [Operazioni Matematiche](./01_operazioni_matematiche.md)
   - Aritmetica intera: `expr`, `let`, `$(( ))`
   - Calcoli in virgola mobile con `bc`
   - Operatori: `+`, `-`, `*`, `/`, `%`, `**`
   - Confronto numerico e operazioni bitwise

2. [Parametri Posizionali e Shift](./02_parametri_posizionali.md)
   - `$1`…`$9`, `${10}`, `$#`, `$@`, `$*`
   - Il comando `shift`
   - Validazione e gestione degli argomenti
   - Array in Bash

3. [Colorazione e Formattazione dell'Output](./03_output_formattazione.md)
   - Codici ANSI per colori e stili
   - `tput` per output portabile
   - Barre di progresso e animazioni
   - `printf` avanzato

4. [Menu Interattivi con `select` e `case`](./04_menu_select.md)
   - Il costrutto `select`
   - Menu con `while` + `case`
   - Menu numerati e con testo libero

5. [Gestione Opzioni con `getopts`](./05_getopts.md)
   - Sintassi di `getopts`
   - Opzioni con e senza argomento
   - Messaggi di uso e validazione

---

## Esempi

- [`esempi/01_matematica.sh`](./esempi/01_matematica.sh) — demo di tutti gli operatori matematici e bc
- [`esempi/02_menu_getopts.sh`](./esempi/02_menu_getopts.sh) — menu con select e gestione opzioni con getopts

---

## Esercizi

Vai agli [esercizi del modulo](./esercizi/README.md) per mettere in pratica i concetti.

---

## Concetti Chiave

| Strumento | Uso |
|-----------|-----|
| `$(( expr ))` | aritmetica intera veloce |
| `bc` | calcoli in virgola mobile |
| `$#` | numero di argomenti |
| `shift` | sposta i parametri posizionali |
| `\033[1;32m` | codice ANSI verde grassetto |
| `tput` | formattazione terminale portabile |
| `select` | menu automatico numerato |
| `getopts` | parsing opzioni stile POSIX |

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../06-Introduzione_Scripting_Bash/README.md>)
- [➡️ successivo](<../08_Manipolazione_Stringhe/README.md>)
