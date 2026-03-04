# Il Mondo Open Source e la Comunità Linux

## Che cos'è il Software Open Source?

Con **software open source** (OSS) si intende qualsiasi programma il cui **codice sorgente** è messo a disposizione del pubblico con una licenza che ne permette liberamente:

- la **visione** (puoi leggere come funziona)
- la **modifica** (puoi adattarlo alle tue esigenze)
- la **ridistribuzione** (puoi condividere versioni originali o modificate)

Il contrario è il **software proprietario** (o closed source), in cui il codice sorgente è segreto e i diritti d'uso sono strettamente controllati dal produttore.

## Software Libero vs Open Source

I termini sono spesso usati come sinonimi, ma hanno sfumature diverse:

| | Software Libero (Free Software) | Open Source |
|---|---|---|
| **Promotore** | Richard Stallman / FSF | OSI (Open Source Initiative) |
| **Enfasi** | Libertà etica dell'utente | Qualità e collaborazione |
| **Licenze tipiche** | GPL, LGPL, AGPL | MIT, Apache, BSD, GPL |
| **Parola chiave** | *Free as in freedom* (libero, non gratuito) | Codice accessibile |

Linux adotta la licenza **GPL v2** (GNU General Public License): chiunque può usarlo, modificarlo e redistribuirlo, ma le versioni derivate devono anch'esse essere open source sotto la stessa licenza.

## La Storia dell'Open Source e di GNU

### 1983 — Il Progetto GNU
Richard Stallman avvia il progetto **GNU** (GNU's Not Unix) con l'obiettivo di creare un sistema operativo completamente libero. Fornisce compilatori (GCC), editor (Emacs), shell (Bash) e molti altri strumenti — tutto tranne il kernel.

### 1991 — Nasce il Kernel Linux
Linus Torvalds, studente all'Università di Helsinki, pubblica la prima versione del kernel Linux il 25 agosto 1991 con un post storico su Usenet:

> *"I'm doing a (free) operating system (just a hobby, won't be big and professional like gnu) for 386(486) AT clones."*

Combinando il kernel Linux con gli strumenti GNU nasce il sistema operativo **GNU/Linux**.

### 1998 — Il termine "Open Source"
Eric Raymond e Bruce Perens fondano la **Open Source Initiative** (OSI), coniando il termine "open source" per sottolineare i vantaggi pratici (qualità del codice, sicurezza, collaborazione) rispetto all'aspetto etico del software libero.

## Come Funziona la Comunità Linux?

Linux è sviluppato da una comunità globale distribuita. Chiunque può contribuire:

### I canali di contribuzione
- **Patch al kernel**: sviluppatori inviano modifiche a Linus Torvalds e ai maintainer
- **Distribuzioni**: team mantengono distribuzioni come Ubuntu, Debian, Fedora
- **Software applicativo**: migliaia di progetti su GitHub, GitLab, SourceForge
- **Documentazione**: wiki, manuali, tutorial
- **Segnalazione bug**: anche gli utenti non tecnici contribuiscono

### La governance del kernel
Il kernel Linux è gestito attraverso un sistema di **maintainer**:
- Linus Torvalds supervisiona il kernel principale
- Maintainer di sottosistemi gestiscono aree specifiche (networking, filesystem, driver...)
- Le patch vengono revisionate dalla comunità prima di essere accettate

## Le Principali Licenze Open Source

| Licenza | Copyleft | Note |
|---|---|---|
| **GPL v2/v3** | Forte | Deve restare open source. Usata da Linux |
| **LGPL** | Debole | Permette l'uso in software proprietario |
| **MIT** | Nessuno | Massima libertà, minime restrizioni |
| **Apache 2.0** | Nessuno | Include protezione brevetti |
| **BSD** | Nessuno | Simile a MIT |

## Perché l'Open Source è Importante?

- **Sicurezza**: il codice è ispezionabile da tutti; i bug vengono scoperti e corretti più velocemente
- **Qualità**: molti sviluppatori revisionano il codice ("given enough eyeballs, all bugs are shallow" — Legge di Linus)
- **Indipendenza**: nessun vendor lock-in
- **Innovazione**: le idee si propagano liberamente
- **Sostenibilità**: i progetti non muoiono con un'azienda

---

- [📑 Indice](<README.md>)
- [⬅️ precedente](<01_linux_e_sistemi_operativi.md>)
- [➡️ successivo](<03_applicazioni_open_source.md>)
