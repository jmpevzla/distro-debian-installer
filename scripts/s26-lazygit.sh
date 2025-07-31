#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 26 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s26.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y lazygit'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 26 ==="'
run 'echo ""'
