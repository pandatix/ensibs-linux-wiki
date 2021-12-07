#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR30 - Applications utilisant PAM\033[0m"
echo "-------------------------------------"

cat <<EOF >> /etc/pam.d/other
auth      required  pam_securetty.so
auth      required  pam_unix_auth.so
auth      required  pam_warn.so
auth      required  pam_deny.so
account   required  pam_unix_acct.so
account   required  pam_warn.so
account   required  pam_deny.so
password  required  pam_unix_passwd.so
password  required  pam_warn.so
password  required  pam_deny.so
session   required  pam_unix_session.so
session   required  pam_warn.so
session   required  pam_deny.so
EOF
echo -e "  - PAM base policy \t\t[ \033[0;32mOK\033[0m ]"
