# Estrazione di Dati dai File

## `cut` — Estrai Colonne o Campi

`cut` estrae parti specifiche di ogni riga: per posizione di carattere o per delimitatore di campo.

```bash
# Per carattere (posizione)
cut -c 1 file.txt               # primo carattere di ogni riga
cut -c 1-5 file.txt             # caratteri dalla 1 alla 5
cut -c 1,5,10 file.txt          # caratteri nelle posizioni 1, 5 e 10

# Per campo (field) con delimitatore
cut -d ':' -f 1 /etc/passwd     # primo campo (username), separatore ':'
cut -d ':' -f 1,3 /etc/passwd   # campi 1 e 3 (username e UID)
cut -d ':' -f 3- /etc/passwd    # dal campo 3 in poi
cut -d ',' -f 2 dati.csv        # secondo campo di un CSV

# Esempi pratici
cut -d ':' -f 1 /etc/passwd | sort      # lista ordinata degli utenti
cut -d ':' -f 1,7 /etc/passwd           # utenti e loro shell
```

---

## `awk` — Il Linguaggio di Elaborazione Testo

`awk` è molto più potente di `cut`: è un vero linguaggio di programmazione per l'elaborazione di testi strutturati per colonne.

```bash
# Sintassi base: awk 'pattern { azione }' file
awk '{print $1}' file.txt           # stampa la prima colonna
awk '{print $1, $3}' file.txt       # stampa colonna 1 e 3
awk '{print NR, $0}' file.txt       # stampa numero riga + riga intera

# Con separatore personalizzato (-F)
awk -F ':' '{print $1}' /etc/passwd         # username
awk -F ':' '{print $1, $3}' /etc/passwd     # username e UID
awk -F ',' '{print $2}' dati.csv            # seconda colonna CSV

# Filtrare con condizioni
awk '$3 > 1000' /etc/passwd                 # utenti con UID > 1000
awk -F ':' '$3 >= 1000 {print $1}' /etc/passwd   # username utenti normali
awk '/root/' /etc/passwd                    # righe che contengono "root"
awk 'NR==1' file.txt                        # solo la prima riga
awk 'NR>=2 && NR<=5' file.txt               # righe da 2 a 5

# Calcoli
awk '{sum += $1} END {print sum}' numeri.txt    # somma colonna 1
awk 'END {print NR}' file.txt                   # conta le righe
awk -F ':' '{print NR": "$1}' /etc/passwd       # numera gli utenti
```

---

## `sed` — Stream EDitor

`sed` modifica il testo riga per riga seguendo comandi. È potente per sostituzioni e trasformazioni.

```bash
# Sostituzione (s/vecchio/nuovo/)
sed 's/gatto/cane/' file.txt            # sostituisce la prima occorrenza per riga
sed 's/gatto/cane/g' file.txt           # sostituisce TUTTE le occorrenze (g=global)
sed 's/gatto/cane/gi' file.txt          # sostituisce ignorando maiuscole/minuscole
sed 's/gatto/cane/2' file.txt           # sostituisce solo la 2ª occorrenza

# Modificare il file originale (-i = in-place)
sed -i 's/vecchio/nuovo/g' file.txt     # modifica il file direttamente
sed -i.bak 's/vecchio/nuovo/g' file.txt # modifica + crea backup (.bak)

# Cancellare righe
sed '/pattern/d' file.txt               # elimina righe che contengono "pattern"
sed '3d' file.txt                       # elimina la riga 3
sed '3,5d' file.txt                     # elimina le righe da 3 a 5
sed '/^$/d' file.txt                    # elimina le righe vuote
sed '/^#/d' file.txt                    # elimina le righe di commento

# Stampare righe specifiche
sed -n '5p' file.txt                    # stampa solo la riga 5 (-n sopprime l'output)
sed -n '2,5p' file.txt                  # stampa righe 2-5
sed -n '/pattern/p' file.txt            # stampa righe con "pattern"

# Aggiungere testo
sed '3a\Testo aggiunto dopo riga 3' file.txt   # aggiunge dopo riga 3
sed '3i\Testo inserito prima riga 3' file.txt  # inserisce prima riga 3

# Esempi pratici
# Rimuovere commenti e righe vuote da un file di configurazione:
sed -e '/^#/d' -e '/^$/d' /etc/ssh/sshd_config

# Aggiungere tabulazione all'inizio di ogni riga:
sed 's/^/    /' file.txt
```

---

## Pipeline: Combinare gli Strumenti

La vera potenza emerge combinando più comandi con le **pipe** (`|`):

```bash
# Chi sono gli utenti con shell bash?
grep "bash$" /etc/passwd | cut -d ':' -f 1

# Quanti utenti ci sono sul sistema?
cat /etc/passwd | wc -l

# Le 10 parole più frequenti in un file
cat file.txt | tr ' ' '\n' | sort | uniq -c | sort -nr | head -10

# I 5 file più grandi in /var
du -h /var/* 2>/dev/null | sort -rh | head -5

# Elenco IP che compaiono più spesso in un log
grep -oE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access.log | \
    sort | uniq -c | sort -rn | head -10

# Utenti con UID >= 1000 (utenti normali)
awk -F ':' '$3 >= 1000 {print $1, $3}' /etc/passwd | sort -k2 -n
```

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<04_ricerca_filtraggio.md>)
