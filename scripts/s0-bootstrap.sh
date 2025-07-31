#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 0 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    umount_part
    mount_part
    run 'echo ""'
    info 
fi

run 'echo "$(yq '.distro.stages.s0.desc' "$DISTRO_CONFIG")"'

ARCH="$(yq '.distro.config.arch' "$DISTRO_CONFIG" | tr -d '\"')"
REPO="$(yq '.distro.config.repo' "$DISTRO_CONFIG" | tr -d '\"')"
VERSION="$(yq '.distro.version' "$DISTRO_CONFIG" | tr -d '\"')"

run 'debootstrap --arch $ARCH $VERSION $ROOTM $REPO'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 0 ==="'
run 'echo ""'
