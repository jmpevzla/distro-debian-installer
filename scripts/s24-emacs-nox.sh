#!/bin/bash

source ./loader.sh

run 'echo ""'
run 'echo "=== Begin Distro Installer - Stage 24 ==="'
run 'echo ""'

stage_mount
info

run 'echo "$(yq '.distro.stages.s24.desc' "$DISTRO_CONFIG")"'

apt_update
croot 'apt install -y emacs-nox'

run 'echo ""'
run 'echo "=== End Distro Installer - Stage 24 ==="'
run 'echo ""'
