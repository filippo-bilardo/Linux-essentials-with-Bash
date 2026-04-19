#!/bin/bash

# Script che mostra come legger i parametri posizionali e usarli in operazioni matematiche.
# esercizio fatto con l'IA da completare

# Controlla che siano stati passati 3 parametri
# $# è il numero di parametri passati allo script
if [ $# -ne 3 ]; then
    # Mostro un messaggio di errore e l'uso corretto dello script
    echo "Errore: Devi fornire esattamente 3 parametri."
    # $0 è il nome dello script
    echo "Utilizzo: $0 <operazione> <numero1> <numero2>"
    exit 1
fi


# Assegna i parametri alle variabili
num1=$1
num2=$2

# Esegue operazioni matematiche
sum=$((num1 + num2))
product=$((num1 * num2))

# Mostra i risultati
echo "La somma è: $sum"
echo "Il prodotto è: $product"