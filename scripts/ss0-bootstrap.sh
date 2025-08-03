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
    umount_part
    mount_part
    run 'echo ""'
    info 
fi

get_desc "$FILE"

ARCH="$(yq '.distro.config.arch' "$DISTRO_CONFIG" | tr -d '\"')"
REPO="$(yq '.distro.config.repo' "$DISTRO_CONFIG" | tr -d '\"')"
VERSION="$(yq '.distro.version' "$DISTRO_CONFIG" | tr -d '\"')"

run 'debootstrap --arch $ARCH $VERSION $ROOTM $REPO'

run 'echo ""'
run 'echo "=== End Distro Installer - $FILE ==="'
run 'echo ""'
