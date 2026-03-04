# Esercizi - Modulo 07: Operazioni Matematiche e Scripting Avanzato

## Obiettivi

Metti in pratica i calcoli matematici, la gestione degli argomenti, la formattazione colorata dell'output, i menu interattivi e il parsing delle opzioni con `getopts`.

---

## Esercizio 1 — Calcolatrice Bash

Crea `~/calcolatrice.sh` che accetti tre argomenti: `numero1`, `operatore` e `numero2`:

```bash
./calcolatrice.sh 15 + 7    # Risultato: 22
./calcolatrice.sh 10 / 3    # Risultato: 3 (intero)
./calcolatrice.sh 10 % 3    # Risultato: 1
./calcolatrice.sh 2 ** 8    # Risultato: 256
```

Lo script deve:
1. Verificare che siano stati passati esattamente 3 argomenti (altrimenti mostrare l'uso).
2. Verificare che il secondo argomento sia `+`, `-`, `*`, `/`, `%` o `**`.
3. Eseguire il calcolo con `$(( ))`.
4. Gestire la divisione per zero come caso di errore.

---

## Esercizio 2 — Statistiche su serie di numeri

Crea `~/statistiche.sh` che accetti una lista di numeri come argomenti:

```bash
./statistiche.sh 5 3 8 1 9 4 7 2 6
```

Output atteso:
```
Numeri inseriti: 9
Somma:           45
Media:           5.00
Minimo:          1
Massimo:         9
```

Usa `$(( ))` per i calcoli interi e `bc` per la media decimale. Verifica che siano stati passati almeno 2 argomenti.

---

## Esercizio 3 — Calcolatrice con bc

Crea `~/calc_float.sh` che legga due numeri decimali e un'operazione con `read` e usi `bc` per il calcolo.

Esempi:
```
Primo numero:  3.14
Secondo numero: 2.718
Operazione (+/-/*//): *
Risultato: 8.5345
```

Aggiungere le operazioni: `sqrt` (radice del primo numero) e `^` (potenza).

---

## Esercizio 4 — Script con `shift` e argomenti multipli

Crea `~/conta_parole.sh` che:
1. Accetti come argomenti uno o più file di testo.
2. Per ogni file mostri il conteggio di righe, parole e caratteri.
3. Alla fine stampi i totali cumulativi.
4. Usi `shift` per iterare sugli argomenti.

```bash
./conta_parole.sh file1.txt file2.txt file3.txt
```

Output atteso:
```
file1.txt    : 10 righe  150 parole  900 caratteri
file2.txt    :  5 righe   80 parole  480 caratteri
────────────────────────────────────────
TOTALE       : 15 righe  230 parole 1380 caratteri
```

---

## Esercizio 5 — Output Colorato e Formattato

Crea `~/report.sh` che generi un report di sistema con output colorato e formattato:

```
╔═══════════════════════════════════════╗
║         REPORT DI SISTEMA             ║
╠═══════════════════════════════════════╣
  Hostname   : nomemacchina          ← ciano
  Kernel     : 5.15.0-72-generic     ← ciano
  Utente     : pippo                 ← verde
  Data/Ora   : 04/03/2026 10:30      ← bianco
  Uptime     : 2 ore 15 min          ← bianco
╠═══════════════════════════════════════╣
  Memoria libera: 2.1G / 8.0G        ← verde se >30%, giallo se <30%, rosso se <10%
  CPU load:       0.42               ← verde se <1, giallo se <3, rosso se ≥3
╚═══════════════════════════════════════╝
```

Usa le variabili ANSI discusse nel modulo. Adatta la larghezza del box alla larghezza del terminale con `$(tput cols)`.

---

## Esercizio 6 — Menu con `select`

Crea `~/menu_file.sh` che mostri un menu con `select` per gestire file:

```
1) Elenca file
2) Crea file
3) Visualizza file
4) Elimina file
5) Esci
```

Ogni voce deve:
- Richiedere ulteriori informazioni se necessario (es. nome del file)
- Mostrare messaggi di errore a colori se l'operazione non riesce
- Tornare al menu dopo ogni operazione (loop continuo)

---

## Esercizio 7 — Gestione Opzioni con `getopts`

Crea `~/processa_log.sh` con le seguenti opzioni:

| Opzione | Significato |
|---------|-------------|
| `-f file` | file di log da analizzare (obbligatorio) |
| `-n N` | mostra le ultime N righe (default: 20) |
| `-k parola` | filtra le righe che contengono la parola |
| `-e` | mostra solo le righe di errore (ERROR o error) |
| `-v` | modalità verbosa |
| `-h` | mostra l'aiuto |

Esempi di utilizzo:
```bash
./processa_log.sh -f /var/log/syslog -n 50
./processa_log.sh -f app.log -k "timeout" -n 10
./processa_log.sh -f app.log -e -v
```

Lo script deve:
1. Verificare che `-f file` sia stato specificato e che il file esista.
2. Applicare i filtri nella sequenza corretta.
3. Gestire combinazioni di opzioni.

---

## Esercizio 8 — Script Completo (Sfida)

Crea `~/backup_avanzato.sh` che combini tutte le tecniche del modulo:

**Opzioni** (via `getopts`):
- `-s dir` — directory sorgente da backuppare (obbligatoria)
- `-d dir` — directory destinazione backup (default: `~/backups`)
- `-n N` — numero massimo di backup da conservare (default: 5)
- `-v` — verboso
- `-h` — aiuto

**Funzionalità**:
1. Crea l'archivio con nome `NOMEDIR_YYYYMMDD_HHMMSS.tar.gz`.
2. Mostra una barra di avanzamento durante la compressione (o almeno un messaggio animato).
3. Calcola e mostra la dimensione del backup.
4. Mantiene solo gli ultimi N backup (elimina i più vecchi).
5. Usa output colorato: verde per successo, rosso per errori, giallo per avvisi.

**Esempio di output**:
```
╔══════════════════════════════════╗
║        BACKUP AVANZATO v1.0      ║
╚══════════════════════════════════╝
[INFO]  Sorgente:     /home/pippo/Documenti
[INFO]  Destinazione: /home/pippo/backups
Compressione in corso... ████████████████░░░░ 80%
[OK]    Backup creato: Documenti_20260304_103045.tar.gz
[INFO]  Dimensione:   3.2M
[INFO]  Backup totali: 3/5
```

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../../06-Introduzione_Scripting_Bash/esercizi/README.md>)
- [➡️ successivo](<../../08_Manipolazione_Stringhe/README.md>)
