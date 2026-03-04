# Modulo 05 — Redirezione e Pipe

## Obiettivi del Modulo

Al termine di questo modulo sarai in grado di:

- Redirigere l'output e l'input di un comando verso file o dispositivi
- Distinguere tra stdout, stderr e stdin
- Concatenare comandi con le pipe `|`
- Usare `tee`, `xargs` e la sostituzione di comando
- Costruire pipeline efficaci per elaborare dati

---

## Argomenti

1. [Redirezione di input e output](./01_redirezione.md)
   - Standard input, output ed error
   - Operatori `>`, `>>`, `<`, `2>`, `2>&1`, `&>`
   - `/dev/null` — il cestino di Linux
   - Here-document (`<<`) e here-string (`<<<`)

2. [Pipe e filtri](./02_pipe.md)
   - L'operatore pipe `|`
   - `tee` — duplicare l'output
   - `xargs` — passare output come argomenti
   - Sostituzione di comando `$()` e `` ` ``
   - Costruire pipeline complesse

---

## Esempi

- [`esempi/01_redirezione.sh`](./esempi/01_redirezione.sh) — demo di redirezione stdout/stderr/stdin
- [`esempi/02_pipe.sh`](./esempi/02_pipe.sh) — pipeline con tee, xargs e sostituzione di comando

---

## Esercizi

Vai agli [esercizi del modulo](./esercizi/README.md) per mettere in pratica i concetti.

---

## Concetti Chiave

| Operatore | Significato |
|-----------|-------------|
| `cmd > file` | redirige stdout su file (sovrascrive) |
| `cmd >> file` | redirige stdout su file (aggiunge) |
| `cmd < file` | legge stdin da file |
| `cmd 2> file` | redirige stderr su file |
| `cmd 2>&1` | redirige stderr verso lo stesso canale di stdout |
| `cmd &> file` | redirige sia stdout che stderr su file |
| `cmd1 \| cmd2` | passa stdout di cmd1 a stdin di cmd2 |
| `/dev/null` | scarta tutto ciò che viene scritto |
| `tee file` | copia stdin su stdout e su file |
| `$(cmd)` | sostituisce il testo con l'output di cmd |

---

## Navigazione

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../04-Visualizzazione_e_Ricerca/README.md>)
- [➡️ successivo](<../06-Introduzione_Scripting_Bash/README.md>)
