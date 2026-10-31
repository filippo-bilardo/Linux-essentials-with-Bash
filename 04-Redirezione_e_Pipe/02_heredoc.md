# Here-Document (heredoc): input su più righe

Un **here-document**, spesso abbreviato in **heredoc**, fornisce un blocco di testo allo standard input di un comando. Si usa dal terminale o dentro uno script Bash, per esempio per creare configurazioni o preparare dati di prova.

## 1. Sintassi e primo esempio

```text
comando <<DELIMITATORE
testo da fornire al comando
altre righe di testo
DELIMITATORE
```

`<<` indica la redirezione dell'input. La shell raccoglie le righe fino al delimitatore finale e le passa al comando, senza includere i delimitatori.

Prova con `cat`: senza nomi di file, questo comando legge da stdin e riproduce il testo su stdout.

```bash
cat <<FINE
Prima riga del messaggio.
Seconda riga del messaggio.
FINE
```

Output:

```text
Prima riga del messaggio.
Seconda riga del messaggio.
```

`FINE` è un nome scelto da noi: sono comuni anche `EOF` ed `END`. Scegli un nome che non compaia da solo nel contenuto.

Nel terminale interattivo Bash può mostrare il prompt di continuazione `>` mentre aspetta le righe successive. Quel simbolo è un prompt: non va copiato nel testo.

## 2. Come chiudere il blocco

Con `<<` il delimitatore di chiusura deve comparire **da solo, all'inizio della riga**, con le stesse maiuscole e minuscole usate nell'apertura. Non aggiungere spazi, commenti o altri caratteri sulla stessa riga.

Se apri con `<<'FINE'`, chiudi con `FINE`, senza virgolette. Se dimentichi la chiusura, la shell continua ad aspettare input; nel terminale puoi annullare con `Ctrl+C`.

Gli spazi presenti nelle normali righe del testo vengono conservati. Anche una riga vuota fa parte del contenuto.

## 3. Salvare il testo in un file

Combina l'heredoc con la redirezione di stdout:

```bash
cat > server.conf <<'CONFIG'
[server]
host=localhost
port=8080
debug=false
CONFIG

cat server.conf
```

Qui intervengono due redirezioni: `<<'CONFIG'` alimenta stdin di `cat`; `> server.conf` salva il suo output. Il file viene creato oppure sovrascritto. L'heredoc, da solo, non crea un file.

Per aggiungere righe al file esistente, usa `>>`:

```bash
cat >> server.conf <<'CONFIG'

[database]
host=127.0.0.1
port=5432
CONFIG
```

La riga vuota dopo l'apertura inserisce una separazione tra le due sezioni.

## 4. Espansioni: delimitatore libero o tra virgolette

### Delimitatore senza virgolette

La shell può sostituire variabili, risultati di comandi ed espressioni aritmetiche prima di fornire il testo al programma.

```bash
nome="Ada"
cat <<REPORT
Studente: $nome
Directory: $(pwd)
Esercizi previsti: $((2 + 3))
REPORT
```

La prima riga dell'output sarà `Studente: Ada`, la seconda conterrà la directory corrente e la terza `Esercizi previsti: 5`. La forma `$(comando)` inserisce l'output del comando; `$((espressione))` calcola un valore intero.

Le virgolette inserite **nel corpo** non bloccano queste sostituzioni:

```bash
nome="Ada"
cat <<REPORT
Nome: "$nome"
REPORT
```

Il risultato è `Nome: "Ada"`: le virgolette restano nel testo.

### Delimitatore tra virgolette

Per scrivere testo letterale, proteggi il delimitatore nell'apertura:

```bash
cat <<'MODELLO'
Studente: $nome
Directory: $(pwd)
Esercizi previsti: $((2 + 3))
MODELLO
```

L'output coincide con le tre righe scritte: `$nome`, `$(pwd)` e `$((2 + 3))` rimangono letterali. È utile per salvare modelli o esempi di codice.

Anche `<<"MODELLO"` e `<<\MODELLO` disabilitano le espansioni del corpo. Per un testo fisso, la forma `<<'MODELLO'` rende chiara l'intenzione.

## 5. Indentazione con `<<-`

Con `<<-` Bash elimina le **tabulazioni iniziali**, anche dalla riga di chiusura. Questo permette di indentare il blocco in uno script.

Nell'esempio seguente ogni riga del corpo e il delimitatore finale iniziano con una tabulazione reale, non con spazi:

```bash
cat <<-'FINE'
	Prima riga.
	Seconda riga.
	FINE
```

L'output contiene le due righe senza tabulazioni iniziali. Gli spazi non vengono rimossi: se l'editor sostituisce il tasto Tab con spazi, la chiusura indentata non viene riconosciuta.

Se non puoi garantire la presenza di tabulazioni, usa `<<` e lascia il delimitatore finale all'inizio della riga.

## 6. Fornire dati direttamente a un comando

L'heredoc si può usare con i programmi che leggono da stdin, non solo con `cat`:

```bash
wc -l <<'DATI'
Alice
Bob
Carlo
DATI
```

Il comando stampa `3`: riceve tre righe. I delimitatori non vengono contati.

Un programma deve effettivamente leggere da stdin per usare questi dati: un heredoc non trasforma le righe in argomenti del comando.

## 7. Differenza rispetto a `<` e `<<<`

| Forma | Da dove arriva l'input |
|-------|-----------------------|
| `comando < file.txt` | Da un file già esistente |
| `comando <<FINE` | Dalle righe successive, fino al delimitatore |
| `comando <<< "testo"` | Da una stringa, con un carattere di fine riga aggiunto |

L'ultima forma è una **here-string** di Bash:

```bash
cat <<< "Una sola riga"
```

Per un blocco di configurazione su più righe, l'heredoc rende più visibile il contenuto; per un input breve, la here-string è compatta.

## Esercizi

Metti in pratica delimitatori ed espansioni negli [esercizi del modulo](esercizi/README.md#esercizio-3--heredoc-letterale-e-con-espansioni).

Per approfondire la sintassi, consulta il [manuale ufficiale di Bash: Here Documents](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Here-Documents).

---

- [📑 Indice](README.md)
- [⬅️ Redirezione di input e output](01_redirezione.md)
- [➡️ Pipe e filtri](03_pipe.md)
