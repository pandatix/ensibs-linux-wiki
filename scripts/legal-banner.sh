#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33m[BANN-7126] [BANN-7130] Bannières et identification\033[0m"
echo "------------------------------------"

read -r -d '' banner <<-EOF
Illegal access or intrustion in this system if forbidden by the Code Pénal (French) from
article 323-1 to 323-7. This will imply law enforcement by authorities.
EOF

echo $banner >> /etc/issue
echo $banner >> /etc/issue.net

# Enable if not already the case
sed -i 's/#Banner/Banner/' /etc/ssh/sshd_config
# If not set, set the /etc/issue.net
sed -i 's/Banner none/Banner \/etc\/issue.net/' /etc/ssh/sshd_config
# Restart to apply changes
systemctl restart sshd.service

echo -e "  Mise en place des bannières \t\t[ \033[0;32mOK\033[0m ]"
