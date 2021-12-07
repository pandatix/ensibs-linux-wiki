#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo -e "[+] \033[1;33m[HRDN-7222] Hardening compilers\033[0m"
echo "------------------------------------"

compils=("as" "cc" "clang" "gcc")
for c in ${compils[@]}; do
    echo -en "  - $c\t\t"
    loc=$(which $c)
    if [[ -n $loc ]]; then
        rlpath=$(realpath $loc)
        if [[ -n $rlpath ]]; then
            # Delete real binary
            rm $rlpath
            echo -e "[ \033[0;32mDeleted\033[0m ]"
        else
            echo "[ Not Found ]"
        fi
    # Delete the link
    rm -f $loc
    else
        echo "[ Not Found ]"
    fi
done
