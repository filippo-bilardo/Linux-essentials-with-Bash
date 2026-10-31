# Estrarre campi e trasformare testo

Usa i file del [laboratorio](README.md#preparazione-dei-dati). Per ogni richiesta scegli lo strumento più diretto: `cut` estrae campi, `awk` applica condizioni e calcoli, `sed` trasforma righe.

## cut: estrazione per posizione o separatore

```bash
cut -c 1-5 note.txt
cut -d ',' -f 1,3 studenti.csv
```

`-c` seleziona posizioni di carattere; `-d` indica il separatore e `-f` i campi, numerati da 1. L'intestazione viene trattata come qualsiasi altra riga.

```bash
tail -n +2 studenti.csv | cut -d ',' -f 1
```

Ottieni i sette nomi. Con delimitatori presenti nei valori o CSV con virgolette servirebbe un parser dedicato: questi esempi riguardano dati semplici.

## awk: campi, condizioni e calcoli

La forma essenziale è `awk 'condizione { azione }' file`. Senza condizione, l'azione si applica a ogni riga; senza azione, una condizione vera fa stampare la riga intera.

| Elemento | Significato |
|----------|-------------|
| `-F ','` | Separatore dei campi |
| `$0` | Riga intera |
| `$1`, `$2`… | Campi della riga |
| `NR` | Numero progressivo della riga |
| `END { … }` | Azioni dopo la lettura dell'input |

Senza `-F` i campi sono separati da sequenze di spazi o tabulazioni. Le virgolette singole attorno al programma evitano che Bash espanda `$1` e gli altri riferimenti.

```bash
awk -F ',' 'NR>1 {print $1, $3}' studenti.csv
awk -F ',' 'NR>1 && $2>=20 {print $1, $2}' studenti.csv
awk -F ',' 'NR>1 && $3=="Roma" {print $1}' studenti.csv
awk 'NR>=2 && NR<=4 {print NR, $0}' studenti.csv
```

`NR>1` salta l'intestazione; `&&` richiede che entrambe le condizioni siano vere. `==` confronta valori, `=` assegna un valore a una variabile.

```bash
awk -F ',' 'NR>1 {somma += $2; n++} END {print "Studenti:", n; print "Somma eta:", somma}' studenti.csv
awk -F ',' 'NR>1 {somma += $2; n++} END {printf "Eta media: %.1f\n", somma/n}' studenti.csv
```

`+=` accumula, `n++` incrementa il contatore; `printf` permette di scegliere il formato: `%.1f` usa una cifra decimale e `\n` termina la riga. Con questi dati ottieni sette studenti, somma 138 e media 19,7 anni. La divisione presuppone almeno un record: per ora usiamo il file di prova non vuoto.

Le strutture più avanzate di `awk`, come array e funzioni, restano nel [modulo sulla manipolazione delle stringhe](../09-Manipolazione_Stringhe/README.md).

## sed: selezione e sostituzione

`sed` legge il testo e, di norma, stampa il risultato su stdout senza cambiare l'originale.

```bash
sed -n '2,4p' studenti.csv
sed 's/debug=true/debug=false/' servizio.conf
sed -e '/^#/d' -e '/^$/d' servizio.conf
```

`-n` disattiva la stampa automatica, `p` stampa le righe indicate; `d` elimina righe dall'output. Con `-e` puoi combinare più istruzioni. Nell'ultimo esempio i commenti devono iniziare con `#` nella prima colonna e le righe vuote devono essere effettivamente vuote.

### Prima occorrenza o tutte?

```bash
echo "gatto gatto" | sed 's/gatto/cane/'
echo "gatto gatto" | sed 's/gatto/cane/g'
```

Senza `g` viene sostituita solo la prima occorrenza **di ogni riga**; con `g` tutte quelle della riga.

### Modificare il file con un backup

```bash
cp servizio.conf servizio_modificato.conf
sed -i.bak 's/^debug=true$/debug=false/' servizio_modificato.conf
diff -u servizio_modificato.conf.bak servizio_modificato.conf
```

Su Linux, `-i.bak` modifica il file e ne conserva la versione precedente con suffisso `.bak`. Il pattern ancorato modifica solo la voce esatta; `diff` deve mostrare un'unica modifica. Non usare la redirezione del risultato sullo stesso file di input.

### Approfondimento: inserire righe

```bash
sed '2i\# Indirizzo del server' servizio.conf
sed '3a\timeout=30' servizio.conf
```

`i` inserisce prima della riga indicata, `a` aggiunge dopo. Anche qui l'originale resta invariato perché non usiamo `-i`.

---

- [📑 Indice](README.md)
- [⬅️ Ricerca e ordinamento](02_ricerca_filtraggio.md)
- [➡️ Pipeline e xargs](04_pipeline_e_xargs.md)
