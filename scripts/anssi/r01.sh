#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33mR1 - Minimisation des services installés\033[0m"
echo "-------------------------------------"

echo "  - Removing non-critical packages"
# list non critical packages that ReduceDebian assert can be remove
# does not contains:
#  - nano, used during manipulations
#  - grub, used to boot
non_critical_pkg=(
    "acpi"
    "acpid"
    "aptitude"
    "at"
    "aspell"
    "apsell-en"
    "avahi-daemon"
    "bash-completion"
    "bc"
    "bin86"
    "bind9-host"
    "ca-certificates"
    "console-common"
    "console-data"
    "console-tools"
    "dc"
    "debian-faq"
    "debian-faq-de"
    "debian-faq-fr"
    "debian-faq-it"
    "debian-faq-zh-cn"
    "dhcp"
    "dhcp3-client"
    "dhcp3-common"
    "dictionaries"
    "dnsutils"
    "doc-debian"
    "doc-linux-text"
    "eject"
    "fdutils"
    "file"
    "finger"
    "foomatic-filters"
    "gettext-base"
    "groff"
    "gnupg"
    "gnu-efi"
    "hplip"
    "iamerican"
    "ibritish"
    "info"
    "ispell"
    "laptop-detect"
    "libavahi-compat-libdnssd1"
    "libc6-amd64"
    "libc6-i686"
    "libgpmg1"
    "manpages"
    "mtools"
    "mtr-tiny"
    "mutt"
    "nano"
    "netcat"
    "net-tools"
    "ncurses-term"
    "openssh-client"
    "openssh-server"
    "openssl"
    "pidentd"
    "ppp"
    "pppconfig"
    "pppoe"
    "pppoeconf"
    "read-edid"
    "reportbug"
    "smclient"
    "ssh"
    "tasksel"
    "tcsh"
    "traceroute"
    "unzip"
    "usbutils"
    "vim-common"
    "vim-tiny"
    "wamerican"
    "w3m"
    "whois"
    "zeroinstall-injector"
    "zip"
)
for pkg in ${non_critical_pkg[@]}; do
    apt remove $pkg -y 1>/dev/null 2>/dev/null
    res=$?
    echo -ne "     - $pkg\t\t"
    if [[ "$res" -ne "0" ]]; then
        echo -e "[ \033[1;33mKO\033[0m ]"
    else
        echo -e "[ \033[0;32mOK\033[0m ]"
    fi
done

echo "  - Reconfiguring apt"
echo 'APT::Install-Recommends "0" ;' >> /etc/apt/apt.conf
echo -e "     - no-install-recommends\t\t[ \033[0;32mOK\033[0m ]"
echo 'APT::Install-Suggests "0" ; ' >> /etc/apt/apt.conf
echo -e "     - no-suggests\t\t[ \033[0;32mOK\033[0m ]"

echo "  - Cleaning up packages"
apt autoremove -y 1>/dev/null 2>/dev/null
echo -e "     - autoremove\t\t[ \033[0;32mOK\033[0m ]"
apt autoclean -y 1>/dev/null 2>/dev/null
echo -e "     - autoclean\t\t[ \033[0;32mOK\033[0m ]"

echo "  - Removing additional files"
rm -rf /usr/share/man/??
rm -rf /usr/share/man/??_*
echo -e "     - Foreign language man files\t\t[ \033[0;32mOK\033[0m ]"
ipv6_files=(
    "/lib/xtables/libip6t_ah.so"
    "/lib/xtables/libip6t_dst.so"
    "/lib/xtables/libip6t_eui64.so"
    "/lib/xtables/libip6t_frag.so"
    "/lib/xtables/libip6t_hbh.so"
    "/lib/xtables/libip6t_hl.so"
    "/lib/xtables/libip6t_HL.so"
    "/lib/xtables/libip6t_icmp6.so"
    "/lib/xtables/libip6t_ipv6header.so"
    "/lib/xtables/libip6t_LOG.so"
    "/lib/xtables/libip6t_mh.so"
    "/lib/xtables/libip6t_REJECT.so"
    "/lib/xtables/libip6t_rt.so"
    "/lib/xtables/libip6t_DNAT.so"
    "/lib/xtables/libip6t_DNPT.so"
    "/lib/xtables/libip6t_MASQUERADE.so"
    "/lib/xtables/libip6t_NETMAP.so"
    "/lib/xtables/libip6t_REDIRECT.so"
    "/lib/xtables/libip6t_SNAT.so"
    "/lib/xtables/libip6t_SNPT.so "
)
for f in ${ipv6_files[@]}; do
    rm -rf $f
done
echo -e "     - IPv6 files\t\t[ \033[0;32mOK\033[0m ]"
