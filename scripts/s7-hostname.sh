#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 7 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s7.desc' "$DISTRO_CONFIG")"'

HOSTNAME="$(yq '.distro.config.hostname' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Hostname to \"$HOSTNAME\" in /etc/hostname"'
run 'echo "$HOSTNAME" > /"$ROOTM"/etc/hostname'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 7 ==="'
run 'echo ""'
