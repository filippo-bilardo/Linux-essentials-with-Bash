# Esercizi — Modulo 03: Lavorare con File e Cartelle

---

## Esercizio 1 — Esplora il filesystem

```bash
ls /
ls -la /home
ls -la /etc | head -20
cat /proc/version
```

**Domande:**
1. Quante directory ci sono direttamente sotto `/`?
2. Cosa contiene `/proc/version`?
3. Qual è la differenza tra `/bin` e `/sbin`?

---

## Esercizio 2 — Navigazione con percorsi assoluti e relativi

Partendo dalla tua home (`~`), raggiungi le seguenti directory usando sia percorsi assoluti che relativi:

1. `/etc`
2. `/tmp`
3. `/var/log`
4. Di nuovo la tua home

Usa sempre `pwd` per confermare dove ti trovi.

**Bonus:** usa `cd -` per tornare alla directory precedente e verifica il risultato.

---

## Esercizio 3 — Creare una struttura di directory

Crea la seguente struttura di directory nella tua home:

```
~/esercizio03/
├── documenti/
│   ├── lavoro/
│   └── personale/
├── immagini/
├── script/
└── backup/
```

**Suggerimento:** usa `mkdir -p` per creare più livelli in un colpo.  
Poi verifica con `find ~/esercizio03 -type d`.

---

## Esercizio 4 — Creare e manipolare file

Nella directory `~/esercizio03/documenti/lavoro/`:

1. Crea tre file di testo:
   ```bash
   echo "Contenuto del primo file" > report1.txt
   echo "Contenuto del secondo file" > report2.txt
   echo "Contenuto del terzo file" > report3.txt
   ```

2. Copia `report1.txt` nella directory `backup/` con il nome `report1_backup.txt`

3. Sposta `report3.txt` nella directory `documenti/personale/`

4. Rinomina `report2.txt` in `relazione_finale.txt`

5. Verifica con `ls -la` in ogni directory interessata

---

## Esercizio 5 — Globbing

Nella directory `~/esercizio03/script/`, crea i seguenti file:

```bash
touch script1.sh script2.sh script3.sh
touch config.cfg config_backup.cfg
touch log_2024.txt log_2025.txt log_2026.txt
touch README.md CHANGELOG.md
```

Poi, usando il globbing, esegui:

1. Lista tutti i file `.sh`
2. Lista tutti i file `.txt`
3. Lista i file che iniziano con `log_`
4. Lista i file il cui nome ha esattamente un carattere numerico dopo `script` (es. `script1.sh`)
5. Lista i file che iniziano con maiuscola: `[A-Z]*`
6. Copia tutti i file `.sh` nella directory `backup/`

---

## Esercizio 6 — find

1. Trova tutti i file `.txt` nella tua home:
   ```bash
   find ~ -name "*.txt"
   ```

2. Trova tutte le directory in `~/esercizio03`:
   ```bash
   find ~/esercizio03 -type d
   ```

3. Trova i file più grandi di 1KB in `/var/log`:
   ```bash
   find /var/log -size +1k -name "*.log" 2>/dev/null | head -10
   ```

4. Trova i file modificati nelle ultime 24 ore nella tua home:
   ```bash
   find ~ -mtime 0
   ```

---

## Esercizio 7 — Link simbolici

1. Crea un link simbolico a `~/esercizio03/script/` chiamato `~/script_link`:
   ```bash
   ln -s ~/esercizio03/script ~/script_link
   ```

2. Verifica con `ls -la ~` che sia creato correttamente (freccia `→`)

3. Accedi alla directory tramite il link: `cd ~/script_link && pwd`

4. Crea un hard link:
   ```bash
   cd ~/esercizio03/documenti/lavoro
   ln report1.txt report1_hardlink.txt
   ls -li report1.txt report1_hardlink.txt
   ```

**Domande:**
1. I due file dell'hard link hanno lo stesso inode number?
2. Cosa succede al link simbolico se elimini la directory originale?

---

## Esercizio 8 — Pulizia (opzionale)

Elimina la struttura creata:

```bash
rm -rf ~/esercizio03
rm -f ~/script_link
```

> **Attenzione:** verifica due volte il percorso prima di usare `rm -rf`!

---

## Sfida: Script di backup

Crea uno script `~/backup_home.sh` che:
1. Crei una directory `~/backup_YYYYMMDD` (con la data di oggi nel nome)
2. Copi tutti i file `.txt` dalla home a quella directory
3. Stampi un messaggio con quanti file sono stati copiati

**Suggerimento:** usa `$(date +%Y%m%d)` per ottenere la data nel formato `20260304`.

---

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../02-Utilizzo_Command_Line/esercizi/README.md>)
- [➡️ successivo](<../../04-Visualizzazione_e_Ricerca/README.md>)
