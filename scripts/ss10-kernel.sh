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

ARCH="$(yq '.distro.config.arch' "$DISTRO_CONFIG" | tr -d '\"')"

apt_update
croot 'apt install -y linux-image-"$ARCH" linux-headers-"$ARCH" initramfs-tools'

run 'echo ""'
run 'echo "=== End Distro Installer - $FILE ==="'
run 'echo ""'
