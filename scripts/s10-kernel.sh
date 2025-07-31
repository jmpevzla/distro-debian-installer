#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 10 ==="'
run 'echo ""'

if [[ ! -f "./installer.lock" ]]; then
    load_single
fi

run 'echo "$(yq '.distro.stages.s10.desc' "$DISTRO_CONFIG")"'

ARCH="$(yq '.distro.config.arch' "$DISTRO_CONFIG" | tr -d '\"')"

apt_update
croot 'apt install -y linux-image-"$ARCH" linux-headers-"$ARCH" initramfs-tools'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 10 ==="'
run 'echo ""'
