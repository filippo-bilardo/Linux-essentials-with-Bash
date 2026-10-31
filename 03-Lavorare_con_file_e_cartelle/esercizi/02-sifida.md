# Sfida finale — Modulo 03: Lavorare con File e Cartelle

Tre esercizi collegati: devi preparare una consegna, mantenerla accessibile dopo alcuni spostamenti e recuperarla da un archivio. La difficoltà sta nel rispettare tutti i vincoli e spiegare il risultato delle operazioni.

## Regole e preparazione

- Usa i comandi delle guide su [filesystem e percorsi](../01_filesystem_linux.md), [gestione dei file](../02_comandi_navigazione_gestione.md) e [archiviazione e compressione](../03_archiviazione_compressione.md).
- Non usare pipe, cicli, script o strumenti dei moduli successivi. Puoi eseguire più comandi separati e usare `echo` per scrivere nei file.
- Esegui gli esercizi nell'ordine indicato. Consegna la sequenza dei comandi, le verifiche e una breve motivazione per ogni scelta.
- Prima di ogni operazione, prevedi quali file o percorsi verranno coinvolti. Verifica poi con `pwd`, `ls`, `find` e `readlink`, secondo il caso.

Parti da una directory nuova `~/sfida03`. Esegui questi comandi una sola volta per creare i dati iniziali:

```bash
mkdir ~/sfida03
cd ~/sfida03
mkdir -p ingresso/sotto consegna/documenti scarti collegamenti archivi ripristino
touch ingresso/relazione_{A1,A2,A10,Ax,AB1,B1,B2,B3,C1}.txt
touch ingresso/relazione_{A1,B2}.txt.bak
touch ingresso/appunti.txt ingresso/.promemoria ingresso/cache.tmp
touch ingresso/sotto/sessione.tmp ingresso/sotto/relazione_A3.txt
echo "Versione 1" > ingresso/relazione_A1.txt
echo "ambiente=esame" > consegna/.config
```

I file vuoti sono intenzionali: servono a verificare la selezione dei nomi.

---

## Esercizio 1 — Selezionare senza coinvolgere gli intrusi

Rimani nella radice `~/sfida03`: per questo esercizio non puoi cambiare directory e devi usare percorsi relativi.

1. Con **un solo comando `cp` e un solo pattern di globbing**, copia in `consegna/documenti/` le relazioni presenti direttamente in `ingresso/` il cui nome contiene, dopo `relazione_`, una lettera `A` oppure `B`, seguita da **una sola cifra da 1 a 3**, e termina esattamente con `.txt`. Non puoi elencare i singoli nomi o usare la brace expansion per enumerarli.
2. Sposta in `scarti/` tutti i file che terminano con `.bak` presenti direttamente in `ingresso/`, usando **un solo comando e un pattern**. Gli altri file devono restare al loro posto.
3. Con **un solo comando `find`**, elimina tutti i file regolari che terminano con `.tmp` nell'intero albero `ingresso/`, comprese le sottodirectory. Prima esegui la stessa ricerca senza cancellazione e controlla i risultati.

**Verifica:** `consegna/documenti/` deve contenere esattamente cinque file e `scarti/` due file. `ingresso/.promemoria` e `ingresso/sotto/relazione_A3.txt` devono esistere ancora; i due file `.tmp` devono essere scomparsi. Le relazioni copiate devono esistere anche in `ingresso/`.

**Da spiegare:** perché un pattern con `*` subito dopo la lettera selezionerebbe anche nomi non ammessi? Perché `?` da solo non garantisce che il carattere sia una cifra?

---

## Esercizio 2 — Link che sopravvivono agli spostamenti

Parti dalla radice del laboratorio dopo l'esercizio 1.

1. Crea in `collegamenti/` un **hard link** chiamato `copia_fisica.txt` e un **link simbolico relativo** chiamato `attuale.txt`, entrambi riferiti a `consegna/documenti/relazione_A1.txt`. Non usare `cp`. Il percorso memorizzato nel link simbolico non deve contenere la home o un percorso assoluto.
2. Aggiungi la riga `Revisione approvata` al file passando attraverso `collegamenti/copia_fisica.txt`. Prima di verificare, prevedi il contenuto visibile attraverso gli altri due nomi. Dimostra con `ls -li` quali nomi condividono l'inode.
3. Rinomina `consegna/documenti/` in `consegna/pronti/`. Individua quale link continua a funzionare e quale diventa pendente. Ripara **soltanto il link simbolico**, mantenendo lo stesso nome e usando ancora un percorso relativo. Non ricreare i documenti e non cambiare l'hard link.
4. Torna nella home e rinomina l'intero laboratorio da `sfida03` a `sfida03_consegna`. Entra nella directory rinominata e verifica entrambi i link senza modificarli.

**Verifica:** `consegna/pronti/` contiene ancora cinque documenti. `relazione_A1.txt` contiene due righe. L'hard link condivide ancora l'inode con quel file e il link simbolico funziona anche dopo lo spostamento dell'intero laboratorio.

**Da spiegare:** rispetto a quale directory viene interpretata la destinazione relativa di un link simbolico? Perché rinominare la sottodirectory dei documenti e rinominare l'intero laboratorio producono effetti diversi?

---

## Esercizio 3 — Recuperare i file senza confondere le copie con i link

Lavora dalla radice `~/sfida03_consegna`, con i risultati dell'esercizio 2.

1. Crea `archivi/consegna.tar.gz` includendo l'intera directory `consegna/`, con le sue sottodirectory e il file nascosto `.config`. I nomi dei membri devono iniziare con `consegna/`, senza percorsi assoluti. Non includere `ingresso/`, `scarti/`, `collegamenti/` o l'archivio stesso. Elenca il contenuto senza estrarlo.
2. Senza estrarre tutto, ripristina **soltanto** `consegna/pronti/relazione_A1.txt` dentro `ripristino/`, mantenendo il percorso registrato nell'archivio. Non puoi estrarre altri file per poi cancellarli.
3. Rinomina `consegna/` in `consegna_originale/`, senza modificarne il contenuto. Prevedi lo stato dei due link in `collegamenti/`, poi estrai l'archivio completo nella radice del laboratorio per ricreare `consegna/`. Non riparare i link a mano. Confronta gli inode del documento ripristinato, del documento in `consegna_originale/` e dell'hard link.

**Verifica:**

- L'archivio contiene sei file regolari: i cinque documenti e `.config`, oltre alle directory che li contengono.
- In `ripristino/` esiste un solo file regolare, nel percorso `consegna/pronti/relazione_A1.txt`.
- Dopo il ripristino completo, `consegna/` contiene nuovamente i cinque documenti e il file nascosto; `relazione_A1.txt` contiene le due righe attese.
- Il link simbolico torna valido. L'hard link continua a condividere l'inode con il documento in `consegna_originale/`, mentre il documento appena ripristinato ha un inode diverso.

**Da spiegare:** perché il link simbolico ora raggiunge il documento ripristinato, mentre l'hard link resta associato al documento originale? Perché salvare solo i nomi selezionati da `consegna/*` rischierebbe di perdere una parte della consegna?

---

## Criteri di riuscita

La sfida è completata se i risultati coincidono con tutte le verifiche, i vincoli sui comandi sono rispettati e sai motivare selezioni, percorsi e comportamento dei link. Una sequenza che produce i file giusti ma coinvolge o modifica anche gli intrusi non è corretta.

---

- [📑 Indice del modulo](../README.md)
- [⬅️ Esercizi di base](README.md)
- [➡️ Modulo successivo](../../04-Redirezione_e_Pipe/README.md)
