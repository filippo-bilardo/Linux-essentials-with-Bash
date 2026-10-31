# Pipe, tee e sostituzione di comando

## Collegare stdout a stdin

La pipe `|` invia stdout del comando a sinistra a stdin del comando a destra. Stderr mantiene la propria destinazione, normalmente il terminale. Non serve un file intermedio.

Prepara due file di prova:

```bash
mkdir ~/lab04_pipe
cd ~/lab04_pipe
echo "Alice" > gruppo_a.txt
echo "Bob" >> gruppo_a.txt
echo "Carlo" > gruppo_b.txt
```

Il comando `cat` può leggere più file in sequenza. Confronta i due modi di contare le righe:

```bash
# Con un file intermedio
cat gruppo_a.txt gruppo_b.txt > tutti.txt
wc -l < tutti.txt

# Con una pipe
cat gruppo_a.txt gruppo_b.txt | wc -l
```

Entrambi producono `3`. I programmi di una pipeline possono lavorare contemporaneamente: ogni comando può elaborare i dati mentre il precedente li produce.

## Osservare e salvare con `tee`

`tee` legge da stdin e copia i dati su stdout e su uno o più file:

```bash
cat gruppo_a.txt gruppo_b.txt | tee iscritti.txt
cat gruppo_a.txt gruppo_b.txt | tee controllo.txt | wc -l
```

Nel primo caso vedi i nomi e li salvi. Nel secondo, il terminale mostra soltanto il conteggio: l'output di `tee` prosegue verso `wc`, mentre `controllo.txt` conserva i nomi.

```bash
echo "Diana" | tee -a iscritti.txt
```

Per impostazione predefinita `tee` sovrascrive i file; `-a` aggiunge. Non usare come destinazione lo stesso file che la pipeline sta leggendo.

## La pipe non include automaticamente stderr

Per inviare anche gli errori al comando successivo, unisci i canali **prima della pipe**:

```bash
ls gruppo_a.txt assente.txt 2>&1 | tee esito.txt
```

`assente.txt` non esiste: `esito.txt` conterrà il risultato normale e il messaggio di errore. Questa operazione combina `2>&1` e `|`.

## Inserire un risultato nel testo: `$(comando)`

La sostituzione di comando usa stdout di un comando come parte di un altro comando. I caratteri di fine riga finali vengono rimossi.

```bash
echo "Directory corrente: $(pwd)"
echo "Righe complessive: $(cat gruppo_a.txt gruppo_b.txt | wc -l)"
```

Per riutilizzare il risultato, assegnalo a una variabile: non inserire spazi attorno a `=`.

```bash
totale=$(cat gruppo_a.txt gruppo_b.txt | wc -l)
echo "Iscritti: $totale"
echo "Operazione del $(date '+%Y-%m-%d')" >> registro.txt
```

Mantieni le espansioni tra virgolette doppie quando costituiscono un argomento. La sostituzione produce testo; la pipe trasferisce un flusso di dati.

## Dati su stdin e argomenti sono diversi

`cat file.txt` riceve un nome come argomento; `cat < file.txt` riceve il contenuto su stdin. Una pipe fornisce dati su stdin, non un elenco automatico di argomenti.

Per esempio, passare nomi a `touch` con una pipe non crea quei file: `touch` richiede nomi come argomenti. Nel modulo 05 incontreremo [`xargs`](../05-Visualizzazione_e_Ricerca/04_pipeline_e_xargs.md), dopo le pipeline di ricerca.

## Esercizi

Applica pipe, `tee` e sostituzione di comando negli [esercizi 4 e 5](esercizi/README.md#esercizio-4--contare-mostrare-e-salvare-un-flusso).

---

- [📑 Indice](README.md)
- [⬅️ Heredoc](02_heredoc.md)
- [➡️ Editor nano](04_editor_nano.md)
