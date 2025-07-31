#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 17 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s17.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y bluez bluez-tools'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 17 ==="'
run 'echo ""'
