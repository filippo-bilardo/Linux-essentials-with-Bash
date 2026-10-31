# Redirezione di input e output

## I tre canali standard

| Canale | Numero | Uso normale |
|--------|--------|-------------|
| stdin | 0 | Dati letti dal comando, spesso dalla tastiera |
| stdout | 1 | Risultati, normalmente mostrati nel terminale |
| stderr | 2 | Diagnostica ed errori, normalmente mostrati nel terminale |

La redirezione cambia l'origine o la destinazione di un canale. Non cambia gli argomenti del comando.

Per osservare i risultati useremo due strumenti: `cat file` mostra il contenuto di un file; `cat` senza argomenti riproduce stdin su stdout. `wc -l` conta i caratteri di fine riga ricevuti: nei nostri file, terminati correttamente, corrispondono al numero di righe.

## Preparare il laboratorio

Esegui i blocchi nell'ordine indicato, in una cartella nuova:

```bash
mkdir ~/lab04_flussi
cd ~/lab04_flussi
echo "prima riga" > note.txt
```

## Scrivere o aggiungere: `>` e `>>`

```bash
echo "seconda riga" >> note.txt
cat note.txt
```

`>` crea il file oppure **sovrascrive** il suo contenuto; `>>` crea il file oppure aggiunge in fondo. In questo momento `note.txt` contiene due righe. La shell apre il file di destinazione prima che il comando lo utilizzi: evita operazioni come `cat note.txt > note.txt`, che svuoterebbero il file prima della lettura.

## Leggere da un file: `<`

```bash
cat < note.txt
wc -l < note.txt
cat < note.txt > copia.txt
```

Il conteggio è `2`. Con `<`, il comando riceve dati su stdin; con `>`, il suo risultato viene scritto in un altro file. `cat` non riceve il nome `note.txt` come argomento: è la shell ad aprire il file.

## Separare risultati ed errori

`manca.txt` non deve esistere nel laboratorio:

```bash
ls note.txt manca.txt > elenco.txt 2> errori.txt
cat elenco.txt
cat errori.txt
```

`elenco.txt` contiene il nome del file esistente; `errori.txt` contiene la diagnostica per quello mancante. `ls` termina con uno stato diverso da zero perché una richiesta è fallita: in questo esempio è previsto.

`2>> errori.txt` aggiunge gli errori a un file esistente. Per ignorare solo stderr:

```bash
ls note.txt manca.txt 2> /dev/null
```

`/dev/null` scarta ciò che riceve. L'output normale resta visibile.

## Unire i canali e capire l'ordine

```bash
ls note.txt manca.txt > tutto.txt 2>&1
cat tutto.txt
```

Prima stdout viene diretto al file, poi stderr viene collegato alla destinazione corrente di stdout. Entrambi finiscono in `tutto.txt`. Bash permette anche `&> tutto.txt`.

Invertendo gli operatori, cambia il risultato:

```bash
ls note.txt manca.txt 2>&1 > solo_output.txt
```

Stderr viene collegato allo stdout iniziale, cioè al terminale. Solo dopo stdout viene diretto al file: l'errore resta sul terminale e `solo_output.txt` contiene il risultato normale.

## Scegliere l'operatore

| Obiettivo | Forma |
|-----------|-------|
| Scrivere stdout, sostituendo il contenuto | `comando > file` |
| Aggiungere stdout | `comando >> file` |
| Leggere stdin | `comando < file` |
| Salvare stderr | `comando 2> file` |
| Salvare entrambi i canali | `comando > file 2>&1` |
| Ignorare solo gli errori | `comando 2> /dev/null` |

Per fornire un blocco di testo senza creare prima un file, passa alla guida sugli heredoc. Per collegare direttamente due comandi, useremo le pipe.

---

- [📑 Indice](README.md)
- [⬅️ Archiviazione e compressione](../03-Lavorare_con_file_e_cartelle/03_archiviazione_compressione.md)
- [➡️ Heredoc](02_heredoc.md)
