#!/bin/bash

source ./chroot.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 5 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s5.desc' "$DISTRO_CONFIG")"'

ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"
HOSTNAME="$(yq '.distro.config.hostname' "$DISTRO_CONFIG" | tr -d '\"')"

run 'echo "Set Hostname to \"$HOSTNAME\" in /etc/hostname"'
run 'echo "$HOSTNAME" > /"$ROOTM"/etc/hostname'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 5 ==="'
run 'echo ""'
