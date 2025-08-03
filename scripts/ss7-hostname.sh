#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

FILE=$(basename "$BASH_SOURCE")

run 'echo ""'
run 'echo "=== Begin Distro Installer - $FILE ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

get_desc "$FILE"

HOSTNAME="$(yq '.distro.config.hostname' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Hostname to \"$HOSTNAME\" in /etc/hostname"'
run 'echo "$HOSTNAME" > /"$ROOTM"/etc/hostname'

run 'echo ""'
run 'echo "=== End Distro Installer - $FILE ==="'
run 'echo ""'
