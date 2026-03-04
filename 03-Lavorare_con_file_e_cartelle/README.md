# 03 — Lavorare con File e Cartelle

## Descrizione

In questo modulo esploreremo la struttura del filesystem di Linux e impareremo a gestire file e directory dalla riga di comando. Dalla navigazione con `cd` e `ls` fino alla copia, spostamento, ridenominazione e cancellazione di file, acquisiremo la padronanza completa delle operazioni fondamentali sul filesystem.

## Obiettivi

Al termine di questo modulo sarai in grado di:

- Descrivere la struttura gerarchica del filesystem di Linux e il significato delle directory principali
- Navigare il filesystem con `pwd`, `cd`, `ls` usando percorsi assoluti e relativi
- Creare, copiare, spostare, rinominare ed eliminare file e directory
- Usare i metacaratteri (globbing) per selezionare gruppi di file
- Creare e interpretare link simbolici e hard link
- Gestire i permessi di base dei file

---

## Indice degli Argomenti

### Guide
1. [Il Filesystem di Linux](01_filesystem_linux.md)
2. [Comandi di Navigazione e Gestione dei File](02_comandi_navigazione_gestione.md)

### Esempi
- [Navigazione del filesystem](esempi/01_navigazione.sh)
- [Gestione file e directory](esempi/02_gestione_file.sh)

### Esercizi
- [Esercizi del Modulo 03](esercizi/README.md)

---

## Concetti Chiave

| Termine | Significato |
|---------|------------|
| **Percorso assoluto** | Inizia dalla radice `/`, es. `/home/utente/file.txt` |
| **Percorso relativo** | Relativo alla directory corrente, es. `../altro/file.txt` |
| **`.`** | La directory corrente |
| **`..`** | La directory padre |
| **`~`** | La home directory dell'utente corrente |
| **Globbing** | Uso di `*`, `?`, `[]` per selezionare più file |
| **Hard link** | Altro nome per lo stesso file (stesso inode) |
| **Link simbolico** | Puntatore (scorciatoia) a un altro file o directory |

---

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../02-Utilizzo_Command_Line/README.md>)
- [➡️ successivo](<../04-Visualizzazione_e_Ricerca/README.md>)
