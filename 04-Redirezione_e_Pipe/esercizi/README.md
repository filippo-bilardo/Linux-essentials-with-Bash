# Esercizi — Modulo 04: Redirezione e Pipe

## Preparazione

Tempo indicativo: **60 minuti**, compresa la sfida. Le prime attività preparano i file usati dalle successive. Esegui comandi nel terminale: la scrittura di script sarà affrontata nel modulo 06.

```bash
mkdir ~/esercizi04
cd ~/esercizi04
```

Puoi consultare le guide: [redirezione](../01_redirezione.md), [heredoc](../02_heredoc.md), [pipe](../03_pipe.md), [nano](../04_editor_nano.md). Per ogni attività conserva i comandi usati e l'output delle verifiche.

## Esercizio 1 — Scrivere e rileggere

1. Crea `note.txt` con la riga `Linux` usando `>`. Aggiungi `Shell` e `File` con due operazioni di aggiunta.
2. Mostra il contenuto passando il file a stdin di `cat`; crea anche `copia.txt` usando redirezioni di input e output.
3. Conta le righe senza far comparire il nome del file nel risultato. Spiega cosa cambierebbe sostituendo il secondo `>>` con `>`, senza alterare i dati.

**Verifica:** entrambi i file contengono tre righe nell'ordine indicato.

## Esercizio 2 — Separare risultati e diagnostica

`assente.txt` non deve esistere nella cartella di lavoro.

1. Elenca `note.txt` e `assente.txt` con un unico `ls`, salvando stdout in `elenco.txt` e stderr in `errori.txt`.
2. Ripeti salvando entrambi i canali in `tutto.txt`. Ripeti ancora invertendo l'ordine di `>` e `2>&1`: spiega quale messaggio resta sul terminale.
3. Esegui lo stesso elenco scartando soltanto stderr. L'assenza della diagnostica significa che tutti i file sono stati trovati?

**Verifica:** `elenco.txt` menziona solo il file esistente; `errori.txt` quello mancante; `tutto.txt` contiene entrambe le informazioni. Il testo esatto dell'errore dipende dalla lingua del sistema.

## Esercizio 3 — Heredoc letterale e con espansioni

1. Crea `app.conf` con un heredoc. Deve contenere esattamente le righe `host=localhost`, `port=8080` e `directory=$HOME`: la variabile deve restare letterale.
2. Aggiungi `debug=false` con un secondo heredoc, senza perdere le righe precedenti.
3. Assegna il tuo nome a una variabile `nome`. Usa un altro heredoc per mostrare il nome e la directory corrente con valori espansi.

**Verifica:** `app.conf` ha quattro righe; contiene ancora i caratteri `$HOME`. Il messaggio a schermo mostra invece i valori effettivi. Spiega la scelta del delimitatore nei due casi.

## Esercizio 4 — Contare, mostrare e salvare un flusso

1. Crea `extra.txt` con due righe: `Rete` e `Processi`.
2. Collega la lettura di `note.txt` ed `extra.txt` a un conteggio con `wc`, senza file intermedi.
3. Modifica la pipeline per salvare il testo completo in `raccolta.txt` con `tee`, mostrando sul terminale soltanto il conteggio.
4. In un comando distinto, aggiungi `Archivi` a `raccolta.txt` con `tee -a`.

**Verifica:** il conteggio al punto 3 è `5`; dopo il punto 4 il file ha sei righe. I due file iniziali restano invariati.

## Esercizio 5 — Usare un risultato nel testo

1. Calcola il numero di righe complessivo dei due file iniziali e assegnalo alla variabile `totale` usando `$(comando)`.
2. Crea `riepilogo.txt` con il messaggio `Righe iniziali: 5`, ottenendo il numero dalla variabile.
3. Aggiungi una riga con la data corrente usando `$(date ...)`. Non digitare a mano la data.

**Verifica:** il riepilogo ha due righe. Il conteggio resta `5`, anche se `raccolta.txt` è stata ampliata: spiega perché.

## Esercizio 6 — Una correzione manuale con nano

1. Apri `app.conf` con `nano` e cerca `port`.
2. Cambia solo la porta da `8080` a `9090`. Inserisci all'inizio una riga di commento a tua scelta.
3. Salva, chiudi e verifica il risultato dal terminale.

**Verifica:** il file ha cinque righe, conserva `directory=$HOME` e `debug=false`, e contiene la porta aggiornata.

## Sfida conclusiva — Una consegna verificabile

Senza usare comandi del modulo successivo:

1. Crea una pipeline che salvi i cinque dati iniziali in `consegna.txt` e mostri il loro numero.
2. Crea `manifesto.txt` con un heredoc con espansioni: deve riportare la directory corrente e il numero di righe di `consegna.txt`, calcolati dai comandi.
3. Aggiungi allo stesso manifesto una sezione letterale che contenga `Esempio di variabile: $totale` senza espanderla.

La consegna è corretta se i dati iniziali sono invariati, `consegna.txt` ha cinque righe e il manifesto distingue valori calcolati e testo letterale. Spiega quale ruolo hanno stdin, stdout e `tee` nella prima operazione.

## Esempi per il ripasso

Gli script sono dimostrazioni delle guide; le verifiche sopra indicano i risultati attesi degli esercizi.

- [Redirezione](../esempi/01_redirezione.sh)
- [Heredoc](../esempi/02_heredoc.sh)
- [Pipe](../esempi/03_pipe.sh)

---

- [📑 Indice del modulo](../README.md)
- [⬅️ Esercizi del modulo 03](../../03-Lavorare_con_file_e_cartelle/esercizi/README.md)
- [➡️ Esercizi del modulo 05](../../05-Visualizzazione_e_Ricerca/esercizi/README.md)
