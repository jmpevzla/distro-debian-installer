#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 20 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s20.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y 7zip fastfetch htop btop ncal plocate'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 20 ==="'
run 'echo ""'
