#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 12 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s12.desc' "$DISTRO_CONFIG")"'

apt_update

croot 'apt install -y firmware-linux-nonfree'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 12 ==="'
run 'echo ""'
