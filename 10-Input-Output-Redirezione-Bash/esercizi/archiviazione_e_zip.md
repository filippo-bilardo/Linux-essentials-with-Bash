# Guida all'Archiviazione e Compressione in Linux

## Indice
1. [Introduzione](#introduzione)
2. [Differenza tra Archiviazione e Compressione](#differenza-tra-archiviazione-e-compressione)
3. [TAR - Tape Archive](#tar---tape-archive)
4. [GZIP - Compressione GNU](#gzip---compressione-gnu)
5. [BZIP2 - Compressione Migliorata](#bzip2---compressione-migliorata)
6. [XZ - Compressione Avanzata](#xz---compressione-avanzata)
7. [ZIP - Formato Cross-Platform](#zip---formato-cross-platform)
8. [7Z - Compressione ad Alto Rapporto](#7z---compressione-ad-alto-rapporto)
9. [RAR - Formato Proprietario](#rar---formato-proprietario)
10. [Confronto tra Formati](#confronto-tra-formati)
11. [Esempi Pratici](#esempi-pratici)
12. [Esercizi](#esercizi)
13. [Soluzioni](#soluzioni)

---

## Introduzione

L'**archiviazione** e la **compressione** sono operazioni fondamentali in Linux per:
- 📦 Raggruppare più file in un unico archivio
- 💾 Ridurre lo spazio occupato su disco
- 📤 Facilitare il trasferimento di file
- 🔒 Creare backup efficienti
- 📨 Distribuire software

### Vantaggi:
- ✅ Risparmio di spazio su disco
- ✅ Trasferimenti più veloci
- ✅ Organizzazione migliore dei file
- ✅ Backup più gestibili

---

## Differenza tra Archiviazione e Compressione

### Archiviazione
**Raggruppa** più file e directory in un unico file archivio.
- Non riduce necessariamente la dimensione
- Mantiene la struttura delle directory
- Preserva permessi e metadata

**Esempio**: `tar` (Tape Archive)

### Compressione
**Riduce** la dimensione di un file utilizzando algoritmi.
- Diminuisce lo spazio occupato
- Può operare su singoli file
- Necessita decompressione per accedere ai dati

**Esempio**: `gzip`, `bzip2`, `xz`

### Combinazione (Archiviazione + Compressione)
Il metodo più comune in Linux:
```bash
tar + gzip = .tar.gz (o .tgz)
tar + bzip2 = .tar.bz2
tar + xz = .tar.xz
```

---

## TAR - Tape Archive

### Descrizione
TAR è lo strumento standard Unix/Linux per creare archivi. Originariamente progettato per backup su nastro magnetico.

### Sintassi Base
```bash
tar [opzioni] [archivio] [file/directory...]
```

### Opzioni Principali

| Opzione | Descrizione |
|---------|-------------|
| `-c` | **C**rea un nuovo archivio |
| `-x` | E**x**trae file da un archivio |
| `-t` | Mos**t**ra il contenuto |
| `-v` | **V**erbose (mostra dettagli) |
| `-f` | Specifica il nome del **f**ile archivio |
| `-z` | Usa g**z**ip per compressione |
| `-j` | Usa bzip2 per compressione |
| `-J` | Usa xz per compressione |
| `-C` | Cambia directory |
| `-r` | Aggiunge file all'archivio |
| `-u` | Aggiorna l'archivio |
| `--exclude` | Esclude file/pattern |

### Esempi Base

#### Creare un archivio
```bash
# Archivio semplice (non compresso)
tar -cvf archivio.tar directory/

# Archivio con gzip
tar -czvf archivio.tar.gz directory/

# Archivio con bzip2
tar -cjvf archivio.tar.bz2 directory/

# Archivio con xz
tar -cJvf archivio.tar.xz directory/
```

#### Estrarre un archivio
```bash
# Estrazione base
tar -xvf archivio.tar

# Estrazione con gzip
tar -xzvf archivio.tar.gz

# Estrazione con bzip2
tar -xjvf archivio.tar.bz2

# Estrazione in directory specifica
tar -xzvf archivio.tar.gz -C /percorso/destinazione/
```

#### Visualizzare il contenuto
```bash
# Lista file nell'archivio
tar -tvf archivio.tar

# Lista con gzip
tar -tzvf archivio.tar.gz
```

#### Estrarre file specifici
```bash
# Estrae solo un file
tar -xzvf archivio.tar.gz file.txt

# Estrae una directory specifica
tar -xzvf archivio.tar.gz directory/subdirectory/
```

### Esempi Avanzati

#### Escludere file/directory
```bash
# Escludi file .log
tar -czvf backup.tar.gz --exclude='*.log' directory/

# Escludi multiple pattern
tar -czvf backup.tar.gz \
    --exclude='*.tmp' \
    --exclude='*.cache' \
    --exclude='node_modules' \
    directory/

# Escludi da file
tar -czvf backup.tar.gz --exclude-from=exclude.txt directory/
```

#### Backup incrementale
```bash
# Backup completo con snapshot
tar -czvf backup-full.tar.gz --listed-incremental=snapshot.snar directory/

# Backup incrementale
tar -czvf backup-inc.tar.gz --listed-incremental=snapshot.snar directory/
```

#### Archiviare con date
```bash
# Archivio con timestamp
tar -czvf backup-$(date +%Y%m%d).tar.gz directory/

# Solo file modificati dopo una certa data
tar -czvf recent.tar.gz --newer="2026-01-01" directory/
```

#### Testare l'integrità
```bash
# Verifica archivio
tar -tzf archivio.tar.gz > /dev/null && echo "OK" || echo "Corrotto"
```

---

## GZIP - Compressione GNU

### Descrizione
GZIP è l'algoritmo di compressione più usato in Linux. Buon bilanciamento tra velocità e ratio di compressione.

### Sintassi Base
```bash
gzip [opzioni] file
```

### Opzioni Principali

| Opzione | Descrizione |
|---------|-------------|
| `-c` | Scrive su stdout (mantiene originale) |
| `-d` | Decomprime |
| `-k` | Mantiene il file originale |
| `-r` | Ricorsivo |
| `-t` | Testa integrità |
| `-v` | Verbose |
| `-1` a `-9` | Livello compressione (1=veloce, 9=massimo) |

### Esempi

#### Compressione
```bash
# Comprimi file (elimina originale)
gzip file.txt
# Risultato: file.txt.gz

# Comprimi mantenendo originale
gzip -k file.txt

# Compressione massima
gzip -9 file.txt

# Comprimi e stampa su stdout
gzip -c file.txt > file.txt.gz
```

#### Decompressione
```bash
# Decomprimi
gzip -d file.txt.gz
# O equivalente:
gunzip file.txt.gz

# Decomprimi mantenendo .gz
gzip -dk file.txt.gz
```

#### Visualizzare contenuto senza decomprimere
```bash
# Visualizza file compresso
zcat file.txt.gz

# Cerca in file compresso
zgrep "pattern" file.txt.gz

# Meno per file compresso
zless file.txt.gz
```

---

## BZIP2 - Compressione Migliorata

### Descrizione
BZIP2 offre migliore compressione rispetto a GZIP, ma è più lento.

### Sintassi Base
```bash
bzip2 [opzioni] file
```

### Opzioni Principali
Simili a GZIP: `-d`, `-k`, `-v`, `-1` a `-9`

### Esempi

#### Compressione
```bash
# Comprimi file
bzip2 file.txt
# Risultato: file.txt.bz2

# Comprimi mantenendo originale
bzip2 -k file.txt

# Compressione massima
bzip2 -9 file.txt
```

#### Decompressione
```bash
# Decomprimi
bzip2 -d file.txt.bz2
# O:
bunzip2 file.txt.bz2
```

#### Visualizzazione
```bash
# Visualizza contenuto
bzcat file.txt.bz2

# Cerca in file compresso
bzgrep "pattern" file.txt.bz2

# Less per file compresso
bzless file.txt.bz2
```

---

## XZ - Compressione Avanzata

### Descrizione
XZ offre il miglior rapporto di compressione, ma è il più lento. Basato su algoritmo LZMA.

### Sintassi Base
```bash
xz [opzioni] file
```

### Esempi

#### Compressione
```bash
# Comprimi file
xz file.txt
# Risultato: file.txt.xz

# Comprimi mantenendo originale
xz -k file.txt

# Compressione estrema
xz -9e file.txt
```

#### Decompressione
```bash
# Decomprimi
xz -d file.txt.xz
# O:
unxz file.txt.xz
```

#### Visualizzazione
```bash
# Visualizza contenuto
xzcat file.txt.xz

# Cerca in file compresso
xzgrep "pattern" file.txt.xz

# Less per file compresso
xzless file.txt.xz
```

---

## ZIP - Formato Cross-Platform

### Descrizione
ZIP è il formato più compatibile tra sistemi operativi (Windows, Mac, Linux).

### Sintassi Base
```bash
zip [opzioni] archivio.zip file1 file2 ...
unzip [opzioni] archivio.zip
```

### Opzioni ZIP

| Opzione | Descrizione |
|---------|-------------|
| `-r` | Ricorsivo (directory) |
| `-e` | Crittografa con password |
| `-u` | Aggiorna archivio esistente |
| `-d` | Elimina file dall'archivio |
| `-9` | Compressione massima |
| `-q` | Quiet (silenzioso) |
| `-v` | Verbose |

### Esempi ZIP

#### Creare archivio
```bash
# Comprimi file
zip archivio.zip file1.txt file2.txt

# Comprimi directory ricorsivamente
zip -r archivio.zip directory/

# Compressione massima
zip -9 -r archivio.zip directory/

# Con password
zip -e -r archivio.zip directory/
# Richiederà password
```

#### Aggiungere/aggiornare file
```bash
# Aggiungi file
zip -u archivio.zip nuovo_file.txt

# Elimina file dall'archivio
zip -d archivio.zip file_da_eliminare.txt
```

#### Escludere file
```bash
# Escludi pattern
zip -r archivio.zip directory/ -x "*.log" "*.tmp"

# Escludi directory
zip -r archivio.zip directory/ -x "*/node_modules/*"
```

### Opzioni UNZIP

| Opzione | Descrizione |
|---------|-------------|
| `-l` | Lista file |
| `-d` | Directory di destinazione |
| `-o` | Sovrascrivi senza chiedere |
| `-n` | Non sovrascrivere |
| `-q` | Quiet |
| `-v` | Verbose |

### Esempi UNZIP

#### Estrarre archivio
```bash
# Estrai tutto
unzip archivio.zip

# Estrai in directory specifica
unzip archivio.zip -d /percorso/destinazione/

# Estrai file specifico
unzip archivio.zip file.txt

# Lista contenuto
unzip -l archivio.zip

# Testa integrità
unzip -t archivio.zip
```

#### Estrazione con pattern
```bash
# Estrai solo file .txt
unzip archivio.zip "*.txt"

# Estrai directory specifica
unzip archivio.zip "directory/*"
```

---

## 7Z - Compressione ad Alto Rapporto

### Descrizione
7-Zip offre uno dei migliori rapporti di compressione disponibili.

### Installazione
```bash
# Ubuntu/Debian
sudo apt install p7zip-full

# Fedora/RHEL
sudo dnf install p7zip p7zip-plugins
```

### Sintassi Base
```bash
7z [comando] [opzioni] archivio file...
```

### Comandi Principali

| Comando | Descrizione |
|---------|-------------|
| `a` | Aggiungi (crea archivio) |
| `x` | Estrai con percorsi completi |
| `e` | Estrai senza percorsi |
| `l` | Lista file |
| `t` | Testa integrità |
| `u` | Aggiorna archivio |
| `d` | Elimina file |

### Esempi

#### Creare archivio
```bash
# Crea archivio
7z a archivio.7z directory/

# Compressione massima
7z a -mx=9 archivio.7z directory/

# Con password
7z a -p archivio.7z directory/
# O specificando password:
7z a -pMiaPassword archivio.7z directory/

# Crittografia forte
7z a -mhe=on -pMiaPassword archivio.7z directory/
```

#### Estrarre archivio
```bash
# Estrai con struttura
7z x archivio.7z

# Estrai senza struttura
7z e archivio.7z

# Estrai in directory specifica
7z x archivio.7z -o/percorso/destinazione/

# Lista contenuto
7z l archivio.7z
```

#### Operazioni avanzate
```bash
# Testa integrità
7z t archivio.7z

# Aggiorna archivio
7z u archivio.7z file_nuovo.txt

# Elimina file dall'archivio
7z d archivio.7z file_da_eliminare.txt

# Split in volumi
7z a -v100m archivio.7z directory/
# Crea: archivio.7z.001, archivio.7z.002, ecc.
```

---

## RAR - Formato Proprietario

### Descrizione
RAR è un formato proprietario ma molto popolare, specialmente su Windows.

### Installazione
```bash
# Ubuntu/Debian (solo unrar)
sudo apt install unrar

# Per creare archivi RAR:
# Scaricare da https://www.rarlab.com/
```

### Esempi

#### Estrarre archivio RAR
```bash
# Estrai
unrar x archivio.rar

# Estrai in directory specifica
unrar x archivio.rar /percorso/destinazione/

# Lista contenuto
unrar l archivio.rar

# Testa integrità
unrar t archivio.rar
```

#### Creare archivio RAR (con rar commerciale)
```bash
# Crea archivio
rar a archivio.rar directory/

# Compressione massima
rar a -m5 archivio.rar directory/

# Con password
rar a -p archivio.rar directory/
```

---

## Confronto tra Formati

### Tabella Comparativa

| Formato | Ratio Compressione | Velocità | Compatibilità | Uso CPU | Memoria |
|---------|-------------------|----------|---------------|---------|---------|
| **tar** | Nessuna | Molto veloce | Ottima (Linux) | Basso | Bassa |
| **gzip** | Media | Veloce | Ottima | Medio | Bassa |
| **bzip2** | Buona | Media | Buona | Medio-alto | Media |
| **xz** | Eccellente | Lenta | Buona | Alto | Alta |
| **zip** | Media | Veloce | Eccellente | Medio | Bassa |
| **7z** | Ottima | Media | Buona | Medio-alto | Media-alta |
| **rar** | Ottima | Media | Eccellente | Medio-alto | Media |

### Quando Usare Quale Formato

#### TAR.GZ (.tar.gz o .tgz)
- ✅ Standard Linux/Unix
- ✅ Buon bilanciamento velocità/compressione
- ✅ Per distribuzioni software
- ✅ Backup veloci

#### TAR.BZ2 (.tar.bz2)
- ✅ Migliore compressione di gzip
- ✅ Per file di grandi dimensioni
- ✅ Quando lo spazio è critico
- ⚠️ Più lento di gzip

#### TAR.XZ (.tar.xz)
- ✅ Massima compressione
- ✅ Distribuzioni software ufficiali
- ✅ Archivi a lungo termine
- ⚠️ Molto lento in compressione
- ⚠️ Richiede più memoria

#### ZIP (.zip)
- ✅ Compatibilità cross-platform
- ✅ Windows, Mac, Linux
- ✅ Per condividere con utenti Windows
- ✅ Supporta password
- ⚠️ Compressione media

#### 7Z (.7z)
- ✅ Ottima compressione
- ✅ Supporta crittografia forte
- ✅ Split in volumi
- ⚠️ Meno compatibile di ZIP

### Benchmark Pratico

Esempio su directory di 100 MB:

```bash
# File originale: 100 MB

# TAR (non compresso)
tar -cf test.tar directory/      # 100 MB, 2 secondi

# TAR.GZ
tar -czf test.tar.gz directory/  # 25 MB, 10 secondi

# TAR.BZ2
tar -cjf test.tar.bz2 directory/ # 20 MB, 30 secondi

# TAR.XZ
tar -cJf test.tar.xz directory/  # 15 MB, 60 secondi

# ZIP
zip -r test.zip directory/       # 27 MB, 12 secondi

# 7Z
7z a test.7z directory/          # 18 MB, 35 secondi
```

---

## Esempi Pratici

### 1. Backup Home Directory
```bash
# Backup completo
tar -czvf backup-home-$(date +%Y%m%d).tar.gz \
    --exclude='*.cache' \
    --exclude='*.tmp' \
    --exclude='Downloads' \
    /home/username/

# Backup incrementale
tar -czvf backup-home-incremental-$(date +%Y%m%d).tar.gz \
    --listed-incremental=/home/backup.snar \
    /home/username/
```

### 2. Backup Database
```bash
# Backup MySQL
mysqldump -u root -p database_name | gzip > backup-db-$(date +%Y%m%d).sql.gz

# Ripristino
gunzip < backup-db-20260120.sql.gz | mysql -u root -p database_name
```

### 3. Comprimere Log Files
```bash
# Comprimi tutti i log vecchi
find /var/log -name "*.log" -mtime +30 -exec gzip {} \;

# Comprimi e rimuovi originale
gzip /var/log/apache2/access.log
```

### 4. Sincronizzazione con Archivi
```bash
# Crea archivio di directory modificate
rsync -av --delete source/ dest/ && \
tar -czvf backup-$(date +%Y%m%d).tar.gz dest/
```

### 5. Trasferimento Remoto con Compressione
```bash
# Backup remoto via SSH
tar -czf - /directory | ssh user@host "cat > backup.tar.gz"

# Backup e estrazione remota
tar -czf - /directory | ssh user@host "tar -xzf -"

# Trasferimento ottimizzato
rsync -avz -e ssh /source/ user@host:/destination/
```

### 6. Dividere Archivi Grandi
```bash
# Con split
tar -czf - large_directory/ | split -b 100M - backup.tar.gz.

# Risultato: backup.tar.gz.aa, backup.tar.gz.ab, ecc.

# Riunire
cat backup.tar.gz.* | tar -xzf -

# Con 7z
7z a -v100m backup.7z large_directory/
```

### 7. Cifrare Archivi
```bash
# Con GPG
tar -czf - directory/ | gpg -c > backup.tar.gz.gpg
# Decifrare:
gpg -d backup.tar.gz.gpg | tar -xzf -

# Con OpenSSL
tar -czf - directory/ | openssl enc -aes-256-cbc -salt -out backup.tar.gz.enc
# Decifrare:
openssl enc -d -aes-256-cbc -in backup.tar.gz.enc | tar -xzf -

# Con 7z (più semplice)
7z a -p -mhe=on backup.7z directory/
```

### 8. Confrontare Archivi
```bash
# Confronta contenuti
diff <(tar -tzf archive1.tar.gz | sort) <(tar -tzf archive2.tar.gz | sort)

# Verifica integrità con checksum
tar -czf backup.tar.gz directory/
md5sum backup.tar.gz > backup.tar.gz.md5
# Verifica:
md5sum -c backup.tar.gz.md5
```

### 9. Estrazione Parziale
```bash
# Estrai solo file .txt
tar -xzvf archive.tar.gz --wildcards "*.txt"

# Estrai directory specifica
tar -xzvf archive.tar.gz directory/subdirectory/

# Estrai escludendo pattern
tar -xzvf archive.tar.gz --exclude="*.log"
```

### 10. Pipeline Avanzate
```bash
# Backup con verifica
tar -czf - /data | tee backup.tar.gz | md5sum > backup.md5

# Backup con progress bar
tar -czf - /large_dir | pv > backup.tar.gz

# Backup con logging
tar -czvf backup.tar.gz /data 2>&1 | tee backup.log
```

---

## Esercizi

### Esercizio 1: Base
Crea un archivio tar.gz della directory `/home/user/Documents` chiamato `docs-backup.tar.gz`.

---

### Esercizio 2: Base
Estrai l'archivio `project.tar.gz` nella directory `/tmp/extracted`.

---

### Esercizio 3: Intermedio
Crea un archivio zip della directory `website/` escludendo tutti i file `.log` e la directory `node_modules/`.

---

### Esercizio 4: Intermedio
Lista tutti i file contenuti nell'archivio `backup.tar.bz2` e cerca quelli che contengono "config" nel nome.

---

### Esercizio 5: Intermedio
Comprimi tutti i file `.txt` nella directory corrente usando gzip, mantenendo i file originali.

---

### Esercizio 6: Avanzato
Crea uno script che effettui un backup giornaliero della directory `/var/www`, escludendo file cache e temporanei, con il nome che include la data corrente.

---

### Esercizio 7: Avanzato
Crea un archivio 7z con password della directory `sensitive-data/` con compressione massima e crittografia.

---

### Esercizio 8: Avanzato
Scrivi un comando che trovi tutti i file `.log` più vecchi di 30 giorni, li comprima con gzip e li sposti in una directory di archivio.

---

### Esercizio 9: Esperto
Crea un sistema di backup incrementale usando tar che mantenga:
- Un backup completo settimanale
- Backup incrementali giornalieri
- Naming convention con date

---

### Esercizio 10: Esperto
Scrivi uno script che:
1. Crei un archivio tar.gz di una directory
2. Lo divida in chunk da 100MB
3. Calcoli il checksum MD5 di ogni chunk
4. Trasferisca i chunk via SSH a un server remoto
5. Verifichi l'integrità sul server remoto

---

## Soluzioni

### Soluzione Esercizio 1
```bash
tar -czvf docs-backup.tar.gz /home/user/Documents
```
O se già dentro /home/user:
```bash
tar -czvf docs-backup.tar.gz Documents/
```

---

### Soluzione Esercizio 2
```bash
tar -xzvf project.tar.gz -C /tmp/extracted
```
Se la directory non esiste, creala prima:
```bash
mkdir -p /tmp/extracted && tar -xzvf project.tar.gz -C /tmp/extracted
```

---

### Soluzione Esercizio 3
```bash
zip -r website.zip website/ -x "*.log" "*/node_modules/*"
```
O con sintassi alternativa:
```bash
zip -r website.zip website/ --exclude "*.log" --exclude "node_modules/*"
```

---

### Soluzione Esercizio 4
```bash
tar -tjf backup.tar.bz2 | grep config
```
O per vedere l'archivio completo prima:
```bash
# Lista tutto
tar -tjvf backup.tar.bz2

# Filtra per "config"
tar -tjvf backup.tar.bz2 | grep config
```

---

### Soluzione Esercizio 5
```bash
gzip -k *.txt
```
O in modo più sicuro con find:
```bash
find . -maxdepth 1 -name "*.txt" -exec gzip -k {} \;
```

---

### Soluzione Esercizio 6
```bash
#!/bin/bash
# backup-website.sh

# Variabili
BACKUP_DIR="/var/backups/website"
SOURCE_DIR="/var/www"
DATE=$(date +%Y%m%d)
BACKUP_FILE="website-backup-${DATE}.tar.gz"

# Crea directory backup se non esiste
mkdir -p "$BACKUP_DIR"

# Crea backup
tar -czvf "${BACKUP_DIR}/${BACKUP_FILE}" \
    --exclude='*.cache' \
    --exclude='*.tmp' \
    --exclude='*/cache/*' \
    --exclude='*/tmp/*' \
    "$SOURCE_DIR"

# Verifica successo
if [ $? -eq 0 ]; then
    echo "Backup completato: ${BACKUP_FILE}"
    
    # Calcola checksum
    md5sum "${BACKUP_DIR}/${BACKUP_FILE}" > "${BACKUP_DIR}/${BACKUP_FILE}.md5"
    
    # Elimina backup più vecchi di 30 giorni
    find "$BACKUP_DIR" -name "website-backup-*.tar.gz" -mtime +30 -delete
else
    echo "Errore durante il backup!" >&2
    exit 1
fi
```

Per automatizzare con cron:
```bash
# Aggiungi a crontab
crontab -e
# Aggiungi questa riga per eseguire ogni giorno alle 2 AM:
0 2 * * * /path/to/backup-website.sh
```

---

### Soluzione Esercizio 7
```bash
# Crea archivio 7z con password e compressione massima
7z a -p -mhe=on -mx=9 sensitive-data.7z sensitive-data/
```

Spiegazione opzioni:
- `-p`: Richiede password (verrà chiesta interattivamente)
- `-mhe=on`: Cripta anche i nomi dei file
- `-mx=9`: Compressione massima

O specificando la password direttamente (meno sicuro):
```bash
7z a -pMiaPasswordSegreta -mhe=on -mx=9 sensitive-data.7z sensitive-data/
```

---

### Soluzione Esercizio 8
```bash
#!/bin/bash
# compress-old-logs.sh

ARCHIVE_DIR="/var/log/archive"
LOG_DIR="/var/log"

# Crea directory archivio
mkdir -p "$ARCHIVE_DIR"

# Trova e comprimi log vecchi
find "$LOG_DIR" -name "*.log" -type f -mtime +30 | while read logfile; do
    # Comprimi
    gzip -c "$logfile" > "${ARCHIVE_DIR}/$(basename ${logfile}).gz"
    
    # Se compressione riuscita, rimuovi originale
    if [ $? -eq 0 ]; then
        rm "$logfile"
        echo "Archiviato: $logfile"
    fi
done
```

Versione più compatta con xargs:
```bash
find /var/log -name "*.log" -type f -mtime +30 -print0 | \
    xargs -0 -I {} sh -c 'gzip -c "{}" > /var/log/archive/$(basename "{}").gz && rm "{}"'
```

---

### Soluzione Esercizio 9
```bash
#!/bin/bash
# incremental-backup.sh

BACKUP_DIR="/backups"
SOURCE_DIR="/data"
SNAPSHOT_FILE="${BACKUP_DIR}/backup.snar"
DATE=$(date +%Y%m%d)
DOW=$(date +%u)  # 1=Lunedì, 7=Domenica

mkdir -p "$BACKUP_DIR"

if [ "$DOW" -eq 1 ]; then
    # Lunedì: backup completo
    echo "Eseguendo backup completo..."
    
    # Rimuovi snapshot precedente per ricominciare
    rm -f "$SNAPSHOT_FILE"
    
    # Backup completo
    tar -czvf "${BACKUP_DIR}/full-backup-${DATE}.tar.gz" \
        --listed-incremental="$SNAPSHOT_FILE" \
        "$SOURCE_DIR"
    
    echo "Backup completo completato"
else
    # Altri giorni: backup incrementale
    echo "Eseguendo backup incrementale..."
    
    tar -czvf "${BACKUP_DIR}/incremental-backup-${DATE}.tar.gz" \
        --listed-incremental="$SNAPSHOT_FILE" \
        "$SOURCE_DIR"
    
    echo "Backup incrementale completato"
fi

# Pulizia: mantieni solo ultimi 60 giorni
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +60 -delete

# Log
echo "$(date): Backup completato" >> "${BACKUP_DIR}/backup.log"
```

Per ripristinare:
```bash
# Ripristina backup completo
tar -xzvf full-backup-20260113.tar.gz -G

# Poi applica incrementali in ordine
tar -xzvf incremental-backup-20260114.tar.gz -G
tar -xzvf incremental-backup-20260115.tar.gz -G
# ecc...
```

---

### Soluzione Esercizio 10
```bash
#!/bin/bash
# advanced-backup-transfer.sh

# Configurazione
SOURCE_DIR="/important/data"
LOCAL_BACKUP="/tmp/backup"
REMOTE_HOST="backup-server.example.com"
REMOTE_USER="backup"
REMOTE_DIR="/backups"
DATE=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="backup-${DATE}"
CHUNK_SIZE="100M"

# Cleanup locale all'uscita
cleanup() {
    rm -rf "$LOCAL_BACKUP"
}
trap cleanup EXIT

# Step 1: Crea directory temporanea
mkdir -p "$LOCAL_BACKUP"
cd "$LOCAL_BACKUP"

echo "=== Step 1: Creazione archivio ==="
tar -czf "${ARCHIVE_NAME}.tar.gz" -C "$(dirname $SOURCE_DIR)" "$(basename $SOURCE_DIR)"

if [ $? -ne 0 ]; then
    echo "Errore nella creazione dell'archivio!"
    exit 1
fi

# Step 2: Dividi in chunk
echo "=== Step 2: Divisione in chunk ==="
split -b "$CHUNK_SIZE" -d "${ARCHIVE_NAME}.tar.gz" "${ARCHIVE_NAME}.tar.gz.part"

# Step 3: Calcola checksum di ogni chunk
echo "=== Step 3: Calcolo checksum ==="
md5sum ${ARCHIVE_NAME}.tar.gz.part* > checksums.md5

# Step 4: Trasferimento via SSH
echo "=== Step 4: Trasferimento remoto ==="

# Crea directory remota
ssh ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ${REMOTE_DIR}/${ARCHIVE_NAME}"

# Trasferisci chunk e checksums
for chunk in ${ARCHIVE_NAME}.tar.gz.part*; do
    echo "Trasferimento: $chunk"
    scp "$chunk" ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/${ARCHIVE_NAME}/
    
    if [ $? -ne 0 ]; then
        echo "Errore nel trasferimento di $chunk!"
        exit 1
    fi
done

scp checksums.md5 ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/${ARCHIVE_NAME}/

# Step 5: Verifica integrità remota
echo "=== Step 5: Verifica integrità remota ==="
ssh ${REMOTE_USER}@${REMOTE_HOST} "cd ${REMOTE_DIR}/${ARCHIVE_NAME} && md5sum -c checksums.md5"

if [ $? -eq 0 ]; then
    echo "=== Backup completato con successo! ==="
    
    # Script di ripristino remoto (opzionale)
    cat > restore.sh << 'EOF'
#!/bin/bash
# Script di ripristino
cat *.tar.gz.part* > backup.tar.gz
tar -xzvf backup.tar.gz
EOF
    
    scp restore.sh ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/${ARCHIVE_NAME}/
    ssh ${REMOTE_USER}@${REMOTE_HOST} "chmod +x ${REMOTE_DIR}/${ARCHIVE_NAME}/restore.sh"
    
    echo "Info backup salvate in: ${REMOTE_DIR}/${ARCHIVE_NAME}"
else
    echo "Errore nella verifica dell'integrità!"
    exit 1
fi

# Log locale
echo "$(date): Backup ${ARCHIVE_NAME} completato" >> /var/log/backup.log
```

Per ripristinare sul server remoto:
```bash
ssh backup@backup-server.example.com
cd /backups/backup-20260120_143022
./restore.sh
```

---

## Best Practices

### 1. Verifica sempre gli archivi
```bash
# Dopo creazione
tar -tzf archive.tar.gz > /dev/null && echo "OK" || echo "Corrotto"

# Con checksum
md5sum archive.tar.gz > archive.md5
md5sum -c archive.md5
```

### 2. Usa nomi significativi con date
```bash
backup-$(hostname)-$(date +%Y%m%d-%H%M%S).tar.gz
```

### 3. Testa il ripristino
```bash
# Testa in directory temporanea
mkdir /tmp/test-restore
tar -xzvf backup.tar.gz -C /tmp/test-restore
```

### 4. Documenta gli esclusioni
```bash
# Crea file exclude.txt
cat > exclude.txt << EOF
*.log
*.tmp
*.cache
node_modules/
.git/
EOF

tar -czf backup.tar.gz --exclude-from=exclude.txt /data
```

### 5. Automatizza con script
```bash
#!/bin/bash
set -e  # Exit on error
set -u  # Exit on undefined variable
set -o pipefail  # Exit on pipe failure

# Il tuo codice di backup qui
```

### 6. Implementa rotazione backup
```bash
# Mantieni 7 backup giornalieri, 4 settimanali, 12 mensili
find /backup -name "daily-*" -mtime +7 -delete
find /backup -name "weekly-*" -mtime +28 -delete
find /backup -name "monthly-*" -mtime +365 -delete
```

### 7. Monitora lo spazio disco
```bash
# Prima di fare backup
df -h /backup

# Oppure controlla automaticamente
SPACE_AVAILABLE=$(df /backup | awk 'NR==2 {print $4}' | sed 's/G//')
if [ "$SPACE_AVAILABLE" -lt 10 ]; then
    echo "Spazio insufficiente!"
    exit 1
fi
```

### 8. Usa compressione appropriata
- **gzip**: per velocità
- **bzip2**: per spazio
- **xz**: per massima compressione
- **nessuna**: se i dati sono già compressi (jpg, mp4, zip)

---

## Comandi Quick Reference

### TAR
```bash
# Crea
tar -czf archive.tar.gz dir/    # gzip
tar -cjf archive.tar.bz2 dir/   # bzip2
tar -cJf archive.tar.xz dir/    # xz

# Estrai
tar -xzf archive.tar.gz         # gzip
tar -xjf archive.tar.bz2        # bzip2
tar -xJf archive.tar.xz         # xz

# Lista
tar -tzf archive.tar.gz
```

### GZIP/BZIP2/XZ
```bash
# Comprimi
gzip file.txt       # → file.txt.gz
bzip2 file.txt      # → file.txt.bz2
xz file.txt         # → file.txt.xz

# Decomprimi
gunzip file.txt.gz
bunzip2 file.txt.bz2
unxz file.txt.xz

# Visualizza
zcat file.txt.gz
bzcat file.txt.bz2
xzcat file.txt.xz
```

### ZIP
```bash
# Crea
zip -r archive.zip dir/

# Estrai
unzip archive.zip

# Lista
unzip -l archive.zip
```

### 7Z
```bash
# Crea
7z a archive.7z dir/

# Estrai
7z x archive.7z

# Lista
7z l archive.7z
```

---

## Conclusione

L'archiviazione e la compressione sono competenze essenziali per:
- 💾 Gestire efficacemente lo spazio su disco
- 📦 Creare backup affidabili
- 🚀 Trasferire dati in modo efficiente
- 🔐 Proteggere informazioni sensibili

**Ricorda**:
1. Scegli il formato giusto per il tuo caso d'uso
2. Verifica sempre l'integrità degli archivi
3. Testa periodicamente il ripristino
4. Automatizza i backup critici
5. Implementa una strategia di rotazione

---

*Creato per scopi didattici - TECINF*