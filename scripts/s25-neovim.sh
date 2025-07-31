#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 25 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s25.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y neovim'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 25 ==="'
run 'echo ""'
