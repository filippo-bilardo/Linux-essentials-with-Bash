# Linux Essentials with Bash

Benvenuto al corso **Linux Essentials with Bash**! Questo percorso didattico è pensato per chi si avvicina per la prima volta al sistema operativo Linux e alla shell Bash. Attraverso una serie di esercitazioni pratiche, imparerai a muoverti con sicurezza nell'ambiente Linux: dalla navigazione del filesystem alla scrittura di script Bash avanzati.

Il corso si articola in esercitazioni progressive, ognuna delle quali presenta:
- **Teoria**: spiegazione dei concetti fondamentali
- **Esempi**: script e comandi pronti da eseguire
- **Esercizi**: attività pratiche per consolidare le competenze acquisite

Non è richiesta alcuna esperienza pregressa: si parte dai fondamenti e si arriva gradualmente a padroneggiare gli strumenti più potenti di Linux e Bash.

## Indice del Corso

1. [01. Introduzione al s.o. Linux](./01-Introduzione_al_so_Linux/README.md) 
    1. Linux e i sistemi operativi più diffusi
    2. Il mondo open source e la comunità Linux
    3. Le principali applicazioni open source su Linux
    4. Distribuzioni Linux: differenze e scelte
    5. Competenze ICT - Lavorare con Linux
2. [02. Utilizzo della Command Line](./02-Utilizzo_Command_Line/README.md)
    1. La linea di comando
    2. Ottenere aiuto e documentazione
3. [03 - Lavorare con file e cartelle](./03-Lavorare_con_file_e_cartelle/README.md)
    1. Il filesystem di Linux
    2. Comandi di navigazione e gestione dei file
4. [04 - Visualizzazione e ricerca nei file](./04-Visualizzazione_e_Ricerca/README.md)
    1. Visualizzazione e ricerca nei file
    2. L'editor di testo `nano` (altri `vim`, `emacs`)
    3. Archiviazione e compressione dei file
    4. Ricerca e filtraggio dei dati nei file
    5. Estrazione di dati dai file
5. [05 - Redirezione e Pipe](./05-Redirezione_e_Pipe/README.md)
    1. Redirezione
    2. Pipe
6. [06 - Introduzione allo Scripting Bash](./06-Introduzione_Scripting_Bash/README.md)
    1. Shebang e il linguaggi di scripting
    2. Il primo script Bash: struttura, creazione, esecuzione
    3. Variabili, input/output e comandi di base (quoting, `echo`, `read`, `clear`, `date`, `uname`)
    4. L'exit status dei comandi e la gestione degli errori
    5. Il costrutto `if` per il controllo del flusso e altre strutture condizionali
    6. Il comando test e le espressioni condizionali
7. [07 - Operazioni matematiche e stringhe in Bash](./07-Operazioni_matematiche/README.md)
    1. Operazioni matematiche in Bash: `expr`, `let`, `$(( ))`
    2. I parametri posizionali
    3. Il cicli `for`, `while` e `until` per l'iterazione
    4. I codici ANSI per la colorazione del testo e la formattazione dell'output
    5. Creazione di menu interattivi con `select` e `case`
    6. Uso di `getopts` per la gestione delle opzioni degli script
8. [08 - Manipolazione di stringhe in Bash](./08_Manipolazione_Stringhe/README.md)
    1. Manipolazione di stringhe in Bash: concatenazione, lunghezza, estrazione, sostituzione
    2. Espressioni regolari per la ricerca e la manipolazione di testo
    3. Uso di `awk` per l'elaborazione avanzata di testo
    4. Uso di `sed` per la manipolazione di testo e i flussi di dati
    5. Uso di `grep` per la ricerca di testo nei file e nei flussi di dati
    6. Uso di `cut`, `sort`, `uniq` e altri comandi per l'elaborazione di testo
    7. Uso di `xargs` per costruire comandi da input
    8. Uso di `tr` per la trasformazione di testo
    9. Uso di `wc` per contare parole, righe e caratteri
    10. Uso di `diff` per confrontare file e output
    11. Uso di `tee` per scrivere output su file e terminale contemporaneamente
   

5. [09 - Date e Orari in Bash](./09_Date_e_Orari/README.md)
    1. Gestione di date e orari in Bash: `date`, `cal`, `timedatectl`
    2. Formattazione di date e orari
    3. Calcoli con date e orari
    4. Uso di `cron` per la schedulazione di attività
    5. Uso di `at` per l'esecuzione di comandi a tempo


5.  [Gestione di Utenti e Permessi](./03-Utenti-Permessi/README.md) - Controllo degli accessi e sicurezza
6.  [Processi e Gestione dei Servizi](./04-Processi-Servizi/README.md) - Monitoraggio e controllo dei processi
7.  [Networking di Base in Linux](./05-Networking-Base/README.md) - Configurazione e diagnostica della rete
11. [Introduzione allo Scripting Bash](./06-Introduzione-Scripting-Bash/README.md) - Primi passi nella creazione di script
12. [Variabili e Tipi di Dati in Bash](./07-Variabili-Dati-Bash/README.md) - Gestione dei dati negli script
13. [Controllo del Flusso in Bash](./08-Controllo-Flusso-Bash/README.md) - Condizioni e cicli per script dinamici
14. [Funzioni in Bash](./09-Funzioni-Bash/README.md) - Modularizzazione del codice
15. [Input/Output e Redirezione](./10-Input-Output-Redirezione-Bash/README.md) - Gestione avanzata dei flussi di dati
16. [Gestione Errori e Debugging](./11-Gestione-Errori-Debugging-Bash/README.md) - Tecniche per script robusti
17. [Scripting Avanzato in Bash](./12-Scripting-Avanzato-Bash/README.md) - Tecniche e strumenti avanzati
18. [Progetti Pratici e Script Complessi](./13-Progetti-Pratici-Script-Complessi/README.md) - Applicazioni reali
19. [Risorse Utili e Prossimi Passi](./14-Risorse-Utili-Prossimi-Passi/README.md) - Continuare l'apprendimento

## Struttura del Corso

Il corso è suddiviso in moduli, ognuno focalizzato su specifici argomenti. Ogni modulo è contenuto in una cartella numerata e include:

- Un file `README.md` con la descrizione del modulo, gli argomenti trattati e link a risorse.
- Una sottocartella `guide/` con materiale didattico approfondito su ogni argomento.
- Una sottocartella `esempi/` con script Bash e comandi di esempio commentati e pronti all'uso.
- Una sottocartella `esercizi/` con problemi pratici di difficoltà crescente per consolidare l'apprendimento.

## Come Utilizzare Questo Corso

Si consiglia di seguire i moduli nell'ordine proposto, poiché ogni lezione si basa sulle conoscenze acquisite nelle precedenti. Per ogni modulo:

1. Leggete attentamente il file `README.md` per una panoramica degli argomenti
2. Studiate le guide nella cartella `guide/` per approfondire ogni concetto
3. Esaminate gli esempi nella cartella `esempi/` ed eseguiteli nel vostro ambiente
4. Completate gli esercizi nella cartella `esercizi/` per verificare la vostra comprensione
5. Sperimentate modificando gli script esistenti per consolidare l'apprendimento

Non esitate a tornare ai moduli precedenti se necessario e ricordate che la pratica costante è la chiave per padroneggiare Bash e Linux.

Buono studio!

