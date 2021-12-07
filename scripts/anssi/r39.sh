#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR39 - Répertoire temporaires dédiés aux comptes\033[0m"
echo "-------------------------------------"

cat <<EOF >> /etc/pam.d/common-session
session  optional  pam_mktemp.so  debug  dir  prefix=/var/tmp  var=SESSION_TEMPDIR
EOF
echo -e "  - PAM rule for session temporary dir\t\t[ \033[0;32mOK\033[0m ]"
