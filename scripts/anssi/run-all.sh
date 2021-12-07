#!/bin/bash
# @author PandatiX <lucasfloriantesson@gmail.com>

echo "===== RUNNING ALL SCRIPTS ====="
echo ""

rxxs=$(ls . -1 | egrep "^r[0-9]{2}.sh")
for rxx in ${rxxs[@]}; do
    ./$rxx
    echo ""
done
