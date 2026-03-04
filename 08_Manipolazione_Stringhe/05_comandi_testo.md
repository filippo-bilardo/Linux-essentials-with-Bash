# Comandi di Testo: `tr`, `cut`, `sort`, `uniq`, `wc`, `diff`, `tee`

## `tr` — Traduzione e Rimozione di Caratteri

`tr` (translate) trasforma o rimuove caratteri leggendo da stdin.

```bash
# Convertire minuscolo → maiuscolo
echo "ciao mondo" | tr 'a-z' 'A-Z'    # CIAO MONDO
echo "CIAO MONDO" | tr 'A-Z' 'a-z'    # ciao mondo

# Sostituire caratteri
echo "uno:due:tre" | tr ':' ','        # uno,due,tre

# Rimuovere caratteri (-d = delete)
echo "H3ll0 W0rld" | tr -d '0-9'      # Hll Wrld
echo "ciao" | tr -d 'aeiou'           # c

# Rimuovere caratteri duplicati (-s = squeeze)
echo "aabbccdd ee" | tr -s 'a-z'      # abcd e (un solo carattere consecutivo)
echo "   troppi   spazi   " | tr -s ' '  # un solo spazio

# Combinazioni utili
# Ogni parola su una riga:
echo "uno due tre quattro" | tr ' ' '\n'

# Rimuovere tutto tranne printable ASCII
tr -cd '[:print:]\n' < binario.bin

# Sostituire newline con spazio (unire righe)
tr '\n' ' ' < file.txt
```

---

## `cut` — Estrarre Campi e Colonne

```bash
# -d = delimitatore, -f = campo (field)
cut -d ':' -f 1 /etc/passwd            # solo i nomi utente
cut -d ':' -f 1,7 /etc/passwd          # nomi e shell
cut -d ':' -f 3-5 /etc/passwd          # campi 3, 4 e 5
cut -d ',' -f 2- dati.csv              # dal campo 2 in poi

# Per colonne a posizione fissa (caratteri)
cut -c 1-10 file.txt                   # caratteri 1-10 di ogni riga
cut -c 5-   file.txt                   # dal 5° carattere in poi
cut -c 1,5,10 file.txt                 # caratteri 1, 5 e 10
```

---

## `sort` — Ordinamento Avanzato

```bash
# Ordinamento base (alfabetico)
sort nomi.txt

# Numerico
sort -n numeri.txt

# Inverso
sort -r file.txt
sort -rn numeri.txt

# Per colonna specifica (-k)
sort -k2 tabella.txt               # ordina su colonna 2
sort -k2,2 -k1,1 tabella.txt       # prima su col.2, poi col.1
sort -k3 -n prezzi.csv             # numericamente sulla col.3
sort -t ',' -k2 -n dati.csv        # CSV, numericamente col.2

# Rimuovere duplicati durante l'ordinamento
sort -u file.txt                   # equivale a sort | uniq

# Ordine umano (1K, 2M, 3G)
sort -h dimensioni.txt
du -sh /etc/* | sort -h

# Stabile (mantiene l'ordine originale per elementi uguali)
sort -s -k2 tabella.txt
```

---

## `uniq` — Deduplicazione

`uniq` lavora su **righe adiacenti**: per eliminare tutti i duplicati, ordina prima.

```bash
# Rimuove righe adiacenti duplicate
sort frutti.txt | uniq

# Mostra il conteggio
sort frutti.txt | uniq -c

# Solo i duplicati
sort frutti.txt | uniq -d

# Solo gli unici (non duplicati)
sort frutti.txt | uniq -u

# Ignora maiuscole/minuscole
sort -f file.txt | uniq -i

# Ignora i primi N campi (-f) o N caratteri (-s)
sort file.txt | uniq -f 1    # ignora il primo campo nel confronto
```

---

## `wc` — Conteggio

```bash
wc file.txt                    # righe  parole  caratteri  nome_file
wc -l file.txt                 # solo righe
wc -w file.txt                 # solo parole
wc -c file.txt                 # solo byte
wc -m file.txt                 # caratteri (unicode-aware)

# Contare file
ls /etc | wc -l
find . -name "*.py" | wc -l

# Contare processi
ps aux | wc -l

# Lunghezza della stringa più lunga in un file
awk '{ if(length>max) max=length } END{print max}' file.txt
```

---

## `diff` — Confronto File

```bash
# Confronto di base
diff file1.txt file2.txt

# Output unificato (più leggibile, usato da git)
diff -u file1.txt file2.txt

# Output contestuale
diff -c file1.txt file2.txt

# Ignora spazi e righe vuote
diff -w -B file1.txt file2.txt

# Confronto directory
diff -r dir1/ dir2/

# Solo i nomi dei file diversi
diff -rq dir1/ dir2/

# Confronta output di comandi
diff <(ls dir1/) <(ls dir2/)
diff <(sort file1.txt) <(sort file2.txt)
```

### Interpretare l'output di `diff`

```
< riga solo in file1
> riga solo in file2
--- separatore
```

Con `-u` (unified):
```
-riga rimossa da file1
+riga aggiunta in file2
 riga uguale (contesto)
```

### `patch` — applicare diff

```bash
# Creare il patch
diff -u originale.txt modificato.txt > modifiche.patch

# Applicare il patch
patch originale.txt < modifiche.patch
```

---

## `tee` — Duplicare Flussi

`tee` è già stato trattato nel modulo 05. Usi avanzati:

```bash
# Scrivere su più file
comando | tee file1.txt file2.txt file3.txt

# Appendere invece di sovrascrivere
comando | tee -a log.txt

# Debug di pipeline: inserisci tee nel mezzo
cat dati.csv \
    | tee /tmp/passo1.txt \
    | awk -F ',' '{print $2}' \
    | tee /tmp/passo2.txt \
    | sort | uniq -c

# Usare tee con sudo per scrivere file protetti
echo "nuova riga" | sudo tee -a /etc/hosts > /dev/null
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<04_sed_avanzato.md>)
- [➡️ successivo](<../09_Date_e_Orari/README.md>)
