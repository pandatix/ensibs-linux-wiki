#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR42 - Services et démons résidents en mémoire\033[0m"
echo "-------------------------------------"

echo "  - Arrêt des démons et sockets"
targets=(
    "dbus.service"
    "dbus.socket"
)
for target in ${targets[@]}; do
    systemctl stop    $target 1>/dev/null 2>/dev/null
    systemctl disable $target 1>/dev/null 2>/dev/null
    echo -e "     - $target\t\t[ \033[0;32mOK\033[0m ]"
done
