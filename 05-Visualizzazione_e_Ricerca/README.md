# 05 — Visualizzazione e Ricerca nei File

## Percorso del modulo

Usiamo redirezioni, heredoc e pipe già studiati nel [modulo 04](../04-Redirezione_e_Pipe/README.md) per leggere, cercare e trasformare dati. Ogni strumento ha un compito: prima lo proviamo da solo, poi lo inseriamo in una pipeline.

| Unità | Contenuti principali | Tempo indicativo |
|-------|---------------------|------------------|
| [1. Visualizzazione](01_visualizzazione_file.md) | `less`, `head`, `tail`, misure e confronto | 30 minuti |
| [2. Ricerca e ordinamento](02_ricerca_filtraggio.md) | `grep`, regex essenziali, `sort`, `uniq`, `tr` | 30 minuti |
| [3. Estrazione e trasformazione](03_estrazione_dati.md) | `cut`, basi di `awk` e `sed` | 40 minuti |
| [4. Pipeline di analisi](04_pipeline_e_xargs.md) | Composizione e verifica dei risultati | 20 minuti |

Prevedi altri **60 minuti di laboratorio** per gli [esercizi](esercizi/README.md). Come nel modulo 04, il percorso principale richiede circa tre ore complessive. L'approfondimento su `xargs` e gli strumenti per file binari sono facoltativi.

## Preparazione dei dati

Dalla cartella di questo modulo, crea una cartella di lavoro nuova e copia i dati forniti:

```bash
mkdir ~/lab05_testi
cp esempi/dati/* ~/lab05_testi/
cd ~/lab05_testi
```

Le guide e gli esercizi usano questi file:

- [studenti.csv](esempi/dati/studenti.csv): intestazione e sette studenti; campi separati da virgole.
- [visite.txt](esempi/dati/visite.txt): sette città, con ripetizioni.
- [servizio.conf](esempi/dati/servizio.conf): configurazione con commenti e una riga vuota.
- [note.txt](esempi/dati/note.txt): breve testo per visualizzazione e confronto.

I CSV del laboratorio non contengono virgole nei valori o campi tra virgolette. Una semplice divisione sui separatori è sufficiente per questi dati, ma non per qualsiasi CSV.

## Obiettivi

- Ispezionare un file e confrontare due versioni.
- Cercare righe con pattern precisi.
- Ordinare, deduplicare e contare occorrenze.
- Selezionare campi e calcolare valori con `awk`.
- Trasformare testo con `sed` mantenendo un backup.
- Costruire pipeline verificando l'output di ogni stadio.

## Esempi eseguibili

Gli script preparano dati temporanei e li rimuovono alla fine. Si eseguono con `bash percorso_script.sh` da qualsiasi directory; la preparazione del laboratorio è necessaria solo per le prove manuali.

- [01_visualizzazione.sh](esempi/01_visualizzazione.sh): lettura, ricerca e ordinamento.
- [02_awk.sh](esempi/02_awk.sh): campi, condizioni e calcoli.
- [03_sed.sh](esempi/03_sed.sh): sostituzioni e backup.
- [04_pipeline.sh](esempi/04_pipeline.sh): analisi composta e nomi di file con spazi.

---

- [📑 Indice del corso](../README.md)
- [⬅️ Modulo 04](../04-Redirezione_e_Pipe/README.md)
- [➡️ Modulo 06](../06-Introduzione_Scripting_Bash/README.md)
