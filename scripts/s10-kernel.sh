#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 10 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s10.desc' "$DISTRO_CONFIG")"'

ARCH="$(yq '.distro.config.arch' "$DISTRO_CONFIG" | tr -d '\"')"

apt_update
croot 'apt install -y linux-image-"$ARCH" linux-headers-"$ARCH" initramfs-tools'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 10 ==="'
run 'echo ""'
