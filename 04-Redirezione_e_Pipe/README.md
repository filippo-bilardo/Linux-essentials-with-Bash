# 04 — Redirezione e Pipe

## Percorso del modulo

Dopo la gestione di file e archivi del modulo 03, impariamo a fornire input ai comandi, salvare i risultati e collegare programmi. Il laboratorio usa file locali, senza privilegi di amministrazione. Per iniziare bastano `echo`, `ls` e i comandi del modulo precedente; `cat` e `wc` vengono introdotti qui per osservare i flussi.

| Unità | Contenuti principali | Tempo indicativo |
|-------|---------------------|------------------|
| [1. Redirezione](01_redirezione.md) | stdin, stdout, stderr, ordine degli operatori | 30 minuti |
| [2. Heredoc](02_heredoc.md) | Blocchi di testo, delimitatori, espansioni e here-string | 30 minuti |
| [3. Pipe](03_pipe.md) | Collegamenti, `tee` e sostituzione di comando | 30 minuti |
| [4. Editor nano](04_editor_nano.md) | Creare, correggere e salvare un file | 30 minuti |

Prevedi altri **60 minuti di laboratorio** per gli [esercizi](esercizi/README.md), inclusa la sfida conclusiva. I tempi comprendono lettura e prove e possono essere distribuiti su più incontri.

## Obiettivi

- Distinguere i tre canali standard e redirigerli separatamente o insieme.
- Scegliere tra sovrascrittura, aggiunta e input da file.
- Preparare testo letterale o con espansioni usando un heredoc.
- Collegare comandi che leggono da stdin, osservando i risultati con `tee`.
- Usare `$(comando)` per inserire un risultato in un messaggio.
- Modificare un file locale con `nano`.

## Esempi eseguibili

Esegui gli script dalla cartella `esempi/`, oppure fornisci a Bash il loro percorso. Ogni script crea e rimuove la propria directory temporanea.

- [01_redirezione.sh](esempi/01_redirezione.sh): canali separati e ordine delle redirezioni.
- [02_heredoc.sh](esempi/02_heredoc.sh): file, delimitatori e testo letterale.
- [03_pipe.sh](esempi/03_pipe.sh): conteggi, `tee` e sostituzione di comando.

## Collegamento con il modulo successivo

Nel [modulo 05](../05-Visualizzazione_e_Ricerca/README.md) useremo questi flussi per cercare e trasformare dati con `grep`, `sort`, `cut`, `awk` e `sed`. Le pipeline di analisi e `xargs` sono sviluppati lì, dopo aver spiegato gli strumenti necessari.

---

- [📑 Indice del corso](../README.md)
- [⬅️ Modulo 03](../03-Lavorare_con_file_e_cartelle/README.md)
- [➡️ Modulo 05](../05-Visualizzazione_e_Ricerca/README.md)
