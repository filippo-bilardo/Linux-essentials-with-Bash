# Esercizi — Modulo 08: Manipolazione delle Stringhe

## Esercizio 1 — Analisi Stringhe Bash

Crea uno script `analisi_stringa.sh` che:

1. Chiede all'utente di inserire una stringa
2. Stampa:
   - La lunghezza della stringa
   - La stringa tutta maiuscola e tutta minuscola
   - Il primo e l'ultimo carattere
   - La stringa al contrario (usa un ciclo, non `rev`)
3. Chiede poi una sottostringa da cercare e indica se è presente (con `[[ ]]` e `*...*`)

**Esempio di output:**
```
Inserisci una stringa: Hello World
Lunghezza: 11
Maiuscolo: HELLO WORLD
Minuscolo: hello world
Primo char: H  -  Ultimo: d
Al contrario: dlroW olleH
```

---

## Esercizio 2 — Manipolazione Percorsi

Dato un array di percorsi assoluti:

```bash
percorsi=(
    "/home/user/documenti/report.pdf"
    "/var/log/syslog"
    "/etc/nginx/nginx.conf"
    "/home/user/script.sh"
)
```

Per ciascun percorso, stampa (usando **solo** l'espansione di parametri `${...}`):
- Il nome del file
- La directory contenente
- L'estensione
- Il nome senza estensione

---

## Esercizio 3 — Grep Ricette

Scarica (o copia) un file di testo con almeno 20 righe che contiene dati misti.  
In alternativa, crea `ricette.txt` con 5 ricette nel formato:
```
Nome: Spaghetti aglio e olio | Tempo: 20 min | Kcal: 450
```

Con `grep`:
1. Trova tutte le ricette con tempo ≤ 30 min (usa `-E` e `[0-2][0-9]`)
2. Estrai solo i numeri di calorie (`-oE`)
3. Conta le ricette "vegane" (aggiungi la parola a qualche riga)
4. Mostra le righe che **non** contengono "carne" (`-v`)

---

## Esercizio 4 — Report CSV con awk

Crea un file `vendite.csv` con il formato:
```
prodotto,categoria,quantità,prezzo
```

Almeno 10 righe con categorie ripetute. Poi scrivi uno script `report.sh` che usa `awk` per:

1. Stampare intestazione formattata con `printf`
2. Calcolare il totale per categoria (array associativo)
3. Trovare il prodotto più venduto (per quantità)
4. Stampare un riepilogo finale con `END`

---

## Esercizio 5 — sed: Log Cleaner

Crea un file `app.log` simulato con righe del tipo:
```
2024-01-15 08:30:22 [INFO]  Server started
2024-01-15 08:31:00 [ERROR] Connection refused: port 5432
2024-01-15 08:31:05 [WARN]  Retry attempt 1/3
```

Scrivi uno script `clean_log.sh` che usa `sed` per:
1. Stampare solo le righe `[ERROR]` e `[WARN]`
2. Anonimizzare gli indirizzi IP (sostituisci con `[REDACTED]`)
3. Aggiungere una riga di intestazione `=== LOG ANALISI ===` all'inizio
4. Salvare il risultato in `app_clean.log` (senza modificare l'originale)

---

## Esercizio 6 — Pipeline con `tr`, `cut`, `sort`, `uniq`

Dato il file `/etc/passwd`, costruisci **una singola pipeline** che:

1. Estrae solo il campo shell (campo 7)
2. Converte in minuscolo con `tr`
3. Ordina e conta le occorrenze con `sort | uniq -c`
4. Ordina per frequenza decrescente
5. Mostra il risultato formattato con `awk`

**Output atteso (esempio):**
```
  15  /bin/bash
   8  /usr/sbin/nologin
   3  /bin/sh
```

---

## Esercizio 7 — Confronto Configurazioni con `diff`

Simula l'evoluzione di un file di configurazione:

1. Crea `config_v1.ini` con almeno 8 chiavi
2. Crea `config_v2.ini` modificando 3 chiavi, aggiungendo 2 e rimuovendone 1
3. Genera un patch con `diff -u > aggiornamento.patch`
4. Applica il patch su una copia di `config_v1.ini` con `patch`
5. Verifica che il risultato sia identico a `config_v2.ini`

---

## Esercizio 8 — Script Completo: Analisi File di Testo

Scrivi `analisi_testo.sh` che accetta un file come argomento e produce un report:

```
=== ANALISI: relazione.txt ===
Righe totali   : 142
Parole totali  : 1834
Caratteri      : 11206
Riga più lunga : 97 caratteri

Top 10 parole più frequenti:
  45  la
  38  il
  ...

Righe contenenti numeri: 12
Paragrafi (sep. da riga vuota): 18
```

**Strumenti da usare:** `wc`, `awk`, `tr`, `sort`, `uniq -c`, `grep`

---

## Verifica

Dopo aver completato gli esercizi:

```bash
# Rendi eseguibili gli script
chmod +x *.sh

# Testa ciascuno
./analisi_stringa.sh
./report.sh
./clean_log.sh
./analisi_testo.sh relazione.txt
```

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../../07-Operazioni_matematiche/esercizi/README.md>)
- [➡️ successivo](<../../09_Date_e_Orari/README.md>)
