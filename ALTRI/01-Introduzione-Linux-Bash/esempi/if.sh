if ls /bin > /dev/null
then
  echo "comando eseguito con successo."
  echo "la cartella /dev/null esiste"
fi

echo
read -p "Premi un tasto per continuare... " -s cont
echo
echo

if ls /pippo &> /dev/null
then
  echo "la cartella /pippo esiste"
else
  echo "la cartella /pippo non esiste"
fi
