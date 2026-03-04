# Esercizi - Modulo 06: Introduzione allo Scripting Bash

## Obiettivi

Scrivi script Bash funzionanti che usino variabili, parametri, input interattivo e strutture di controllo.

---

## Esercizio 1 — Il tuo primo script

Crea il file `~/saluto.sh`:

1. Inserisci la shebang corretta.
2. Lo script deve:
   - Stampare `Ciao, [NOME]!` dove `[NOME]` viene letto con `read -p`
   - Chiedere l'età e rispondere con `Sei maggiorenne` o `Sei minorenne`
   - Stampare l'orario corrente con `date`
3. Rendilo eseguibile con `chmod +x` ed eseguilo con `./saluto.sh`.

**Verifica:** Lo script chiede nome ed età, risponde correttamente in entrambi i casi.

---

## Esercizio 2 — Informazioni di sistema

Crea `~/info_sistema.sh` che stampi un report formattato con:

```
╔══════════════════════════════╗
║     INFORMAZIONI DI SISTEMA  ║
╚══════════════════════════════╝
  Hostname   : nomemacchina
  Utente     : pippo
  Data/Ora   : 04/03/2026 10:30:15
  Kernel     : 5.15.0-72-generic
  Uptime     : 2 hours, 15 minutes
  Shell      : /bin/bash
  File in ~  : 42
```

Usa `$(...)` per ottenere ogni valore dinamicamente.  
Formatta con `printf` per allineare le colonne.

---

## Esercizio 3 — Script con argomenti

Crea `~/crea_progetto.sh` che accetti un argomento (il nome del progetto):

```bash
./crea_progetto.sh mio_progetto
```

Lo script deve:
1. Verificare che sia stato passato esattamente 1 argomento. Se no, stampare l'uso e uscire con `exit 1`.
2. Verificare che la directory `~/mio_progetto` non esista già.
3. Creare la struttura:
   ```
   ~/mio_progetto/
   ├── src/
   ├── docs/
   ├── tests/
   └── README.md   (con il testo "# mio_progetto")
   ```
4. Stampare un messaggio di successo.

**Verifica:** Testa anche i casi di errore (nessun argomento, directory già esistente).

---

## Esercizio 4 — Ciclo for: tabellina

Crea `~/tabellina.sh` che:
1. Legga un numero da 1 a 10 con `read -p`.
2. Verifichi che il numero sia nell'intervallo [1, 10]. Se no, stampa un errore e termina.
3. Stampi la tabellina completa (da 1 a 10) con `for` e `printf`.

Esempio output per il numero 6:
```
Tabellina del 6:
  6 ×  1 =  6
  6 ×  2 = 12
  ...
  6 × 10 = 60
```

---

## Esercizio 5 — Ciclo while: countdown

Crea `~/countdown.sh` che:
1. Accetti un argomento numerico (il punto di partenza).
2. Se non è un numero o è <= 0, stampi un errore.
3. Faccia il conto alla rovescia da N a 0 con `while`.
4. Alla fine stampi `Tempo scaduto!`.
5. **(Opzionale)** Aggiunga `sleep 1` tra ogni seconda per dare l'effetto animato.

```bash
./countdown.sh 5
5... 4... 3... 2... 1... Tempo scaduto!
```

---

## Esercizio 6 — Analisi di file con for e if

Crea `~/analizza_dir.sh` che:
1. Accetti una directory come argomento (default: `.`).
2. Verifichi che la directory esista.
3. Iteri su tutti i file con `for f in dir/*`.
4. Per ogni elemento stampi:
   - `[DIR]  nome` se è una directory
   - `[FILE] nome  (NNN bytes)` se è un file
   - `[LINK] nome` se è un link simbolico
5. Alla fine stampi il totale: `Trovati: X file, Y directory, Z link`

**Verifica:** Testa con `/etc`, `~`, e `.`.

---

## Esercizio 7 — Menu interattivo con case

Crea `~/menu_sistema.sh` con un menu che rimane attivo finché l'utente non sceglie "Esci":

```
╔═══════════════════════════╗
║  MENU DI SISTEMA          ║
╠═══════════════════════════╣
║  1) Informazioni sistema  ║
║  2) Utenti connessi       ║
║  3) Spazio disco          ║
║  4) Processi attivi (top) ║
║  5) Contenuto directory   ║
║  q) Esci                  ║
╚═══════════════════════════╝
```

Implementa ogni voce con il comando appropriato (`uname -a`, `who`, `df -h`, `ps aux | head -10`, `ls -la`).

---

## Esercizio 8 — Script di backup (Sfida)

Crea `~/backup.sh` che:

1. Accetti come argomento la directory da backuppare.
2. Verifichi che la directory sorgente esista.
3. Crei un archivio `~/backup/NOMEDIR_YYYYMMDD_HHMMSS.tar.gz`.
4. Crei la directory `~/backup/` se non esiste.
5. Verifichi che l'archivio sia stato creato con successo (testa il file con `-f`).
6. Stampi le dimensioni del backup con `du -sh`.
7. Mantenga solo gli ultimi 5 backup (elimina i più vecchi con `ls -t | tail -n +6 | xargs rm`).

**Esempio di utilizzo:**
```bash
./backup.sh ~/Documenti
Backup creato: ~/backup/Documenti_20260304_103045.tar.gz
Dimensione: 2.3M
Backup totali conservati: 3
```

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../../05-Redirezione_e_Pipe/esercizi/README.md>)
- [➡️ successivo](<../../07-Operazioni_Matematiche_Stringhe/README.md>)
