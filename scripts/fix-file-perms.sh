#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33m[FILE-7524] Permissions de fichier\033[0m"
echo "------------------------------------"

# Files
files=(
    "600:/boot/grub/grub.cfg"
    "600:/etc/crontab"
    "644:/etc/group"
    "644:/etc/group-"
    "644:/etc/hosts.allow"
    "644:/etc/hosts.deny"
    "644:/etc/issue"
    "644:/etc/issue.net"
    "644:/etc/motd"
    "644:/etc/passwd"
    "644:/etc/passwd-"
    "600:/etc/ssh/sshd_config"
)
for f in ${files[@]}; do
    tpl=$(echo $f | sed 's/:/ /')
    perms=$(echo $tpl | awk '{printf $1}')
    file=$(echo $tpl | awk '{printf $2}')
    chmod $perms $file
    echo -e "  - File: $file set to $perms \t\t[ \033[0;32mOK\033[0m ]"
done

# Directories
dir=(
    "700:/etc/cron.d"
    "700:/etc/cron.daily"
    "700:/etc/cron.hourly"
    "700:/etc/cron.weekly"
    "700:/etc/cron.monthly"
)
for f in ${dir[@]}; do
    tpl=$(echo $f | sed 's/:/ /')
    perms=$(echo $tpl | awk '{printf $1}')
    file=$(echo $tpl | awk '{printf $2}')
    chmod $perms $file
    echo -e "  - Directory: $file set to $perms \t\t[ \033[0;32mOK\033[0m ]"
done
