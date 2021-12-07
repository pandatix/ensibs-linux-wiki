#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR37 - Exécutables avec bits setuid et setgid\033[0m"
echo "-------------------------------------"

echo -e "  - Retrait du bit setuid"
suids=(
    "/usr/bin/gpasswd"
    "/usr/bin/umount"
    "/usr/bin/chfn"
    "/usr/bin/chsh"
    "/usr/bin/newgrp"
    "/usr/bin/su"
    "/usr/bin/mount"
    "/usr/lib/dbus-1.0/dbus-daemon-launch-helper"
)
for suid in ${suids[@]}; do
    chmod u-s $suid
    echo -e "     - $suid\t\t[ \033[0;32mOK\033[0m ]"
done

echo -e "  - Retrait du bit setgid"
guids=(
    "/usr/sbin/unix_chkpwd"
    "/usr/bin/dotlockfile"
    "/usr/bin/crontab"
    "/usr/bin/chage"
    "/usr/bin/expiry"
    "/usr/bin/wall"
    "/usr/bin/write.ul"
)
for guid in ${guids[@]}; do
    chmod g-s $guid
    echo -e "     - $guid\t\t[ \033[0;32mOK\033[0m ]"
done
