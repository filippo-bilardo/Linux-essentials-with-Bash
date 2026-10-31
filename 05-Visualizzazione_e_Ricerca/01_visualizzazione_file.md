# Visualizzare e confrontare file

Prepara i file come indicato nell'[indice del modulo](README.md#preparazione-dei-dati). `cat` e `wc -l` sono già stati introdotti per osservare i flussi nel modulo 04; qui approfondiamo l'ispezione del contenuto.

## Consultare un file con less

```bash
less note.txt
```

| Tasto | Azione |
|-------|--------|
| Spazio / `b` | Pagina successiva / precedente |
| `g` / `G` | Inizio / fine del file |
| `/testo`, Invio | Cerca in avanti |
| `n` / `N` | Occorrenza successiva / precedente |
| `q` | Esci |

`less` non modifica il documento. Per correggerlo usa [`nano`](../04-Redirezione_e_Pipe/04_editor_nano.md), già studiato nel modulo 04.

## Mostrare una parte del testo

```bash
head -n 3 studenti.csv
tail -n 2 studenti.csv
tail -n +2 studenti.csv
```

`head` mostra l'inizio; `tail` la fine. `tail -n +2` parte invece dalla seconda riga, utile per saltare l'intestazione di questi dati.

`cat -n note.txt` numera le righe; `cat -A note.txt` rende visibili fine riga e caratteri come le tabulazioni. I simboli mostrati da `-A` non vengono aggiunti al file.

## Misurare il contenuto

```bash
wc -l studenti.csv
wc -w note.txt
wc -c note.txt
wc -m note.txt
```

`-l` conta i fine riga, `-w` le parole, `-c` i byte e `-m` i caratteri secondo la codifica e le impostazioni locali. Con lettere accentate, byte e caratteri possono essere diversi. `studenti.csv` ha otto righe: sette studenti e l'intestazione.

Con `wc -l < studenti.csv` il nome del file non appare nell'output, perché il programma legge da stdin.

## Confrontare due versioni

```bash
cp note.txt note_revisionate.txt
echo "Revisione completata." >> note_revisionate.txt
diff -u note.txt note_revisionate.txt
```

`diff` mostra le righe cambiate; `-u` aggiunge contesto. Un risultato senza differenze produce stato `0`, differenze trovate producono stato `1`; non significa che il confronto sia fallito.

```bash
cmp note.txt note_revisionate.txt
```

`cmp` individua la prima differenza tra i byte. Per confrontare testi e leggere le modifiche usa normalmente `diff`.

## Approfondimento facoltativo: aggiornamenti e file binari

- `tail -f file.log` continua a mostrare le righe aggiunte; termina con `Ctrl+C`. Puoi provarlo su un file del laboratorio, aggiungendo testo da un secondo terminale.
- `file nomefile` identifica il tipo di contenuto.
- `xxd -l 64 nomefile` mostra i primi 64 byte in esadecimale.
- `strings nomefile` estrae sequenze di caratteri leggibili da un file binario.

Questi ultimi strumenti non sono necessari per gli esercizi principali.

---

- [📑 Indice](README.md)
- [⬅️ Editor nano](../04-Redirezione_e_Pipe/04_editor_nano.md)
- [➡️ Ricerca e ordinamento](02_ricerca_filtraggio.md)
