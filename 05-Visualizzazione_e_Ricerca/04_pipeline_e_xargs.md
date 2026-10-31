# Pipeline di analisi e xargs

Questa guida combina gli strumenti delle tre unità precedenti. Redirezioni, `tee` e `$(comando)` restano quelli del [modulo 04](../04-Redirezione_e_Pipe/03_pipe.md): qui ci concentriamo sulla scelta e sull'ordine dei filtri.

## Progettare una pipeline per stadi

Con il file `studenti.csv` del [laboratorio](README.md#preparazione-dei-dati), vogliamo contare gli studenti per città, mostrando prima le frequenze maggiori.

```bash
tail -n +2 studenti.csv
tail -n +2 studenti.csv | cut -d ',' -f 3
tail -n +2 studenti.csv | cut -d ',' -f 3 | sort
tail -n +2 studenti.csv | cut -d ',' -f 3 | sort | uniq -c
```

Ogni comando aggiunge un solo passaggio: salta l'intestazione, estrae la città, raggruppa le righe uguali, conta le occorrenze. Controlla l'output prima di aggiungere lo stadio successivo.

```bash
tail -n +2 studenti.csv | cut -d ',' -f 3 | sort | uniq -c | sort -nr | tee frequenze.txt
```

Il risultato deve riportare Roma 4, Milano 2, Napoli 1. Gli spazi prima dei conteggi dipendono dalla formattazione di `uniq`.

## Filtrare campi, poi ordinare

Per gli studenti di Roma con almeno vent'anni:

```bash
awk -F ',' 'NR>1 && $3=="Roma" && $2>=20 {print $1, $2}' studenti.csv | sort -k2,2nr
```

Giulia precede Franco. Il confronto sul campo città evita corrispondenze casuali in altre colonne. Per selezioni tabellari articolate, un singolo `awk` è spesso più leggibile di numerosi `grep`.

Per mostrare solo i due studenti più grandi:

```bash
tail -n +2 studenti.csv | sort -t ',' -k2,2nr | head -n 2
```

L'intestazione deve essere rimossa **prima** dell'ordinamento. Il risultato contiene Giulia e Diana.

## Creare un testo pronto per la consegna

```bash
sed -e '/^#/d' -e '/^$/d' servizio.conf | tee configurazione_pulita.conf | wc -l
```

Il file salvato contiene quattro impostazioni, il terminale mostra `4`. Per un report, puoi usare `$(comando)` per i riepiloghi numerici e `tee` per conservare un risultato intermedio.

## Approfondimento facoltativo: xargs

`xargs` converte elementi ricevuti su stdin in argomenti di un altro programma. Per semplici parole separate da spazi:

```bash
echo "uno due tre quattro" | xargs -n 2 echo
```

`-n 2` passa al massimo due argomenti per invocazione. Per nomi di file, spazi e caratteri speciali richiedono un separatore non ambiguo:

```bash
mkdir -p documenti copie
touch "documenti/relazione finale.txt" "documenti/appunti.txt"
find documenti -type f -name '*.txt' -print0 | xargs -0 -r -I {} cp -- "{}" copie/
```

- `find -print0` separa i nomi con il carattere NUL.
- `xargs -0` legge lo stesso formato, conservando spazi e fine riga nei nomi.
- `-r`, nella versione GNU usata su Linux, evita l'invocazione se l'input è vuoto.
- `-I {}` inserisce ogni nome al posto di `{}`; `--` termina le opzioni di `cp`.

Nel laboratorio i nomi di base sono distinti: le copie non si sovrascrivono. Non usare l'output di `ls` come elenco di argomenti. Per cercare e agire sui file puoi anche scegliere `find -exec`, già incontrato nel modulo 03.

Per le opzioni complete consulta il [manuale GNU di xargs](https://www.gnu.org/software/findutils/manual/html_node/find_html/xargs-options.html).

---

- [📑 Indice](README.md)
- [⬅️ Estrazione e trasformazione](03_estrazione_dati.md)
- [➡️ Introduzione allo scripting](../06-Introduzione_Scripting_Bash/01_primo_script.md)
