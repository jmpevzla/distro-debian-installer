#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 7 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s7.desc' "$DISTRO_CONFIG")"'

HOSTNAME="$(yq '.distro.config.hostname' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Hostname to \"$HOSTNAME\" in /etc/hostname"'
run 'echo "$HOSTNAME" > /"$ROOTM"/etc/hostname'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 7 ==="'
run 'echo ""'
