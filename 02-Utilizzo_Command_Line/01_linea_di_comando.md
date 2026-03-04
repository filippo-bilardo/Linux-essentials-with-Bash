# La Linea di Comando

## Cos'è la Shell?

La **shell** è un programma che interpreta i comandi che l'utente digita e li traduce in chiamate al sistema operativo. È l'interfaccia testuale tra l'utente e il kernel Linux.

Esistono diverse shell per Linux:

| Shell | Nome completo | Note |
|---|---|---|
| **bash** | Bourne Again SHell | La più diffusa, shell predefinita su Ubuntu/Debian |
| **sh** | Bourne Shell | La shell originale di Unix, minimalista |
| **zsh** | Z Shell | Altamente personalizzabile, popolare tra gli sviluppatori |
| **fish** | Friendly Interactive SHell | Autocompletamento avanzato, sintassi diversa |
| **dash** | Debian Almquist Shell | Velocissima, usata per script di sistema |

Per sapere quale shell stai usando:
```bash
echo $SHELL       # Shell predefinita del tuo utente
echo $0           # Shell correntemente attiva
cat /etc/shells   # Tutte le shell installate sul sistema
```

---

## Anatomia di un Comando

Un comando Linux ha tipicamente questa struttura:

```
comando  [opzioni]  [argomenti]
   |          |          |
   |          |          └── Su cosa agisce il comando (file, directory, testo...)
   |          └── Come si comporta il comando
   └── Il programma da eseguire
```

### Esempio:
```bash
ls    -la    /home
 ^     ^       ^
 |     |       └── argomento: la directory da listare
 |     └── opzioni: -l (formato lungo) -a (mostra nascosti)
 └── comando: ls (lista il contenuto di una directory)
```

### Opzioni in forma breve e lunga
La maggior parte dei comandi accetta opzioni in due formati:

```bash
ls -a               # forma breve: un trattino + lettera
ls --all            # forma lunga: due trattini + parola

# Opzioni brevi possono essere combinate:
ls -l -a -h         # equivalente a:
ls -lah             # combinazione di -l, -a, -h
```

---

## Scorciatoie da Tastiera Fondamentali

Queste scorciatoie aumentano enormemente la produttività:

### Completamento automatico (Tab)
```
Tab           → completa automaticamente nomi di comandi, file, directory
Tab Tab       → mostra tutte le possibili completamenti
```

### Navigazione nel prompt
```
Ctrl+A        → vai all'inizio della riga
Ctrl+E        → vai alla fine della riga
Ctrl+←        → sposta il cursore una parola a sinistra
Ctrl+→        → sposta il cursore una parola a destra
```

### Modifica del testo
```
Ctrl+U        → cancella dalla posizione corrente all'inizio
Ctrl+K        → cancella dalla posizione corrente alla fine
Ctrl+W        → cancella la parola a sinistra del cursore
Ctrl+Y        → incolla il testo cancellato (yank)
```

### Cronologia dei comandi
```
↑ / ↓         → naviga nella cronologia dei comandi
Ctrl+R        → ricerca interattiva nella cronologia
!!            → ripete l'ultimo comando
!n            → ripete il comando numero n della cronologia
!stringa      → ripete l'ultimo comando che inizia con "stringa"
history       → mostra tutta la cronologia
history 20    → mostra gli ultimi 20 comandi
```

### Controllo del terminale
```
Ctrl+C        → interrompe il comando in esecuzione
Ctrl+Z        → sospende il comando in esecuzione (in background)
Ctrl+D        → fine input (EOF) / esce dalla shell
Ctrl+L        → pulisce lo schermo (equivalente a clear)
```

---

## Tipi di Comandi

In Linux esistono due tipi principali di comandi:

### 1. Comandi interni (builtin)
Sono parte integrante della shell, non esistono come file eseguibili separati.

```bash
type cd       # → cd is a shell builtin
type echo     # → echo is a shell builtin
type pwd      # → pwd is a shell builtin
```

Esempi di builtin: `cd`, `echo`, `pwd`, `export`, `alias`, `source`, `exit`, `read`, `set`, `unset`, `history`

### 2. Comandi esterni
Sono file eseguibili presenti nelle directory del sistema.

```bash
type ls       # → ls is /usr/bin/ls
type grep     # → grep is /usr/bin/grep
which python3 # → /usr/bin/python3  (mostra il percorso dell'eseguibile)
```

### Scoprire il tipo di un comando
```bash
type -a ls    # mostra tutti i tipi (alias, builtin, file)
which comando # trova il percorso di un comando esterno
whereis ls    # cerca binario, sorgente e manuale
```

---

## La Variabile PATH

Quando digiti un comando, la shell cerca il file eseguibile nelle directory elencate nella variabile **PATH**:

```bash
echo $PATH
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

La shell cerca nell'ordine da sinistra a destra. Se il file non è trovato in nessuna directory del PATH, otterrai:
```
bash: comando_sconosciuto: command not found
```

Per aggiungere una directory al PATH (temporaneamente):
```bash
export PATH="$PATH:/nuova/directory"
```

---

## Exit Status: il Codice di Ritorno

Ogni comando, quando termina, restituisce un **exit status** (codice di uscita):

- **0** = successo
- **1-255** = errore (il significato dipende dal comando)

```bash
ls /tmp          # Comando con successo
echo $?          # → 0

ls /cartella_che_non_esiste
echo $?          # → 2 (errore)
```

La variabile speciale `$?` contiene sempre l'exit status dell'**ultimo** comando eseguito.

---

## Variabili Speciali della Shell

| Variabile | Significato |
|---|---|
| `$?` | Exit status dell'ultimo comando |
| `$0` | Nome dello script o della shell |
| `$$` | PID (Process ID) della shell corrente |
| `$!` | PID dell'ultimo processo lanciato in background |
| `$-` | Opzioni attive della shell |
| `$_` | Ultimo argomento dell'ultimo comando |

```bash
sleep 10 &       # lancia sleep in background
echo $!          # → PID del processo sleep appena lanciato
echo $$          # → PID della shell corrente
echo $0          # → bash (o il nome dello script)
```

---

## Alias: Creare Scorciatoie

Gli **alias** permettono di creare abbreviazioni per comandi lunghi o complessi:

```bash
alias ll='ls -lah'                   # crea un alias
alias gs='git status'
alias update='sudo apt update && sudo apt upgrade -y'

alias                                # mostra tutti gli alias attivi
unalias ll                           # rimuove un alias
```

Per renderli permanenti, aggiungili al file `~/.bashrc`:
```bash
echo "alias ll='ls -lah'" >> ~/.bashrc
source ~/.bashrc    # ricarica il file di configurazione
```

---

- [📑 Indice](<README.md>)
- [➡️ successivo](<02_ottenere_aiuto.md>)
