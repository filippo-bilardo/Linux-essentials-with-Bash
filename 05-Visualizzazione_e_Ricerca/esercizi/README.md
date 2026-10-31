# Esercizi — Modulo 05: Visualizzazione e Ricerca

## Preparazione

Tempo indicativo: **60 minuti** per le sei attività principali. L'ultima combina le competenze del modulo. L'approfondimento su `xargs` è facoltativo e richiede tempo aggiuntivo.

Usa i file della [preparazione del laboratorio](../README.md#preparazione-dei-dati), lavorando in `~/lab05_testi`. Mantieni invariati gli originali `studenti.csv`, `visite.txt`, `servizio.conf` e `note.txt`. Redirezioni e pipe del modulo 04 ora possono essere usate liberamente.

## Esercizio 1 — Ispezionare e confrontare

1. Apri `note.txt` con `less`, cerca `shell`, raggiungi la fine e torna all'inizio.
2. Mostra le prime tre righe e le ultime due righe di `studenti.csv`. Conta separatamente le righe complessive e quelle dei soli studenti.
3. Copia `note.txt` in `note_nuove.txt`, aggiungi una riga e usa `diff -u` per individuare la modifica.

**Verifica:** otto righe nel CSV, sette studenti. Il confronto deve mostrare una sola riga aggiunta; lo stato `1` di `diff` indica che sono state trovate differenze.

## Esercizio 2 — Ricerca precisa con grep

1. Mostra, con i numeri di riga originali, gli studenti di Roma. Il pattern deve selezionare il campo completo.
2. Conta gli studenti del gruppo A e quelli di vent'anni con due ricerche distinte.
3. Cerca Alice ignorando maiuscole e minuscole. Spiega perché una ricerca non ancorata può essere insufficiente con nomi più lunghi.

**Verifica:** quattro studenti di Roma alle righe 2, 4, 7 e 8; quattro del gruppo A; due di vent'anni. Ogni conteggio deve escludere l'intestazione.

## Esercizio 3 — Ordinamento e frequenze

1. Elenca le città distinte di `visite.txt` in ordine alfabetico.
2. Conta tutte le occorrenze di ciascuna città. Spiega perché eseguire soltanto `uniq -c visite.txt` non risolve la richiesta.
3. Ordina gli studenti per età crescente, senza includere l'intestazione tra i dati.

**Verifica:** tre città distinte; frequenze Roma 4, Milano 2, Napoli 1. Gli studenti più giovani sono Alice ed Eva, il più grande è Giulia. L'ordine tra studenti della stessa età non è un requisito.

## Esercizio 4 — Estrarre campi e calcolare con awk

1. Estrai con `cut` soltanto i nomi, senza intestazione.
2. Con un solo `awk`, mostra nome ed età degli studenti del gruppo A con almeno diciannove anni.
3. In un'altra esecuzione di `awk`, calcola il numero e la somma delle età degli studenti che rispettano quella stessa condizione.

**Verifica:** al primo punto ottieni sette nomi; ai successivi Carlo e Giulia, due studenti con somma delle età `41`. Non calcolare i risultati a mano nel comando.

## Esercizio 5 — Trasformare con sed e conservare un backup

1. Crea `servizio_consegna.conf` come copia di `servizio.conf`.
2. Con una sola invocazione di `sed`, porta `port=8080` a `port=9090` e `debug=true` a `debug=false`, conservando il backup `.bak`. Usa pattern che corrispondano alle intere voci.
3. Confronta il backup con la versione modificata.
4. Genera `servizio_pulito.conf` eliminando commenti e righe vuote dalla versione modificata, senza cambiare altri file.

**Verifica:** il confronto mostra due righe cambiate. Il file pulito contiene quattro impostazioni; il backup conserva porta e debug originali.

## Esercizio 6 — Analisi integrata: sfida finale

Partendo sempre da `studenti.csv`:

1. Seleziona gli studenti del gruppo A, estrai la città e produci il conteggio per città, in ordine di frequenza decrescente. Salva il risultato in `distribuzione_A.txt` e mostralo sul terminale con la stessa pipeline.
2. Produci una seconda pipeline che mostri soltanto i due studenti più grandi dell'intero elenco, senza intestazione.
3. Crea un breve report con `$(comando)` e un heredoc: numero totale di studenti, numero nel gruppo A e numero di città distinte nell'intero elenco. Nessun numero deve essere inserito a mano.

**Verifica:** distribuzione del gruppo A: Roma 3, Milano 1; studenti più grandi: Giulia e Diana; riepilogo: `7` studenti, `4` nel gruppo A, `3` città. Mostra almeno un risultato intermedio e spiega l'ordine dei filtri.

## Approfondimento facoltativo — xargs e nomi con spazi

Dopo la [guida dedicata](../04_pipeline_e_xargs.md#approfondimento-facoltativo-xargs):

1. Crea `documenti/appunti.txt` e `documenti/relazione finale.txt`, poi una directory `copie/`.
2. Copia entrambi i file con una pipeline basata su `find -print0` e `xargs -0`.
3. Ripeti una ricerca che non trovi file, usando `-r` per evitare invocazioni senza argomenti.

**Verifica:** nella destinazione ci sono esattamente due nomi; lo spazio in `relazione finale.txt` è conservato. Non usare l'output di `ls` per passare i nomi a `xargs`.

## Esempi per il ripasso

- [Visualizzazione e ricerca](../esempi/01_visualizzazione.sh)
- [awk](../esempi/02_awk.sh)
- [sed](../esempi/03_sed.sh)
- [Pipeline e xargs](../esempi/04_pipeline.sh)

---

- [📑 Indice del modulo](../README.md)
- [⬅️ Esercizi del modulo 04](../../04-Redirezione_e_Pipe/esercizi/README.md)
- [➡️ Esercizi del modulo 06](../../06-Introduzione_Scripting_Bash/esercizi/README.md)
