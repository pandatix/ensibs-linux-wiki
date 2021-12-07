#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR23 - Paramétrage des sysctl système\033[0m"
echo "-------------------------------------"

cat <<EOF >> /etc/sysctl.conf
# Désactivation des SysReq
kernel.sysrq = 0

# Pas de core dump des exécutables setuid
fs.suid_dumpable = 0

# Interdiction de déréférencer des liens vers des fichiers dont
# l'utilisateur courant n'est pas le propriétaire
# Peut empêcher certains programmes de fonctionner correctement
fs.protected_symlinks = 1
fs.protected_hardlinks = 1

# Activation de l'ASLR
kernel.randomize_va_space = 2

# Interdiction de mapper de la mémoire dans les adresses basses (0)
vm.mmap_min_addr = 65536

# Espace de choix plus grand pour les valeurs de PID
kernel.pid_max = 65536

# Obfuscation des adresses mémoire kernel
kernel.kptr_restrict = 1

# Restriction d'accès au buffer dmesg
kernel.dmesg_restrict = 1

# Restreint l'utilisation du sous système perf
kernel.perf_event_paranoid = 2
kernel.perf_event_max_sample_rate = 1
kernel.perf_cpu_time_max_percent = 1
EOF
systemctl restart systemd-sysctl.service
echo -e "  - Configuration\t\t[ \033[0;32mOK\033[0m ]"
