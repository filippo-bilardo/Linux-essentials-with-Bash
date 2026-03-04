# Visualizzazione dei File

## Leggere il Contenuto di un File

### `cat` — Stampa il contenuto completo
```bash
cat file.txt                # stampa tutto il file
cat file1.txt file2.txt     # concatena e stampa più file
cat -n file.txt             # con numeri di riga
cat -A file.txt             # mostra caratteri non stampabili ($ = fine riga)
```

`cat` è l'abbreviazione di *concatenate*. È pensato per file brevi; per file lunghi usa `less`.

### `less` — Scorrimento interattivo (consigliato)
```bash
less file.txt               # apre il file in modalità interattiva
less +G file.txt            # apre direttamente alla fine
less +/parola file.txt      # apre cercando "parola"
```

**Comandi all'interno di less:**

| Tasto | Azione |
|-------|--------|
| `↑` / `↓` | Riga su/giù |
| `Space` / `f` | Pagina avanti |
| `b` | Pagina indietro |
| `g` | Vai all'inizio |
| `G` | Vai alla fine |
| `/parola` | Cerca "parola" in avanti |
| `?parola` | Cerca "parola" all'indietro |
| `n` | Prossima occorrenza |
| `N` | Occorrenza precedente |
| `q` | Esci |

### `more` — Scorrimento solo in avanti (più datato)
```bash
more file.txt               # scorrimento pagina per pagina
```

Usa `less` invece di `more`: è più potente e supporta anche la navigazione all'indietro.

---

## Visualizzare Parti di un File

### `head` — Prime righe
```bash
head file.txt               # prime 10 righe (default)
head -n 5 file.txt          # prime 5 righe
head -5 file.txt            # equivalente abbreviato
head -c 100 file.txt        # primi 100 caratteri (byte)
```

### `tail` — Ultime righe
```bash
tail file.txt               # ultime 10 righe (default)
tail -n 20 file.txt         # ultime 20 righe
tail -c 200 file.txt        # ultimi 200 caratteri
tail -f /var/log/syslog     # segui il file in tempo reale (follow)
tail -f -n 50 access.log    # segue le ultime 50 righe in tempo reale
```

> **`tail -f`** è fondamentale per monitorare i log in tempo reale. Premi `Ctrl+C` per uscire.

---

## Contare e Misurare

### `wc` — Word Count
```bash
wc file.txt                 # righe, parole, byte
wc -l file.txt              # solo righe (lines)
wc -w file.txt              # solo parole (words)
wc -c file.txt              # solo byte (characters)
wc -m file.txt              # caratteri (con supporto Unicode)
ls /etc | wc -l             # conta i file in /etc
```

---

## Confrontare File

### `diff` — Differenze tra due file
```bash
diff file1.txt file2.txt            # mostra le differenze
diff -u file1.txt file2.txt         # formato unificato (più leggibile)
diff -i file1.txt file2.txt         # ignora maiuscole/minuscole
diff -r dir1/ dir2/                 # confronta directory ricorsivamente
```

**Output di `diff`:**
```
3c3        → riga 3 diversa (c=change)
< testo1   → riga nel primo file
---
> testo2   → riga nel secondo file
5d4        → riga 5 eliminata dal primo (d=delete)
7a8        → riga 8 aggiunta nel secondo (a=add)
```

### `cmp` — Confronto byte per byte
```bash
cmp file1.txt file2.txt     # trova il primo byte diverso
cmp -s file1 file2          # silenzioso (usa l'exit status)
```

---

## Visualizzare File Binari

### `xxd` — Dump esadecimale
```bash
xxd file.bin | head -20     # esadecimale + ASCII
xxd -l 64 file.bin          # solo i primi 64 byte
```

### `strings` — Estrae stringhe leggibili
```bash
strings /usr/bin/ls | head -20   # testi stampabili in un binario
file /usr/bin/ls                 # identifica il tipo di file
```

---

## File di Log Comuni

I log di sistema sono in `/var/log/`:

```bash
# Log generale di sistema
less /var/log/syslog

# Log di autenticazione (login, sudo...)
less /var/log/auth.log

# Seguire i log in tempo reale
tail -f /var/log/syslog

# Usare journalctl (systemd)
journalctl -n 50            # ultime 50 righe del journal
journalctl -f               # segui in tempo reale
journalctl -u ssh           # log solo del servizio SSH
journalctl --since "1 hour ago"
```

---

- [📑 Indice](<README.md>)
- [➡️ successivo](<02_editor_nano.md>)
