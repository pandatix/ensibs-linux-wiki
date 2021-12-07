#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33m[HOME-9304] Dossiers personnels\033[0m"
echo "------------------------------------"

homes=$(ls -1 /home)
for home in ${homes[@]}; do
    chmod o-rx "/home/$home"
done

echo -e "  Restriction des droits \t\t[ \033[0;32mOK\033[0m ]"
