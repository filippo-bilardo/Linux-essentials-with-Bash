# Esercizi - Modulo 04: Visualizzazione e Ricerca

## Obiettivi

Metti in pratica i comandi di visualizzazione file, l'editor nano, l'archiviazione e gli strumenti di ricerca e filtraggio trattati nel modulo.

---

## Esercizio 1 — Visualizzare e analizzare un file di testo

1. Visualizza il file `/etc/passwd` con `cat` (scorri con la tastiera).
2. Apri lo stesso file con `less`. Prova a:
   - Spostarti in avanti con `Spazio`, indietro con `b`
   - Cercare la parola `root` con `/root` poi `n` per la prossima occorrenza
   - Uscire con `q`
3. Usa `head` per vedere le prime 5 righe e `tail` per le ultime 5.
4. Conta le righe, le parole e i caratteri del file con `wc`.

---

## Esercizio 2 — Editor nano

1. Crea un nuovo file con nano:
   ```bash
   nano ~/appunti_linux.txt
   ```
2. Scrivi almeno 5 righe di appunti sui comandi Linux imparati finora.
3. Salva il file senza uscire (`Ctrl+O`), poi esci (`Ctrl+X`).
4. Riapri il file, vai alla riga 3 con `Ctrl+_` → `3`, aggiungi una riga, salva e chiudi.
5. Verifica il contenuto con `cat ~/appunti_linux.txt`.

---

## Esercizio 3 — Creare e gestire archivi tar

1. Crea una directory `~/backup_test/` con almeno 3 file al suo interno.
2. Crea un archivio compresso:
   ```bash
   tar -czvf ~/archivio_test.tar.gz ~/backup_test/
   ```
3. Elenca il contenuto dell'archivio senza estrarlo:
   ```bash
   tar -tzvf ~/archivio_test.tar.gz
   ```
4. Crea una directory `~/ripristino/` ed estrai l'archivio lì:
   ```bash
   tar -xzvf ~/archivio_test.tar.gz -C ~/ripristino/
   ```
5. Verifica che i file siano stati ripristinati correttamente.

---

## Esercizio 4 — Ricerca con grep

Crea il file `~/studenti.txt` con questo contenuto:
```
Alice Rossi 18 Roma
Bob Bianchi 20 Milano
Carlo Verdi 19 Roma
Diana Neri 21 Napoli
Eva Russo 18 Milano
Franco Marino 20 Roma
```

1. Trova tutti gli studenti di Roma:
   ```bash
   grep "Roma" ~/studenti.txt
   ```
2. Conta quanti studenti hanno 20 anni:
   ```bash
   grep -c "20" ~/studenti.txt
   ```
3. Trova gli studenti che **non** sono di Milano:
   ```bash
   grep -v "Milano" ~/studenti.txt
   ```
4. Cerca il testo `alice` ignorando maiuscole/minuscole:
   ```bash
   grep -i "alice" ~/studenti.txt
   ```

---

## Esercizio 5 — Ordinare i dati

Usando il file `~/studenti.txt` dell'esercizio precedente:

1. Ordina gli studenti per nome (colonna 1):
   ```bash
   sort ~/studenti.txt
   ```
2. Ordina per età (colonna 3) in modo numerico:
   ```bash
   sort -k3 -n ~/studenti.txt
   ```

---

## Esercizio 6 — Estrazione dati con awk

Crea il file `~/inventario.csv`:
```
prodotto,quantita,prezzo
mele,50,0.80
banane,30,0.50
arance,40,1.20
kiwi,20,1.50
pere,35,0.90
```

1. Mostra i prodotti con prezzo superiore a €1.00 con `awk`:
   ```bash
   awk -F ',' 'NR>1 && $3>1.00 {print $1, "→", $3"€"}' ~/inventario.csv
   ```
2. Calcola il valore totale del magazzino (quantità × prezzo) con `awk`:
   ```bash
   awk -F ',' 'NR>1 {tot += $2*$3} END {printf "Valore totale: %.2f€\n", tot}' ~/inventario.csv
   ```

---

## Soluzioni Veloci

Per verificare le tue soluzioni, esegui gli script di esempio presenti in `../esempi/`:
```bash
bash ../esempi/01_visualizzazione.sh
bash ../esempi/02_archivi.sh
bash ../esempi/03_awk.sh
bash ../esempi/04_sed.sh
```

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../../03-Lavorare_con_file_e_cartelle/esercizi/README.md>)
- [➡️ successivo](<../../05-Redirezione_e_Pipe/README.md>)
