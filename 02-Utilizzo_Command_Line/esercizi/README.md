# Esercizi — Modulo 02: Utilizzo della Command Line

Completa gli esercizi seguenti nel terminale. Per ogni esercizio annota il comando usato e l'output ottenuto.

---

## Esercizio 1 — Identificare il tipo di comandi

Per ognuno dei seguenti comandi, usa `type` per scoprire se è un builtin, un file esterno o un alias:

```bash
type cd
type ls
type echo
type grep
type man
type history
```

**Domande:**
1. Quali comandi sono builtin della shell?
2. Qual è il percorso del file eseguibile di `ls`?
3. Cosa succede se digiti `type -a echo`? Perché ci sono due risultati?

---

## Esercizio 2 — Leggere una man page

1. Apri il manuale del comando `ls`:
   ```bash
   man ls
   ```
2. Rispondi alle seguenti domande usando **solo** la man page (senza cercare online):
   - Quale opzione ordina i file per data di modifica?
   - Quale opzione mostra la dimensione dei file in formato leggibile (es. `4.0K`)?
   - Come si elencano i file ordinati per dimensione, dal più grande al più piccolo?
   - Qual è il significato del campo numerico nella seconda colonna dell'output di `ls -l`?

---

## Esercizio 3 — Usare `--help` e `whatis`

```bash
whatis cp
whatis mv
whatis rm
cp --help | head -20
```

**Domande:**
1. Qual è la differenza tra `cp` e `mv`?
2. Come si copia ricorsivamente una directory? (usa `cp --help`)
3. Come si usa `rm` per rimuovere una directory? (usa `rm --help`)

---

## Esercizio 4 — `apropos`: trovare comandi sconosciuti

Usa `apropos` per trovare comandi che non conosci ancora:

```bash
apropos "disk usage"
apropos "network interface"
apropos compress
```

**Domande:**
1. Quale comando mostra l'utilizzo del disco? (cerca tra i risultati di `disk usage`)
2. Quale comando mostra le interfacce di rete?
3. Trova 3 comandi per la compressione dei file.

---

## Esercizio 5 — Scorciatoie da tastiera

Pratica queste scorciatoie nel terminale:

1. Digita `ls -la /home` ma **senza eseguirlo**, poi vai all'inizio della riga con `Ctrl+A`
2. Ora vai alla fine della riga con `Ctrl+E`
3. Cancella tutta la riga con `Ctrl+U`
4. Digita qualche comando (`ls`, `pwd`, `date`, `whoami`)
5. Usa `Ctrl+R` e digita `wh` per cercare `whoami` nella cronologia
6. Usa `↑` e `↓` per navigare tra i comandi precedenti

**Domande:**
1. Cosa fa `Ctrl+W`? Prova a usarlo mentre c'è del testo nel prompt.
2. Come usi `!!` per rieseguire l'ultimo comando con `sudo`?

---

## Esercizio 6 — Exit status

```bash
ls /tmp
echo "Exit status: $?"

ls /directory_inesistente_xyz
echo "Exit status: $?"

true
echo "Exit status: $?"

false
echo "Exit status: $?"
```

**Domande:**
1. Qual è l'exit status di un comando che ha avuto successo?
2. Quali exit status hai ottenuto per i comandi falliti?
3. Cosa sono i comandi `true` e `false`? (usa `man true`)

---

## Esercizio 7 — Creare alias

1. Crea questi alias nella sessione corrente:
   ```bash
   alias ll='ls -lah'
   alias ..='cd ..'
   alias c='clear'
   alias h='history'
   ```

2. Verifica che funzionino:
   ```bash
   ll
   h | tail -5
   ```

3. Visualizza tutti gli alias attivi:
   ```bash
   alias
   ```

4. Rimuovi l'alias `c`:
   ```bash
   unalias c
   ```

**Domanda:** Gli alias creati in questo modo persistono dopo aver chiuso il terminale? Come si rendono permanenti?

---

## Esercizio 8 — Sfida: script di documentazione

Crea un file `info_comando.sh` nella cartella `esercizi/` che:
1. Accetti un nome di comando come argomento (`$1`)
2. Mostri: tipo del comando, percorso (se esterno), e descrizione `whatis`
3. Se non viene passato alcun argomento, mostri un messaggio di utilizzo

Esempio di output atteso:
```
$ bash info_comando.sh ls
Comando  : ls
Tipo     : file
Percorso : /usr/bin/ls
Descr.   : ls (1) - list directory contents
```

**Suggerimento:** usa `type -t`, `which`, `whatis` e la variabile `$1`.

---

## Soluzioni

> Le soluzioni saranno discusse in aula. Prova a svolgere gli esercizi in autonomia prima di confrontarti con il docente.

---

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../01-Introduzione_al_so_Linux/esercizi/README.md>)
- [➡️ successivo](<../../03-Lavorare_con_file_e_cartelle/README.md>)
