# Ricerca, ordinamento e frequenze

Usa i file del [laboratorio](README.md#preparazione-dei-dati). Le pipe sono già state spiegate nel modulo 04: qui le applichiamo ai nuovi filtri.

## grep: selezionare righe

```bash
grep ',Roma,' studenti.csv
grep -n ',Roma,' studenti.csv
grep -c ',Roma,' studenti.csv
grep -i '^alice,' studenti.csv
grep -v ',Roma,' studenti.csv
```

`grep` stampa le righe che corrispondono al pattern. `-n` aggiunge il numero di riga, `-c` conta le righe corrispondenti, `-i` ignora maiuscole e minuscole, `-v` inverte la selezione. Nell'ultimo esempio rimane anche l'intestazione: non è una riga di Roma.

Il pattern `,Roma,` include i separatori del campo, così non confonde Roma con una parte di un altro valore.

### Espressioni regolari essenziali

| Forma | Significato |
|-------|-------------|
| `^` / `$` | Inizio / fine della riga |
| `.` | Un carattere qualsiasi |
| `[0-9]` | Una cifra |
| `[AB]` | Uno dei caratteri indicati |
| `*` | Zero o più ripetizioni dell'elemento precedente |
| `+`, `?`, `{n}` con `-E` | Una o più, zero o una, esattamente n ripetizioni |
| Alternativa con `-E`: `Roma\|Milano` | Uno dei due testi |

Nell'ultima riga della tabella la barra verticale è parte della regex, non una pipe della shell: il pattern deve stare tra virgolette.

```bash
grep ',A$' studenti.csv
grep -E ',(Roma|Milano),' studenti.csv
grep -E '^[A-Z][a-z]+,[0-9]{2},' studenti.csv
```

L'ultimo pattern verifica una forma parziale delle righe, non la validità completa di un CSV. Le regex e il globbing del modulo 03 sono linguaggi diversi: in una regex `*` ripete l'elemento precedente.

Se non trova corrispondenze, `grep` normalmente non stampa righe e restituisce stato `1`; `grep -c` stampa `0`. Lo stato `2` segnala un errore.

## sort: ordinare righe o campi

```bash
sort visite.txt
sort -r visite.txt
sort -u visite.txt
```

`-r` inverte l'ordine; `-u` elimina le righe uguali mentre ordina. Per ordinare numericamente un campo di `studenti.csv` serve prima rimuovere l'intestazione:

```bash
tail -n +2 studenti.csv | sort -t ',' -k2,2n
```

`-t ','` imposta il separatore; `-k2,2n` usa soltanto il secondo campo come chiave numerica. Senza `n`, il confronto sarebbe lessicografico. L'ordine alfabetico dipende dalle impostazioni locali; per risultati riproducibili su testi ASCII puoi eseguire `LC_ALL=C sort visite.txt`.

## uniq: contare ripetizioni adiacenti

```bash
sort visite.txt | uniq -c
sort visite.txt | uniq -d
```

`uniq` confronta righe **adiacenti**: per raggruppare tutte le città uguali, qui occorre ordinare prima. `-c` conta le occorrenze; `-d` mostra i valori ripetuti. Le frequenze sono Roma 4, Milano 2, Napoli 1.

## tr: trasformare caratteri

```bash
echo "linux bash" | tr 'a-z' 'A-Z'
echo "Roma,Milano,Napoli" | tr ',' '\n'
echo "troppi   spazi" | tr -s ' '
```

`tr` legge da stdin. Il primo esempio converte i caratteri ASCII, il secondo sostituisce ogni virgola con un fine riga, il terzo comprime gli spazi consecutivi. Per modificare parole intere, useremo `sed`.

---

- [📑 Indice](README.md)
- [⬅️ Visualizzazione](01_visualizzazione_file.md)
- [➡️ Estrazione e trasformazione](03_estrazione_dati.md)
