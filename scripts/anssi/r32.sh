#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR32 - Protection des mots de passe stockés\033[0m"
echo "-------------------------------------"

cat <<EOF >> /etc/pam.d/common-password
password  required  pam_unix.so  obscure  sha512  rounds=65536
EOF
echo -e "  - Configuring PAM\t\t[ \033[0;32mOK\033[0m ]"

cat <<EOF >> /etc/login.defs
ENCRYPT_METHOD       SHA512
SHA_CRYPT_MIN_ROUNDS 65536
EOF
echo -e "  - Configuring /etc/login.defs\t\t[ \033[0;32mOK\033[0m ]"
