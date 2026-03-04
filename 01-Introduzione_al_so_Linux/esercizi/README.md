# Esercizi — Modulo 01: Introduzione al s.o. Linux

Completa gli esercizi seguenti sul tuo sistema Linux (o macchina virtuale).  
Per ogni esercizio annota il comando usato e l'output ottenuto.

---

## Esercizio 1 — Scopri il tuo sistema

Apri il terminale ed esegui i seguenti comandi uno alla volta. Per ognuno, annota l'output.

```bash
whoami
hostname
uname -r
uname -a
```

**Domande:**
1. Qual è il tuo nome utente?
2. Come si chiama il tuo computer?
3. Quale versione del kernel Linux stai usando?
4. Qual è l'architettura della tua CPU?

---

## Esercizio 2 — Distribuzione Linux

Esegui i seguenti comandi per scoprire quale distribuzione Linux stai usando:

```bash
cat /etc/os-release
lsb_release -a
```

**Domande:**
1. Quale distribuzione Linux stai usando?
2. Qual è la versione?
3. È una versione LTS (Long Term Support)?

---

## Esercizio 3 — Risorse del sistema

Esegui i comandi per vedere le risorse hardware:

```bash
free -h
df -h
lscpu | head -20
```

**Domande:**
1. Quanta RAM è disponibile nel sistema?
2. Quanto spazio è libero sul disco principale?
3. Quanti core ha il processore?

---

## Esercizio 4 — Utenti e permessi

```bash
id
groups
cat /etc/passwd | grep $(whoami)
```

**Domande:**
1. Qual è il tuo UID (User ID)?
2. A quali gruppi appartieni?
3. Qual è la tua home directory secondo `/etc/passwd`?
4. Qual è la tua shell predefinita?

---

## Esercizio 5 — Esegui gli script di esempio

1. Vai nella cartella degli esempi di questo modulo:
   ```bash
   cd esempi/
   ```

2. Rendi gli script eseguibili:
   ```bash
   chmod +x 01_comandi_informativi.sh
   chmod +x 02_esplora_sistema.sh
   ```

3. Esegui il primo script:
   ```bash
   bash 01_comandi_informativi.sh
   ```

4. Esegui il secondo script interattivo:
   ```bash
   bash 02_esplora_sistema.sh
   ```

**Domande:**
1. Cosa fa il comando `chmod +x`?
2. Qual è la differenza tra eseguire `bash script.sh` e `./script.sh`?

---

## Esercizio 6 — Ricerca e confronto (approfondimento)

Usando Internet, ricerca e confronta **tre distribuzioni Linux** a tua scelta.  
Compila la seguente tabella:

| Caratteristica | Distro 1: ___ | Distro 2: ___ | Distro 3: ___ |
|---|---|---|---|
| Anno di prima uscita | | | |
| Gestore di pacchetti | | | |
| Desktop predefinito | | | |
| Basata su | | | |
| Uso principale | | | |
| Sito ufficiale | | | |

---

## Esercizio 7 — Sfida: script personalizzato

Crea un nuovo file chiamato `mio_sistema.sh` nella cartella `esercizi/` che:

1. Stampi un titolo "Informazioni sul mio sistema"
2. Mostri nome utente, hostname e data corrente
3. Mostri la distribuzione Linux e la versione del kernel
4. Mostri quanta RAM è libera

**Suggerimento**: usa i comandi `whoami`, `hostname`, `date`, `uname -r`, `free -h` e il comando `echo` per formattare l'output.

---

## Soluzioni

> Le soluzioni saranno discusse in aula. Prova a svolgere gli esercizi in autonomia prima di confrontarti con il docente.

---

- [📑 Indice](<../README.md>)
- [⬅️ precedente](<../README.md>)
- [➡️ successivo](<../../02-Utilizzo_Command_Line/README.md>)
