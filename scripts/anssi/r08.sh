#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR8 - Mises à jour régulières\033[0m"
echo "-------------------------------------"

echo "  - Installing packages"
pkgs=(
    "unattended-upgrades"
    "apt-listchanges"
)
for pkg in ${pkgs[@]}; do
    apt install -y $pkg 1>/dev/null 2>/dev/null
    echo -e "     - $pkg\t\t[ \033[0;32mOK\033[0m ]"
done

echo "  - Configuring..."

cat <<EOF > /etc/apt/apt.conf.d/50unattended-upgrades
Unattended-Upgrade::Origins-Pattern {
    "origin=Debian,codename=\${distro_codename},label=Debian-Security";
};
Unattended-Upgrade::Package-Blacklist {};
Unattended-Upgrade::Mail "root";
EOF

echo -e "     - unattended upgrades\t\t[ \033[0;32mOK\033[0m ]"
cat <<EOF > /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Download-Upgradeable-Packages "1";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
APT::Periodic::AutocleanInterval "7";
EOF
echo -e "     - auto upgrades\t\t[ \033[0;32mOK\033[0m ]"

# Initialize to make sure it works
unattended-upgrades --dry-run
res=$?
if [[ "$res" -ne "0" ]]; then
    return $res
fi
