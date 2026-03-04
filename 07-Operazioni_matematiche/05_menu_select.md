# Menu Interattivi con `select` e `case`

## Il Costrutto `select`

`select` genera automaticamente un menu numerato leggendo una lista di voci. È il modo più semplice per creare menu interattivi in Bash.

```bash
select variabile in voce1 voce2 voce3; do
    # $variabile contiene la voce scelta
    # $REPLY contiene il numero inserito dall'utente
    comandi...
done
```

### Esempio base

```bash
#!/bin/bash
echo "Seleziona un'operazione:"
select operazione in "Visualizza file" "Crea directory" "Elimina file" "Esci"; do
    case $operazione in
        "Visualizza file")  ls -la ;;
        "Crea directory")   read -p "Nome: " n; mkdir -p "$n" ;;
        "Elimina file")     read -p "File da eliminare: " f; rm -i "$f" ;;
        "Esci")             break ;;
        *)                  echo "Scelta non valida: $REPLY" ;;
    esac
done
```

Bash stampa automaticamente:
```
1) Visualizza file
2) Crea directory
3) Elimina file
4) Esci
#?
```

### Personalizzare il prompt di `select`

La variabile `PS3` contiene il testo del prompt (default: `#?`):

```bash
PS3="Inserisci la tua scelta: "
select voce in uno due tre esci; do
    [[ $voce == "esci" ]] && break
    echo "Hai scelto: $voce"
done
```

---

## Menu con `while` + `case` (Più Flessibile)

`select` è comodo ma limitato. Con `while` + `case` hai controllo totale su layout e logica:

```bash
#!/bin/bash
VERDE='\033[0;32m'; CIANO='\033[0;36m'; RESET='\033[0m'

mostra_menu() {
    clear
    echo -e "${CIANO}╔═══════════════════════════╗"
    echo -e "║      MENU PRINCIPALE      ║"
    echo -e "╠═══════════════════════════╣"
    echo -e "║  1) Informazioni sistema  ║"
    echo -e "║  2) Utenti connessi       ║"
    echo -e "║  3) Spazio disco          ║"
    echo -e "║  4) Processi attivi       ║"
    echo -e "║  q) Esci                  ║"
    echo -e "╚═══════════════════════════╝${RESET}"
}

while true; do
    mostra_menu
    read -p "Scelta: " scelta
    case $scelta in
        1) uname -a; read -p "Premi Invio..." ;;
        2) who;      read -p "Premi Invio..." ;;
        3) df -h;    read -p "Premi Invio..." ;;
        4) ps aux | head -15; read -p "Premi Invio..." ;;
        q|Q) echo "Arrivederci!"; exit 0 ;;
        *) echo -e "${VERDE}Opzione non valida${RESET}"; sleep 1 ;;
    esac
done
```

---

## Menu con Validazione e Sotto-menu

```bash
#!/bin/bash
menu_rete() {
    echo "--- Strumenti di Rete ---"
    select tool in "ping" "hostname" "ip addr" "Torna al menu principale"; do
        case $tool in
            "ping")
                read -p "Host da pingare: " host
                ping -c 3 "$host"
                ;;
            "hostname") hostname -I ;;
            "ip addr")  ip addr show ;;
            "Torna al menu principale") return ;;
        esac
    done
}

PS3="Scegli: "
select voce in "File system" "Rete" "Processi" "Esci"; do
    case $voce in
        "File system") df -h ;;
        "Rete")        menu_rete ;;
        "Processi")    ps aux | head -10 ;;
        "Esci")        break ;;
        *)             echo "Non valido" ;;
    esac
done
```

---

## Menu con Input da Array

```bash
#!/bin/bash
opzioni=("Visualizza log" "Backup home" "Pulisci temp" "Info sistema" "Esci")

PS3="Seleziona operazione: "
select scelta in "${opzioni[@]}"; do
    case $scelta in
        "Visualizza log")  tail -20 /var/log/syslog 2>/dev/null ;;
        "Backup home")     tar -czf ~/backup_$(date +%Y%m%d).tar.gz ~ 2>/dev/null
                           echo "Backup completato" ;;
        "Pulisci temp")    rm -rf /tmp/lab_* 2>/dev/null; echo "Temp pulita" ;;
        "Info sistema")    uname -a ;;
        "Esci")            echo "Uscita."; break ;;
        *)                 echo "Inserisci un numero da 1 a ${#opzioni[@]}" ;;
    esac
done
```

---

## Navigazione

- [📑 Indice](<README.md>)
- [⬅️ precedente](<04_output_formattazione.md>)
- [➡️ successivo](<06_getopts.md>)
