# Ricerca e Filtraggio dei Dati

## `grep` — Cerca Pattern nei File

`grep` (Global Regular Expression Print) è uno degli strumenti più usati su Linux. Cerca righe che corrispondono a un pattern.

```bash
grep "parola" file.txt              # cerca "parola" in file.txt
grep "parola" *.txt                 # cerca in tutti i .txt
grep -r "parola" /etc/              # cerca ricorsivamente in una directory
grep -i "parola" file.txt           # ignora maiuscole/minuscole (-i = ignore case)
grep -v "parola" file.txt           # mostra le righe che NON contengono "parola"
grep -n "parola" file.txt           # mostra il numero di riga
grep -c "parola" file.txt           # conta le righe che contengono "parola"
grep -l "parola" *.txt              # mostra solo i nomi dei file che contengono il pattern
grep -w "parola" file.txt           # solo parola intera (non parti di parola)
grep -A 3 "parola" file.txt         # mostra 3 righe dopo il match (After)
grep -B 3 "parola" file.txt         # mostra 3 righe prima del match (Before)
grep -C 3 "parola" file.txt         # 3 righe prima e dopo (Context)
```

### grep con espressioni regolari

```bash
grep "^root" /etc/passwd            # righe che iniziano con "root"
grep "bash$" /etc/passwd            # righe che finiscono con "bash"
grep "^$" file.txt                  # righe vuote
grep "[0-9]" file.txt               # righe con almeno un numero
grep "[A-Z]" file.txt               # righe con almeno una maiuscola
grep "colou\?r" file.txt            # "color" o "colour" (? opzionale)
grep "jpe\?g" file.txt              # "jpg" o "jpeg"
```

### grep con espressioni regolari estese (`-E` o `egrep`)

```bash
grep -E "gatto|cane" file.txt       # "gatto" oppure "cane"
grep -E "[0-9]{3}" file.txt         # esattamente 3 cifre consecutive
grep -E "https?://" file.txt        # http:// o https://
grep -E "^[A-Z][a-z]+" file.txt    # riga che inizia con maiuscola + minuscole
```

### Combinare grep con altri comandi

```bash
ps aux | grep nginx                 # trova il processo nginx
cat /etc/passwd | grep -v "nologin" # utenti con shell interattiva
ls -la | grep "^d"                  # solo directory (iniziano con 'd')
history | grep "git"                # comandi git nella cronologia
journalctl | grep "ERROR"           # errori nel log di sistema
```

---

## `sort` — Ordina le Righe

```bash
sort file.txt                       # ordine alfabetico
sort -r file.txt                    # ordine inverso (reverse)
sort -n file.txt                    # ordine numerico
sort -nr file.txt                   # numerico inverso (dal più grande)
sort -k 2 file.txt                  # ordina per la 2ª colonna
sort -k 2 -n file.txt               # ordina per la 2ª colonna numericamente
sort -t ':' -k 3 -n /etc/passwd     # ordina per UID (:  è il separatore)
sort -u file.txt                    # rimuove duplicati mentre ordina
sort file.txt | uniq                # stessa cosa ma in due passi
```

## `uniq` — Rimuove Righe Duplicate

```bash
sort file.txt | uniq                # rimuove duplicati (richiede sort prima)
sort file.txt | uniq -c             # conta le occorrenze di ogni riga
sort file.txt | uniq -d             # mostra solo le righe duplicate
sort file.txt | uniq -u             # mostra solo le righe uniche (non duplicate)
```

---

## `tr` — Trasforma Caratteri

```bash
echo "ciao MONDO" | tr 'a-z' 'A-Z'     # converti in maiuscolo
echo "CIAO MONDO" | tr 'A-Z' 'a-z'     # converti in minuscolo
echo "a:b:c:d" | tr ':' ' '            # sostituisci : con spazio
echo "aaa bbb ccc" | tr -s ' '         # riduci spazi multipli a uno (-s = squeeze)
echo "ciao" | tr -d 'a'                # elimina il carattere 'a' (-d = delete)
cat file.txt | tr -d '\r'              # rimuovi i fine riga Windows (\r)
```

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<03_archiviazione_compressione.md>)
- [➡️ successivo](<05_estrazione_dati.md>)
