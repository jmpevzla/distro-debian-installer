#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 18 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s18.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y openssh-server'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 18 ==="'
run 'echo ""'
