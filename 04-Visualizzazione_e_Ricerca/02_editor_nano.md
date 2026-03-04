# L'Editor di Testo nano

## Introduzione

`nano` è l'editor di testo da riga di comando più semplice disponibile su Linux. È preinstallato su Ubuntu, Debian e molte altre distribuzioni. È il punto di partenza ideale per chi non conosce ancora `vim` o `emacs`.

---

## Aprire nano

```bash
nano                        # apre un file nuovo (senza nome)
nano file.txt               # apre (o crea) file.txt
nano +10 file.txt           # apre posizionandosi alla riga 10
nano -v file.txt            # apre in sola lettura (view)
sudo nano /etc/hostname     # modifica un file di sistema
```

---

## Interfaccia di nano

```
  GNU nano 6.2       file.txt       (modificato)
┌─────────────────────────────────────────────────────┐
│ Prima riga del file                                 │
│ Seconda riga                                        │
│ Il cursore è qui█                                   │
│                                                     │
└─────────────────────────────────────────────────────┘
^G Aiuto    ^X Esci     ^O Salva    ^W Cerca
^K Taglia   ^U Incolla  ^/ Sostit.  ^C Posizione
```

La barra in fondo mostra i comandi disponibili. Il simbolo `^` indica il tasto `Ctrl`.

---

## Comandi Fondamentali

### Salvare e uscire

| Tasto | Azione |
|-------|--------|
| `Ctrl+O` | Salva il file (Write **O**ut) — poi Enter per confermare |
| `Ctrl+X` | Esci da nano (chiede se salvare se ci sono modifiche) |
| `Ctrl+X` poi `Y` poi `Enter` | Salva ed esci in sequenza |
| `Ctrl+X` poi `N` | Esci senza salvare |

### Navigazione

| Tasto | Azione |
|-------|--------|
| `↑` `↓` `←` `→` | Muovi il cursore |
| `Ctrl+A` | Inizio della riga |
| `Ctrl+E` | Fine della riga |
| `Ctrl+Y` | Pagina su |
| `Ctrl+V` | Pagina giù |
| `Ctrl+_` | Vai a riga e colonna specifiche |
| `Ctrl+W` poi `Ctrl+T` | Vai a riga specifica |

### Taglia, Copia, Incolla

| Tasto | Azione |
|-------|--------|
| `Ctrl+K` | Taglia la riga corrente (cut) |
| `Ctrl+U` | Incolla la riga tagliata (uncut) |
| `Alt+6` | Copia la riga senza tagliarla |
| `Ctrl+^` poi navigazione | Seleziona testo |

### Cerca e Sostituisci

| Tasto | Azione |
|-------|--------|
| `Ctrl+W` | Cerca testo |
| `Ctrl+W` poi `Ctrl+R` | Sostituisce testo |
| `Alt+W` | Cerca la prossima occorrenza |

### Altre operazioni

| Tasto | Azione |
|-------|--------|
| `Ctrl+G` | Mostra l'aiuto completo |
| `Ctrl+C` | Mostra la posizione del cursore |
| `Alt+U` | Annulla (Undo) |
| `Alt+E` | Ripristina (Redo) |
| `Ctrl+J` | Giustifica il paragrafo |

---

## Configurazione di nano

Il file di configurazione è `~/.nanorc`. Alcune opzioni utili:

```bash
# Abilita la numerazione delle righe
set linenumbers

# Evidenziazione della riga corrente
set cursorline

# Indentazione automatica
set autoindent

# Espandi tab in spazi
set tabsize 4
set tabstospaces

# Mostra il titolo con il nome del file
set titlecolor bold,white,blue
```

Per abilitarle:
```bash
nano ~/.nanorc
# Incolla le opzioni desiderate, poi Ctrl+O e Ctrl+X
```

---

## Cenni su Vim

`vim` (Vi IMproved) è un editor molto più potente di `nano` ma con una curva di apprendimento ripida. Funziona a **modalità**:

- **Normal mode** (default): per navigare ed eseguire comandi
- **Insert mode** (`i`): per digitare testo
- **Visual mode** (`v`): per selezionare testo
- **Command mode** (`:`): per comandi del file

### Comandi minimi per sopravvivere in vim

```
i           → entra in modalità inserimento
Esc         → torna in modalità normale
:w          → salva
:q          → esci
:wq         → salva ed esci
:q!         → esci senza salvare (forza)
/parola     → cerca "parola"
n           → prossima occorrenza
dd          → cancella la riga
u           → undo
```

Se ti trovi accidentalmente in `vim`, premi `Esc` poi digita `:q!` e premi `Enter` per uscire senza salvare.

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_visualizzazione_file.md>)
- [➡️ successivo](<03_archiviazione_compressione.md>)
