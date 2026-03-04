# Comandi di Navigazione e Gestione dei File

## Navigazione del Filesystem

### `pwd` — Dove mi trovo?
```bash
pwd             # Print Working Directory
# /home/filippo/documenti
```

### `ls` — Cosa c'è qui?
```bash
ls                      # lista base
ls -l                   # formato lungo (permessi, dimensione, data)
ls -a                   # mostra file nascosti (che iniziano con .)
ls -la                  # lungo + nascosti (combinazione più usata)
ls -lh                  # dimensioni in formato leggibile (K, M, G)
ls -lt                  # ordinato per data (più recente prima)
ls -lS                  # ordinato per dimensione (più grande prima)
ls -R                   # lista ricorsiva (include sottodirectory)
ls -d */                # mostra solo le directory
ls /etc/*.conf          # lista i file .conf in /etc
```

**Output di `ls -l`:**
```
-rw-r--r-- 1 filippo filippo 1234 Mar  4 10:30 file.txt
 ^          ^ ^       ^       ^    ^             ^
 |          | |       |       |    |             └── nome file
 |          | |       |       |    └── data/ora modifica
 |          | |       |       └── dimensione (byte)
 |          | |       └── gruppo
 |          | └── utente proprietario
 |          └── numero di hard link
 └── tipo(d=dir,-=file,l=link) + permessi (rwxrwxrwx)
```

### `cd` — Cambia directory
```bash
cd /etc             # directory assoluta
cd documenti        # directory relativa
cd ..               # su di un livello
cd ../..            # su di due livelli
cd ~                # vai alla home
cd                  # vai alla home (equivalente)
cd -                # torna alla directory precedente
```

---

## Creare File e Directory

### `mkdir` — Crea directory
```bash
mkdir nuova_dir                     # crea una directory
mkdir -p a/b/c                      # crea l'albero completo in un colpo
mkdir dir1 dir2 dir3                # crea più directory
mkdir -m 755 pubblica               # crea con permessi specifici
```

### `touch` — Crea file vuoto / aggiorna timestamp
```bash
touch file.txt                      # crea file vuoto (se non esiste)
touch file1.txt file2.txt           # crea più file
touch -t 202601010900 file.txt      # imposta data/ora specifica
```

### Creare file con contenuto
```bash
echo "ciao mondo" > file.txt        # crea file con contenuto
echo "altra riga" >> file.txt       # aggiunge al file
cat > file.txt << EOF               # blocco multi-riga
Riga uno
Riga due
EOF
```

---

## Copiare, Spostare, Rinominare

### `cp` — Copia file
```bash
cp file.txt copia.txt               # copia un file
cp file.txt /tmp/                   # copia in un'altra directory
cp -r cartella/ destinazione/       # copia ricorsiva (directory)
cp -i file.txt dest.txt             # chiede conferma se dest esiste
cp -p file.txt dest.txt             # preserva permessi e timestamp
cp -u sorgente dest                 # copia solo se più recente
cp *.txt /backup/                   # copia tutti i .txt
```

### `mv` — Sposta o rinomina
```bash
mv file.txt nuovo_nome.txt          # rinomina
mv file.txt /tmp/                   # sposta in un'altra directory
mv file.txt /tmp/nuovo_nome.txt     # sposta e rinomina
mv -i file.txt dest.txt             # chiede conferma se dest esiste
mv cartella/ /nuova/posizione/      # sposta una directory
mv *.log /var/log/backup/           # sposta tutti i .log
```

**Nota:** `mv` è l'unico modo per rinominare file/directory su Linux. Non esiste un comando `rename` standard (sebbene esista come utility).

---

## Eliminare File e Directory

### `rm` — Rimuovi file
```bash
rm file.txt                         # rimuove un file
rm file1.txt file2.txt              # rimuove più file
rm *.tmp                            # rimuove tutti i .tmp
rm -i file.txt                      # chiede conferma
rm -f file.txt                      # forza (ignora errori e conferme)
rm -r cartella/                     # rimuove directory ricorsivamente
rm -rf cartella/                    # rimuove senza chiedere (ATTENZIONE!)
```

> **Attenzione:** Su Linux non esiste un cestino dalla riga di comando. `rm` è **permanente**. Usa `rm -i` se hai dubbi.

### `rmdir` — Rimuovi directory vuota
```bash
rmdir dir_vuota/                    # rimuove solo se vuota
rmdir -p a/b/c                      # rimuove l'albero se tutte vuote
```

---

## Globbing: Selezionare File con Metacaratteri

Il **globbing** permette di selezionare più file usando metacaratteri. Viene espanso dalla shell prima dell'esecuzione del comando.

| Metacarattere | Significato | Esempio |
|---|---|---|
| `*` | Qualsiasi sequenza di caratteri (anche vuota) | `*.txt` → tutti i .txt |
| `?` | Esattamente un qualsiasi carattere | `file?.txt` → file1.txt, fileA.txt |
| `[abc]` | Uno dei caratteri tra parentesi | `file[123].txt` |
| `[a-z]` | Un carattere nell'intervallo | `[a-z]*.sh` |
| `[!abc]` | Un carattere NON tra parentesi | `[!0-9]*.sh` |
| `{a,b,c}` | Brace expansion: espande le alternative | `{file1,file2}.txt` |

```bash
ls *.sh                         # tutti i file .sh
ls file?.txt                    # file con UN carattere tra "file" e ".txt"
ls [A-Z]*.md                    # file che iniziano con una maiuscola
rm temp{1,2,3}.log              # rimuove temp1.log, temp2.log, temp3.log
mkdir -p progetto/{src,bin,doc} # crea tre sottodirectory in un colpo
cp *.{jpg,png} /foto/           # copia jpg e png
```

---

## Hard Link e Link Simbolici

### Hard Link
Un hard link è un altro nome per lo stesso file. Puntano allo stesso **inode** (la struttura interna che contiene i dati del file).

```bash
ln file.txt link_al_file.txt    # crea un hard link
ls -li file.txt link_al_file.txt # stesso inode number!
```

- Non può attraversare filesystem diversi
- Non funziona con le directory
- Il file viene cancellato solo quando tutti i link vengono rimossi

### Link Simbolico (Symlink)
Un link simbolico è una "scorciatoia" che punta a un percorso (nome).

```bash
ln -s /percorso/originale link   # crea un link simbolico
ln -s ../lib/funzioni.sh utils   # link simbolico con percorso relativo
ls -la                           # i symlink sono indicati con → 
readlink link                    # mostra a cosa punta il link
```

- Può attraversare filesystem
- Funziona con le directory
- Se il file originale viene eliminato, il link "pende" (dangling link)

---

## Visualizzare e Cercare File

### `find` — Cerca file nel filesystem
```bash
find /home -name "*.txt"            # cerca tutti i .txt in /home
find . -name "file.txt"             # cerca nella directory corrente
find /tmp -mtime +7                 # file più vecchi di 7 giorni
find . -size +1M                    # file più grandi di 1 MB
find . -type d                      # solo directory
find . -type f                      # solo file regolari
find . -name "*.log" -delete        # trova e cancella
find . -name "*.sh" -exec chmod +x {} \; # trova ed esegui comando
```

### `tree` — Vista ad albero (se installato)
```bash
tree                                # albero della directory corrente
tree -L 2                           # max 2 livelli di profondità
tree -d                             # solo directory
sudo apt install tree               # installa se non presente
```

### `du` — Dimensione di file e directory
```bash
du -h file.txt                      # dimensione di un file
du -sh cartella/                    # dimensione totale di una directory (-s = summary)
du -sh /*                           # dimensione di ogni directory in /
du -h --max-depth=1 ~               # dimensione delle sottodirectory della home
```

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_filesystem_linux.md>)
