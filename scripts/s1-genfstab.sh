#!/bin/bash

source ./ps-mount.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 1 ==="'
run 'echo ""'

info

run 'echo "$(yq '.distro.stages.s1.desc' "$DISTRO_CONFIG")"'

ROOTM="$(yq '.distro.mount.root' "$DISTRO_CONFIG" | tr -d '\"')"

run 'genfstab -U $ROOTM > $ROOTM/etc/fstab'
run 'cat $ROOTM/etc/fstab'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 1 ==="'
run 'echo ""'
