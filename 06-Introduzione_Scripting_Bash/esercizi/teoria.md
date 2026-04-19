### Quiz: Programmazione Script Bash

1. **Qual è la "shebang" corretta da inserire nella prima riga di uno script?**
   * A) `#! /bin/bash`
   * B) `# /bin/bash`
   * C) `! /bin/bash`
   * D) `run bash`

2. **Come si dichiara correttamente una variabile `nome` con valore "Mario"?**
   * A) `nome = Mario`
   * B) `nome:=Mario`
   * C) `nome=Mario`
   * D) `set nome Mario`

3. **Perché non devono esserci spazi attorno all'uguale (`=`) durante l'assegnazione?**

   * A) Bash interpreterebbe il nome della variabile come un comando.
   * B) Per rendere il codice più compatto.
   * C) Perché lo spazio è riservato ai commenti.
   * D) Bash aggiunge automaticamente uno zero se vede uno spazio.

4. **Quale comando si usa per stampare a video il valore della variabile `X`?**
   * A) `print X`
   * B) `echo $X`
   * C) `echo X`
   * D) `read X`

5. **Qual è la funzione del comando `read`?**
   * A) Leggere un file di testo.
   * B) Permettere all'utente di inserire dati da tastiera.
   * C) Stampare il contenuto di una variabile.
   * D) Contare le righe di uno script.

6. **In Bash, a cosa serve il comando `let`?**
   * A) A definire costanti.
   * B) A eseguire operazioni aritmetiche tra variabili.
   * C) A creare cicli infiniti.
   * D) A leggere input numerici.

7. **Quale operatore si usa per verificare se due stringhe sono uguali in un `if`?**
   * A) `-eq`
   * B) `==` (o `=`)
   * C) `equals`
   * D) `===`

8. **Qual è l'operatore corretto per verificare se un numero è "maggiore di" un altro?**
   * A) `>`
   * B) `-gt` (Greater Than)
   * C) `-ge`
   * D) `-max`

10. **Come si chiude correttamente un blocco condizionale `if`?**
   * A) `end if`
   * B) `endif`
   * C) `fi`
   * D) `done`

11. **Cosa significa l'operatore `-lt`?**
    * A) Last Time
    * B) Less Than (Minore di)
    * C) Long Term
    * D) List Total

12. **Quale struttura si usa per eseguire un'azione se la condizione dell' `if` è falsa?**
    * A) `otherwise`
    * B) `else`
    * C) `elif`
    * D) `then not`

13. **Come si scrive correttamente l'intestazione di un ciclo `while`?**
    * A) `while [ condizione ] ; do`
    * B) `while ( condizione ) {`
    * C) `while condizione then`
    * D) `repeat while [ condizione ]`

14. **Con quale parola chiave termina un ciclo `while` o un ciclo `for`?**
    * A) `fi`
    * B) `stop`
    * C) `done`
    * D) `end`

15. **Cosa fa il comando `sleep 5` all'interno di un ciclo?**
    * A) Chiude lo script dopo 5 secondi.
    * B) Sospende l'esecuzione per 5 secondi.
    * C) Esegue il ciclo 5 volte.
    * D) Spegne il monitor per 5 secondi.

16. **Quale sintassi si usa per un ciclo `for` che scorre una lista di valori?**
    * A) `for VAR in VAL1 VAL2 VAL3 ; do`
    * B) `for (i=0; i<10; i++)`
    * C) `foreach VAR in LIST`
    * D) `loop VAR from VAL1 to VAL3`

17. **Come si definisce un intervallo numerico (es. da 1 a 5) in un ciclo `for`?**
    * A) `1 to 5`
    * B) `{1..5}`
    * C) `[1-5]`
    * D) `range(1,5)`

18. **A cosa servono le parentesi quadre `[ ]` negli script Bash?**
    * A) A definire array.
    * B) A racchiudere le condizioni da testare (comando `test`).
    * C) A inserire commenti multilinea.
    * D) A eseguire calcoli matematici complessi.

19. **Qual è la differenza tra `read VAR` e `echo $VAR`?**
    * A) `read` scrive, `echo` legge.
    * B) `read` acquisisce dati, `echo` li visualizza.
    * C) Non c'è differenza.
    * D) `read` funziona solo con i numeri.

20. **Come si scrive un commento in uno script Bash?**
    * A) `// commento`
    * B) `/* commento */`
    * C) `# commento`
    * D) `-- commento`

21. **Cosa succede se dimentichi il `do` dopo la condizione di un `while`?**
    * A) Lo script funziona lo stesso.
    * B) Lo script va in loop infinito.
    * C) Bash restituisce un errore di sintassi.
    * D) Il ciclo viene eseguito una sola volta.

---

### Soluzioni
1-A, 2-C, 3-A, 4-B, 5-B, 6-B, 7-B, 8-B, 9-C, 10-B, 11-B, 12-A, 13-C, 14-B, 15-A, 16-B, 17-B, 18-B, 19-C, 20-C.

Ti piacerebbe che trasformassi queste domande in un modulo interattivo o che creassi degli esercizi di "completamento codice" basati su queste slide?

### Quiz: Programmazione Bash (Domande 21-50)

21. **Quale estensione si usa solitamente per i file di script Bash (anche se non obbligatoria)?**
    * A) `.exe`
    * B) `.sh`
    * C) `.bashrc`
    * D) `.txt`

22. **Se `A=10` e `B=5`, quale comando assegna a `C` la loro somma?**
    * A) `C = A + B`
    * B) `let C=A+B`
    * C) `C = $A + $B`
    * D) `sum A B > C`

23. **Cosa succede se esegui `echo $fanta` se la variabile `fanta` non è mai stata definita?**
    * A) Il terminale crasha.
    * B) Stampa un errore "Variable not found".
    * C) Stampa una riga vuota.
    * D) Stampa lo zero.

24. **Quale operatore si usa per verificare se un numero è "Minore o Uguale"?**
    * A) `-le` (Less or Equal)
    * B) `<=`
    * C) `-me`
    * D) `-lt`

25. **Quale operatore si usa per verificare se un numero è "Maggiore o Uguale"?**
    * A) `=>`
    * B) `-ge` (Greater or Equal)
    * C) `-gt`
    * D) `-be`

26. **Quale operatore si usa per verificare se due numeri sono "Diversi" (Not Equal)?**
    * A) `!=`
    * B) `-ne`
    * C) `<>`
    * D) `-not`

27. **Come si scrive correttamente la condizione per verificare se la variabile `N` è uguale a 100?**
    * A) `if [ $N -eq 100 ]`
    * B) `if $N = 100`
    * C) `if [ N eq 100 ]`
    * D) `if ( $N == 100 )`

28. **In uno script, a cosa serve il comando `chmod +x script.sh`?**
    * A) A cancellare lo script.
    * B) A rendere lo script eseguibile.
    * C) A visualizzare il codice dello script.
    * D) A criptare lo script.

29. **Quale parola chiave segue immediatamente la condizione di un `if`?**
    * A) `do`
    * B) `then`
    * C) `begin`
    * D) `{`

30. **Cosa fa l'operatore `!=` tra due stringhe?**
    * A) Verifica se la prima è più lunga della seconda.
    * B) Verifica se sono diverse.
    * C) Unisce le due stringhe.
    * D) Trasforma le stringhe in numeri.

31. **Qual è lo scopo del comando `elif`?**
    * A) Chiudere un ciclo.
    * B) Introdurre una nuova condizione se quella precedente è falsa.
    * C) Generare un numero casuale.
    * D) Leggere un input cifrato.

32. **In un ciclo `for i in 1 2 3`, qual è il valore di `$i` alla seconda iterazione?**
    * A) 1
    * B) 2
    * C) 3
    * D) null

33. **Cosa succede se in un `while` la condizione è sempre vera?**
    * A) Lo script si interrompe subito.
    * B) Si crea un loop infinito.
    * C) Bash corregge automaticamente l'errore.
    * D) Il computer si riavvia.

34. **Come si accede al valore di una variabile chiamata `prezzo`?**
    * A) `&prezzo`
    * B) `$prezzo`
    * C) `*prezzo`
    * D) `val(prezzo)`

35. **Quale di queste assegnazioni è ERRATA?**
    * A) `VALORE=10`
    * B) `VALORE = 10`
    * C) `NOME="Luigi"`
    * D) `X=$Y`

36. **Come si scrive un `if` che controlla se una stringa `$S` è vuota?**
    * A) `if [ $S == "" ]`
    * B) `if $S is empty`
    * C) `if [ -empty $S ]`
    * D) `if S=""`

37. **Cosa stampa `echo "$nome"` se `nome=Anna`?**
    * A) $nome
    * B) Anna
    * C) nome
    * D) "$nome"

38. **All'interno delle parentesi quadre `[ ]`, gli spazi sono obbligatori?**
    * A) No, mai.
    * B) Sì, dopo `[` e prima di `]`.
    * C) Solo se ci sono numeri.
    * D) Solo se si usa l'operatore `-eq`.

39. **Quale comando permette di far avanzare un ciclo `for` su una lista di file?**
    * A) `for f in * ; do`
    * B) `for f list files`
    * C) `foreach file`
    * D) `read files in for`

40. **Cosa indica il simbolo `$` davanti al nome di una variabile?**
    * A) Che stiamo definendo la variabile.
    * B) Che vogliamo estrarre/leggere il contenuto della variabile.
    * C) Che la variabile è di tipo "valuta" (soldi).
    * D) Che la variabile è globale.

41. **Cosa fa il comando `read -p "Messaggio: " var`?**
    * A) Legge una variabile in modo privato.
    * B) Mostra un messaggio di testo prima di attendere l'input.
    * C) Stampa il valore di `var`.
    * D) Legge solo password.

42. **Se scrivi `while [ $contatore -gt 0 ]`, quando si ferma il ciclo?**
    * A) Quando `contatore` diventa maggiore di zero.
    * B) Quando `contatore` diventa minore o uguale a zero.
    * C) Quando `contatore` è uguale a 1.
    * D) Non si ferma mai.

43. **Qual è l'output di `let x=5*2; echo $x`?**
    * A) 5*2
    * B) 10
    * C) x
    * D) Errore di sintassi

44. **Come si commentano più righe contemporaneamente in Bash?**
    * A) Usando `/* ... */`
    * B) Usando `#` all'inizio di ogni riga.
    * C) Usando `[[ ... ]]`
    * D) Non è possibile commentare più righe.

45. **Nel comando `for i in {1..100}`, quante volte viene eseguito il loop?**
    * A) 1
    * B) 99
    * C) 100
    * D) Infinite

46. **A cosa serve l'istruzione `do`?**
    * A) A terminare un `if`.
    * B) Ad aprire il blocco di istruzioni di un ciclo `for` o `while`.
    * C) A eseguire un comando di sistema.
    * D) A dichiarare una funzione.

47. **Quale di questi è un operatore booleano "AND" in Bash (stile test)?**
    * A) `-a`
    * B) `&&`
    * C) Entrambe le precedenti (dipende dal contesto delle parentesi)
    * D) `AND`

48. **In uno script Bash, le variabili sono tipizzate (es. int, string)?**
    * A) Sì, bisogna dichiararle prima.
    * B) No, Bash è debolmente tipizzato (tratta quasi tutto come stringhe o numeri all'occorrenza).
    * C) Sì, ma solo per i numeri decimali.
    * D) Solo se si usa il comando `type`.

49. **Cosa succede se scrivi `fi` prima di `then`?**
    * A) Lo script inverte la condizione.
    * B) Errore di sintassi (fi chiude l'if).
    * C) Nulla, Bash ignora l'ordine.
    * D) Si apre un sotto-guscio (subshell).

50. **Qual è il modo corretto di eseguire uno script chiamato `test.sh` dalla cartella corrente?**
    * A) `run test.sh`
    * B) `./test.sh`
    * C) `open test.sh`
    * D) `test.sh` (senza nulla davanti)

---

### Soluzioni (21-50)
21-B, 22-B, 23-C, 24-A, 25-B, 26-B, 27-A, 28-B, 29-B, 30-B, 31-B, 32-B, 33-B, 34-B, 35-B, 36-A, 37-B, 38-B, 39-A, 40-B, 41-B, 42-B, 43-B, 44-B, 45-C, 46-B, 47-C, 48-B, 49-B, 50-B.

**Vorresti che preparassi uno script "modello" che contenga tutti questi elementi (variabili, if, while, for) così da poterlo studiare come esempio pratico?**