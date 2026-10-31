# Modificare i file con nano

Heredoc e redirezioni permettono di generare contenuto dal terminale. Un editor è utile quando devi correggere una riga, cercare una parola o aggiungere una sezione a un file esistente.

## Aprire e salvare

```bash
nano appunti.txt
```

Se il file non esiste, `nano` prepara un nuovo documento. Nella barra inferiore `^` indica il tasto Ctrl: `^O` significa `Ctrl+O`.

| Operazione | Tasti |
|------------|-------|
| Salvare | `Ctrl+O`, poi Invio per confermare il nome |
| Uscire | `Ctrl+X` |
| Aiuto | `Ctrl+G` |
| Annullare | `Alt+U` |
| Ripristinare | `Alt+E` |

Se esci dopo una modifica, leggi la domanda sul salvataggio. Le lettere proposte dipendono dalla lingua dell'interfaccia.

## Spostarsi e cercare

| Operazione | Tasti |
|------------|-------|
| Inizio o fine della riga | `Ctrl+A`, `Ctrl+E` |
| Pagina precedente o successiva | `Ctrl+Y`, `Ctrl+V` |
| Andare a una riga | `Ctrl+_`, numero della riga, Invio |
| Cercare testo | `Ctrl+W`, testo, Invio |
| Cercare l'occorrenza successiva | `Alt+W` |
| Cercare e sostituire | `Ctrl+\` |
| Tagliare una riga | `Ctrl+K` |
| Incollare il testo tagliato | `Ctrl+U` |

Puoi aprire direttamente alla riga 3 o in sola lettura:

```bash
nano +3 appunti.txt
nano -v appunti.txt
```

## Una modifica controllata

Prepara `server.conf` con l'heredoc studiato nella [guida dedicata](02_heredoc.md): inserisci `host=localhost`, `port=8080` e `debug=true`, una voce per riga.

1. Apri il file con `nano` e cerca `debug`.
2. Cambia solo il valore in `false`.
3. Aggiungi una riga di commento iniziale, salva ed esci.
4. Usa `cat server.conf` e `wc -l < server.conf`: devono apparire quattro righe, con una sola voce `debug=false`.

Le ricerche su molti file e le sostituzioni automatiche saranno trattate nel modulo 05. Qui l'obiettivo è saper modificare e verificare un singolo documento.

Per le combinazioni di tasti e le opzioni complete, consulta il [manuale ufficiale di nano](https://nano-editor.org/manual.html).

---

- [📑 Indice](README.md)
- [⬅️ Pipe](03_pipe.md)
- [➡️ Visualizzazione dei file](../05-Visualizzazione_e_Ricerca/01_visualizzazione_file.md)
