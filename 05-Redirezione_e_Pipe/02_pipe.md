# Pipe e Filtri

## L'Operatore Pipe `|`

La **pipe** (`|`) collega stdout di un comando all'stdin del successivo, permettendo di costruire catene di elaborazione senza file intermedi.

```
cmd1 | cmd2 | cmd3 | ...
```

```bash
# Senza pipe (due comandi separati + file intermedio)
ls /etc > /tmp/lista.txt
grep "conf" /tmp/lista.txt

# Con pipe (un solo passo, nessun file temporaneo)
ls /etc | grep "conf"
```

---

## Pipeline Comuni

### Paginare output lungo

```bash
ls -la /etc | less                  # naviga con frecce, q per uscire
man bash | less
cat /var/log/syslog | less          # oppure: less /var/log/syslog
```

### Contare righe di output

```bash
ls /etc | wc -l                     # quanti file in /etc
ps aux | wc -l                      # quanti processi attivi
find /var -name "*.log" | wc -l     # quanti file .log
```

### Filtrare con grep

```bash
ps aux | grep "python"              # processi python
cat /etc/passwd | grep "bash"       # utenti con shell bash
dmesg | grep -i "error"             # errori kernel
```

### Ordinare e deduplicare

```bash
cat /etc/passwd | cut -d ':' -f 7 | sort | uniq    # elenco shell uniche
du -sh /etc/* | sort -h | tail -10                  # 10 cartelle più grandi
```

### Pipeline a più stadi

```bash
# Mostra i 5 processi che usano più CPU
ps aux | sort -k3 -rn | head -6

# Parole più usate in un file
cat testo.txt | tr ' ' '\n' | sort | uniq -c | sort -rn | head -10

# Log degli ultimi 100 errori unici
cat /var/log/syslog | grep -i error | tail -100 | sort | uniq
```

---

## `tee` — Duplicare l'Output

`tee` legge da stdin e scrive contemporaneamente su stdout **e** su un file. È utile quando vuoi vedere l'output e salvarlo allo stesso tempo.

```
stdin → tee → stdout
              ↓
             file
```

```bash
ls /etc | tee lista.txt              # mostra E salva
ls /etc | tee lista.txt | wc -l      # salva e conta allo stesso tempo

# Modalità aggiunta
echo "nuova riga" | tee -a log.txt

# Scrivere su più file
ls /etc | tee file1.txt file2.txt > /dev/null

# Utile per pipeline di debug
cat dati.txt | sort | tee dati_ordinati.txt | uniq > dati_unici.txt
```

---

## `xargs` — Passare Output come Argomenti

Molti comandi non accettano input da stdin ma solo come argomenti sulla riga di comando. `xargs` converte lo stdin in argomenti.

```bash
# rm non legge da stdin — xargs risolve il problema
find . -name "*.tmp" | xargs rm

# echo con argomenti multipli
echo "uno due tre" | xargs -n 1 echo    # uno per riga

# Creare directory lette da un file
cat nomi_dir.txt | xargs mkdir -p

# Con placeholder {} per posizionare l'argomento
find . -name "*.txt" | xargs -I {} cp {} ~/backup/
```

### Opzioni utili di xargs

| Opzione | Significato |
|---------|-------------|
| `-n N` | max N argomenti per invocazione |
| `-I {}` | usa `{}` come segnaposto per ogni argomento |
| `-p` | chiede conferma prima di eseguire (interattivo) |
| `-0` | usa `\0` come separatore (per nomi con spazi) |

```bash
# Sicuro con file che hanno spazi nel nome
find . -name "*.txt" -print0 | xargs -0 rm
```

---

## Sostituzione di Comando: `$()`

La sostituzione di comando esegue un comando e usa il suo output come testo all'interno di un'altra espressione.

```bash
# Sintassi moderna: $()
data=$(date '+%Y-%m-%d')
echo "Oggi è $data"

# Esempio pratico: nome file con data
tar -czvf backup_$(date '+%Y%m%d').tar.gz ~/Documenti/

# Contare e usare il risultato
n=$(ls /etc | wc -l)
echo "In /etc ci sono $n file"

# Dentro altre espressioni
echo "Hostname: $(hostname)  —  Kernel: $(uname -r)"
```

La sintassi alternativa con backtick `` `cmd` `` è equivalente ma meno leggibile e non annidabile:

```bash
echo "Data: `date`"        # funziona ma sconsigliato
echo "Data: $(date)"       # preferito
```

### Annidamento

```bash
echo "L'utente più vecchio in /etc/passwd ha UID: $(awk -F: '{print $3}' /etc/passwd | sort -n | tail -1)"
```

---

## Pipeline Avanzate: Esempi Pratici

### Analisi di log

```bash
# Conta gli accessi per IP (da un log Apache)
cat /var/log/apache2/access.log | awk '{print $1}' | sort | uniq -c | sort -rn | head -10
```

### Monitoraggio sistema

```bash
# Mostra l'utilizzo del disco ordinato, in formato leggibile
df -h | grep -v tmpfs | sort -k5 -rn

# Processi per utente
ps aux | awk 'NR>1 {print $1}' | sort | uniq -c | sort -rn
```

### Manipolazione file massiva

```bash
# Rinomina tutti i .txt in .bak
ls *.txt | sed 's/\.txt$//' | xargs -I {} mv {}.txt {}.bak

# Comprime tutti i log di 7+ giorni
find /var/log -name "*.log" -mtime +7 | xargs gzip
```

### Generare report

```bash
# Report utenti del sistema con la loro shell
getent passwd | awk -F: '$3>=1000 {printf "%-15s %s\n", $1, $7}' | sort
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_redirezione.md>)
- [➡️ successivo](<../06-Introduzione_Scripting_Bash/README.md>)
