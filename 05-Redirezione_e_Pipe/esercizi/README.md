# Esercizi - Modulo 05: Redirezione e Pipe

## Obiettivi

Metti in pratica la redirezione di stdin/stdout/stderr e le pipeline per elaborare dati in modo efficiente.

---

## Esercizio 1 — Redirigere stdout e stderr

1. Esegui il comando `ls /etc /inesistente` e:
   - Salva solo l'output normale in `~/output.txt`
   - Salva solo gli errori in `~/errori.txt`
   - Verifica i due file con `cat`

2. Ripeti il comando salvando **entrambi** in un unico file `~/tutto.txt` (usa `2>&1`).

3. Esegui `find / -name "*.conf"` scartando tutti i messaggi di errore. Salva solo l'output valido in `~/conf_files.txt`. Conta quanti file ha trovato con `wc -l`.

---

## Esercizio 2 — Aggiungere a un file di log

Crea uno script `~/registro.sh` che ogni volta che viene eseguito:
1. Aggiunge una riga al file `~/registro.log` nel formato:  
   `[2026-03-04 10:30:00] Script eseguito da: nomeutente`
2. Usa `>>` per non sovrascrivere le esecuzioni precedenti.
3. Usa `$(date)` e `$(whoami)` per ottenere i valori dinamici.

Esegui lo script 3 volte e poi mostra il contenuto di `registro.log`.

---

## Esercizio 3 — Here-Document

1. Crea il file `~/server.conf` usando un here-document con questo contenuto:
   ```
   [server]
   host = localhost
   port = 8080
   workers = 4
   
   [database]
   host = 127.0.0.1
   port = 5432
   name = mydb
   ```

2. Crea il file `~/template.html` con un here-doc che contenga una pagina HTML minimale (DOCTYPE, html, head, body).

3. Usa un here-string per calcolare `sqrt(2)` con `bc`:
   ```bash
   bc <<< "scale=10; sqrt(2)"
   ```

---

## Esercizio 4 — Pipeline di base

Crea il file `~/studenti.txt` con questi dati (uno per riga, separati da spazio):
```
Alice Rossi 18 Roma A
Bob Bianchi 20 Milano B
Carlo Verdi 19 Roma A
Diana Neri 21 Napoli C
Eva Russo 18 Milano A
Franco Marino 20 Roma B
Giulia Fontana 22 Roma A
```

Usando pipeline (`|`), risolvi:
1. Elenca gli studenti di Roma ordinati per nome.
2. Mostra quanti studenti hanno preso il voto `A`.
3. Trova lo studente più anziano (colonna 3 numerica).
4. Conta gli studenti per città (output: `n   Città`).

---

## Esercizio 5 — `tee` per debug e salvataggio

1. Genera l'elenco dei file in `/etc` e:
   - Salvalo in `~/etc_files.txt`
   - Visualizzalo a schermo contemporaneamente

   Hint: `ls /etc | tee ~/etc_files.txt`

2. Crea una pipeline che:
   - Legge `/etc/passwd`
   - Filtra solo gli utenti con UID ≥ 1000 (colonna 3)
   - Salva il risultato intermedio in `~/utenti_reali.txt` con `tee`
   - Conte le righe risultanti

3. Aggiungi una riga di separazione `---` al file `~/utenti_reali.txt` usando `tee -a`.

---

## Esercizio 6 — `xargs` per operazioni massive

1. Crea 5 file vuoti `~/test/file_{1..5}.txt` (usa una singola riga con `touch` e `brace expansion` o crea la directory prima).

2. Usa una pipeline con `xargs` per cancellare tutti i file `.txt` nella directory `~/test/`:
   ```bash
   ls ~/test/*.txt | xargs rm -v
   ```

3. Trova tutti i file `.log` in `/var/log` (solo il primo livello) e usa `xargs ls -lh` per mostrarne i dettagli.

4. Usa `echo "uno due tre quattro cinque"` con `xargs -n 2` per stampare 2 parole per riga.

---

## Esercizio 7 — Sostituzione di comando `$()`

1. Crea un file il cui nome include la data odierna:
   ```bash
   touch ~/backup_$(date '+%Y%m%d').txt
   ```

2. Crea una variabile `NUM_PROC` che contenga il numero di processi attivi e stampa:  
   `"Processi attivi: NN"`

3. Scrivi un comando che stampi il testo:  
   `"Il sistema [hostname] ha [N] utenti connessi al [data]"`  
   usando `$(hostname)`, `$(who | wc -l)`, `$(date '+%d/%m/%Y')`.

4. Salva l'output di `uname -a` in una variabile e stampala.

---

## Esercizio 8 — Pipeline Complessa (Sfida)

Usando il file `/etc/passwd`, costruisci una pipeline che produca un report nel formato:
```
=== Report Utenti del Sistema ===
Utenti totali  : NN
Utenti reali   : NN  (UID >= 1000)
Shell più usate:
  N  /bin/bash
  N  /bin/sh
  N  /usr/sbin/nologin
```

Salva il report in `~/report_utenti.txt` e visualizzalo a schermo con `tee`.  
*(Hint: combina `awk`, `wc -l`, `sort | uniq -c | sort -rn`, `tee`)*

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../../04-Visualizzazione_e_Ricerca/esercizi/README.md>)
- [➡️ successivo](<../../06-Introduzione_Scripting_Bash/README.md>)
