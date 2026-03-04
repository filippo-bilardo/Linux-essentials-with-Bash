# Archiviazione e Compressione

## Concetti: Archivio vs Compressione

- **Archivio**: raccoglie più file in **uno solo** (es. `tar`), senza necessariamente ridurre la dimensione
- **Compressione**: riduce la dimensione di un file (es. `gzip`, `bzip2`, `xz`)
- **Archivio compresso**: fa entrambe le cose contemporaneamente (es. `tar.gz`)

---

## `tar` — Il Re degli Archivi Linux

`tar` (Tape ARchive) è il tool standard per creare e gestire archivi su Linux.

### Sintassi memory trick: **c**reate/**e**xtract + **v**erbose + **f**ile + compressione

```bash
# Creare un archivio
tar -cvf  archivio.tar    cartella/           # crea archivio .tar
tar -czvf archivio.tar.gz cartella/           # crea + comprime con gzip
tar -cjvf archivio.tar.bz2 cartella/          # crea + comprime con bzip2
tar -cJvf archivio.tar.xz  cartella/          # crea + comprime con xz

# Estrarre un archivio
tar -xvf  archivio.tar                        # estrai .tar
tar -xzvf archivio.tar.gz                     # estrai .tar.gz
tar -xjvf archivio.tar.bz2                    # estrai .tar.bz2
tar -xvf  archivio.tar.gz -C /destinazione/   # estrai in una directory specifica

# Elencare il contenuto senza estrarre
tar -tvf archivio.tar.gz                      # lista il contenuto
tar -tvf archivio.tar | grep ".sh"            # cerca file specifici

# Aggiungere file a un archivio esistente (solo .tar non compresso)
tar -rvf archivio.tar nuovo_file.txt
```

### Opzioni principali di tar

| Opzione | Significato |
|---------|-------------|
| `-c` | Crea un nuovo archivio |
| `-x` | Estrai dall'archivio |
| `-t` | Lista il contenuto |
| `-v` | Verbose (mostra i file elaborati) |
| `-f` | Specifica il nome del file archivio |
| `-z` | Compressione gzip (`.tar.gz` o `.tgz`) |
| `-j` | Compressione bzip2 (`.tar.bz2`) |
| `-J` | Compressione xz (`.tar.xz`) |
| `-C` | Specifica la directory di destinazione |
| `-p` | Preserva permessi e proprietà |

---

## `gzip` e `gunzip` — Compressione Singoli File

```bash
gzip file.txt               # comprime → file.txt.gz (rimuove l'originale)
gzip -k file.txt            # comprime e mantiene l'originale (-k = keep)
gzip -9 file.txt            # massima compressione (più lenta)
gzip -1 file.txt            # velocità massima (meno compressione)

gunzip file.txt.gz           # decomprime
gzip -d file.txt.gz          # decomprime (equivalente a gunzip)

zcat file.txt.gz             # legge il file compresso senza decomprimere
zless file.txt.gz            # sfoglia il file compresso
```

## `bzip2` e `xz`

```bash
bzip2 file.txt              # comprime → file.txt.bz2 (migliore compressione di gzip)
bunzip2 file.txt.bz2        # decomprime
bzcat file.txt.bz2          # legge senza decomprimere

xz file.txt                 # comprime → file.txt.xz (migliore compressione di bzip2)
unxz file.txt.xz            # decomprime
xzcat file.txt.xz           # legge senza decomprimere
```

**Confronto:**

| Algoritmo | Velocità | Compressione | Estensione |
|-----------|---------|--------------|------------|
| `gzip` | Veloce | 中 | `.gz` |
| `bzip2` | Media | Buona | `.bz2` |
| `xz` | Lenta | Ottima | `.xz` |
| `zstd` | Molto veloce | Ottima | `.zst` |

---

## `zip` e `unzip` — Compatibilità Windows

```bash
zip archivio.zip file1.txt file2.txt   # crea zip con file specifici
zip -r archivio.zip cartella/          # zip ricorsivo di una cartella
zip -9 archivio.zip file.txt           # massima compressione

unzip archivio.zip                     # estrai nella directory corrente
unzip archivio.zip -d /destinazione/   # estrai in directory specifica
unzip -l archivio.zip                  # lista il contenuto
unzip -v archivio.zip                  # lista con dettagli
```

---

## Identificare Archivi Sconosciuti

```bash
file archivio.tar.gz        # identifica il tipo di file
file archivio.zip
```

`tar` moderno riconosce automaticamente il tipo di compressione:
```bash
tar -xvf archivio.tar.gz    # funziona anche senza -z
tar -xvf archivio.tar.bz2   # funziona anche senza -j
```

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<02_editor_nano.md>)
- [➡️ successivo](<04_ricerca_filtraggio.md>)
