#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR22 - Paramétrage des sysctl réseau\033[0m"
echo "-------------------------------------"

cat <<EOF >> /etc/sysctl.conf
# Pas de routage entre les interfaces
net.ipv4.ip_forward = 0

# Filtrage par chemin inverse
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ne pas envoyer de redirections ICMP
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Refuser les paquets de source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

# Ne pas accepter les ICMP de type redirect
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.secure_redirects = 0

# Loguer les paquets ayant des IPs anormales
net.ipv4.conf.all.log_martians = 1

# RFC 1337
net.ipv4.tcp_rfc1337 = 1

# Ignorer les réponses non conformes à la RFC 1122
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Augmenter la plage pour les ports éphémères
net.ipv4.ip_local_port_range = 32768 65535

# Utiliser les SYN cookies
net.ipv4.tcp_syncookies = 1

# Désactiver le support IPv6
net.ipv6.conf.all.disable_ipv6 = 1
EOF
systemctl restart systemd-sysctl.service
echo -e "  - Configuration\t\t[ \033[0;32mOK\033[0m ]"
