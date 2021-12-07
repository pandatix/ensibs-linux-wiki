#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR40 - Sticky bit et droits d'accès en écriture\033[0m"
echo "-------------------------------------"

dirs=$(find / -type d \( -perm -0002 -a \! -perm -1000 \) -ls 2>/dev/null)
for dir in ${dirs[@]}; do
    chmod o+t $dir
done
echo -e "  - Armement du sticky bit\t\t[ \033[0;32mOK\033[0m ]"

dirs=$(find / -type d -perm -0002 -a \! -uid 0 -ls 2>/dev/null)
for di in ${dirs[@]}; do
    chown root:root $dir
done
echo -e "  - Appropriation des dossiers modifiables par tous à root\t\t[ \033[0;32mOK\033[0m ]"
